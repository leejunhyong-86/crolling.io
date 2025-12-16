# TradeWinds 개발 계획서 (TODO)

> **프로젝트명:** TradeWinds (트레이드윈즈)  
> **문서 버전:** 1.0.0  
> **최종 수정일:** 2024년 12월

---

## 개발 개요

### 기술 스택
- **Frontend:** Flutter 3.x (Dart)
- **Backend:** Supabase (PostgreSQL, Auth, Storage, Edge Functions)
- **State Management:** flutter_bloc
- **지도:** flutter_map + OpenStreetMap
- **Crawling:** Python (Scrapy) + Supabase Edge Functions

### 개발 기간
- **Phase 0 (기획/설계):** 2주
- **Phase 1 (MVP 개발):** 8주
- **Phase 2 (베타 런칭):** 4주
- **Phase 3 (정식 런칭):** 4주

---

## Phase 0: 기획 및 설계 (2주)

### Week 1: 기획 문서화

- [x] PRD(Product Requirements Document) 작성
- [x] 서비스 브랜딩 확정 (네이밍, 슬로건, 세계관)
- [x] UX/UI 용어 매핑 테이블 작성
- [x] 컬러 팔레트 및 디자인 시스템 정의
- [x] 와이어프레임 설계 (Markdown 문서로 대체)
  - [x] 온보딩 화면 → `docs/wireframes/01_onboarding.md`
  - [x] 항해 본부 (홈) → `docs/wireframes/02_home.md`
  - [x] 세계 지도 탐험 → `docs/wireframes/03_world_map.md`
  - [x] 보물 목록 / 보물 감정서 → `docs/wireframes/04_treasure.md`
  - [x] 선적 화물 (장바구니) → `docs/wireframes/05_cart.md`
  - [x] 선장실 (마이페이지) → `docs/wireframes/06_profile.md`

### Week 2: 기술 설계

- [x] 데이터베이스 스키마 설계
- [x] ERD 다이어그램 작성
- [ ] API 엔드포인트 설계
- [x] Flutter 프로젝트 아키텍처 설계 → `tradewinds_app/`
- [ ] 크롤링 시스템 설계
- [x] 145개 크라우드펀딩 사이트 목록 정리 → `data/crowdfunding_sites.json`
  - [x] 국가별 분류
  - [x] 카테고리별 분류
  - [x] 크롤링 우선순위 결정

---

## Phase 1: MVP 개발 (8주)

### Sprint 1 (Week 1-2): 프로젝트 셋업 & 인프라

#### 1.1 Flutter 프로젝트 초기화
- [x] Flutter 프로젝트 생성 → `tradewinds_app/`
- [x] 폴더 구조 설정 (Clean Architecture)
  ```
  lib/
  ├── core/           ✅ 구현 완료
  ├── data/           (Phase 2에서 구현)
  ├── domain/         (Phase 2에서 구현)
  ├── presentation/   ✅ 구현 완료
  └── routes/         ✅ 구현 완료
  ```
- [x] 필수 패키지 설치
  - [x] `flutter_bloc` - 상태관리
  - [ ] `supabase_flutter` - Supabase 연동
  - [x] `flutter_map` - 지도
  - [x] `go_router` - 라우팅
  - [ ] `freezed` - 모델 코드 생성
  - [ ] `hive_flutter` - 로컬 저장소
  - [x] `cached_network_image` - 이미지 캐싱

#### 1.2 Supabase 설정
- [ ] Supabase 프로젝트 생성
- [ ] 데이터베이스 스키마 적용 (Migration)
  - [ ] `ports` 테이블
  - [ ] `treasures` 테이블
  - [ ] `captains` 테이블
  - [ ] `cargo` 테이블
  - [ ] `treasure_maps` 테이블
  - [ ] `voyage_logs` 테이블
  - [ ] `trades` 테이블
  - [ ] `reviews` 테이블
- [ ] Row Level Security (RLS) 정책 설정
- [ ] Storage 버킷 설정 (이미지 저장용)
- [ ] Edge Functions 환경 설정

#### 1.3 개발 환경 설정
- [ ] 환경 변수 설정 (.env)
- [x] Git 저장소 초기화
- [x] README.md 작성 → `tradewinds_app/README.md`
- [x] 코드 포맷팅 설정 (analysis_options.yaml)

### Sprint 2 (Week 3-4): 인증 & 기본 UI

#### 2.1 인증 시스템
- [ ] Supabase Auth 연동
- [ ] 소셜 로그인 구현
  - [ ] Google 로그인
  - [ ] Apple 로그인 (iOS)
  - [ ] Kakao 로그인
- [ ] 로그인/회원가입 화면 UI
- [ ] 자동 로그인 (토큰 저장)
- [ ] 로그아웃 기능
- [ ] 회원 탈퇴 기능

#### 2.2 온보딩 플로우
- [x] 스플래시 화면 → `splash_page.dart`
  - [x] 로고 애니메이션 (나침반)
  - [x] "새로운 항해를 시작합니다" 텍스트
- [x] 온보딩 튜토리얼 (3~4 페이지) → `onboarding_page.dart`
  - [x] 세계관 소개
  - [x] 핵심 기능 소개
  - [x] 시작하기 버튼
- [ ] 선장 프로필 설정
  - [ ] 닉네임 입력
  - [ ] 아바타 선택

#### 2.3 기본 UI 컴포넌트
- [x] 테마 설정 (AppColors, AppTypography) → `core/constants/`, `core/theme/`
- [x] 커스텀 위젯 제작 → `presentation/widgets/`
  - [ ] TradeWindsAppBar (앱바)
  - [x] TreasureCard (상품 카드) → `treasure_card.dart`
  - [x] CompassLoading (로딩 인디케이터) → `compass_loading.dart`
  - [x] GoldButton (CTA 버튼) → `gold_button.dart`
  - [ ] ParchmentCard (파치먼트 배경 카드)
- [x] 하단 네비게이션 바 (나침반 모티브) → `app_router.dart`
- [x] 에러/빈 상태 화면 → `empty_state.dart`

### Sprint 3 (Week 5-6): 핵심 기능 개발

#### 3.1 항해 본부 (홈 화면)
- [x] 홈 화면 레이아웃 → `home_page.dart`
- [x] 섹션 구현 (UI Mock)
  - [x] 오늘 발견된 유물 (가로 스크롤)
  - [x] 떠오르는 보물 (가로 스크롤)
  - [x] 선장들의 선택 (그리드)
  - [x] 마감 임박 항해 (리스트)
- [ ] Pull-to-refresh (데이터 연동 시)
- [ ] 무한 스크롤 (페이지네이션)
- [ ] 스켈레톤 로딩

#### 3.2 보물 목록 (상품 목록)
- [ ] 리스트/그리드 뷰 토글
- [ ] 정렬 옵션
  - [ ] 최신순
  - [ ] 인기순 (펀딩률)
  - [ ] 마감임박순
- [ ] 필터 기능
  - [ ] 가격대
  - [ ] 카테고리 (항로)
  - [ ] 펀딩 상태
  - [ ] 항구 (사이트)
- [ ] 빈 결과 화면

#### 3.3 보물 감정서 (상품 상세)
- [x] 이미지 캐러셀 → `treasure_detail_page.dart`
- [x] 상품 정보 표시 (UI Mock)
  - [x] 제목, 설명
  - [x] 가격 (원화 환산)
  - [x] 펀딩 진행률 (프로그레스 바)
  - [x] 남은 기간
  - [x] 참여자 수
- [x] 원본 사이트 바로가기 버튼
- [x] 보물 지도 추가 (찜하기)
- [x] 선적하기 (장바구니 추가)
- [x] 공유 기능
- [x] 항해사 평가 (리뷰) 섹션

#### 3.4 정찰 (검색)
- [ ] 검색 화면 UI
- [ ] 키워드 검색 (Supabase full-text search)
- [ ] 자동완성 (최근 검색어)
- [ ] 검색 결과 표시
- [ ] 검색 히스토리 저장 (로컬)

#### 3.5 세계 지도 탐험
- [x] 세계 지도 표시 (flutter_map) → `map_page.dart`
- [x] 국가별 마커 (항구) 표시
- [x] 마커 클릭 시 바텀시트
  - [x] 국가명, 펀딩 사이트 수
  - [x] 사이트 목록
- [x] 대륙별 필터 (상단 칩)
- [x] 확대/축소 제스처
- [ ] 항구 선택 시 해당 사이트 보물 목록으로 이동 (데이터 연동 시)

### Sprint 4 (Week 7-8): 사용자 기능 & QA

#### 4.1 선적 화물 (장바구니)
- [x] 장바구니 화면 UI → `cart_page.dart`
- [x] 상품 추가/삭제 (UI)
- [x] 수량 변경 (UI)
- [x] 예상 금액 계산 (UI)
- [x] 빈 장바구니 화면
- [x] 교역하기 (결제) 버튼 (Phase 2에서 연동)

#### 4.2 보물 지도 (위시리스트)
- [ ] 위시리스트 화면
- [ ] 찜 추가/삭제
- [ ] 폴더 분류 기능 (선택)
- [ ] 마감 임박 표시

#### 4.3 항해 일지 (최근 본 상품)
- [ ] 조회 기록 저장
- [ ] 조회 기록 화면
- [ ] 기록 삭제 기능

#### 4.4 선장실 (마이페이지)
- [x] 프로필 표시 → `profile_page.dart`
  - [x] 닉네임, 아바타
  - [x] 선장 등급 & XP 바
  - [x] 금화 잔액
- [x] 항해 통계 (UI Mock)
- [x] 메뉴 구성
  - [x] 보물 지도
  - [x] 항해 일지
  - [x] 교역 내역 (준비 중)
  - [x] 금화 & 허가증 (준비 중)
  - [x] 봉화 신호 설정
  - [x] 설정

#### 4.5 설정
- [ ] 알림 설정
- [ ] 계정 관리
- [ ] 앱 정보
- [ ] 로그아웃
- [ ] 회원 탈퇴

#### 4.6 QA & 버그 수정
- [ ] 기능 테스트
- [ ] UI/UX 점검
- [ ] 성능 최적화
- [ ] 에러 핸들링 점검
- [ ] 다양한 기기 테스트

---

## Phase 2: 베타 런칭 (4주)

### Week 9-10: 크롤링 시스템 구축

#### 크롤링 서버 개발
- [ ] Python 크롤링 환경 설정
- [ ] 크롤러 아키텍처 설계
- [ ] 주요 사이트 크롤러 개발
  - [ ] Kickstarter 크롤러
  - [ ] Indiegogo 크롤러
  - [ ] Makuake 크롤러
  - [ ] Wadiz 크롤러
  - [ ] 기타 사이트 (우선순위에 따라)
- [ ] 데이터 파싱 & 정제
- [ ] Supabase 데이터 저장
- [ ] 스케줄러 설정 (정기 크롤링)
- [ ] 에러 알림 시스템

### Week 11: 추가 기능 개발

#### 알림 시스템
- [ ] Firebase Cloud Messaging 연동
- [ ] 푸시 알림 구현
  - [ ] 신규 보물 알림
  - [ ] 찜 상품 업데이트
  - [ ] 마감 임박 알림
- [ ] 인앱 알림 센터

#### 리뷰 시스템
- [ ] 리뷰 작성 UI
- [ ] 별점 입력
- [ ] 이미지 첨부
- [ ] 리뷰 목록 표시
- [ ] 도움됨 투표

### Week 12: 베타 테스트

#### 베타 사용자 모집
- [ ] 테스트플라이트 설정 (iOS)
- [ ] Firebase App Distribution (Android)
- [ ] 얼리버드 탐험대 모집 (500명)
- [ ] 베타 테스터 전용 칭호 부여

#### 피드백 수집
- [ ] 인앱 피드백 기능
- [ ] 설문조사
- [ ] 버그 리포트 수집
- [ ] 개선 사항 정리

---

## Phase 3: 정식 런칭 (4주)

### Week 13-14: 결제 시스템 & 마감

#### 결제 연동
- [ ] 결제 PG 선정 (토스페이먼츠 / 아임포트)
- [ ] 결제 플로우 구현
- [ ] 주문서 작성 화면
- [ ] 결제 완료 화면
- [ ] 주문 내역 관리

#### 배송 연동
- [ ] 배송 상태 추적
- [ ] 배송 알림

#### 운영 기능
- [ ] 관리자 대시보드 (기본)
- [ ] 사용자 문의 시스템
- [ ] FAQ 페이지

### Week 15: 앱스토어 출시

#### iOS 출시
- [ ] App Store Connect 설정
- [ ] 앱 스크린샷 제작
- [ ] 앱 설명문 작성
- [ ] 심사 제출
- [ ] 심사 대응

#### Android 출시
- [ ] Google Play Console 설정
- [ ] 스토어 등록 정보 작성
- [ ] 앱 출시
- [ ] 피처드 신청

### Week 16: 런칭 마케팅

#### 마케팅 집행
- [ ] 런칭 보도자료 배포
- [ ] SNS 채널 오픈 (인스타그램, 트위터)
- [ ] 테크 유튜버 협업 진행
- [ ] 커뮤니티 바이럴

#### 운영 안정화
- [ ] 실시간 모니터링
- [ ] 긴급 버그 대응
- [ ] 사용자 피드백 대응

---

## Phase 4: 고도화 (지속)

### 기능 고도화

#### AI 추천 시스템
- [ ] 사용자 행동 데이터 수집
- [ ] 추천 알고리즘 개발
- [ ] "숨겨진 보물" 섹션 구현

#### 선장 등급 시스템 완성
- [ ] XP 획득 로직 구현
- [ ] 등급별 혜택 적용
- [ ] 등급 업 알림

#### 금화 & 허가증 시스템
- [ ] 금화 적립/사용 기능
- [ ] 쿠폰(허가증) 시스템
- [ ] 리워드 히스토리

### 수익화

#### 프리미엄 멤버십
- [ ] 멤버십 상품 설계
- [ ] 인앱 구독 연동 (iOS/Android)
- [ ] 프리미엄 혜택 구현

#### 광고 연동
- [ ] AdMob 연동
- [ ] 네이티브 광고 배치

### 글로벌 확장

#### 다국어 지원
- [ ] 영어 지원
- [ ] 일본어 지원
- [ ] 다국어 시스템 구축

---

## 크라우드펀딩 사이트 목록 (정리 필요)

### 북미 (North America)
| No. | 사이트명 | 국가 | URL | 우선순위 |
|-----|---------|------|-----|---------|
| 1 | Kickstarter | 미국 | kickstarter.com | 🔴 High |
| 2 | Indiegogo | 미국 | indiegogo.com | 🔴 High |
| 3 | GoFundMe | 미국 | gofundme.com | 🟡 Medium |
| 4 | Patreon | 미국 | patreon.com | 🟡 Medium |
| 5 | Republic | 미국 | republic.com | 🟢 Low |
| ... | ... | ... | ... | ... |

### 아시아 (Asia)
| No. | 사이트명 | 국가 | URL | 우선순위 |
|-----|---------|------|-----|---------|
| 1 | Makuake | 일본 | makuake.com | 🔴 High |
| 2 | Campfire | 일본 | camp-fire.jp | 🔴 High |
| 3 | Wadiz | 한국 | wadiz.kr | 🔴 High |
| 4 | Tumblbug | 한국 | tumblbug.com | 🟡 Medium |
| 5 | JD Crowdfunding | 중국 | z.jd.com | 🟢 Low |
| ... | ... | ... | ... | ... |

### 유럽 (Europe)
| No. | 사이트명 | 국가 | URL | 우선순위 |
|-----|---------|------|-----|---------|
| 1 | Ulule | 프랑스 | ulule.com | 🟡 Medium |
| 2 | KissKissBankBank | 프랑스 | kisskissbankbank.com | 🟡 Medium |
| 3 | Crowdcube | 영국 | crowdcube.com | 🟡 Medium |
| 4 | Seedrs | 영국 | seedrs.com | 🟢 Low |
| ... | ... | ... | ... | ... |

> **참고:** 전체 145개 사이트 목록은 별도 스프레드시트에서 관리

---

## 기술적 고려사항

### 성능 최적화
- [ ] 이미지 lazy loading
- [ ] 리스트 가상화
- [ ] 캐싱 전략 (Hive, Memory)
- [ ] API 응답 캐싱

### 보안
- [ ] API 키 보안 (환경 변수)
- [ ] Supabase RLS 검증
- [ ] 사용자 입력 검증
- [ ] 결제 보안 (PCI-DSS)

### 접근성
- [ ] 스크린 리더 지원
- [ ] 색상 대비 검증
- [ ] 폰트 크기 조절

### 분석
- [ ] Firebase Analytics 연동
- [ ] 사용자 행동 추적
- [ ] 전환율 측정
- [ ] A/B 테스트 환경

---

## 담당자 & 일정

| 역할 | 담당 | 비고 |
|------|------|------|
| PM/기획 | TBD | PRD, 일정 관리 |
| Flutter 개발 | TBD | 앱 개발 |
| Backend 개발 | TBD | Supabase, 크롤링 |
| 디자인 | TBD | UI/UX, 에셋 |
| QA | TBD | 테스트 |

---

## 참고 링크

- [PRD 문서](./PRD.md)
- [Supabase 대시보드](https://supabase.com/dashboard)
- [Flutter 공식 문서](https://flutter.dev/docs)
- [flutter_bloc 문서](https://bloclibrary.dev)

---

*최종 업데이트: 2024년 12월*

