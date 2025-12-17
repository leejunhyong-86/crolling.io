import 'package:equatable/equatable.dart';
import '../../widgets/treasure_card.dart';
import 'treasure_event.dart';

/// 보물 목록 상태
enum TreasureStatus {
  initial,
  loading,
  loaded,
  error,
}

/// 보물 목록 상태 클래스
class TreasureState extends Equatable {
  final TreasureStatus status;
  final List<TreasureData> treasures;
  final bool hasReachedMax;
  final TreasureFilter filter;
  final TreasureSortType sortType;
  final ViewMode viewMode;
  final String? errorMessage;
  final int currentPage;

  const TreasureState({
    this.status = TreasureStatus.initial,
    this.treasures = const [],
    this.hasReachedMax = false,
    this.filter = const TreasureFilter(),
    this.sortType = TreasureSortType.latest,
    this.viewMode = ViewMode.grid,
    this.errorMessage,
    this.currentPage = 0,
  });

  /// 로딩 상태인지 확인
  bool get isLoading => status == TreasureStatus.loading;

  /// 초기 로딩 상태인지 확인 (데이터 없이 로딩 중)
  bool get isInitialLoading =>
      status == TreasureStatus.loading && treasures.isEmpty;

  /// 추가 로딩 상태인지 확인 (데이터 있고 더 로딩 중)
  bool get isLoadingMore =>
      status == TreasureStatus.loading && treasures.isNotEmpty;

  /// 빈 결과인지 확인
  bool get isEmpty =>
      status == TreasureStatus.loaded && treasures.isEmpty;

  /// 필터가 적용되어 있는지 확인
  bool get hasActiveFilter => !filter.isEmpty;

  TreasureState copyWith({
    TreasureStatus? status,
    List<TreasureData>? treasures,
    bool? hasReachedMax,
    TreasureFilter? filter,
    TreasureSortType? sortType,
    ViewMode? viewMode,
    String? errorMessage,
    int? currentPage,
  }) {
    return TreasureState(
      status: status ?? this.status,
      treasures: treasures ?? this.treasures,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      filter: filter ?? this.filter,
      sortType: sortType ?? this.sortType,
      viewMode: viewMode ?? this.viewMode,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        treasures,
        hasReachedMax,
        filter,
        sortType,
        viewMode,
        errorMessage,
        currentPage,
      ];
}
