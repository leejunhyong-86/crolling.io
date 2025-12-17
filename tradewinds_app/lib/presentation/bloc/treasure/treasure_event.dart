import 'package:equatable/equatable.dart';

/// 보물 목록 필터 모델
class TreasureFilter extends Equatable {
  final double? minPrice;
  final double? maxPrice;
  final List<String> categories;
  final List<String> fundingStatuses;
  final List<String> ports;

  const TreasureFilter({
    this.minPrice,
    this.maxPrice,
    this.categories = const [],
    this.fundingStatuses = const [],
    this.ports = const [],
  });

  TreasureFilter copyWith({
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    List<String>? fundingStatuses,
    List<String>? ports,
  }) {
    return TreasureFilter(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      categories: categories ?? this.categories,
      fundingStatuses: fundingStatuses ?? this.fundingStatuses,
      ports: ports ?? this.ports,
    );
  }

  bool get isEmpty =>
      minPrice == null &&
      maxPrice == null &&
      categories.isEmpty &&
      fundingStatuses.isEmpty &&
      ports.isEmpty;

  @override
  List<Object?> get props =>
      [minPrice, maxPrice, categories, fundingStatuses, ports];
}

/// 정렬 타입
enum TreasureSortType {
  latest,       // 최신순
  popular,      // 인기순 (펀딩률)
  endingSoon,   // 마감임박순
}

/// 뷰 모드
enum ViewMode {
  list,
  grid,
}

/// 보물 목록 이벤트
abstract class TreasureEvent extends Equatable {
  const TreasureEvent();

  @override
  List<Object?> get props => [];
}

/// 초기 로드
class TreasureLoadRequested extends TreasureEvent {
  const TreasureLoadRequested();
}

/// 더 많은 데이터 로드 (무한 스크롤)
class TreasureLoadMoreRequested extends TreasureEvent {
  const TreasureLoadMoreRequested();
}

/// 새로고침 (Pull-to-refresh)
class TreasureRefreshRequested extends TreasureEvent {
  const TreasureRefreshRequested();
}

/// 필터 변경
class TreasureFilterChanged extends TreasureEvent {
  final TreasureFilter filter;

  const TreasureFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// 정렬 변경
class TreasureSortChanged extends TreasureEvent {
  final TreasureSortType sortType;

  const TreasureSortChanged(this.sortType);

  @override
  List<Object?> get props => [sortType];
}

/// 뷰 모드 변경
class TreasureViewModeChanged extends TreasureEvent {
  final ViewMode viewMode;

  const TreasureViewModeChanged(this.viewMode);

  @override
  List<Object?> get props => [viewMode];
}

/// 필터 초기화
class TreasureFilterReset extends TreasureEvent {
  const TreasureFilterReset();
}
