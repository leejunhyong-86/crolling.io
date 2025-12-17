import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/treasure_card.dart';
import 'treasure_event.dart';
import 'treasure_state.dart';

/// 보물 목록 BLoC
class TreasureBloc extends Bloc<TreasureEvent, TreasureState> {
  static const int _pageSize = 10;

  TreasureBloc() : super(const TreasureState()) {
    on<TreasureLoadRequested>(_onLoadRequested);
    on<TreasureLoadMoreRequested>(_onLoadMoreRequested);
    on<TreasureRefreshRequested>(_onRefreshRequested);
    on<TreasureFilterChanged>(_onFilterChanged);
    on<TreasureSortChanged>(_onSortChanged);
    on<TreasureViewModeChanged>(_onViewModeChanged);
    on<TreasureFilterReset>(_onFilterReset);
  }

  /// 초기 로드
  Future<void> _onLoadRequested(
    TreasureLoadRequested event,
    Emitter<TreasureState> emit,
  ) async {
    emit(state.copyWith(status: TreasureStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final treasures = _getMockTreasures(0, _pageSize);
      final sortedTreasures = _sortTreasures(treasures, state.sortType);

      emit(state.copyWith(
        status: TreasureStatus.loaded,
        treasures: sortedTreasures,
        hasReachedMax: sortedTreasures.length < _pageSize,
        currentPage: 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TreasureStatus.error,
        errorMessage: '보물을 불러오는 중 문제가 발생했습니다',
      ));
    }
  }

  /// 더 많은 데이터 로드 (무한 스크롤)
  Future<void> _onLoadMoreRequested(
    TreasureLoadMoreRequested event,
    Emitter<TreasureState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoading) return;

    emit(state.copyWith(status: TreasureStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final newTreasures = _getMockTreasures(
        state.currentPage * _pageSize,
        _pageSize,
      );
      final sortedNew = _sortTreasures(newTreasures, state.sortType);

      emit(state.copyWith(
        status: TreasureStatus.loaded,
        treasures: [...state.treasures, ...sortedNew],
        hasReachedMax: sortedNew.length < _pageSize,
        currentPage: state.currentPage + 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TreasureStatus.loaded,
        errorMessage: '추가 보물을 불러오는 중 문제가 발생했습니다',
      ));
    }
  }

  /// 새로고침 (Pull-to-refresh)
  Future<void> _onRefreshRequested(
    TreasureRefreshRequested event,
    Emitter<TreasureState> emit,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final treasures = _getMockTreasures(0, _pageSize);
      final filtered = _applyFilter(treasures, state.filter);
      final sorted = _sortTreasures(filtered, state.sortType);

      emit(state.copyWith(
        status: TreasureStatus.loaded,
        treasures: sorted,
        hasReachedMax: sorted.length < _pageSize,
        currentPage: 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TreasureStatus.error,
        errorMessage: '새로고침 중 문제가 발생했습니다',
      ));
    }
  }

  /// 필터 변경
  Future<void> _onFilterChanged(
    TreasureFilterChanged event,
    Emitter<TreasureState> emit,
  ) async {
    emit(state.copyWith(
      status: TreasureStatus.loading,
      filter: event.filter,
    ));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final allTreasures = _getMockTreasures(0, 50);
      final filtered = _applyFilter(allTreasures, event.filter);
      final sorted = _sortTreasures(filtered, state.sortType);
      final paged = sorted.take(_pageSize).toList();

      emit(state.copyWith(
        status: TreasureStatus.loaded,
        treasures: paged,
        hasReachedMax: paged.length >= sorted.length,
        currentPage: 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TreasureStatus.error,
        errorMessage: '필터 적용 중 문제가 발생했습니다',
      ));
    }
  }

  /// 정렬 변경
  Future<void> _onSortChanged(
    TreasureSortChanged event,
    Emitter<TreasureState> emit,
  ) async {
    emit(state.copyWith(
      status: TreasureStatus.loading,
      sortType: event.sortType,
    ));

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final sorted = _sortTreasures(state.treasures, event.sortType);

      emit(state.copyWith(
        status: TreasureStatus.loaded,
        treasures: sorted,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TreasureStatus.loaded,
      ));
    }
  }

  /// 뷰 모드 변경
  void _onViewModeChanged(
    TreasureViewModeChanged event,
    Emitter<TreasureState> emit,
  ) {
    emit(state.copyWith(viewMode: event.viewMode));
  }

  /// 필터 초기화
  Future<void> _onFilterReset(
    TreasureFilterReset event,
    Emitter<TreasureState> emit,
  ) async {
    emit(state.copyWith(
      status: TreasureStatus.loading,
      filter: const TreasureFilter(),
    ));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final treasures = _getMockTreasures(0, _pageSize);
      final sorted = _sortTreasures(treasures, state.sortType);

      emit(state.copyWith(
        status: TreasureStatus.loaded,
        treasures: sorted,
        hasReachedMax: sorted.length < _pageSize,
        currentPage: 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TreasureStatus.error,
        errorMessage: '필터 초기화 중 문제가 발생했습니다',
      ));
    }
  }

  /// 필터 적용
  List<TreasureData> _applyFilter(
    List<TreasureData> treasures,
    TreasureFilter filter,
  ) {
    if (filter.isEmpty) return treasures;

    return treasures.where((t) {
      // 가격 필터
      if (filter.minPrice != null && t.price < filter.minPrice!) {
        return false;
      }
      if (filter.maxPrice != null && t.price > filter.maxPrice!) {
        return false;
      }

      // 카테고리 필터
      if (filter.categories.isNotEmpty &&
          !filter.categories.contains(t.category)) {
        return false;
      }

      // 펀딩 상태 필터
      if (filter.fundingStatuses.isNotEmpty) {
        final status = _getFundingStatus(t);
        if (!filter.fundingStatuses.contains(status)) {
          return false;
        }
      }

      // 항구 필터
      if (filter.ports.isNotEmpty && !filter.ports.contains(t.portName)) {
        return false;
      }

      return true;
    }).toList();
  }

  String _getFundingStatus(TreasureData treasure) {
    if (treasure.daysLeft <= 0) return 'ended';
    if (treasure.fundingPercentage >= 100) return 'success';
    return 'inProgress';
  }

  /// 정렬 적용
  List<TreasureData> _sortTreasures(
    List<TreasureData> treasures,
    TreasureSortType sortType,
  ) {
    final sorted = List<TreasureData>.from(treasures);

    switch (sortType) {
      case TreasureSortType.latest:
        // ID 역순 (Mock에서는 ID가 생성 순서)
        sorted.sort((a, b) => b.id.compareTo(a.id));
        break;
      case TreasureSortType.popular:
        // 펀딩률 높은 순
        sorted.sort((a, b) => b.fundingPercentage.compareTo(a.fundingPercentage));
        break;
      case TreasureSortType.endingSoon:
        // 남은 일수 적은 순
        sorted.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
        break;
    }

    return sorted;
  }

  /// Mock 데이터 생성
  List<TreasureData> _getMockTreasures(int offset, int limit) {
    final allTreasures = _allMockTreasures;
    if (offset >= allTreasures.length) return [];
    
    final end = (offset + limit).clamp(0, allTreasures.length);
    return allTreasures.sublist(offset, end);
  }

  /// 전체 Mock 데이터
  static final List<TreasureData> _allMockTreasures = [
    const TreasureData(
      id: '1',
      title: 'Revolutionary Smart Watch with AI Assistant',
      imageUrl: 'https://picsum.photos/seed/treasure1/400/300',
      portName: 'Kickstarter',
      portLogoUrl: '',
      country: '🇺🇸',
      category: 'Tech',
      price: 149,
      currency: '\$',
      fundingPercentage: 285,
      daysLeft: 15,
      backerCount: 2847,
      rating: 4.8,
    ),
    const TreasureData(
      id: '2',
      title: 'Portable Solar-Powered Projector',
      imageUrl: 'https://picsum.photos/seed/treasure2/400/300',
      portName: 'Indiegogo',
      portLogoUrl: '',
      country: '🇺🇸',
      category: 'Tech',
      price: 299,
      currency: '\$',
      fundingPercentage: 520,
      daysLeft: 8,
      backerCount: 1523,
    ),
    const TreasureData(
      id: '3',
      title: '最先端ワイヤレスイヤホン',
      imageUrl: 'https://picsum.photos/seed/treasure3/400/300',
      portName: 'Makuake',
      portLogoUrl: '',
      country: '🇯🇵',
      category: 'Audio',
      price: 29800,
      currency: '¥',
      fundingPercentage: 1850,
      daysLeft: 22,
      backerCount: 892,
    ),
    const TreasureData(
      id: '4',
      title: 'Eco-Friendly Smart Backpack',
      imageUrl: 'https://picsum.photos/seed/treasure4/400/300',
      portName: 'Kickstarter',
      portLogoUrl: '',
      country: '🇩🇪',
      category: 'Lifestyle',
      price: 89,
      currency: '\$',
      fundingPercentage: 156,
      daysLeft: 3,
      backerCount: 567,
      isWishlisted: true,
    ),
    const TreasureData(
      id: '5',
      title: '스마트 공기청정기 2세대',
      imageUrl: 'https://picsum.photos/seed/treasure5/400/300',
      portName: 'Wadiz',
      portLogoUrl: '',
      country: '🇰🇷',
      category: 'Home',
      price: 159000,
      currency: '₩',
      fundingPercentage: 890,
      daysLeft: 5,
      backerCount: 1234,
    ),
    const TreasureData(
      id: '6',
      title: 'Minimalist Desk Organizer Set',
      imageUrl: 'https://picsum.photos/seed/treasure6/400/300',
      portName: 'Kickstarter',
      portLogoUrl: '',
      country: '🇺🇸',
      category: 'Lifestyle',
      price: 45,
      currency: '\$',
      fundingPercentage: 320,
      daysLeft: 12,
      backerCount: 890,
    ),
    const TreasureData(
      id: '7',
      title: 'Premium Mechanical Keyboard',
      imageUrl: 'https://picsum.photos/seed/treasure7/400/300',
      portName: 'Indiegogo',
      portLogoUrl: '',
      country: '🇹🇼',
      category: 'Tech',
      price: 189,
      currency: '\$',
      fundingPercentage: 780,
      daysLeft: 18,
      backerCount: 2100,
      rating: 4.9,
    ),
    const TreasureData(
      id: '8',
      title: '프리미엄 캠핑 텐트',
      imageUrl: 'https://picsum.photos/seed/treasure8/400/300',
      portName: 'Wadiz',
      portLogoUrl: '',
      country: '🇰🇷',
      category: 'Outdoor',
      price: 289000,
      currency: '₩',
      fundingPercentage: 450,
      daysLeft: 7,
      backerCount: 678,
    ),
    const TreasureData(
      id: '9',
      title: 'Smart Water Bottle with Temperature Display',
      imageUrl: 'https://picsum.photos/seed/treasure9/400/300',
      portName: 'Kickstarter',
      portLogoUrl: '',
      country: '🇬🇧',
      category: 'Lifestyle',
      price: 35,
      currency: '\$',
      fundingPercentage: 210,
      daysLeft: 25,
      backerCount: 1450,
    ),
    const TreasureData(
      id: '10',
      title: '高性能ワイヤレス充電器',
      imageUrl: 'https://picsum.photos/seed/treasure10/400/300',
      portName: 'Makuake',
      portLogoUrl: '',
      country: '🇯🇵',
      category: 'Tech',
      price: 8900,
      currency: '¥',
      fundingPercentage: 1200,
      daysLeft: 10,
      backerCount: 560,
    ),
    const TreasureData(
      id: '11',
      title: 'Compact Travel Pillow',
      imageUrl: 'https://picsum.photos/seed/treasure11/400/300',
      portName: 'Indiegogo',
      portLogoUrl: '',
      country: '🇺🇸',
      category: 'Travel',
      price: 29,
      currency: '\$',
      fundingPercentage: 95,
      daysLeft: 2,
      backerCount: 234,
    ),
    const TreasureData(
      id: '12',
      title: '혁신적인 스마트 화분',
      imageUrl: 'https://picsum.photos/seed/treasure12/400/300',
      portName: 'Wadiz',
      portLogoUrl: '',
      country: '🇰🇷',
      category: 'Home',
      price: 79000,
      currency: '₩',
      fundingPercentage: 670,
      daysLeft: 14,
      backerCount: 890,
    ),
    const TreasureData(
      id: '13',
      title: 'Noise-Cancelling Earbuds Pro',
      imageUrl: 'https://picsum.photos/seed/treasure13/400/300',
      portName: 'Kickstarter',
      portLogoUrl: '',
      country: '🇺🇸',
      category: 'Audio',
      price: 129,
      currency: '\$',
      fundingPercentage: 420,
      daysLeft: 20,
      backerCount: 3200,
      rating: 4.7,
    ),
    const TreasureData(
      id: '14',
      title: 'Portable Coffee Maker',
      imageUrl: 'https://picsum.photos/seed/treasure14/400/300',
      portName: 'Indiegogo',
      portLogoUrl: '',
      country: '🇮🇹',
      category: 'Lifestyle',
      price: 79,
      currency: '\$',
      fundingPercentage: 890,
      daysLeft: 6,
      backerCount: 1780,
    ),
    const TreasureData(
      id: '15',
      title: 'Ultra-Light Hiking Gear Set',
      imageUrl: 'https://picsum.photos/seed/treasure15/400/300',
      portName: 'Kickstarter',
      portLogoUrl: '',
      country: '🇨🇦',
      category: 'Outdoor',
      price: 199,
      currency: '\$',
      fundingPercentage: 340,
      daysLeft: 11,
      backerCount: 450,
    ),
    const TreasureData(
      id: '16',
      title: '스마트 홈 허브 시스템',
      imageUrl: 'https://picsum.photos/seed/treasure16/400/300',
      portName: 'Wadiz',
      portLogoUrl: '',
      country: '🇰🇷',
      category: 'Tech',
      price: 199000,
      currency: '₩',
      fundingPercentage: 560,
      daysLeft: 9,
      backerCount: 780,
    ),
    const TreasureData(
      id: '17',
      title: 'Ergonomic Office Chair',
      imageUrl: 'https://picsum.photos/seed/treasure17/400/300',
      portName: 'Indiegogo',
      portLogoUrl: '',
      country: '🇸🇪',
      category: 'Home',
      price: 399,
      currency: '\$',
      fundingPercentage: 230,
      daysLeft: 16,
      backerCount: 340,
    ),
    const TreasureData(
      id: '18',
      title: 'Premium Leather Wallet',
      imageUrl: 'https://picsum.photos/seed/treasure18/400/300',
      portName: 'Kickstarter',
      portLogoUrl: '',
      country: '🇮🇹',
      category: 'Fashion',
      price: 65,
      currency: '\$',
      fundingPercentage: 180,
      daysLeft: 4,
      backerCount: 620,
    ),
    const TreasureData(
      id: '19',
      title: 'コンパクト空気清浄機',
      imageUrl: 'https://picsum.photos/seed/treasure19/400/300',
      portName: 'Makuake',
      portLogoUrl: '',
      country: '🇯🇵',
      category: 'Home',
      price: 19800,
      currency: '¥',
      fundingPercentage: 980,
      daysLeft: 13,
      backerCount: 1100,
    ),
    const TreasureData(
      id: '20',
      title: 'Smart Fitness Ring',
      imageUrl: 'https://picsum.photos/seed/treasure20/400/300',
      portName: 'Indiegogo',
      portLogoUrl: '',
      country: '🇫🇮',
      category: 'Tech',
      price: 249,
      currency: '\$',
      fundingPercentage: 1500,
      daysLeft: 21,
      backerCount: 4500,
      rating: 4.6,
    ),
  ];

  /// 사용 가능한 카테고리 목록
  static const List<String> availableCategories = [
    'Tech',
    'Audio',
    'Lifestyle',
    'Home',
    'Outdoor',
    'Travel',
    'Fashion',
  ];

  /// 사용 가능한 항구 목록
  static const List<String> availablePorts = [
    'Kickstarter',
    'Indiegogo',
    'Makuake',
    'Wadiz',
  ];

  /// 펀딩 상태 목록
  static const List<String> fundingStatuses = [
    'inProgress',
    'success',
    'ended',
  ];
}
