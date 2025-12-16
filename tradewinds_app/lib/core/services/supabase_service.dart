import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase 서비스 클래스
/// 앱 전체에서 Supabase 클라이언트에 접근하기 위한 싱글톤 서비스
class SupabaseService {
  SupabaseService._();
  
  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;
  
  /// Supabase 초기화
  /// main.dart에서 앱 시작 시 호출
  static Future<void> initialize() async {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    
    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception(
        'Supabase configuration missing. '
        'Please check your .env file for SUPABASE_URL and SUPABASE_ANON_KEY'
      );
    }
    
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: false, // 프로덕션에서는 false로 설정
    );
  }
  
  /// Supabase 클라이언트 인스턴스
  SupabaseClient get client => Supabase.instance.client;
  
  /// 현재 인증된 사용자
  User? get currentUser => client.auth.currentUser;
  
  /// 사용자 인증 여부
  bool get isAuthenticated => currentUser != null;
  
  /// 인증 상태 변경 스트림
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
  
  // ─────────────────────────────────────────────────────────────
  // 인증 관련 메서드
  // ─────────────────────────────────────────────────────────────
  
  /// 이메일/비밀번호로 회원가입
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? nickname,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: nickname != null ? {'nickname': nickname} : null,
    );
    return response;
  }
  
  /// 이메일/비밀번호로 로그인
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }
  
  /// OAuth 로그인 (Google, Apple, Kakao 등)
  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    final response = await client.auth.signInWithOAuth(
      provider,
      redirectTo: 'io.tradewinds.app://login-callback/',
    );
    return response;
  }
  
  /// 로그아웃
  Future<void> signOut() async {
    await client.auth.signOut();
  }
  
  /// 비밀번호 재설정 이메일 발송
  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }
  
  // ─────────────────────────────────────────────────────────────
  // 데이터베이스 헬퍼 메서드
  // ─────────────────────────────────────────────────────────────
  
  /// ports (항구) 테이블 조회
  Future<List<Map<String, dynamic>>> getPorts({
    String? region,
    bool activeOnly = true,
  }) async {
    var query = client.from('ports').select();
    
    if (region != null) {
      query = query.eq('region', region);
    }
    if (activeOnly) {
      query = query.eq('is_active', true);
    }
    
    final response = await query.order('treasure_count', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
  
  /// treasures (보물) 테이블 조회
  Future<List<Map<String, dynamic>>> getTreasures({
    String? portId,
    String? category,
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = client.from('treasures').select('''
      *,
      ports!inner(name, country, country_code, logo_url)
    ''');
    
    if (portId != null) {
      query = query.eq('port_id', portId);
    }
    if (category != null) {
      query = query.eq('category', category);
    }
    if (status != null) {
      query = query.eq('status', status);
    }
    
    final response = await query
        .order('crawled_at', ascending: false)
        .range(offset, offset + limit - 1);
    
    return List<Map<String, dynamic>>.from(response);
  }
  
  /// 오늘 발견된 유물 조회
  Future<List<Map<String, dynamic>>> getTodayDiscoveries({int limit = 10}) async {
    final response = await client
        .from('today_discoveries')
        .select()
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }
  
  /// 떠오르는 보물 조회
  Future<List<Map<String, dynamic>>> getRisingTreasures({int limit = 10}) async {
    final response = await client
        .from('rising_treasures')
        .select()
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }
  
  /// 마감 임박 보물 조회
  Future<List<Map<String, dynamic>>> getEndingSoon({int limit = 10}) async {
    final response = await client
        .from('ending_soon')
        .select()
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }
  
  /// 선장들의 선택 조회
  Future<List<Map<String, dynamic>>> getCaptainsChoice({int limit = 10}) async {
    final response = await client
        .from('captains_choice')
        .select()
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }
  
  /// 보물 상세 조회
  Future<Map<String, dynamic>?> getTreasureDetail(String treasureId) async {
    final response = await client
        .from('treasures')
        .select('''
          *,
          ports!inner(name, country, country_code, logo_url, base_url)
        ''')
        .eq('id', treasureId)
        .single();
    return response;
  }
  
  /// 보물 검색
  Future<List<Map<String, dynamic>>> searchTreasures(String query, {int limit = 20}) async {
    final response = await client
        .from('treasures')
        .select('''
          *,
          ports!inner(name, country, country_code, logo_url)
        ''')
        .textSearch('title', query)
        .eq('status', 'active')
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }
  
  // ─────────────────────────────────────────────────────────────
  // 사용자 관련 메서드 (인증 필요)
  // ─────────────────────────────────────────────────────────────
  
  /// 선장(사용자) 프로필 생성
  Future<void> createCaptainProfile({
    required String nickname,
    String? avatarUrl,
  }) async {
    if (currentUser == null) throw Exception('User not authenticated');
    
    await client.from('captains').insert({
      'id': currentUser!.id,
      'nickname': nickname,
      'email': currentUser!.email,
      'avatar_url': avatarUrl,
    });
  }
  
  /// 선장 프로필 조회
  Future<Map<String, dynamic>?> getCaptainProfile() async {
    if (currentUser == null) return null;
    
    final response = await client
        .from('captains')
        .select()
        .eq('id', currentUser!.id)
        .maybeSingle();
    return response;
  }
  
  /// 선장 프로필 업데이트
  Future<void> updateCaptainProfile({
    String? nickname,
    String? avatarUrl,
  }) async {
    if (currentUser == null) throw Exception('User not authenticated');
    
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (nickname != null) updates['nickname'] = nickname;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    
    await client
        .from('captains')
        .update(updates)
        .eq('id', currentUser!.id);
  }
  
  /// 장바구니(cargo) 추가
  Future<void> addToCargo(String treasureId, {int quantity = 1}) async {
    if (currentUser == null) throw Exception('User not authenticated');
    
    await client.from('cargo').upsert({
      'captain_id': currentUser!.id,
      'treasure_id': treasureId,
      'quantity': quantity,
    });
  }
  
  /// 장바구니 조회
  Future<List<Map<String, dynamic>>> getCargo() async {
    if (currentUser == null) return [];
    
    final response = await client
        .from('cargo')
        .select('''
          *,
          treasures!inner(*)
        ''')
        .eq('captain_id', currentUser!.id);
    return List<Map<String, dynamic>>.from(response);
  }
  
  /// 장바구니 삭제
  Future<void> removeFromCargo(String treasureId) async {
    if (currentUser == null) throw Exception('User not authenticated');
    
    await client
        .from('cargo')
        .delete()
        .eq('captain_id', currentUser!.id)
        .eq('treasure_id', treasureId);
  }
  
  /// 위시리스트(treasure_maps) 추가
  Future<void> addToWishlist(String treasureId, {String? note}) async {
    if (currentUser == null) throw Exception('User not authenticated');
    
    await client.from('treasure_maps').insert({
      'captain_id': currentUser!.id,
      'treasure_id': treasureId,
      'note': note,
    });
  }
  
  /// 위시리스트 조회
  Future<List<Map<String, dynamic>>> getWishlist() async {
    if (currentUser == null) return [];
    
    final response = await client
        .from('treasure_maps')
        .select('''
          *,
          treasures!inner(*)
        ''')
        .eq('captain_id', currentUser!.id)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
  
  /// 위시리스트 삭제
  Future<void> removeFromWishlist(String treasureId) async {
    if (currentUser == null) throw Exception('User not authenticated');
    
    await client
        .from('treasure_maps')
        .delete()
        .eq('captain_id', currentUser!.id)
        .eq('treasure_id', treasureId);
  }
  
  /// 위시리스트 여부 확인
  Future<bool> isInWishlist(String treasureId) async {
    if (currentUser == null) return false;
    
    final response = await client
        .from('treasure_maps')
        .select('id')
        .eq('captain_id', currentUser!.id)
        .eq('treasure_id', treasureId)
        .maybeSingle();
    return response != null;
  }
  
  /// 조회 기록(voyage_logs) 추가
  Future<void> addVoyageLog(String treasureId) async {
    if (currentUser == null) return;
    
    await client.from('voyage_logs').insert({
      'captain_id': currentUser!.id,
      'treasure_id': treasureId,
    });
  }
  
  /// 조회 기록 조회
  Future<List<Map<String, dynamic>>> getVoyageLogs({int limit = 50}) async {
    if (currentUser == null) return [];
    
    final response = await client
        .from('voyage_logs')
        .select('''
          *,
          treasures!inner(*)
        ''')
        .eq('captain_id', currentUser!.id)
        .order('viewed_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }
}

/// 편의를 위한 글로벌 접근자
SupabaseService get supabaseService => SupabaseService.instance;
SupabaseClient get supabase => SupabaseService.instance.client;

