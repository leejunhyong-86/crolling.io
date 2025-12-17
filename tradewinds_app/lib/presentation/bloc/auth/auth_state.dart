import 'package:equatable/equatable.dart';

/// 인증 상태 정의
enum AuthStatus {
  /// 초기 상태 (인증 확인 중)
  initial,
  
  /// 인증되지 않음 (로그인 필요)
  unauthenticated,
  
  /// 인증됨 (프로필 설정 필요)
  authenticatedNeedsProfile,
  
  /// 인증 완료 (프로필 설정 완료)
  authenticated,
  
  /// 게스트 모드
  guest,
  
  /// 로딩 중
  loading,
  
  /// 오류 발생
  error,
}

/// 인증 상태 클래스
class AuthState extends Equatable {
  final AuthStatus status;
  final String? userId;
  final String? email;
  final String? nickname;
  final String? avatarUrl;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userId,
    this.email,
    this.nickname,
    this.avatarUrl,
    this.errorMessage,
    this.isLoading = false,
  });

  /// 초기 상태
  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.initial);
  }

  /// 로딩 상태
  factory AuthState.loading() {
    return const AuthState(status: AuthStatus.loading, isLoading: true);
  }

  /// 비인증 상태
  factory AuthState.unauthenticated() {
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  /// 프로필 설정 필요 상태
  factory AuthState.needsProfile({
    required String userId,
    String? email,
  }) {
    return AuthState(
      status: AuthStatus.authenticatedNeedsProfile,
      userId: userId,
      email: email,
    );
  }

  /// 인증 완료 상태
  factory AuthState.authenticated({
    required String userId,
    String? email,
    String? nickname,
    String? avatarUrl,
  }) {
    return AuthState(
      status: AuthStatus.authenticated,
      userId: userId,
      email: email,
      nickname: nickname,
      avatarUrl: avatarUrl,
    );
  }

  /// 게스트 모드 상태
  factory AuthState.guest() {
    return const AuthState(status: AuthStatus.guest);
  }

  /// 오류 상태
  factory AuthState.error(String message) {
    return AuthState(
      status: AuthStatus.error,
      errorMessage: message,
    );
  }

  /// 상태 복사
  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? email,
    String? nickname,
    String? avatarUrl,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// 인증된 상태인지 확인
  bool get isAuthenticated => 
      status == AuthStatus.authenticated || 
      status == AuthStatus.authenticatedNeedsProfile;

  @override
  List<Object?> get props => [
        status,
        userId,
        email,
        nickname,
        avatarUrl,
        errorMessage,
        isLoading,
      ];
}
