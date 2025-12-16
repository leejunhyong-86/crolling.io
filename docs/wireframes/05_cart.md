# 선적 화물 (장바구니) 화면 와이어프레임

> **화면명:** 선적 화물 (Cart / Cargo Hold)  
> **파일 위치:** `lib/presentation/pages/cart/`

---

## 1. 전체 레이아웃

```
┌─────────────────────────────────────┐
│ ┌─────────────────────────────────┐ │
│ │ ← 선적 화물                 편집 │ │  ← AppBar
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│                                     │
│  📦 3개 화물 | 예상 총액 ₩897,000    │  ← 요약
│                                     │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                     │
│  🏴 Kickstarter                     │  ← 항구별 그룹
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ☑ [이미지]  Smart Watch...   │   │
│  │            Early Bird $149   │   │
│  │            (~₩199,000)       │   │
│  │                              │   │
│  │      [-] 1 [+]       🗑️     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ☑ [이미지]  Portable Proj... │   │
│  │            Standard $299     │   │
│  │            (~₩399,000)       │   │
│  │                              │   │
│  │      [-] 1 [+]       🗑️     │   │
│  └─────────────────────────────┘   │
│                                     │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                     │
│  🏴 Makuake                         │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ☑ [이미지]  Wireless Earb... │   │
│  │            限定セット ¥29,800 │   │
│  │            (~₩299,000)       │   │
│  │                              │   │
│  │      [-] 1 [+]       🗑️     │   │
│  └─────────────────────────────┘   │
│                                     │
│                                     │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │  ☑ 전체 선택 (3/3)               │ │  ← 전체 선택
│ ├─────────────────────────────────┤ │
│ │  상품 금액        ₩897,000       │ │
│ │  예상 배송비      별도 문의        │ │
│ │  ─────────────────────────────  │ │
│ │  예상 총액        ₩897,000       │ │
│ │                                 │ │
│ │  ┌───────────────────────────┐ │ │
│ │  │     ⚓ 출항 준비 (3개)       │ │ │  ← 결제 버튼
│ │  └───────────────────────────┘ │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ [🏠] [🗺️] [🧭] [📦] [👤]          │
└─────────────────────────────────────┘
```

---

## 2. 카트 아이템 카드

### 2.1 레이아웃 상세

```
┌─────────────────────────────────────────────────┐
│ ┌──┐                                            │
│ │☑ │  ┌────┐  Smart Watch with AI Assistant    │
│ └──┘  │    │                                    │
│       │이미지│  리워드: Early Bird Special       │
│       │    │  💰 $149 (~₩199,000)              │
│       └────┘                                    │
│                                                 │
│              ┌───┬───┬───┐            ┌───┐   │
│              │ - │ 1 │ + │            │ 🗑️│   │
│              └───┴───┴───┘            └───┘   │
│                                                 │
│  ⏰ 펀딩 마감: D-15 | 📦 예상 배송: 2024.06     │
└─────────────────────────────────────────────────┘
```

### 2.2 카드 구현

```dart
class CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool isSelected;
  final Function(bool?) onSelect;
  final Function(int) onQuantityChange;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black08, blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 체크박스
              Checkbox(
                value: isSelected,
                onChanged: onSelect,
                activeColor: AppColors.gold,
              ),
              // 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '리워드: ${item.rewardName}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    PriceText(
                      price: item.price,
                      currency: item.currency,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // 하단 컨트롤
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 수량 조절
              QuantitySelector(
                quantity: item.quantity,
                onChanged: onQuantityChange,
              ),
              // 삭제 버튼
              IconButton(
                icon: Icon(Icons.delete_outline, color: AppColors.coral),
                onPressed: onRemove,
              ),
            ],
          ),
          // 펀딩 정보
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.parchment,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text('⏰ 펀딩 마감: D-${item.daysLeft}'),
                SizedBox(width: 16),
                Text('📦 예상 배송: ${item.estimatedDelivery}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 3. 수량 선택기

```
┌─────────────────┐
│  [-]  2  [+]    │
└─────────────────┘
```

```dart
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.parchmentDark),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove, size: 18),
            onPressed: quantity > minQuantity 
              ? () => onChanged(quantity - 1) 
              : null,
            constraints: BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              '$quantity',
              style: AppTypography.bodyLarge,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, size: 18),
            onPressed: quantity < maxQuantity 
              ? () => onChanged(quantity + 1) 
              : null,
            constraints: BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }
}
```

---

## 4. 항구별 그룹 헤더

```
┌─────────────────────────────────────────────────┐
│  🏴 Kickstarter  (2개 화물)              총액 > │
└─────────────────────────────────────────────────┘
```

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  color: AppColors.parchment,
  child: Row(
    children: [
      Text('🏴', style: TextStyle(fontSize: 20)),
      SizedBox(width: 8),
      Text(
        'Kickstarter',
        style: AppTypography.headingSmall,
      ),
      SizedBox(width: 8),
      Text(
        '(${items.length}개 화물)',
        style: TextStyle(color: AppColors.textTertiary),
      ),
      Spacer(),
      Text(
        '${formatCurrency(subtotal)}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  ),
)
```

---

## 5. 하단 결제 영역

### 5.1 레이아웃

```
┌─────────────────────────────────────────────────┐
│                                                 │
│  ☑ 전체 선택 (3/3)                              │
│                                                 │
├─────────────────────────────────────────────────┤
│                                                 │
│  상품 금액                          ₩897,000    │
│  예상 배송비                        별도 문의    │
│  ─────────────────────────────────────────────  │
│  예상 총액                          ₩897,000    │
│                                                 │
│  ⚠️ 크라우드펀딩 특성상 정확한 금액은            │
│     결제 시점에 확정됩니다                       │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │          ⚓ 출항 준비 (3개)               │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
└─────────────────────────────────────────────────┘
```

### 5.2 구현

```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(0, -4),
      ),
    ],
  ),
  child: SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 전체 선택
        Row(
          children: [
            Checkbox(
              value: isAllSelected,
              onChanged: (value) => selectAll(value),
              activeColor: AppColors.gold,
            ),
            Text('전체 선택 (${selectedCount}/${totalCount})'),
          ],
        ),
        Divider(),
        // 금액 정보
        _buildPriceRow('상품 금액', formatCurrency(subtotal)),
        _buildPriceRow('예상 배송비', '별도 문의', isNote: true),
        Divider(thickness: 2),
        _buildPriceRow(
          '예상 총액',
          formatCurrency(total),
          isBold: true,
        ),
        SizedBox(height: 8),
        // 안내 문구
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.goldLight.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.gold),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '크라우드펀딩 특성상 정확한 금액은 결제 시점에 확정됩니다',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        // 결제 버튼
        ElevatedButton(
          onPressed: selectedCount > 0 ? () => proceedToCheckout() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.textOnGold,
            minimumSize: Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('⚓', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                '출항 준비 (${selectedCount}개)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
)
```

---

## 6. 편집 모드

### 6.1 레이아웃 (편집 모드)

```
┌─────────────────────────────────────┐
│ ← 선적 화물                     완료 │  ← 완료 버튼
├─────────────────────────────────────┤
│                                     │
│  ☑ 전체 선택 (3/3)       [선택 삭제] │  ← 삭제 버튼
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ☑ Smart Watch...            │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ☐ Portable Projector...     │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ☑ Wireless Earbuds...       │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 7. 빈 카트 상태

```
┌─────────────────────────────────────┐
│ ← 선적 화물                         │
├─────────────────────────────────────┤
│                                     │
│                                     │
│                                     │
│            📦                       │
│         (빈 상자)                    │
│                                     │
│     "선적할 화물이 없습니다"          │
│                                     │
│    세계 곳곳의 보물을 탐험하고         │
│    마음에 드는 보물을 담아보세요       │
│                                     │
│    ┌─────────────────────────┐     │
│    │      보물 탐험 떠나기      │     │
│    └─────────────────────────┘     │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│ [🏠] [🗺️] [🧭] [📦] [👤]          │
└─────────────────────────────────────┘
```

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.inventory_2_outlined,
        size: 80,
        color: AppColors.parchmentDark,
      ),
      SizedBox(height: 24),
      Text(
        '선적할 화물이 없습니다',
        style: AppTypography.headingMedium,
      ),
      SizedBox(height: 8),
      Text(
        '세계 곳곳의 보물을 탐험하고\n마음에 드는 보물을 담아보세요',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textSecondary),
      ),
      SizedBox(height: 32),
      ElevatedButton(
        onPressed: () => context.go('/'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
        ),
        child: Text('보물 탐험 떠나기'),
      ),
    ],
  ),
)
```

---

## 8. 스와이프 삭제

```dart
Dismissible(
  key: Key(item.id),
  direction: DismissDirection.endToStart,
  background: Container(
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 20),
    color: AppColors.coral,
    child: Icon(Icons.delete, color: Colors.white),
  ),
  confirmDismiss: (direction) async {
    return await showDeleteConfirmDialog(context);
  },
  onDismissed: (direction) {
    removeFromCart(item.id);
  },
  child: CartItemCard(item: item),
)
```

---

## 9. 삭제 확인 다이얼로그

```
┌─────────────────────────────────────┐
│                                     │
│           화물을 내리시겠습니까?       │
│                                     │
│    "Smart Watch with AI..."를       │
│    선적 화물에서 제거합니다           │
│                                     │
│  ┌──────────────┐ ┌──────────────┐ │
│  │     취소      │ │     확인      │ │
│  └──────────────┘ └──────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

---

## 10. 상태 관리

```dart
class CartState {
  final List<CartItem> items;
  final Set<String> selectedIds;
  final bool isEditMode;
  final bool isLoading;
}

abstract class CartEvent {}
class LoadCart extends CartEvent {}
class AddToCart extends CartEvent { 
  final String treasureId; 
  final String rewardId; 
}
class RemoveFromCart extends CartEvent { final String itemId; }
class UpdateQuantity extends CartEvent { 
  final String itemId; 
  final int quantity; 
}
class ToggleItemSelection extends CartEvent { final String itemId; }
class SelectAllItems extends CartEvent { final bool isSelected; }
class ToggleEditMode extends CartEvent {}
class RemoveSelectedItems extends CartEvent {}
```

---

## 11. 애니메이션

| 동작 | 애니메이션 |
|------|-----------|
| 아이템 추가 | SlideTransition (좌에서 우) |
| 아이템 삭제 | SlideTransition (우에서 좌) + FadeTransition |
| 수량 변경 | AnimatedSwitcher (숫자 변경) |
| 빈 상태 전환 | FadeTransition |

