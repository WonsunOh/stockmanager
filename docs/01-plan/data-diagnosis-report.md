# Phase 0 — 데이터 진단 리포트

> 작성일: 2026-05-20
> 대상: Firestore (`goodsstockmanager`) + Supabase (`oyoznvosuyxhgxmbfaow`)

---

## 1. 핵심 발견 (TL;DR)

> **Plan 전제가 일부 깨졌습니다.** 양쪽 DB는 같은 데이터의 복사본이 아니라 **서로 다른 도메인**입니다.

1. **Supabase의 `products`는 Flutter 앱과 무관한 별도 시스템**(쇼핑몰 카탈로그)입니다. 12 row가 있으나 스키마/도메인이 완전히 다름.
2. **Supabase에 `goods`, `memos` 테이블은 존재하지 않음**.
3. **Firestore `productData` 데이터가 깨진 상태** — 3 row 중 2 row가 한국어 필드명이라 현재 코드 `ProductFirebaseModel.fromMap`이 못 읽음.
4. **Firestore `goodsData`(124 row)**: 한국어 필드명 + 코드가 한국어로 읽음 → 정상 작동.
5. **Firestore `memoData`(2 row)**: 영문 필드명 + 코드가 영문으로 읽음 → 정상 작동.

→ **충돌 해결(max(inputDay))은 불필요**. Firestore → Supabase **단방향 신규 이관**만 하면 됩니다.

---

## 2. Firestore 현황

### 2.1 `goodsData` — 124 docs

| 항목 | 값 |
|------|-----|
| 총 doc 수 | 124 |
| 필드명 형식 | 한국어 (114 ko-only, 10 mixed with `imageUrls`) |
| 코드 매칭 | ✅ 정상 ([goods_firebase_model.dart](lib/data/models/goods_firebase_model.dart) 한국어로 읽음) |

**관찰된 모든 키**:
```
아이템 넘버 (공백, 124개 doc 전부)
아이템번호  (공백 없음, 2개 doc만 — 중복 키 존재)
상품명, 카테고리, 입력일
상품갯수, 상품무게, 상품가격, 상품재고
메모
imageUrls (10 doc, 모두 빈 배열)
개당 무게 (코드 모델에 없는 필드)
```

**이슈**:
- 키 충돌: `아이템 넘버` vs `아이템번호` — 2개 doc은 다른 키로 저장. 이관 시 통일 필요.
- `imageUrls`: populated 0, empty 10, missing 114 → **이미지 데이터 실제로 없음** (사용자 진술 일치).
- `개당 무게`: 코드 모델에 매핑 없음. 무시 또는 새 컬럼 추가 결정 필요.

### 2.2 `productData` — **3 docs (예상보다 매우 적음)**

| 항목 | 값 |
|------|-----|
| 총 doc 수 | 3 |
| 필드명 형식 | 한국어 2 + 영문 1 (혼재) |
| 코드 매칭 | ⚠️ **부분 작동** — 한국어 2 doc은 코드가 못 읽음 |

**한국어 doc의 키**:
```
제품명, 제품코드, 제품원가, 제품무게, 제품재고량
원료상품명, 원료갯수, 연관상품코드
수수료율, 수익률, 수수료, 수익, 판매가, 개당원가
배송방법, 배송유형
카테고리, 입력일, 메모, 품번
```

**영문 doc의 키** (코드와 일치):
```
itemNumber, title, category, inputDay
g_itemNumber, g_title
number, p_price, weight, commissionRate, earningRate
deliveryMethod, stock, memo
costPrice, price, commission, earning
```

**이슈**:
- 한국어 doc 2개는 사실상 **현재 앱에서 안 보임** (모든 필드가 null로 읽힘). Legacy 데이터로 추정.
- 이관 시 한국어 doc을 영문 스키마로 변환할지, 폐기할지 결정 필요.

### 2.3 `memoData` — 2 docs

| 항목 | 값 |
|------|-----|
| 총 doc 수 | 2 |
| 필드명 형식 | 영문 (코드와 100% 일치) |
| 코드 매칭 | ✅ 정상 |

이슈 없음.

---

## 3. Supabase 현황

| 테이블 | 존재 여부 | row 수 | 비고 |
|--------|----------|--------|------|
| `goods` | ❌ 없음 | - | 신규 생성 필요 |
| `products` | ✅ 있음 | **12** | **다른 시스템** (쇼핑몰 카탈로그) |
| `memos` | ❌ 없음 | - | 신규 생성 필요 |

### 3.1 Supabase `products` 스키마 (실제)

```sql
id                    integer (PK, auto)
name                  text          -- Flutter는 title
description           text          -- Quill JSON 형식
image_url             text          -- Flutter에 없음
total_price           integer
source_url            text
created_at            timestamptz
category_id           integer (FK?) -- Flutter는 category(string)
external_product_id   text
is_displayed          boolean
stock_quantity        integer
product_code          text          -- Flutter의 itemNumber와 유사
related_product_code  text          -- Flutter의 g_itemNumber와 유사
is_sold_out           boolean
is_user_creatable     boolean
shipping_fee          integer
tags                  jsonb         -- {is_hit, is_new, ...}
discount_price        integer
discount_start_date   timestamptz
discount_end_date     timestamptz
additional_images     text[]
-- 일부 Flutter 필드는 컬럼만 있고 모두 null:
cost_price, commission_rate, earning_rate, commission, earning,
weight, delivery_method, memo, quantity, unit_price
```

**결론**: 이 테이블은 **공유 불가**. 별도 테이블로 분리해야 함.

---

## 4. 권장 변경 사항 (Plan 업데이트 제안)

### 4.1 Supabase 테이블 명명 충돌 해결

기존 `products`(쇼핑몰)와 충돌하지 않도록 Flutter 앱 전용 테이블을 별도로 생성:

| 옵션 | 테이블명 | 평가 |
|------|---------|------|
| A | `stock_goods`, `stock_products`, `stock_memos` | ⭐ 명확. 다른 시스템과 분리 |
| B | 새 스키마 `stockmanager`에 `goods`, `products`, `memos` | 깔끔하지만 PostgREST 노출 설정 추가 필요 |
| C | 기존 `products` 확장 후 공유 | ❌ 도메인이 달라 비추 |

**추천: 옵션 A** — `stock_goods`, `stock_products`, `stock_memos`

### 4.2 데이터 정규화 정책

| 데이터 | 정책 |
|--------|------|
| `goodsData`(124) | 한국어 → 영문 컬럼 매핑하여 `stock_goods`로 이관. `아이템번호`(공백 없는 키) 2개는 `아이템 넘버`로 통일. `개당 무게`는 새 컬럼 `unit_weight` 추가 |
| `productData` 한국어 2개 | **사용자 확인 필요**: 폐기 vs 영문으로 마이그레이션 |
| `productData` 영문 1개 | 그대로 `stock_products`로 이관 |
| `memoData`(2) | 그대로 `stock_memos`로 이관 |

### 4.3 Plan 수정 사항

- Phase 1 테이블명을 `stock_*`로 변경
- Phase 5 충돌 해결 알고리즘 → 단순 단방향 upsert로 단순화 (양쪽 같은 키 존재 시나리오 없음)
- "양쪽 데이터 동기화 검증"이 아니라 "이관 후 row count 일치 + 샘플링 검증"으로 변경

---

## 5. 사용자 결정 필요 사항

1. **테이블 명명**: `stock_goods` / `stock_products` / `stock_memos` 로 진행해도 될까요?
2. **`productData` 한국어 2 doc**: 폐기? 영문으로 변환 이관?
3. **`goodsData`의 `개당 무게` 필드**: 새 컬럼으로 보존? 무시?
4. **`아이템번호`(공백 없는) 2개**: `아이템 넘버`로 합칠지 (값이 동일하다면 단순 통합 가능)

---

## 6. 다음 단계

- 위 결정사항 확정 → `firestore-to-supabase-migration.md` Plan 업데이트
- Phase 1 (Supabase 스키마 SQL) 작성 착수
