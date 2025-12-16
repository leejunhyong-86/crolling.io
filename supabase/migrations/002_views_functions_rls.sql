-- ═══════════════════════════════════════════════════════════════
-- TradeWinds Database Schema
-- Migration: 002_views_functions_rls
-- Description: Views, Functions, Triggers, RLS 정책
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Views (데이터 조회용 뷰)
-- ───────────────────────────────────────────────────────────────

-- 오늘 발견된 유물 (24시간 내 크롤링)
CREATE OR REPLACE VIEW today_discoveries AS
SELECT 
    t.*,
    p.name as port_name,
    p.country,
    p.country_code,
    p.logo_url as port_logo,
    p.region
FROM treasures t
JOIN ports p ON t.port_id = p.id
WHERE t.crawled_at >= NOW() - INTERVAL '24 hours'
  AND t.status = 'active'
ORDER BY t.crawled_at DESC;

-- 떠오르는 보물 (펀딩률 높은 순)
CREATE OR REPLACE VIEW rising_treasures AS
SELECT 
    t.*,
    p.name as port_name,
    p.country,
    p.country_code,
    p.logo_url as port_logo,
    p.region
FROM treasures t
JOIN ports p ON t.port_id = p.id
WHERE t.status = 'active'
  AND t.end_date > NOW()
  AND t.funding_percent >= 100
ORDER BY t.funding_percent DESC, t.backer_count DESC
LIMIT 100;

-- 마감 임박 항해 (7일 이내 종료)
CREATE OR REPLACE VIEW ending_soon AS
SELECT 
    t.*,
    p.name as port_name,
    p.country,
    p.country_code,
    p.logo_url as port_logo,
    p.region,
    EXTRACT(DAY FROM (t.end_date - NOW())) as days_left
FROM treasures t
JOIN ports p ON t.port_id = p.id
WHERE t.status = 'active'
  AND t.end_date BETWEEN NOW() AND NOW() + INTERVAL '7 days'
ORDER BY t.end_date ASC;

-- 선장들의 선택 (찜 많은 순)
CREATE OR REPLACE VIEW captains_choice AS
SELECT 
    t.*,
    p.name as port_name,
    p.country,
    p.country_code,
    p.logo_url as port_logo,
    p.region
FROM treasures t
JOIN ports p ON t.port_id = p.id
WHERE t.status = 'active'
  AND t.wishlist_count > 0
ORDER BY t.wishlist_count DESC, t.view_count DESC
LIMIT 100;

-- 항구별 보물 수 통계
CREATE OR REPLACE VIEW port_statistics AS
SELECT 
    p.id,
    p.name,
    p.country,
    p.country_code,
    p.region,
    p.logo_url,
    COUNT(t.id) as total_treasures,
    COUNT(CASE WHEN t.status = 'active' THEN 1 END) as active_treasures,
    AVG(t.funding_percent) as avg_funding_percent
FROM ports p
LEFT JOIN treasures t ON p.id = t.port_id
WHERE p.is_active = true
GROUP BY p.id
ORDER BY total_treasures DESC;

-- ───────────────────────────────────────────────────────────────
-- Functions (함수)
-- ───────────────────────────────────────────────────────────────

-- 위시리스트 카운트 업데이트 함수
CREATE OR REPLACE FUNCTION update_wishlist_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE treasures SET wishlist_count = wishlist_count + 1 WHERE id = NEW.treasure_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE treasures SET wishlist_count = GREATEST(wishlist_count - 1, 0) WHERE id = OLD.treasure_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 조회수 업데이트 함수
CREATE OR REPLACE FUNCTION increment_view_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE treasures SET view_count = view_count + 1 WHERE id = NEW.treasure_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 선장 통계 업데이트 함수 (항해 기록)
CREATE OR REPLACE FUNCTION update_captain_voyages()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE captains SET 
        total_voyages = total_voyages + 1,
        total_discoveries = total_discoveries + 1,
        last_active_at = NOW()
    WHERE id = NEW.captain_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 선장 등급 업데이트 함수
CREATE OR REPLACE FUNCTION update_captain_rank()
RETURNS TRIGGER AS $$
DECLARE
    new_rank VARCHAR(20);
BEGIN
    -- XP에 따른 등급 결정
    IF NEW.xp >= 100000 THEN
        new_rank := 'legend';
    ELSIF NEW.xp >= 20000 THEN
        new_rank := 'admiral';
    ELSIF NEW.xp >= 5000 THEN
        new_rank := 'captain';
    ELSIF NEW.xp >= 1000 THEN
        new_rank := 'navigator';
    ELSE
        new_rank := 'apprentice';
    END IF;
    
    -- 등급이 변경되었으면 업데이트
    IF NEW.rank != new_rank THEN
        NEW.rank := new_rank;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- XP 추가 함수
CREATE OR REPLACE FUNCTION add_captain_xp(
    p_captain_id UUID,
    p_amount INTEGER,
    p_activity_type VARCHAR(50),
    p_description VARCHAR(200) DEFAULT NULL,
    p_reference_id UUID DEFAULT NULL
)
RETURNS void AS $$
BEGIN
    -- XP 트랜잭션 기록
    INSERT INTO xp_transactions (captain_id, amount, activity_type, description, reference_id)
    VALUES (p_captain_id, p_amount, p_activity_type, p_description, p_reference_id);
    
    -- 선장 XP 업데이트
    UPDATE captains SET xp = xp + p_amount WHERE id = p_captain_id;
END;
$$ LANGUAGE plpgsql;

-- 금화 추가 함수
CREATE OR REPLACE FUNCTION add_captain_gold(
    p_captain_id UUID,
    p_amount INTEGER,
    p_type VARCHAR(20),
    p_description VARCHAR(200) DEFAULT NULL,
    p_reference_type VARCHAR(50) DEFAULT NULL,
    p_reference_id UUID DEFAULT NULL,
    p_expires_at TIMESTAMPTZ DEFAULT NULL
)
RETURNS void AS $$
DECLARE
    v_balance INTEGER;
BEGIN
    -- 현재 잔액 조회
    SELECT gold_coins INTO v_balance FROM captains WHERE id = p_captain_id;
    
    -- 금화 트랜잭션 기록
    INSERT INTO gold_transactions (
        captain_id, type, amount, balance_after, 
        description, reference_type, reference_id, expires_at
    )
    VALUES (
        p_captain_id, p_type, p_amount, v_balance + p_amount,
        p_description, p_reference_type, p_reference_id, p_expires_at
    );
    
    -- 선장 금화 업데이트
    UPDATE captains SET gold_coins = gold_coins + p_amount WHERE id = p_captain_id;
END;
$$ LANGUAGE plpgsql;

-- 주문번호 생성 함수
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS VARCHAR(50) AS $$
DECLARE
    v_date VARCHAR(8);
    v_random VARCHAR(6);
BEGIN
    v_date := TO_CHAR(NOW(), 'YYYYMMDD');
    v_random := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
    RETURN 'TW' || v_date || v_random;
END;
$$ LANGUAGE plpgsql;

-- 신규 회원 환영 금화 지급 함수
CREATE OR REPLACE FUNCTION welcome_new_captain()
RETURNS TRIGGER AS $$
BEGIN
    -- 환영 금화 500개 지급
    PERFORM add_captain_gold(
        NEW.id,
        500,
        'earn',
        '신규 선장 환영 보너스',
        'welcome',
        NULL,
        NOW() + INTERVAL '90 days'
    );
    
    -- 환영 XP 100 지급
    PERFORM add_captain_xp(
        NEW.id,
        100,
        'welcome',
        '신규 선장 환영 보너스'
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────────────────────────
-- Triggers (트리거)
-- ───────────────────────────────────────────────────────────────

-- 위시리스트 카운트 트리거
DROP TRIGGER IF EXISTS trigger_update_wishlist_count ON treasure_maps;
CREATE TRIGGER trigger_update_wishlist_count
AFTER INSERT OR DELETE ON treasure_maps
FOR EACH ROW EXECUTE FUNCTION update_wishlist_count();

-- 조회수 트리거
DROP TRIGGER IF EXISTS trigger_increment_view_count ON voyage_logs;
CREATE TRIGGER trigger_increment_view_count
AFTER INSERT ON voyage_logs
FOR EACH ROW EXECUTE FUNCTION increment_view_count();

-- 선장 항해 통계 트리거
DROP TRIGGER IF EXISTS trigger_update_captain_voyages ON voyage_logs;
CREATE TRIGGER trigger_update_captain_voyages
AFTER INSERT ON voyage_logs
FOR EACH ROW EXECUTE FUNCTION update_captain_voyages();

-- 선장 등급 업데이트 트리거
DROP TRIGGER IF EXISTS trigger_update_captain_rank ON captains;
CREATE TRIGGER trigger_update_captain_rank
BEFORE UPDATE OF xp ON captains
FOR EACH ROW EXECUTE FUNCTION update_captain_rank();

-- 신규 회원 환영 트리거
DROP TRIGGER IF EXISTS trigger_welcome_new_captain ON captains;
CREATE TRIGGER trigger_welcome_new_captain
AFTER INSERT ON captains
FOR EACH ROW EXECUTE FUNCTION welcome_new_captain();

-- ───────────────────────────────────────────────────────────────
-- Row Level Security (RLS) 정책
-- ───────────────────────────────────────────────────────────────

-- RLS 활성화
ALTER TABLE captains ENABLE ROW LEVEL SECURITY;
ALTER TABLE cargo ENABLE ROW LEVEL SECURITY;
ALTER TABLE treasure_maps ENABLE ROW LEVEL SECURITY;
ALTER TABLE voyage_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE trades ENABLE ROW LEVEL SECURITY;
ALTER TABLE trade_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE gold_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE permits ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE xp_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- ─────────────────────────────────────
-- captains (선장) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Users can view own captain data" ON captains;
CREATE POLICY "Users can view own captain data" ON captains
    FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can insert own captain data" ON captains;
CREATE POLICY "Users can insert own captain data" ON captains
    FOR INSERT WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own captain data" ON captains;
CREATE POLICY "Users can update own captain data" ON captains
    FOR UPDATE USING (auth.uid() = id);

-- ─────────────────────────────────────
-- cargo (선적 화물) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Users can manage own cargo" ON cargo;
CREATE POLICY "Users can manage own cargo" ON cargo
    FOR ALL USING (auth.uid() = captain_id);

-- ─────────────────────────────────────
-- treasure_maps (보물 지도) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Users can manage own treasure maps" ON treasure_maps;
CREATE POLICY "Users can manage own treasure maps" ON treasure_maps
    FOR ALL USING (auth.uid() = captain_id);

-- ─────────────────────────────────────
-- voyage_logs (항해 일지) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Users can view own voyage logs" ON voyage_logs;
CREATE POLICY "Users can view own voyage logs" ON voyage_logs
    FOR SELECT USING (auth.uid() = captain_id);

DROP POLICY IF EXISTS "Users can insert own voyage logs" ON voyage_logs;
CREATE POLICY "Users can insert own voyage logs" ON voyage_logs
    FOR INSERT WITH CHECK (auth.uid() = captain_id);

-- ─────────────────────────────────────
-- trades (교역) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Users can view own trades" ON trades;
CREATE POLICY "Users can view own trades" ON trades
    FOR SELECT USING (auth.uid() = captain_id);

DROP POLICY IF EXISTS "Users can insert own trades" ON trades;
CREATE POLICY "Users can insert own trades" ON trades
    FOR INSERT WITH CHECK (auth.uid() = captain_id);

-- ─────────────────────────────────────
-- trade_items (교역 상품) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Users can view own trade items" ON trade_items;
CREATE POLICY "Users can view own trade items" ON trade_items
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM trades t 
            WHERE t.id = trade_items.trade_id 
            AND t.captain_id = auth.uid()
        )
    );

-- ─────────────────────────────────────
-- gold_transactions (금화 거래) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Users can view own gold transactions" ON gold_transactions;
CREATE POLICY "Users can view own gold transactions" ON gold_transactions
    FOR SELECT USING (auth.uid() = captain_id);

-- ─────────────────────────────────────
-- permits (항해 허가증) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Users can view own permits" ON permits;
CREATE POLICY "Users can view own permits" ON permits
    FOR SELECT USING (auth.uid() = captain_id);

DROP POLICY IF EXISTS "Users can use own permits" ON permits;
CREATE POLICY "Users can use own permits" ON permits
    FOR UPDATE USING (auth.uid() = captain_id);

-- ─────────────────────────────────────
-- reviews (항해사 평가) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Anyone can view reviews" ON reviews;
CREATE POLICY "Anyone can view reviews" ON reviews
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can manage own reviews" ON reviews;
CREATE POLICY "Users can manage own reviews" ON reviews
    FOR INSERT WITH CHECK (auth.uid() = captain_id);

DROP POLICY IF EXISTS "Users can update own reviews" ON reviews;
CREATE POLICY "Users can update own reviews" ON reviews
    FOR UPDATE USING (auth.uid() = captain_id);

DROP POLICY IF EXISTS "Users can delete own reviews" ON reviews;
CREATE POLICY "Users can delete own reviews" ON reviews
    FOR DELETE USING (auth.uid() = captain_id);

-- ─────────────────────────────────────
-- xp_transactions (XP 거래) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Users can view own xp transactions" ON xp_transactions;
CREATE POLICY "Users can view own xp transactions" ON xp_transactions
    FOR SELECT USING (auth.uid() = captain_id);

-- ─────────────────────────────────────
-- notifications (알림) 정책
-- ─────────────────────────────────────
DROP POLICY IF EXISTS "Users can view own notifications" ON notifications;
CREATE POLICY "Users can view own notifications" ON notifications
    FOR SELECT USING (auth.uid() = captain_id);

DROP POLICY IF EXISTS "Users can update own notifications" ON notifications;
CREATE POLICY "Users can update own notifications" ON notifications
    FOR UPDATE USING (auth.uid() = captain_id);

DROP POLICY IF EXISTS "Users can delete own notifications" ON notifications;
CREATE POLICY "Users can delete own notifications" ON notifications
    FOR DELETE USING (auth.uid() = captain_id);

-- ─────────────────────────────────────
-- 공개 테이블 (ports, treasures)
-- ─────────────────────────────────────
-- ports와 treasures는 모든 사용자가 조회 가능
-- RLS 미적용 상태 유지 (기본적으로 모든 SELECT 허용)

