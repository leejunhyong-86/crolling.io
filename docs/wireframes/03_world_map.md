# 세계 지도 탐험 화면 와이어프레임

> **화면명:** 세계 지도 탐험 (World Map Explorer)  
> **파일 위치:** `lib/presentation/pages/map/`

---

## 1. 전체 레이아웃

```
┌─────────────────────────────────────┐
│ ┌─────────────────────────────────┐ │
│ │ ← 세계 지도 탐험          🔍    │ │  ← AppBar
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ [북미] [유럽] [아시아] [남미] [기타] │  ← 대륙 필터 탭
├─────────────────────────────────────┤
│                                     │
│         🌍 세계 지도                 │
│                                     │
│    🏴(28)              🏴(55)       │  ← 마커 (항구)
│     북미                 유럽        │
│                                     │
│              🏴(45)                 │
│               아시아                 │
│                                     │
│    🏴(4)                🏴(1)       │
│     남미                오세아니아    │
│                                     │
│              🏴(6)                  │
│            중동/아프리카             │
│                                     │
│                    [+][-]           │  ← 줌 컨트롤
│                                     │
├─────────────────────────────────────┤
│ [🏠] [🗺️] [🧭] [📦] [👤]          │  ← 하단 네비게이션
└─────────────────────────────────────┘
```

---

## 2. 대륙 필터 탭

### 2.1 레이아웃

```
┌─────────────────────────────────────────────────┐
│ [전체] [북미] [유럽] [아시아] [남미] [기타]  ──→  │
└─────────────────────────────────────────────────┘
     ↑       선택됨 (하이라이트)
```

### 2.2 탭 스타일

```dart
// 선택된 탭
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text('아시아', style: TextStyle(color: Colors.white)),
)

// 선택 안 된 탭
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.parchmentDark),
  ),
  child: Text('유럽', style: TextStyle(color: AppColors.textSecondary)),
)
```

### 2.3 탭 데이터

| 탭 | 표시 | 지도 이동 위치 | 줌 레벨 |
|-----|------|--------------|--------|
| 전체 | 전체 | 중앙 (0, 20) | 1.5 |
| 북미 | 북미 | (40, -100) | 3 |
| 유럽 | 유럽 | (50, 10) | 3.5 |
| 아시아 | 아시아 | (35, 105) | 3 |
| 남미 | 남미 | (-15, -60) | 3 |
| 기타 | 중동/아프리카/오세아니아 | (0, 50) | 2 |

---

## 3. 지도 영역

### 3.1 flutter_map 설정

```dart
FlutterMap(
  options: MapOptions(
    center: LatLng(20, 0),
    zoom: 1.5,
    minZoom: 1.0,
    maxZoom: 6.0,
    interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      // 또는 커스텀 빈티지 스타일 타일
    ),
    MarkerLayer(markers: portMarkers),
  ],
)
```

### 3.2 지도 스타일 옵션

| 옵션 | 설명 |
|------|------|
| 기본 | OpenStreetMap 기본 타일 |
| 빈티지 | Stamen Watercolor (수채화 느낌) |
| 다크 | CartoDB Dark Matter |
| 커스텀 | 파치먼트 색상 필터 오버레이 |

---

## 4. 마커 (항구)

### 4.1 마커 디자인

```
    ┌─────┐
    │ 28  │  ← 사이트 수
    │ 🏴  │  ← 깃발 아이콘
    └──┬──┘
       │
       ▼
     (핀)
```

### 4.2 마커 크기

| 사이트 수 | 마커 크기 | 색상 |
|----------|----------|------|
| 1-10 | Small (40x50) | Gold Light |
| 11-30 | Medium (50x60) | Gold |
| 31+ | Large (60x70) | Gold Dark |

### 4.3 마커 위젯

```dart
class PortMarker extends StatelessWidget {
  final int siteCount;
  final String region;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text('$siteCount', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnGold,
                )),
                Text('🏴', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          CustomPaint(painter: TrianglePainter()), // 아래 삼각형
        ],
      ),
    );
  }
}
```

### 4.4 마커 위치 데이터

```dart
final List<PortMarkerData> markers = [
  PortMarkerData(
    region: 'north_america',
    position: LatLng(40, -100),
    siteCount: 28,
    label: '북미',
  ),
  PortMarkerData(
    region: 'europe',
    position: LatLng(50, 10),
    siteCount: 55,
    label: '유럽',
  ),
  PortMarkerData(
    region: 'asia',
    position: LatLng(35, 105),
    siteCount: 45,
    label: '아시아',
  ),
  // ...
];
```

---

## 5. 바텀시트 (국가/항구 선택)

### 5.1 마커 클릭 시 바텀시트

```
┌─────────────────────────────────────┐
│ ─────────────                       │  ← 드래그 핸들
│                                     │
│  🌏 아시아 항구 (45개 사이트)         │  ← 지역 제목
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔍 국가 또는 사이트 검색       │   │  ← 검색
│  └─────────────────────────────┘   │
│                                     │
│  📍 국가별                          │
│                                     │
│  🇯🇵 일본 (8)                    >  │  ← 국가 리스트
│  ─────────────────────────────────  │
│  🇰🇷 한국 (4)                    >  │
│  ─────────────────────────────────  │
│  🇨🇳 중국 (6)                    >  │
│  ─────────────────────────────────  │
│  🇹🇼 대만 (2)                    >  │
│  ─────────────────────────────────  │
│  🇮🇳 인도 (3)                    >  │
│  ─────────────────────────────────  │
│  ...더보기                          │
│                                     │
└─────────────────────────────────────┘
```

### 5.2 국가 선택 시 확장

```
┌─────────────────────────────────────┐
│ ─────────────                       │
│                                     │
│  ← 🇯🇵 일본 항구 (8개 사이트)        │  ← 뒤로가기
│                                     │
│  ┌───────────────────────────────┐ │
│  │ [로고]  Makuake               │ │
│  │         makuake.com           │ │
│  │         🏷️ 1,234개 보물        │ │
│  │                           >   │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ [로고]  CAMPFIRE              │ │
│  │         camp-fire.jp          │ │
│  │         🏷️ 892개 보물          │ │
│  │                           >   │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ [로고]  GREEN FUNDING         │ │
│  │         greenfunding.jp       │ │
│  │         🏷️ 456개 보물          │ │
│  │                           >   │ │
│  └───────────────────────────────┘ │
│                                     │
│  ... (스크롤)                       │
│                                     │
└─────────────────────────────────────┘
```

### 5.3 바텀시트 동작

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.5,
    minChildSize: 0.3,
    maxChildSize: 0.9,
    builder: (context, scrollController) => Container(
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: PortListSheet(
        region: selectedRegion,
        scrollController: scrollController,
      ),
    ),
  ),
);
```

---

## 6. 항구 카드 (사이트)

### 6.1 레이아웃

```
┌─────────────────────────────────────────────────┐
│  ┌────┐                                         │
│  │로고│  Kickstarter                            │
│  │    │  kickstarter.com                        │
│  └────┘  🏷️ 보상형 | 🌍 1,234개 보물             │
│                                             >   │
└─────────────────────────────────────────────────┘
```

### 6.2 컴포넌트

```dart
ListTile(
  leading: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(port.logoUrl, width: 48, height: 48),
  ),
  title: Text(port.name, style: AppTypography.bodyLarge),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(port.url, style: TextStyle(color: AppColors.textTertiary)),
      Row(
        children: [
          Chip(label: Text(port.type)), // 보상형, 투자형 등
          SizedBox(width: 8),
          Text('🏷️ ${port.treasureCount}개 보물'),
        ],
      ),
    ],
  ),
  trailing: Icon(Icons.chevron_right),
  onTap: () => navigateToPortTreasures(port.id),
)
```

---

## 7. 줌 컨트롤

### 7.1 레이아웃

```
┌─────┐
│  +  │
├─────┤
│  -  │
└─────┘
```

### 7.2 위치

- 화면 우측 하단
- 하단 네비게이션 바로 위
- 마진: 16px

### 7.3 구현

```dart
Positioned(
  right: 16,
  bottom: 100,
  child: Column(
    children: [
      FloatingActionButton.small(
        heroTag: 'zoom_in',
        onPressed: () => mapController.move(
          mapController.center,
          mapController.zoom + 1,
        ),
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
      ),
      SizedBox(height: 8),
      FloatingActionButton.small(
        heroTag: 'zoom_out',
        onPressed: () => mapController.move(
          mapController.center,
          mapController.zoom - 1,
        ),
        child: Icon(Icons.remove),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
      ),
    ],
  ),
)
```

---

## 8. 애니메이션

### 8.1 지도 이동

```dart
// 대륙 탭 선택 시 애니메이션 이동
mapController.animatedMove(
  targetLatLng,
  targetZoom,
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOut,
);
```

### 8.2 마커 등장

```dart
// 줌 인 시 마커 스케일 애니메이션
AnimatedScale(
  scale: isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 300),
  child: PortMarker(...),
)
```

### 8.3 바텀시트

```dart
// 스프링 애니메이션으로 자연스러운 느낌
DraggableScrollableSheet(
  snap: true,
  snapSizes: [0.3, 0.5, 0.9],
  // ...
)
```

---

## 9. 상태 관리

### 9.1 MapState

```dart
class MapState {
  final String selectedRegion;       // 선택된 대륙
  final String? selectedCountry;     // 선택된 국가
  final List<PortMarkerData> markers;
  final List<Port> ports;
  final LatLng center;
  final double zoom;
  final bool isLoading;
}
```

### 9.2 MapEvent

```dart
abstract class MapEvent {}
class SelectRegion extends MapEvent { final String region; }
class SelectCountry extends MapEvent { final String country; }
class SelectPort extends MapEvent { final String portId; }
class UpdateMapPosition extends MapEvent { 
  final LatLng center; 
  final double zoom; 
}
```

---

## 10. 성능 최적화

### 10.1 마커 클러스터링

```dart
// 줌 레벨이 낮을 때 여러 마커를 하나로 클러스터링
if (zoom < 3) {
  // 대륙별 클러스터 마커만 표시
} else if (zoom < 5) {
  // 국가별 마커 표시
} else {
  // 개별 사이트 마커 표시
}
```

### 10.2 타일 캐싱

```dart
TileLayer(
  urlTemplate: '...',
  tileProvider: CachedTileProvider(),
  maxZoom: 18,
)
```

