import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';

/// 세계 지도 화면
/// 대륙별 크라우드펀딩 사이트 탐험
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  String _selectedRegion = 'all';

  // 대륙별 데이터
  final List<RegionData> _regions = [
    RegionData(id: 'all', name: AppStrings.allRegions, center: LatLng(20, 0), zoom: 1.5),
    RegionData(id: 'north_america', name: AppStrings.northAmerica, center: LatLng(40, -100), zoom: 3),
    RegionData(id: 'europe', name: AppStrings.europe, center: LatLng(50, 10), zoom: 3.5),
    RegionData(id: 'asia', name: AppStrings.asia, center: LatLng(35, 105), zoom: 3),
    RegionData(id: 'south_america', name: AppStrings.southAmerica, center: LatLng(-15, -60), zoom: 3),
    RegionData(id: 'others', name: AppStrings.others, center: LatLng(0, 50), zoom: 2),
  ];

  // 마커 데이터
  final List<PortMarkerData> _markers = [
    PortMarkerData(
      id: 'north_america',
      position: LatLng(40, -100),
      siteCount: 28,
      label: '북미',
    ),
    PortMarkerData(
      id: 'europe',
      position: LatLng(50, 10),
      siteCount: 55,
      label: '유럽',
    ),
    PortMarkerData(
      id: 'asia',
      position: LatLng(35, 105),
      siteCount: 45,
      label: '아시아',
    ),
    PortMarkerData(
      id: 'south_america',
      position: LatLng(-15, -60),
      siteCount: 8,
      label: '남미',
    ),
    PortMarkerData(
      id: 'oceania',
      position: LatLng(-25, 135),
      siteCount: 3,
      label: '오세아니아',
    ),
    PortMarkerData(
      id: 'middle_east',
      position: LatLng(25, 45),
      siteCount: 6,
      label: '중동',
    ),
  ];

  void _selectRegion(String regionId) {
    setState(() => _selectedRegion = regionId);
    
    final region = _regions.firstWhere((r) => r.id == regionId);
    _mapController.move(region.center, region.zoom);
  }

  void _onMarkerTap(PortMarkerData marker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => _PortListSheet(
          marker: marker,
          scrollController: scrollController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(AppStrings.worldMapTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 검색 기능
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 대륙 필터 탭
          Container(
            height: 50,
            color: AppColors.parchment,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _regions.length,
              itemBuilder: (context, index) {
                final region = _regions[index];
                final isSelected = region.id == _selectedRegion;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: CategoryChip(
                    label: region.name,
                    isSelected: isSelected,
                    onTap: () => _selectRegion(region.id),
                  ),
                );
              },
            ),
          ),
          // 지도
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(20, 0),
                    initialZoom: 1.5,
                    minZoom: 1.0,
                    maxZoom: 6.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: [
                    // 타일 레이어
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.tradewinds.app',
                    ),
                    // 빈티지 오버레이 효과
                    Container(
                      color: AppColors.parchment.withOpacity(0.15),
                    ),
                    // 마커 레이어
                    MarkerLayer(
                      markers: _markers.map((marker) {
                        return Marker(
                          point: marker.position,
                          width: 60,
                          height: 70,
                          child: GestureDetector(
                            onTap: () => _onMarkerTap(marker),
                            child: _PortMarkerWidget(data: marker),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                // 줌 컨트롤
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoom_in',
                        onPressed: () {
                          final currentZoom = _mapController.camera.zoom;
                          _mapController.move(
                            _mapController.camera.center,
                            currentZoom + 1,
                          );
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        onPressed: () {
                          final currentZoom = _mapController.camera.zoom;
                          _mapController.move(
                            _mapController.camera.center,
                            currentZoom - 1,
                          );
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 항구 마커 위젯
class _PortMarkerWidget extends StatelessWidget {
  final PortMarkerData data;

  const _PortMarkerWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                '${data.siteCount}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnGold,
                  fontSize: 14,
                ),
              ),
              const Text('🏴', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        CustomPaint(
          size: const Size(12, 8),
          painter: _TrianglePainter(color: AppColors.gold),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 항구 리스트 바텀시트
class _PortListSheet extends StatelessWidget {
  final PortMarkerData marker;
  final ScrollController scrollController;

  const _PortListSheet({
    required this.marker,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // 샘플 항구 데이터
    final samplePorts = [
      PortData(name: 'Kickstarter', url: 'kickstarter.com', treasureCount: 1234, type: '보상형'),
      PortData(name: 'Indiegogo', url: 'indiegogo.com', treasureCount: 892, type: '보상형'),
      PortData(name: 'GoFundMe', url: 'gofundme.com', treasureCount: 456, type: '기부형'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 드래그 핸들
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.parchmentDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('🌏', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  '${marker.label} 항구 (${marker.siteCount}개 사이트)',
                  style: AppTypography.headingMedium,
                ),
              ],
            ),
          ),
          // 검색 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '국가 또는 사이트 검색',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 항구 리스트
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: samplePorts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final port = samplePorts[index];
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('🏴', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  title: Text(port.name, style: AppTypography.bodyLarge),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        port.url,
                        style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.goldLight.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              port.type,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '🏷️ ${port.treasureCount}개 보물',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: 항구 상세 페이지 이동
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 데이터 모델
class RegionData {
  final String id;
  final String name;
  final LatLng center;
  final double zoom;

  RegionData({
    required this.id,
    required this.name,
    required this.center,
    required this.zoom,
  });
}

class PortMarkerData {
  final String id;
  final LatLng position;
  final int siteCount;
  final String label;

  PortMarkerData({
    required this.id,
    required this.position,
    required this.siteCount,
    required this.label,
  });
}

class PortData {
  final String name;
  final String url;
  final int treasureCount;
  final String type;

  PortData({
    required this.name,
    required this.url,
    required this.treasureCount,
    required this.type,
  });
}

/// CategoryChip 위젯 (map_page.dart 내에서 사용)
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.parchmentDark,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

