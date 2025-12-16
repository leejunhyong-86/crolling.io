-- ═══════════════════════════════════════════════════════════════
-- TradeWinds Database Schema
-- Migration: 001_initial_schema
-- Description: 초기 데이터베이스 스키마 생성
-- ═══════════════════════════════════════════════════════════════

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ───────────────────────────────────────────────────────────────
-- 1. ports (항구 - 크라우드펀딩 사이트)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    country_code VARCHAR(3) NOT NULL,
    region VARCHAR(50) NOT NULL,
    base_url VARCHAR(500) NOT NULL,
    logo_url VARCHAR(500),
    description TEXT,
    categories JSONB DEFAULT '[]',
    is_active BOOLEAN DEFAULT true,
    treasure_count INTEGER DEFAULT 0,
    priority VARCHAR(20) DEFAULT 'medium',
    crawl_frequency VARCHAR(20) DEFAULT 'daily',
    coordinates JSONB,
    last_crawled_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_ports_country ON ports(country);
CREATE INDEX IF NOT EXISTS idx_ports_country_code ON ports(country_code);
CREATE INDEX IF NOT EXISTS idx_ports_region ON ports(region);
CREATE INDEX IF NOT EXISTS idx_ports_is_active ON ports(is_active);
CREATE INDEX IF NOT EXISTS idx_ports_priority ON ports(priority);

-- ───────────────────────────────────────────────────────────────
-- 2. treasures (보물 - 크롤링된 상품)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS treasures (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    port_id UUID NOT NULL REFERENCES ports(id) ON DELETE CASCADE,
    external_id VARCHAR(100),
    
    -- 기본 정보
    title VARCHAR(500) NOT NULL,
    description TEXT,
    short_description VARCHAR(300),
    
    -- 미디어
    image_urls JSONB DEFAULT '[]',
    thumbnail_url VARCHAR(500),
    video_url VARCHAR(500),
    
    -- 펀딩 정보
    original_url VARCHAR(1000) NOT NULL,
    funding_goal DECIMAL(15, 2),
    funding_current DECIMAL(15, 2),
    funding_percent INTEGER DEFAULT 0,
    backer_count INTEGER DEFAULT 0,
    currency VARCHAR(10) DEFAULT 'USD',
    price_krw DECIMAL(15, 2),
    
    -- 일정
    start_date TIMESTAMPTZ,
    end_date TIMESTAMPTZ,
    
    -- 분류
    category VARCHAR(100),
    subcategory VARCHAR(100),
    tags JSONB DEFAULT '[]',
    
    -- 메타
    creator_name VARCHAR(200),
    creator_avatar VARCHAR(500),
    
    -- 상태
    status VARCHAR(20) DEFAULT 'active', -- active, ended, cancelled
    is_featured BOOLEAN DEFAULT false,
    view_count INTEGER DEFAULT 0,
    wishlist_count INTEGER DEFAULT 0,
    
    -- 타임스탬프
    crawled_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- 유니크 제약
    UNIQUE(port_id, external_id)
);

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_treasures_port_id ON treasures(port_id);
CREATE INDEX IF NOT EXISTS idx_treasures_category ON treasures(category);
CREATE INDEX IF NOT EXISTS idx_treasures_status ON treasures(status);
CREATE INDEX IF NOT EXISTS idx_treasures_end_date ON treasures(end_date);
CREATE INDEX IF NOT EXISTS idx_treasures_funding_percent ON treasures(funding_percent);
CREATE INDEX IF NOT EXISTS idx_treasures_crawled_at ON treasures(crawled_at DESC);
CREATE INDEX IF NOT EXISTS idx_treasures_is_featured ON treasures(is_featured);
CREATE INDEX IF NOT EXISTS idx_treasures_view_count ON treasures(view_count DESC);
CREATE INDEX IF NOT EXISTS idx_treasures_wishlist_count ON treasures(wishlist_count DESC);

-- 전문 검색 인덱스
CREATE INDEX IF NOT EXISTS idx_treasures_title_search ON treasures USING gin(to_tsvector('english', title));

-- ───────────────────────────────────────────────────────────────
-- 3. captains (선장 - 사용자)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS captains (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- 프로필
    nickname VARCHAR(50),
    email VARCHAR(255),
    avatar_url VARCHAR(500),
    
    -- 등급 시스템
    rank VARCHAR(20) DEFAULT 'apprentice', -- apprentice, navigator, captain, admiral, legend
    xp INTEGER DEFAULT 0,
    
    -- 리워드
    gold_coins INTEGER DEFAULT 0,
    
    -- 통계
    total_voyages INTEGER DEFAULT 0,      -- 총 방문 횟수
    total_discoveries INTEGER DEFAULT 0,  -- 발견한 보물 수
    total_trades INTEGER DEFAULT 0,       -- 구매 횟수
    ports_visited INTEGER DEFAULT 0,      -- 방문한 항구 수
    
    -- 설정
    notification_settings JSONB DEFAULT '{
        "new_treasure": true,
        "wishlist_update": true,
        "ending_soon": true,
        "marketing": false
    }',
    
    -- 온보딩
    onboarding_completed BOOLEAN DEFAULT false,
    
    -- 타임스탬프
    last_active_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ───────────────────────────────────────────────────────────────
-- 4. cargo (선적 화물 - 장바구니)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cargo (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    captain_id UUID NOT NULL REFERENCES captains(id) ON DELETE CASCADE,
    treasure_id UUID NOT NULL REFERENCES treasures(id) ON DELETE CASCADE,
    quantity INTEGER DEFAULT 1,
    reward_tier VARCHAR(100), -- 펀딩 보상 티어
    added_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(captain_id, treasure_id)
);

CREATE INDEX IF NOT EXISTS idx_cargo_captain_id ON cargo(captain_id);

-- ───────────────────────────────────────────────────────────────
-- 5. treasure_maps (보물 지도 - 위시리스트)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS treasure_maps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    captain_id UUID NOT NULL REFERENCES captains(id) ON DELETE CASCADE,
    treasure_id UUID NOT NULL REFERENCES treasures(id) ON DELETE CASCADE,
    note TEXT,
    folder VARCHAR(100) DEFAULT 'default',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(captain_id, treasure_id)
);

CREATE INDEX IF NOT EXISTS idx_treasure_maps_captain_id ON treasure_maps(captain_id);
CREATE INDEX IF NOT EXISTS idx_treasure_maps_treasure_id ON treasure_maps(treasure_id);

-- ───────────────────────────────────────────────────────────────
-- 6. voyage_logs (항해 일지 - 조회 기록)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS voyage_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    captain_id UUID NOT NULL REFERENCES captains(id) ON DELETE CASCADE,
    treasure_id UUID NOT NULL REFERENCES treasures(id) ON DELETE CASCADE,
    viewed_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_voyage_logs_captain_id ON voyage_logs(captain_id);
CREATE INDEX IF NOT EXISTS idx_voyage_logs_viewed_at ON voyage_logs(viewed_at DESC);
CREATE INDEX IF NOT EXISTS idx_voyage_logs_captain_treasure ON voyage_logs(captain_id, treasure_id);

-- ───────────────────────────────────────────────────────────────
-- 7. trades (교역 - 주문)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS trades (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    captain_id UUID NOT NULL REFERENCES captains(id),
    
    -- 주문 정보
    order_number VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'pending', -- pending, processing, shipped, delivered, cancelled
    
    -- 금액
    subtotal DECIMAL(15, 2) NOT NULL,
    shipping_fee DECIMAL(15, 2) DEFAULT 0,
    discount DECIMAL(15, 2) DEFAULT 0,
    total_amount DECIMAL(15, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'KRW',
    
    -- 결제
    payment_method VARCHAR(50),
    payment_status VARCHAR(20) DEFAULT 'pending',
    paid_at TIMESTAMPTZ,
    
    -- 배송
    shipping_address JSONB,
    tracking_number VARCHAR(100),
    shipped_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    
    -- 적립
    gold_earned INTEGER DEFAULT 0,
    xp_earned INTEGER DEFAULT 0,
    
    -- 타임스탬프
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_trades_captain_id ON trades(captain_id);
CREATE INDEX IF NOT EXISTS idx_trades_status ON trades(status);
CREATE INDEX IF NOT EXISTS idx_trades_order_number ON trades(order_number);

-- ───────────────────────────────────────────────────────────────
-- 8. trade_items (교역 상품 - 주문 상세)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS trade_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trade_id UUID NOT NULL REFERENCES trades(id) ON DELETE CASCADE,
    treasure_id UUID NOT NULL REFERENCES treasures(id),
    
    quantity INTEGER DEFAULT 1,
    unit_price DECIMAL(15, 2) NOT NULL,
    reward_tier VARCHAR(100),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_trade_items_trade_id ON trade_items(trade_id);

-- ───────────────────────────────────────────────────────────────
-- 9. gold_transactions (금화 거래 내역)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gold_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    captain_id UUID NOT NULL REFERENCES captains(id),
    
    type VARCHAR(20) NOT NULL, -- earn, spend, expire
    amount INTEGER NOT NULL,
    balance_after INTEGER NOT NULL,
    
    description VARCHAR(200),
    reference_type VARCHAR(50), -- trade, review, event, etc.
    reference_id UUID,
    
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_gold_transactions_captain_id ON gold_transactions(captain_id);
CREATE INDEX IF NOT EXISTS idx_gold_transactions_type ON gold_transactions(type);

-- ───────────────────────────────────────────────────────────────
-- 10. permits (항해 허가증 - 쿠폰)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS permits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    captain_id UUID REFERENCES captains(id),
    
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    
    discount_type VARCHAR(20) NOT NULL, -- percentage, fixed
    discount_value DECIMAL(10, 2) NOT NULL,
    min_order_amount DECIMAL(15, 2) DEFAULT 0,
    max_discount DECIMAL(15, 2),
    
    is_used BOOLEAN DEFAULT false,
    used_at TIMESTAMPTZ,
    trade_id UUID REFERENCES trades(id),
    
    valid_from TIMESTAMPTZ DEFAULT NOW(),
    valid_until TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_permits_captain_id ON permits(captain_id);
CREATE INDEX IF NOT EXISTS idx_permits_code ON permits(code);
CREATE INDEX IF NOT EXISTS idx_permits_is_used ON permits(is_used);

-- ───────────────────────────────────────────────────────────────
-- 11. reviews (항해사 평가 - 리뷰)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    captain_id UUID NOT NULL REFERENCES captains(id),
    treasure_id UUID NOT NULL REFERENCES treasures(id),
    trade_id UUID REFERENCES trades(id),
    
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    content TEXT,
    image_urls JSONB DEFAULT '[]',
    
    is_verified_purchase BOOLEAN DEFAULT false,
    helpful_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(captain_id, treasure_id)
);

CREATE INDEX IF NOT EXISTS idx_reviews_treasure_id ON reviews(treasure_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);
CREATE INDEX IF NOT EXISTS idx_reviews_captain_id ON reviews(captain_id);

-- ───────────────────────────────────────────────────────────────
-- 12. xp_transactions (XP 획득 내역)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS xp_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    captain_id UUID NOT NULL REFERENCES captains(id),
    
    amount INTEGER NOT NULL,
    activity_type VARCHAR(50) NOT NULL, -- login, view, wishlist, trade, review, share
    description VARCHAR(200),
    reference_id UUID,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_xp_transactions_captain_id ON xp_transactions(captain_id);
CREATE INDEX IF NOT EXISTS idx_xp_transactions_activity_type ON xp_transactions(activity_type);

-- ───────────────────────────────────────────────────────────────
-- 13. notifications (봉화 신호 - 알림)
-- ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    captain_id UUID NOT NULL REFERENCES captains(id) ON DELETE CASCADE,
    
    type VARCHAR(50) NOT NULL, -- new_treasure, wishlist_update, ending_soon, trade_update, marketing
    title VARCHAR(200) NOT NULL,
    body TEXT,
    data JSONB,
    
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_notifications_captain_id ON notifications(captain_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

