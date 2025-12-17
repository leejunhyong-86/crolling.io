import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/pages/splash/splash_page.dart';
import '../presentation/pages/onboarding/onboarding_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/profile_setup_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/map/map_page.dart';
import '../presentation/pages/treasure/treasure_detail_page.dart';
import '../presentation/pages/cart/cart_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/auth/auth_state.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/services/supabase_service.dart';

/// 앱 라우터 설정
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  /// 인증 필요 없는 경로들
  static const _publicRoutes = ['/splash', '/onboarding', '/login'];
  
  /// 인증 후 프로필 설정이 필요한 경로
  static const _profileSetupRoute = '/profile-setup';

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: _handleRedirect,
    routes: [
      // 스플래시
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      // 온보딩
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      // 로그인
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      // 프로필 설정
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupPage(),
      ),
      // 홈 리다이렉트 (편의용)
      GoRoute(
        path: '/home',
        redirect: (context, state) => '/',
      ),
      // 메인 쉘 (하단 네비게이션)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // 홈 (항해 본부)
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          // 세계 지도
          GoRoute(
            path: '/map',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MapPage(),
            ),
          ),
          // 장바구니 (선적 화물)
          GoRoute(
            path: '/cart',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CartPage(),
            ),
          ),
          // 프로필 (선장실)
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),
      // 보물 상세
      GoRoute(
        path: '/treasure/:id',
        builder: (context, state) {
          final treasureId = state.pathParameters['id'] ?? '';
          return TreasureDetailPage(treasureId: treasureId);
        },
      ),
    ],
  );

  /// 인증 상태 기반 리다이렉트 처리
  static Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final currentPath = state.uri.path;
    
    // 스플래시, 온보딩은 항상 허용
    if (currentPath == '/splash' || currentPath == '/onboarding') {
      return null;
    }
    
    // AuthBloc에서 현재 상태 가져오기
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;
    
    // 초기 상태이거나 로딩 중이면 리다이렉트 없음
    if (authState.status == AuthStatus.initial || 
        authState.status == AuthStatus.loading) {
      return null;
    }
    
    final isAuthenticated = authState.isAuthenticated;
    final needsProfile = authState.status == AuthStatus.authenticatedNeedsProfile;
    final isGuest = authState.status == AuthStatus.guest;
    final isOnPublicRoute = _publicRoutes.contains(currentPath);
    final isOnProfileSetup = currentPath == _profileSetupRoute;
    
    // 게스트 모드: 로그인 페이지 제외하고 모든 페이지 접근 가능
    if (isGuest) {
      if (currentPath == '/login' || currentPath == '/profile-setup') {
        return '/';
      }
      return null;
    }
    
    // 인증되지 않은 상태
    if (!isAuthenticated && !isGuest) {
      // 퍼블릭 라우트가 아니면 로그인으로 리다이렉트
      if (!isOnPublicRoute) {
        return '/login';
      }
      return null;
    }
    
    // 인증됨 - 프로필 설정 필요
    if (needsProfile) {
      if (!isOnProfileSetup) {
        return '/profile-setup';
      }
      return null;
    }
    
    // 인증 완료 상태에서 로그인/프로필설정 페이지 접근 시 홈으로
    if (isAuthenticated && !needsProfile) {
      if (isOnPublicRoute || isOnProfileSetup) {
        return '/';
      }
    }
    
    return null;
  }
}

/// 메인 쉘 (하단 네비게이션 포함)
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const List<String> _routes = ['/', '/map', '/cart', '/profile'];

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
      context.go(_routes[index]);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // URL 변경 시 인덱스 동기화
    final location = GoRouterState.of(context).uri.toString();
    final index = _routes.indexOf(location);
    if (index != -1 && index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.gold,
            unselectedItemColor: AppColors.textTertiary,
            selectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: AppStrings.navHome,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map),
                label: AppStrings.navMap,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                activeIcon: Icon(Icons.inventory_2),
                label: AppStrings.navCart,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: AppStrings.navProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

