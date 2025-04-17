# stockmanager

우리 사무실 재고관리

## Getting Started
1. 개괄 
- 상품목록 : 상품추가/상품목록
- 제품목록 : 제품만들기 / 제품목록
2. 데이터베이스 : Mysql
3. 상품목록 - 상품을 추가하여 DB에 저장한 후, 상품목록에서 불러오기(카테고리 및 검색결과 별로 불러오기)


## 판매가 계산기 만드는 공식
원가(production cost) : P
판매가(selling price) : S
수수료율(commission ratio) : C
수익률(earning ratio) : E
배송비(delivery charge) : D

S = P / (1-E-C)
S= (P+D) / (1-E-C)  
1의 자리에서 반올림할 것.


