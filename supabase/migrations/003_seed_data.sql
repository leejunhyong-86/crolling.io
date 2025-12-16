-- ═══════════════════════════════════════════════════════════════
-- TradeWinds Database Schema
-- Migration: 003_seed_data
-- Description: 초기 시드 데이터 (항구/크라우드펀딩 사이트)
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- 북미 (North America) 항구들
-- ───────────────────────────────────────────────────────────────

INSERT INTO ports (name, country, country_code, region, base_url, description, categories, priority, crawl_frequency, coordinates) VALUES
('Kickstarter', 'United States', 'US', 'north_america', 'https://www.kickstarter.com', '세계 최대 크라우드펀딩 플랫폼', '["tech", "design", "games", "art", "film"]', 'high', 'hourly', '{"lat": 40.7128, "lng": -74.0060}'),
('Indiegogo', 'United States', 'US', 'north_america', 'https://www.indiegogo.com', '글로벌 크라우드펀딩 및 인디마켓', '["tech", "design", "health", "travel"]', 'high', 'hourly', '{"lat": 37.7749, "lng": -122.4194}'),
('GoFundMe', 'United States', 'US', 'north_america', 'https://www.gofundme.com', '개인 및 사회공헌 펀딩', '["personal", "charity", "community"]', 'medium', 'daily', '{"lat": 37.3382, "lng": -121.8863}'),
('Patreon', 'United States', 'US', 'north_america', 'https://www.patreon.com', '크리에이터 후원 플랫폼', '["creator", "art", "music", "podcast"]', 'medium', 'daily', '{"lat": 37.7749, "lng": -122.4194}'),
('Republic', 'United States', 'US', 'north_america', 'https://republic.com', '스타트업 투자 플랫폼', '["startup", "investment", "equity"]', 'low', 'daily', '{"lat": 40.7128, "lng": -74.0060}'),
('Wefunder', 'United States', 'US', 'north_america', 'https://wefunder.com', '스타트업 투자 크라우드펀딩', '["startup", "investment"]', 'low', 'daily', '{"lat": 37.7749, "lng": -122.4194}'),
('StartEngine', 'United States', 'US', 'north_america', 'https://www.startengine.com', '지분 투자 크라우드펀딩', '["startup", "equity", "investment"]', 'medium', 'daily', '{"lat": 34.0522, "lng": -118.2437}'),
('FundRazr', 'Canada', 'CA', 'north_america', 'https://fundrazr.com', '캐나다 기반 펀딩 플랫폼', '["personal", "charity", "community"]', 'low', 'weekly', '{"lat": 49.2827, "lng": -123.1207}');

-- ───────────────────────────────────────────────────────────────
-- 아시아 (Asia) 항구들
-- ───────────────────────────────────────────────────────────────

INSERT INTO ports (name, country, country_code, region, base_url, description, categories, priority, crawl_frequency, coordinates) VALUES
('Makuake', 'Japan', 'JP', 'asia', 'https://www.makuake.com', '일본 최대 크라우드펀딩', '["tech", "design", "food", "fashion"]', 'high', 'hourly', '{"lat": 35.6762, "lng": 139.6503}'),
('CAMPFIRE', 'Japan', 'JP', 'asia', 'https://camp-fire.jp', '일본 종합 크라우드펀딩', '["creative", "tech", "community", "music"]', 'high', 'hourly', '{"lat": 35.6762, "lng": 139.6503}'),
('READYFOR', 'Japan', 'JP', 'asia', 'https://readyfor.jp', '일본 사회공헌 펀딩', '["social", "community", "culture"]', 'medium', 'daily', '{"lat": 35.6762, "lng": 139.6503}'),
('GREEN FUNDING', 'Japan', 'JP', 'asia', 'https://greenfunding.jp', 'CCC그룹 크라우드펀딩', '["tech", "gadget", "design"]', 'medium', 'daily', '{"lat": 35.6762, "lng": 139.6503}'),
('Kibidango', 'Japan', 'JP', 'asia', 'https://kibidango.com', '일본 제품 펀딩 플랫폼', '["tech", "design", "lifestyle"]', 'medium', 'daily', '{"lat": 35.6762, "lng": 139.6503}'),
('Wadiz', 'South Korea', 'KR', 'asia', 'https://www.wadiz.kr', '한국 최대 크라우드펀딩', '["tech", "design", "fashion", "food"]', 'high', 'hourly', '{"lat": 37.5665, "lng": 126.9780}'),
('Tumblbug', 'South Korea', 'KR', 'asia', 'https://tumblbug.com', '한국 크리에이티브 펀딩', '["creative", "art", "design", "publishing"]', 'high', 'hourly', '{"lat": 37.5665, "lng": 126.9780}'),
('Kakao Makers', 'South Korea', 'KR', 'asia', 'https://makers.kakao.com', '카카오 메이커스 펀딩', '["design", "lifestyle", "food"]', 'medium', 'daily', '{"lat": 37.5665, "lng": 126.9780}'),
('Xiaomi Youpin', 'China', 'CN', 'asia', 'https://www.xiaomiyoupin.com', '샤오미 유핀 크라우드펀딩', '["tech", "gadget", "smart_home"]', 'high', 'daily', '{"lat": 39.9042, "lng": 116.4074}'),
('JD Crowdfunding', 'China', 'CN', 'asia', 'https://z.jd.com', '징동 크라우드펀딩', '["tech", "design", "lifestyle"]', 'medium', 'daily', '{"lat": 39.9042, "lng": 116.4074}'),
('Zeczec', 'Taiwan', 'TW', 'asia', 'https://www.zeczec.com', '대만 최대 크라우드펀딩', '["tech", "design", "creative"]', 'medium', 'daily', '{"lat": 25.0330, "lng": 121.5654}'),
('FlyingV', 'Taiwan', 'TW', 'asia', 'https://www.flyingv.cc', '대만 크리에이티브 펀딩', '["creative", "tech", "social"]', 'medium', 'daily', '{"lat": 25.0330, "lng": 121.5654}'),
('Ketto', 'India', 'IN', 'asia', 'https://www.ketto.org', '인도 사회공헌 펀딩', '["charity", "medical", "social"]', 'low', 'weekly', '{"lat": 19.0760, "lng": 72.8777}');

-- ───────────────────────────────────────────────────────────────
-- 유럽 (Europe) 항구들
-- ───────────────────────────────────────────────────────────────

INSERT INTO ports (name, country, country_code, region, base_url, description, categories, priority, crawl_frequency, coordinates) VALUES
('Crowdcube', 'United Kingdom', 'GB', 'europe', 'https://www.crowdcube.com', '영국 지분 투자 펀딩', '["startup", "equity", "investment"]', 'medium', 'daily', '{"lat": 51.5074, "lng": -0.1278}'),
('Seedrs', 'United Kingdom', 'GB', 'europe', 'https://www.seedrs.com', '영국 스타트업 투자', '["startup", "equity"]', 'low', 'weekly', '{"lat": 51.5074, "lng": -0.1278}'),
('JustGiving', 'United Kingdom', 'GB', 'europe', 'https://www.justgiving.com', '영국 기부 플랫폼', '["charity", "personal"]', 'low', 'weekly', '{"lat": 51.5074, "lng": -0.1278}'),
('Ulule', 'France', 'FR', 'europe', 'https://www.ulule.com', '유럽 최대 크라우드펀딩', '["creative", "tech", "design", "social"]', 'medium', 'daily', '{"lat": 48.8566, "lng": 2.3522}'),
('KissKissBankBank', 'France', 'FR', 'europe', 'https://www.kisskissbankbank.com', '프랑스 크리에이티브 펀딩', '["creative", "music", "art", "film"]', 'medium', 'daily', '{"lat": 48.8566, "lng": 2.3522}'),
('Startnext', 'Germany', 'DE', 'europe', 'https://www.startnext.com', '독일 최대 크라우드펀딩', '["creative", "tech", "social"]', 'medium', 'daily', '{"lat": 52.5200, "lng": 13.4050}'),
('Companisto', 'Germany', 'DE', 'europe', 'https://www.companisto.com', '독일 지분 투자 펀딩', '["startup", "equity"]', 'low', 'weekly', '{"lat": 52.5200, "lng": 13.4050}'),
('wemakeit', 'Switzerland', 'CH', 'europe', 'https://wemakeit.com', '스위스 크라우드펀딩', '["creative", "social", "design"]', 'medium', 'daily', '{"lat": 47.3769, "lng": 8.5417}'),
('Eppela', 'Italy', 'IT', 'europe', 'https://www.eppela.com', '이탈리아 크라우드펀딩', '["creative", "tech", "design"]', 'medium', 'daily', '{"lat": 41.9028, "lng": 12.4964}'),
('Verkami', 'Spain', 'ES', 'europe', 'https://www.verkami.com', '스페인 크리에이티브 펀딩', '["creative", "art", "music", "film"]', 'medium', 'daily', '{"lat": 41.3851, "lng": 2.1734}'),
('Goteo', 'Spain', 'ES', 'europe', 'https://www.goteo.org', '스페인 소셜 펀딩', '["social", "creative", "community"]', 'low', 'weekly', '{"lat": 40.4168, "lng": -3.7038}'),
('Oneplanetcrowd', 'Netherlands', 'NL', 'europe', 'https://www.oneplanetcrowd.com', '네덜란드 지속가능 펀딩', '["sustainability", "social", "green"]', 'low', 'weekly', '{"lat": 52.3676, "lng": 4.9041}'),
('FundedByMe', 'Sweden', 'SE', 'europe', 'https://www.fundedbyme.com', '스웨덴 투자 펀딩', '["startup", "equity"]', 'low', 'weekly', '{"lat": 59.3293, "lng": 18.0686}'),
('Mesenaatti', 'Finland', 'FI', 'europe', 'https://mesenaatti.me', '핀란드 크라우드펀딩', '["creative", "culture", "art"]', 'low', 'weekly', '{"lat": 60.1699, "lng": 24.9384}'),
('PolakPotrafi', 'Poland', 'PL', 'europe', 'https://polakpotrafi.pl', '폴란드 크라우드펀딩', '["creative", "social", "business"]', 'low', 'weekly', '{"lat": 52.2297, "lng": 21.0122}'),
('HitHit', 'Czech Republic', 'CZ', 'europe', 'https://www.hithit.com', '체코 크라우드펀딩', '["creative", "tech", "social"]', 'low', 'weekly', '{"lat": 50.0755, "lng": 14.4378}');

-- ───────────────────────────────────────────────────────────────
-- 오세아니아 (Oceania) 항구들
-- ───────────────────────────────────────────────────────────────

INSERT INTO ports (name, country, country_code, region, base_url, description, categories, priority, crawl_frequency, coordinates) VALUES
('Pozible', 'Australia', 'AU', 'oceania', 'https://www.pozible.com', '호주 최대 크라우드펀딩', '["creative", "tech", "community"]', 'medium', 'daily', '{"lat": -33.8688, "lng": 151.2093}'),
('Chuffed', 'Australia', 'AU', 'oceania', 'https://chuffed.org', '호주 사회공헌 펀딩', '["charity", "social", "community"]', 'low', 'weekly', '{"lat": -33.8688, "lng": 151.2093}'),
('PledgeMe', 'New Zealand', 'NZ', 'oceania', 'https://www.pledgeme.co.nz', '뉴질랜드 크라우드펀딩', '["creative", "startup", "equity"]', 'medium', 'daily', '{"lat": -41.2865, "lng": 174.7762}');

-- ───────────────────────────────────────────────────────────────
-- 남미 (South America) 항구들
-- ───────────────────────────────────────────────────────────────

INSERT INTO ports (name, country, country_code, region, base_url, description, categories, priority, crawl_frequency, coordinates) VALUES
('Catarse', 'Brazil', 'BR', 'south_america', 'https://www.catarse.me', '브라질 최대 크라우드펀딩', '["creative", "music", "film", "games"]', 'medium', 'daily', '{"lat": -23.5505, "lng": -46.6333}'),
('Benfeitoria', 'Brazil', 'BR', 'south_america', 'https://benfeitoria.com', '브라질 소셜 펀딩', '["social", "creative", "community"]', 'low', 'weekly', '{"lat": -22.9068, "lng": -43.1729}'),
('Fondeadora', 'Mexico', 'MX', 'south_america', 'https://fondeadora.mx', '멕시코 크라우드펀딩', '["creative", "social", "tech"]', 'medium', 'daily', '{"lat": 19.4326, "lng": -99.1332}'),
('Idea.me', 'Argentina', 'AR', 'south_america', 'https://idea.me', '아르헨티나 크라우드펀딩', '["creative", "tech", "social"]', 'low', 'weekly', '{"lat": -34.6037, "lng": -58.3816}');

-- ───────────────────────────────────────────────────────────────
-- 중동/아프리카 (Middle East & Africa) 항구들
-- ───────────────────────────────────────────────────────────────

INSERT INTO ports (name, country, country_code, region, base_url, description, categories, priority, crawl_frequency, coordinates) VALUES
('Eureeca', 'United Arab Emirates', 'AE', 'middle_east_africa', 'https://eureeca.com', 'UAE 투자 펀딩', '["startup", "equity"]', 'low', 'weekly', '{"lat": 25.2048, "lng": 55.2708}'),
('Headstart', 'Israel', 'IL', 'middle_east_africa', 'https://www.headstart.co.il', '이스라엘 크라우드펀딩', '["creative", "tech", "startup"]', 'medium', 'daily', '{"lat": 32.0853, "lng": 34.7818}'),
('OurCrowd', 'Israel', 'IL', 'middle_east_africa', 'https://www.ourcrowd.com', '이스라엘 벤처 펀딩', '["startup", "equity", "venture"]', 'medium', 'daily', '{"lat": 31.7683, "lng": 35.2137}'),
('Thundafund', 'South Africa', 'ZA', 'middle_east_africa', 'https://www.thundafund.com', '남아공 크라우드펀딩', '["creative", "social", "startup"]', 'low', 'weekly', '{"lat": -33.9249, "lng": 18.4241}'),
('BackaBuddy', 'South Africa', 'ZA', 'middle_east_africa', 'https://www.backabuddy.co.za', '남아공 기부 펀딩', '["charity", "personal", "medical"]', 'low', 'weekly', '{"lat": -26.2041, "lng": 28.0473}');

-- ───────────────────────────────────────────────────────────────
-- 테스트용 보물(상품) 데이터 (선택적)
-- ───────────────────────────────────────────────────────────────

-- Kickstarter 샘플 보물
INSERT INTO treasures (port_id, external_id, title, description, short_description, image_urls, thumbnail_url, original_url, funding_goal, funding_current, funding_percent, backer_count, currency, end_date, category, tags, creator_name, status, is_featured)
SELECT 
    p.id,
    'ks_sample_001',
    'Smart Backpack with Solar Charger',
    '혁신적인 태양광 충전 백팩입니다. 어디서든 디바이스를 충전하세요.',
    '태양광 패널 내장 스마트 백팩',
    '["https://example.com/backpack1.jpg", "https://example.com/backpack2.jpg"]',
    'https://example.com/backpack_thumb.jpg',
    'https://www.kickstarter.com/projects/sample/smart-backpack',
    50000.00,
    127500.00,
    255,
    1847,
    'USD',
    NOW() + INTERVAL '15 days',
    'tech',
    '["gadget", "solar", "backpack", "travel"]',
    'TechGear Inc.',
    'active',
    true
FROM ports p WHERE p.name = 'Kickstarter';

-- Makuake 샘플 보물
INSERT INTO treasures (port_id, external_id, title, description, short_description, image_urls, thumbnail_url, original_url, funding_goal, funding_current, funding_percent, backer_count, currency, end_date, category, tags, creator_name, status, is_featured)
SELECT 
    p.id,
    'mk_sample_001',
    '超薄型モバイルバッテリー 5000mAh',
    '카드 크기의 초박형 보조배터리입니다. 지갑에 넣어 다니세요.',
    '초박형 카드 사이즈 보조배터리',
    '["https://example.com/battery1.jpg"]',
    'https://example.com/battery_thumb.jpg',
    'https://www.makuake.com/project/sample-battery',
    1000000.00,
    3500000.00,
    350,
    892,
    'JPY',
    NOW() + INTERVAL '10 days',
    'tech',
    '["battery", "mobile", "slim"]',
    'PowerTech Japan',
    'active',
    true
FROM ports p WHERE p.name = 'Makuake';

-- Wadiz 샘플 보물
INSERT INTO treasures (port_id, external_id, title, description, short_description, image_urls, thumbnail_url, original_url, funding_goal, funding_current, funding_percent, backer_count, currency, end_date, category, tags, creator_name, status, is_featured)
SELECT 
    p.id,
    'wd_sample_001',
    '미니멀 디자인 스마트 지갑',
    'RFID 차단 기능과 GPS 트래커가 내장된 스마트 지갑입니다.',
    'RFID 차단 + GPS 트래커 스마트 지갑',
    '["https://example.com/wallet1.jpg", "https://example.com/wallet2.jpg"]',
    'https://example.com/wallet_thumb.jpg',
    'https://www.wadiz.kr/project/sample-wallet',
    5000000.00,
    12500000.00,
    250,
    523,
    'KRW',
    NOW() + INTERVAL '20 days',
    'design',
    '["wallet", "smart", "rfid", "gps"]',
    '스마트라이프 코리아',
    'active',
    true
FROM ports p WHERE p.name = 'Wadiz';

-- ───────────────────────────────────────────────────────────────
-- 항구별 보물 수 업데이트
-- ───────────────────────────────────────────────────────────────

UPDATE ports SET treasure_count = (
    SELECT COUNT(*) FROM treasures WHERE treasures.port_id = ports.id
);

