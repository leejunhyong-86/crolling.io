import 'package:equatable/equatable.dart';

/// 인증 관련 이벤트 정의
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// 앱 시작 시 인증 상태 확인
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Google 로그인 요청
class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

/// Kakao 로그인 요청
class KakaoSignInRequested extends AuthEvent {
  const KakaoSignInRequested();
}

/// 로그아웃 요청
class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

/// 회원 탈퇴 요청
class DeleteAccountRequested extends AuthEvent {
  const DeleteAccountRequested();
}

/// 프로필 설정 완료
class ProfileSetupCompleted extends AuthEvent {
  final String nickname;
  final String? avatarUrl;

  const ProfileSetupCompleted({
    required this.nickname,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [nickname, avatarUrl];
}

/// 프로필 설정 건너뛰기 (게스트 모드)
class GuestModeRequested extends AuthEvent {
  const GuestModeRequested();
}

/// 인증 상태 변경 감지
class AuthStateChanged extends AuthEvent {
  final bool isAuthenticated;
  final bool hasProfile;

  const AuthStateChanged({
    required this.isAuthenticated,
    required this.hasProfile,
  });

  @override
  List<Object?> get props => [isAuthenticated, hasProfile];
}
