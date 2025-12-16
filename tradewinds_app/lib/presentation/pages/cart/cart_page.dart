import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../widgets/common/gold_button.dart';
import '../../widgets/common/empty_state.dart';

/// 장바구니 화면 (선적 화물)
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItemData> _cartItems = [
    CartItemData(
      id: '1',
      title: 'Revolutionary Smart Watch with AI Assistant',
      imageUrl: 'https://picsum.photos/seed/cart1/200/200',
      portName: 'Kickstarter',
      rewardName: 'Early Bird Special',
      price: 149,
      currency: '\$',
      quantity: 1,
      daysLeft: 15,
      estimatedDelivery: '2024.06',
      isSelected: true,
    ),
    CartItemData(
      id: '2',
      title: 'Portable Solar-Powered Projector',
      imageUrl: 'https://picsum.photos/seed/cart2/200/200',
      portName: 'Kickstarter',
      rewardName: 'Standard Pack',
      price: 299,
      currency: '\$',
      quantity: 1,
      daysLeft: 8,
      estimatedDelivery: '2024.07',
      isSelected: true,
    ),
    CartItemData(
      id: '3',
      title: '最先端ワイヤレスイヤホン',
      imageUrl: 'https://picsum.photos/seed/cart3/200/200',
      portName: 'Makuake',
      rewardName: '限定セット',
      price: 29800,
      currency: '¥',
      quantity: 1,
      daysLeft: 22,
      estimatedDelivery: '2024.08',
      isSelected: true,
    ),
  ];

  bool _isEditMode = false;

  int get _selectedCount => _cartItems.where((item) => item.isSelected).length;
  
  double get _totalAmount {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + _convertToKRW(item.price, item.currency) * item.quantity);
  }

  double _convertToKRW(double price, String currency) {
    switch (currency) {
      case '\$':
        return price * 1330;
      case '¥':
        return price * 9;
      case '€':
        return price * 1450;
      default:
        return price;
    }
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      for (var item in _cartItems) {
        item.isSelected = value ?? false;
      }
    });
  }

  void _updateQuantity(String itemId, int newQuantity) {
    setState(() {
      final item = _cartItems.firstWhere((i) => i.id == itemId);
      item.quantity = newQuantity.clamp(1, 10);
    });
  }

  void _removeItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((i) => i.id == itemId);
    });
  }

  void _removeSelectedItems() {
    setState(() {
      _cartItems.removeWhere((i) => i.isSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.parchment,
        appBar: AppBar(
          title: Text(AppStrings.cartTitle),
        ),
        body: EmptyState(
          emoji: '📦',
          title: AppStrings.cartEmpty,
          description: AppStrings.cartEmptyDescription,
          buttonText: AppStrings.exploreTreasures,
          onButtonTap: () {
            // TODO: 홈으로 이동
          },
        ),
      );
    }

    // 항구별로 그룹핑
    final groupedItems = <String, List<CartItemData>>{};
    for (var item in _cartItems) {
      groupedItems.putIfAbsent(item.portName, () => []).add(item);
    }

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(AppStrings.cartTitle),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _isEditMode = !_isEditMode);
            },
            child: Text(
              _isEditMode ? AppStrings.done : AppStrings.edit,
              style: TextStyle(color: AppColors.gold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 요약 바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                const Text('📦', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '${_cartItems.length}개 화물',
                  style: AppTypography.bodyMedium,
                ),
                const Spacer(),
                Text(
                  '예상 총액 ',
                  style: AppTypography.bodySmall,
                ),
                Text(
                  '₩${_formatNumber(_totalAmount.toInt())}',
                  style: AppTypography.priceMedium,
                ),
              ],
            ),
          ),
          // 카트 리스트
          Expanded(
            child: ListView.builder(
              itemCount: groupedItems.length,
              itemBuilder: (context, groupIndex) {
                final portName = groupedItems.keys.elementAt(groupIndex);
                final items = groupedItems[portName]!;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 항구 헤더
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: AppColors.parchment,
                      child: Row(
                        children: [
                          const Text('🏴', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(portName, style: AppTypography.headingSmall),
                        ],
                      ),
                    ),
                    // 아이템들
                    ...items.map((item) => _CartItemCard(
                      item: item,
                      isEditMode: _isEditMode,
                      onSelect: (value) {
                        setState(() => item.isSelected = value ?? false);
                      },
                      onQuantityChange: (qty) => _updateQuantity(item.id, qty),
                      onRemove: () => _removeItem(item.id),
                    )),
                  ],
                );
              },
            ),
          ),
          // 하단 결제 영역
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -4),
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
                  value: _selectedCount == _cartItems.length && _cartItems.isNotEmpty,
                  onChanged: _toggleSelectAll,
                  activeColor: AppColors.gold,
                ),
                Text('전체 선택 ($_selectedCount/${_cartItems.length})'),
                if (_isEditMode) ...[
                  const Spacer(),
                  TextButton(
                    onPressed: _selectedCount > 0 ? _removeSelectedItems : null,
                    child: Text(
                      '선택 삭제',
                      style: TextStyle(color: AppColors.coral),
                    ),
                  ),
                ],
              ],
            ),
            const Divider(),
            // 금액 정보
            _buildPriceRow('상품 금액', '₩${_formatNumber(_totalAmount.toInt())}'),
            _buildPriceRow(AppStrings.shippingFee, AppStrings.toBeConfirmed, isNote: true),
            const Divider(thickness: 2),
            _buildPriceRow(
              AppStrings.totalAmount,
              '₩${_formatNumber(_totalAmount.toInt())}',
              isBold: true,
            ),
            const SizedBox(height: 8),
            // 안내 문구
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.goldLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.gold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '크라우드펀딩 특성상 정확한 금액은 결제 시점에 확정됩니다',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 결제 버튼
            GoldButton(
              text: '${AppStrings.checkout} ($_selectedCount개)',
              icon: Icons.sailing,
              onPressed: _selectedCount > 0
                  ? () {
                      // TODO: 결제 화면 이동
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isNote = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold ? AppTypography.labelLarge : AppTypography.bodyMedium,
          ),
          Text(
            value,
            style: isBold
                ? AppTypography.priceMedium
                : isNote
                    ? AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)
                    : AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemData item;
  final bool isEditMode;
  final Function(bool?) onSelect;
  final Function(int) onQuantityChange;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.isEditMode,
    required this.onSelect,
    required this.onQuantityChange,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.coral,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onRemove(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 체크박스
                Checkbox(
                  value: item.isSelected,
                  onChanged: onSelect,
                  activeColor: AppColors.gold,
                ),
                // 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.parchmentDark,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '리워드: ${item.rewardName}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.currency}${item.price.toStringAsFixed(0)}',
                        style: AppTypography.priceSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 하단 컨트롤
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 수량 조절
                _QuantitySelector(
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.parchment,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text('⏰ 펀딩 마감: D-${item.daysLeft}', style: AppTypography.caption),
                  const SizedBox(width: 16),
                  Text('📦 예상 배송: ${item.estimatedDelivery}', style: AppTypography.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onChanged;

  const _QuantitySelector({
    required this.quantity,
    required this.onChanged,
  });

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
            icon: const Icon(Icons.remove, size: 18),
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text('$quantity', style: AppTypography.bodyLarge),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: quantity < 10 ? () => onChanged(quantity + 1) : null,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }
}

// 데이터 모델
class CartItemData {
  final String id;
  final String title;
  final String imageUrl;
  final String portName;
  final String rewardName;
  final double price;
  final String currency;
  int quantity;
  final int daysLeft;
  final String estimatedDelivery;
  bool isSelected;

  CartItemData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.portName,
    required this.rewardName,
    required this.price,
    required this.currency,
    required this.quantity,
    required this.daysLeft,
    required this.estimatedDelivery,
    this.isSelected = false,
  });
}

