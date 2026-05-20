# Firestore → Supabase 마이그레이션 계획 (v3 — 의도 정정 후 최종)

> 작성일: 2026-05-20
> 작성자: gruto (wonsun5@gmail.com)
> 방식: 데이터 이관 없음 — **Flutter 코드만 Supabase에 맞게 교체**

---

## 🔄 v3 변경 배경

v1/v2는 **"Firestore 데이터를 Supabase로 이관한다"** 는 잘못된 전제로 작성되었습니다.

사용자 실제 의도는:
> "기존(Firestore) 데이터를 Supabase에 있는 데이터로 바꾸는 것"
> = **Firestore 폐기, Flutter 앱이 Supabase에 이미 있는 데이터를 보고 관리하도록 코드 교체**

재진단 결과, Supabase에는 **이미 데이터가 모두 준비되어 있습니다**.

---

## Executive Summary

| 항목 | 내용 |
|------|------|
| 기능 | Flutter 앱 백엔드를 Firestore → Supabase로 전환 |
| 시작일 | 2026-05-20 |
| 예상 완료일 | 2026-05-24 (영업일 ~4일) |
| 예상 소요 | **데이터 이관 불필요로 대폭 단축** (Supabase에 이미 데이터 있음) |

### 결과 요약

| 항목 | 수치 |
|------|------|
| Supabase 기존 데이터 (그대로 사용) | `materials` 116, `products` 12, `categories` 59 |
| Firestore 데이터 처리 | **모두 폐기** (goodsData 124, productData 3, memoData 2) |
| 제거 대상 기능 | Memo 전체 (memos 테이블 없음, 화면/Repository/Model 삭제) |
| 변경 대상 파일 | Models 2, Repositories 2, main.dart, pubspec.yaml + Memo 파일 5+ 삭제 |
| 제거 대상 의존성 | `cloud_firestore`, `firebase_core`, `firebase_options.dart`, `tools/extract_categories.dart` |

### Value Delivered (4관점)

| 관점 | 내용 |
|------|------|
| Problem | Flutter 앱이 Firestore를 보고 있는데, 실제 사용 데이터는 이미 Supabase에 있음. 두 곳을 오가는 비효율. |
| Solution | Flutter 모델/Repository를 Supabase 스키마에 맞춰 재설계. Firestore 완전 제거. |
| Function UX Effect | 동일한 화면에서 Supabase 데이터를 보고 관리. Memo 메뉴 사라짐. |
| Core Value | 단일 백엔드. 카테고리 정규화(FK) 활용. SQL 기반 확장 가능. |

---

## 1. Supabase 데이터 현황 (재진단 결과)

### 1.1 `materials` 테이블 — 116 row

기존 Firestore `goodsData`(124)에서 이관된 흔적이 명백 (`original_item_number`, `firebase_category` 컬럼). 124 → 116 = 8개 차이는 폐기되거나 통합된 것으로 추정. **사용자 결정: Supabase 데이터를 신뢰하고 차이 무시**.

| 컬럼 | 타입 | 비고 |
|------|------|------|
| `id` | integer PK auto | **새 PK 체계 (기존 itemNumber와 다름)** |
| `name` | text | (기존: `상품명`) |
| `category_id` | integer FK→categories | (기존: `카테고리` string → FK 정규화) |
| `price` | integer | (기존: `상품가격`) |
| `unit_price` | integer | (개당 가격) |
| `stock_quantity` | integer | (기존: `상품재고`) |
| `unit` | text | "개" 등 |
| `weight` | text | (기존: `상품무게`) |
| `quantity` | integer | (기존: `상품갯수`) |
| `memo` | text | (기존: `메모`) |
| `image_url` | text | 모두 null |
| `original_item_number` | text | Firestore itemNumber 보존 (검색·표시용) |
| `firebase_category` | text | Firestore 카테고리 string 보존 |
| `created_at`, `updated_at` | timestamptz | |

**firebase_category 분포**: 과자 44, 초콜릿 23, 사탕 20, 젤리 17, 차/음료 7, 껌 3, 기타 2

### 1.2 `products` 테이블 — 12 row

쇼핑몰 카탈로그 + Flutter 앱이 사용할 필드들.

주요 컬럼 (Flutter 매핑 관점):
- `id` PK integer auto
- `name`, `description`(Quill JSON), `image_url`, `additional_images`(text[])
- `total_price`, `unit_price`, `cost_price`, `discount_price`, `shipping_fee`
- `category_id` FK
- `product_code`, `related_product_code` (← Flutter의 itemNumber, g_itemNumber)
- `stock_quantity`, `quantity`, `weight`
- `commission_rate`, `earning_rate`, `commission`, `earning`
- `delivery_method`, `memo`
- `is_displayed`, `is_sold_out`, `is_user_creatable`, `tags`(jsonb)
- `created_at`

### 1.3 `categories` 테이블 — 59 row

| 컬럼 | 타입 |
|------|------|
| `id` | integer PK |
| `name` | text |
| `parent_id` | integer (self FK, 계층) |
| `created_at` | timestamptz |

`materials.category_id`, `products.category_id`가 이 테이블 참조.

### 1.4 `memos` 테이블 — 존재하지 않음

→ Memo 기능 자체를 Flutter 앱에서 제거.

---

## 2. Flutter 모델 재설계

### 2.1 GoodsFirebaseModel → MaterialModel (신규)

```dart
class MaterialModel {
  final int? id;                       // PK auto (insert 시 null)
  final String? name;                  // (기존 title)
  final int? categoryId;               // FK
  final String? firebaseCategory;      // 카테고리 string (표시·필터용)
  final int? price;
  final int? unitPrice;
  final int? stockQuantity;            // (기존 stock)
  final String? unit;                  // "개"
  final String? weight;
  final int? quantity;                 // (기존 number)
  final String? memo;
  final String? imageUrl;
  final String? originalItemNumber;    // (기존 itemNumber, 검색·표시)
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

- 기존 `GoodsFirebaseModel`의 한국어 키 처리는 모두 제거.
- 화면에서 itemNumber로 표시하던 부분은 `originalItemNumber`로 교체.
- 카테고리는 우선 `firebaseCategory`(string)로 표시 → 추후 categories join 고려.

### 2.2 ProductFirebaseModel → ProductModel (신규)

```dart
class ProductModel {
  final int? id;
  final String? name;                  // (기존 title)
  final String? productCode;           // (기존 itemNumber)
  final String? relatedProductCode;    // (기존 g_itemNumber)
  final int? categoryId;
  final int? totalPrice;               // (기존 price)
  final int? unitPrice;                // (기존 p_price)
  final int? costPrice;                // (기존 costPrice)
  final int? stockQuantity;            // (기존 stock)
  final int? quantity;                 // (기존 number)
  final String? weight;
  final num? commissionRate;
  final num? earningRate;
  final num? commission;
  final num? earning;
  final String? deliveryMethod;
  final String? memo;
  final String? imageUrl;
  final List<String>? additionalImages;
  final bool? isDisplayed;
  final bool? isSoldOut;
  // description(Quill), tags(jsonb), shipping_fee, discount_* 등은 표시만, 편집 X
  final DateTime? createdAt;
}
```

- `g_title`(구성 상품명)은 Supabase products에 컬럼 없음 → **현재 Flutter에는 입력 칸이 있으나 저장 못 함 → UI에서 제거**.
- 가격 계산기(`add_product_viewmodel.dart`)의 컬럼명만 갈아끼움.

### 2.3 MemoModel → 삭제

---

## 3. 작업 단계

### Phase A — 모델 + Repository 재작성 *(~1일)*

- [pubspec.yaml](pubspec.yaml)에 `supabase_flutter` 추가
- `lib/data/models/material_model.dart` 신규
- `lib/data/models/product_model.dart` Supabase 스키마로 교체
- `lib/data/repositories/material_repository.dart` 신규 (Supabase)
- `lib/data/repositories/product_repository.dart` Supabase로 교체
- Stream은 Supabase `.stream(primaryKey: ['id'])` 사용 → 실시간 유지

### Phase B — Memo 기능 제거 *(~0.5일)*

삭제 파일:
- `lib/data/models/memo_model.dart`
- `lib/data/repositories/memo_repository.dart`
- `lib/presentation/views/memo/` 전체
- `lib/presentation/viewmodels/memo_list_viewmodel.dart`
- `lib/presentation/viewmodels/add_memo_viewmodel.dart`

수정:
- `lib/main.dart`: `/memoList`, `/addMemo` 라우트 제거
- `lib/presentation/views/home_screen.dart`: 메모 메뉴 버튼 제거

### Phase C — ViewModel / 화면 코드 수정 *(~1일)*

`GoodsFirebaseModel` → `MaterialModel` 변경 영향:
- `lib/presentation/viewmodels/goods_list_viewmodel.dart`
- `lib/presentation/viewmodels/add_goods_viewmodel.dart`
- `lib/presentation/views/goods/add_goods_screen.dart`
- `lib/presentation/views/goods/goods_detail_screen.dart`
- `lib/presentation/views/goods/goods_list_screen.dart` (있다면)
- `lib/views/screen/add_product_form.dart` (legacy)

`ProductFirebaseModel` → `ProductModel` 변경 영향:
- `lib/presentation/viewmodels/product_list_viewmodel.dart`
- `lib/presentation/viewmodels/add_product_viewmodel.dart` (가격 계산기)
- `lib/presentation/viewmodels/add_product_state.dart`
- `lib/presentation/views/product/*.dart`

`g_title` 입력 칸 제거 (Supabase products에 컬럼 없음).

### Phase D — main.dart 교체 *(~0.5일)*

```dart
// Before
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// After
await Supabase.initialize(
  url: const String.fromEnvironment('SUPABASE_URL'),
  anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
);
```

`.env` 로딩은 `flutter_dotenv` 추가 또는 `--dart-define` 빌드 옵션 사용 결정 필요.

### Phase E — Firebase 흔적 제거 + 정리 *(~0.5일)*

- `pubspec.yaml`에서 `cloud_firestore`, `firebase_core` 제거
- `lib/firebase_options.dart` 삭제
- `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist` 삭제
- Gradle/Podfile에서 Firebase 플러그인 제거
- `tools/extract_categories.dart` 삭제 (Firebase 의존성 + 임무 완료)
- `flutter clean && flutter pub get` 후 빌드 확인

---

## 4. 리스크 & 완화책

| 리스크 | 완화책 |
|--------|--------|
| PK 체계 변경(string itemNumber → integer id)으로 화면/검색 로직 영향 | `original_item_number` / `product_code` 텍스트 컬럼으로 사용자 표시는 유지 |
| `g_title` 컬럼 없음 → 입력 칸 제거로 UX 변화 | 사용자에게 사전 공지, 필요 시 Supabase에 `g_title` 추가 옵션 |
| Memo 삭제로 인한 라우트/import 누락 | `flutter analyze` 통과 확인 |
| `--dart-define`이냐 `.env` 패키지냐 결정 미정 | Phase D 진입 전 확정 (질문 필요) |
| Supabase Realtime 동작이 Firestore Stream과 미세 차이 | 수동 스모크 테스트로 확인 |
| Firestore 데이터 폐기 후 복구 불가 | Firebase 콘솔/billing은 당분간 유지 (실수 시 복구 가능) |

---

## 5. 완료 기준

- [ ] 앱이 빌드되고 모든 화면(Goods/Product) 정상 표시
- [ ] Supabase `materials` 116 row가 Goods 리스트에 표시
- [ ] Supabase `products` 12 row가 Product 리스트에 표시
- [ ] Goods/Product 추가·수정·삭제가 Supabase에 반영됨
- [ ] 다른 디바이스에서 변경 시 실시간 반영
- [ ] Memo 메뉴/화면/코드 완전 제거
- [ ] `pubspec.yaml`에 firebase_* 의존성 없음
- [ ] `flutter analyze` 0 error

---

## 6. 결정 필요 (Phase A 진입 전)

1. **카테고리 표시 방식**:
   - (a) `firebase_category` string 그대로 표시 (간단)
   - (b) `category_id` FK + categories 테이블 join하여 `name` 표시 (정규화된 방식)
   - (c) 둘 다 보존하되 표시는 `firebase_category`, 신규 입력 시 categories에서 선택

2. **Supabase 자격증명 주입 방식**:
   - (a) `--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` (빌드 옵션, .env 불필요)
   - (b) `flutter_dotenv` 패키지 추가하여 `.env` 런타임 로드 (이미 .env 파일 있음 → 자연스러움)

3. **`g_title` 처리**:
   - (a) Supabase products에 `g_title` 컬럼 추가 후 유지
   - (b) UI에서 입력 칸 제거 (단순화)

4. **`add_product_form.dart` (lib/views/screen/)**:
   - 이건 legacy 파일로 보이는데 사용 중인가요? 사용 안 하면 같이 제거.

---

## 7. 다음 단계

1. ✅ Plan v3 검토
2. 위 결정 4가지 확정
3. Phase A 착수 (모델 + Repository 재작성)
