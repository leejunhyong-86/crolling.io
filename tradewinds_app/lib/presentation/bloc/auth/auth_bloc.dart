import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import '../../../core/services/supabase_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// 인증 BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  StreamSubscription<dynamic>? _authStateSubscription;
  
  // Google Sign-In 인스턴스 (모바일 전용 - lazy 초기화)
  GoogleSignIn? _googleSignIn;
  
  GoogleSignIn get googleSignIn {
    _googleSignIn ??= GoogleSignIn(
      scopes: ['email', 'profile'],
    );
    return _googleSignIn!;
  }
  
  AuthBloc() : super(AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<KakaoSignInRequested>(_onKakaoSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<ProfileSetupCompleted>(_onProfileSetupCompleted);
    on<GuestModeRequested>(_onGuestModeRequested);
    on<AuthStateChanged>(_onAuthStateChanged);
    
    // 인증 상태 변경 리스너 설정
    _setupAuthStateListener();
  }

  void _setupAuthStateListener() {
    _authStateSubscription = supabaseService.authStateChanges.listen((authState) {
      // Supabase 인증 상태 변경 시 체크 요청
      add(const AuthCheckRequested());
    });
  }

  /// 인증 상태 확인
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());
      
      final user = supabaseService.currentUser;
      
      if (user == null) {
        emit(AuthState.unauthenticated());
        return;
      }
      
      // 프로필 확인
      final profile = await supabaseService.getCaptainProfile();
      
      if (profile == null || profile['nickname'] == null) {
        // 프로필 설정 필요
        emit(AuthState.needsProfile(
          userId: user.id,
          email: user.email,
        ));
      } else {
        // 인증 완료
        emit(AuthState.authenticated(
          userId: user.id,
          email: user.email,
          nickname: profile['nickname'],
          avatarUrl: profile['avatar_url'],
        ));
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
      emit(AuthState.error('인증 상태를 확인할 수 없습니다.'));
    }
  }

  /// Google 로그인
  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());
      
      if (kIsWeb) {
        // 웹: OAuth redirect 방식
        final success = await supabaseService.signInWithOAuth(OAuthProvider.google);
        if (!success) {
          emit(AuthState.error('Google 로그인에 실패했습니다.'));
        }
        // OAuth 리다이렉트 후 상태는 authStateChanges에서 처리됨
      } else {
        // 모바일: 네이티브 SDK 사용
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          emit(AuthState.unauthenticated());
          return;
        }
        
        final googleAuth = await googleUser.authentication;
        final idToken = googleAuth.idToken;
        final accessToken = googleAuth.accessToken;
        
        if (idToken == null) {
          emit(AuthState.error('Google 인증 토큰을 가져올 수 없습니다.'));
          return;
        }
        
        // Supabase에 ID Token으로 로그인
        await supabaseService.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
        
        // 인증 상태 확인
        add(const AuthCheckRequested());
      }
    } catch (e) {
      debugPrint('Google sign in error: $e');
      emit(AuthState.error('Google 로그인 중 오류가 발생했습니다.'));
    }
  }

  /// Kakao 로그인
  Future<void> _onKakaoSignInRequested(
    KakaoSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());
      
      if (kIsWeb) {
        // 웹: OAuth redirect 방식
        final success = await supabaseService.signInWithOAuth(OAuthProvider.kakao);
        if (!success) {
          emit(AuthState.error('카카오 로그인에 실패했습니다.'));
        }
        // OAuth 리다이렉트 후 상태는 authStateChanges에서 처리됨
      } else {
        // 모바일: 네이티브 SDK 사용
        kakao.OAuthToken token;
        
        // 카카오톡 설치 여부 확인
        if (await kakao.isKakaoTalkInstalled()) {
          token = await kakao.UserApi.instance.loginWithKakaoTalk();
        } else {
          token = await kakao.UserApi.instance.loginWithKakaoAccount();
        }
        
        final idToken = token.idToken;
        if (idToken == null) {
          emit(AuthState.error('카카오 인증 토큰을 가져올 수 없습니다.'));
          return;
        }
        
        // Supabase에 ID Token으로 로그인
        await supabaseService.signInWithIdToken(
          provider: OAuthProvider.kakao,
          idToken: idToken,
          accessToken: token.accessToken,
        );
        
        // 인증 상태 확인
        add(const AuthCheckRequested());
      }
    } catch (e) {
      debugPrint('Kakao sign in error: $e');
      emit(AuthState.error('카카오 로그인 중 오류가 발생했습니다.'));
    }
  }

  /// 로그아웃
  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());
      
      // 모바일에서 Google 로그아웃
      if (!kIsWeb && _googleSignIn != null) {
        try {
          await _googleSignIn!.signOut();
        } catch (_) {}
      }
      
      await supabaseService.signOut();
      emit(AuthState.unauthenticated());
    } catch (e) {
      debugPrint('Sign out error: $e');
      emit(AuthState.error('로그아웃 중 오류가 발생했습니다.'));
    }
  }

  /// 회원 탈퇴
  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());
      
      // Edge Function 호출하여 계정 삭제
      await supabaseService.deleteAccount();
      
      // 모바일에서 Google 로그아웃
      if (!kIsWeb && _googleSignIn != null) {
        try {
          await _googleSignIn!.signOut();
        } catch (_) {}
      }
      
      emit(AuthState.unauthenticated());
    } catch (e) {
      debugPrint('Delete account error: $e');
      emit(AuthState.error('회원 탈퇴 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.'));
    }
  }

  /// 프로필 설정 완료
  Future<void> _onProfileSetupCompleted(
    ProfileSetupCompleted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      final user = supabaseService.currentUser;
      if (user == null) {
        emit(AuthState.unauthenticated());
        return;
      }
      
      // 프로필 존재 여부 확인 후 생성 또는 업데이트
      final existingProfile = await supabaseService.getCaptainProfile();
      
      if (existingProfile == null) {
        // 새 프로필 생성
        await supabaseService.createCaptainProfile(
          nickname: event.nickname,
          avatarUrl: event.avatarUrl,
        );
      } else {
        // 기존 프로필 업데이트
        await supabaseService.updateCaptainProfile(
          nickname: event.nickname,
          avatarUrl: event.avatarUrl,
        );
      }
      
      emit(AuthState.authenticated(
        userId: user.id,
        email: user.email,
        nickname: event.nickname,
        avatarUrl: event.avatarUrl,
      ));
    } catch (e) {
      debugPrint('Profile setup error: $e');
      emit(AuthState.error('프로필 설정 중 오류가 발생했습니다.'));
    }
  }

  /// 게스트 모드
  Future<void> _onGuestModeRequested(
    GuestModeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.guest());
  }

  /// 인증 상태 변경 처리
  Future<void> _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.isAuthenticated) {
      add(const AuthCheckRequested());
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
