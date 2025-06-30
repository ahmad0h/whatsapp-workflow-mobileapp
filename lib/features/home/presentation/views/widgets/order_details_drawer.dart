import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/format_time.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_tracking_widget.dart';

class OrderDetailsDrawer extends StatefulWidget {
  final OrderCardModel order;
  final Function(OrderCardModel)? onOrderUpdated;

  const OrderDetailsDrawer({
    super.key,
    required this.order,
    this.onOrderUpdated,
  });

  @override
  State<OrderDetailsDrawer> createState() => _OrderDetailsDrawerState();
}

class _OrderDetailsDrawerState extends State<OrderDetailsDrawer> {
  bool _isOrderAccepted = false;

  @override
  void initState() {
    super.initState();
    // If order status is 'Preparing', 'In Progress', or 'Arrived', mark as accepted
    _isOrderAccepted =
        widget.order.status == 'Preparing' ||
        widget.order.status == 'In Progress' ||
        widget.order.status == 'Arrived';
  }

  // Colors
  static const _backgroundColor = AppColors.background;
  static const _cardBackgroundColor = AppColors.backgroundDark;
  static const _primaryColor = AppColors.primary;
  static const _successColor = AppColors.success;
  static const _dividerColor = AppColors.borderLight;
  static const _textColor = AppColors.textPrimary;
  static const _secondaryTextColor = AppColors.textSecondary;

  // Get status color based on status string
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.primary;
      case 'in_progress':
        return AppColors.statusPreparing;
      case 'arrived':
        return AppColors.statusArrived;
      case 'completed':
        return AppColors.statusCompleted;
      case 'cancelled':
      case 'rejected':
        return AppColors.statusRejected;
      default:
        return AppColors.textSecondary;
    }
  }

  // Dimensions
  static const _cardHeight = 90.0;
  static const _cardBorderRadius = 3.17;
  static const _sectionSpacing = 25.0;
  static const _elementSpacing = 8.0;
  static const _buttonBorderRadius = 25.0;

  // Text Styles
  static const _titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: _textColor,
  );

  static const _subtitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: _textColor,
  );

  static const _bodyStyle = TextStyle(fontSize: 18, color: _textColor);

  static const _buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: _backgroundColor,
  );

  Future<void> _handleAcceptOrder() async {
    if (!mounted) return;

    final homeBloc = context.read<HomeBloc>();
    final orderId = widget.order.orderData.id ?? '';

    setState(() {
      _isOrderAccepted = true;
      widget.order.status = 'In Progress';
    });

    try {
      // First update the order status
      homeBloc.add(HomeEvent.updateOrderStatus(orderId, 'in_progress'));

      // Wait for the status update to complete
      await homeBloc.stream
          .where((state) => state.updateOrderStatus != ResponseStatus.loading)
          .first;

      if (!mounted) return;

      // Then refresh the orders list to get the latest data including updatedAt
      homeBloc.add(const HomeEvent.getOrdersData());
      await homeBloc.stream
          .where((state) => state.getOrdersListStatus != ResponseStatus.loading)
          .first;

      if (!mounted) return;

      // Find the updated order in the state
      final updatedOrder = homeBloc.state.ordersList?.firstWhere(
        (order) => order.id == orderId,
        orElse: () =>
            widget.order.orderData, // Fallback to current order if not found
      );

      // Update the local order data with the latest from the server
      if (updatedOrder != null) {
        // Create a new OrderCardModel with updated values
        final status = updatedOrder.status ?? 'in_progress';
        final statusText = status
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (s) => s.isNotEmpty
                  ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}'
                  : '',
            )
            .join(' ');

        final updatedCardModel = OrderCardModel(
          orderNumber: updatedOrder.orderNumber ?? widget.order.orderNumber,
          customerName:
              updatedOrder.customer?.fullName ?? widget.order.customerName,
          time: updatedOrder.orderDate != null
              ? formatTime(updatedOrder.orderDate!)
              : widget.order.time,
          status: statusText,
          statusColor: _getStatusColor(status),
          carBrand: updatedOrder.vehicle?.brand ?? widget.order.carBrand,
          carColor: updatedOrder.vehicle?.color?.toLowerCase() ?? 'grey',
          plateNumber:
              updatedOrder.vehicle?.plateNumber ?? widget.order.plateNumber,
          carDetails:
              '${updatedOrder.vehicle?.brand ?? ''} ${updatedOrder.vehicle?.model ?? ''} (${updatedOrder.vehicle?.color ?? 'N/A'})',
          orderData: updatedOrder,
        );

        // Update the widget's order reference
        if (mounted) {
          setState(() {
            _isOrderAccepted = true;
            // Update the order reference to trigger UI refresh
            widget.order.status = updatedCardModel.status;
            // Notify parent widget about the update
            if (widget.onOrderUpdated != null) {
              widget.onOrderUpdated!(updatedCardModel);
            }
          });
          GoRouter.of(context).pop();
        }
      }

      if (!mounted) return;

      // Show success message
      log('Order updated successfully');

      // Notify parent widget to refresh if needed
      if (widget.onOrderUpdated != null) {
        widget.onOrderUpdated!(widget.order);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isOrderAccepted = false;
        widget.order.status = 'Pending';
      });

      log('Failed to update order status: $e');
    }
  }

  // Convert color name to Color object
  Color _getColorFromName(String colorName) {
    // Convert to lowercase for case-insensitive comparison
    final name = colorName.toLowerCase().trim();

    // Map of common color names to their Color values
    final colorMap = {
      'red': Colors.red,
      'green': Colors.green,
      'blue': Colors.blue,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'brown': Colors.brown,
      'grey': Colors.grey,
      'black': Colors.black,
      'white': Colors.white,
      'teal': Colors.teal,
      'cyan': Colors.cyan,
      'indigo': Colors.indigo,
      'amber': Colors.amber,
      'silver': Colors.grey,
    };

    // Try to find the color in the map, default to green if not found
    return colorMap[name] ?? _successColor;
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    bool isCarColor = false,
  }) {
    // Get the car color if this is the car color card
    final borderColor = _getColorFromName(value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: _cardHeight,
      decoration: BoxDecoration(
        color: _cardBackgroundColor,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        border: isCarColor
            ? Border(right: BorderSide(color: borderColor, width: 25))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: _secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: _subtitleStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Container(
        color: _backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderHeader(),
                      const SizedBox(height: 20),
                      _buildOrderInfoGrid(),
                      const SizedBox(height: 25),
                      _buildDivider(),
                      const SizedBox(height: 25),
                      _buildOrderDetailsSection(),
                      const SizedBox(height: _sectionSpacing),
                      _buildTotalAmount(),
                      const SizedBox(height: _sectionSpacing),
                      _buildDivider(),
                      const SizedBox(height: _sectionSpacing),
                      _buildAcceptButton(context),
                      if (_isOrderAccepted) ...[
                        const SizedBox(height: 20),
                        OrderTrackingTimeline(
                          updatedAt:
                              widget.order.orderData.updatedAt ??
                              widget.order.orderData.orderDate ??
                              DateTime.now().toIso8601String(),
                        ),
                      ],
                      if (!_isOrderAccepted) ...[
                        const SizedBox(height: 50),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.textPrimary.withValues(
                                  alpha: 0.1,
                                ),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: SlideAction(
                            text: 'Reject Order',
                            textColor: AppColors.error,
                            sliderButtonIcon: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.error,
                              size: 16,
                            ),
                            elevation: 0,
                            onSubmit: () async {},
                            innerColor: const Color(0xFFFFFFFF),
                            outerColor: const Color.fromARGB(
                              255,
                              236,
                              232,
                              232,
                            ),
                            borderRadius: 28,
                          ),
                        ),
                      ],
                      const SizedBox(
                        height: 24,
                      ), // Add bottom padding for better scrolling
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 54, left: 24),

      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
              child: const Icon(
                Icons.close,
                size: 24,
                color: _textColor,
                weight: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isOrderAccepted)
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            height: 48,

            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: widget.order.status == 'Arrived'
                  ? const Color(0xFF27AE60)
                  : const Color(0xFFEEB128),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.order.status == 'Arrived'
                      ? 'Completed'
                      : 'In Progress',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (widget.order.status != 'Arrived')
                  Image.asset(
                    'assets/icons/spinner.png',
                    width: 24,
                    height: 24,
                  ),
              ],
            ),
          ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              '#${widget.order.orderNumber}',
              style: _bodyStyle.copyWith(
                fontSize: 25.33,
                color: _secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.order.customerName,
          style: _titleStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInfoGrid() {
    return Column(
      children: [
        // First row
        SizedBox(
          height: _cardHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildInfoCard(
                  title: 'Order Time',
                  value: widget.order.time,
                ),
              ),
              const SizedBox(width: _elementSpacing),
              Expanded(
                child: _buildInfoCard(
                  title: 'Plate No.',
                  value: widget.order.plateNumber,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: _elementSpacing),
        // Second row
        SizedBox(
          height: _cardHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildInfoCard(
                  title: 'Car Details',
                  value:
                      '${widget.order.carBrand} - ${widget.order.carDetails}',
                ),
              ),
              const SizedBox(width: _elementSpacing),
              Expanded(
                child: _buildInfoCard(
                  title: 'Car Color',
                  value:
                      widget.order.orderData.vehicle?.color?.isNotEmpty == true
                      ? widget.order.orderData.vehicle!.color!
                      : 'N/A',
                  isCarColor: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetailsSection() {
    final orderDetails = widget.order.orderData.orderDetails ?? [];

    if (orderDetails.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order details', style: _titleStyle),
        const SizedBox(height: _sectionSpacing),
        ...orderDetails.expand<Widget>((detail) {
            final price = double.tryParse(detail.productPrice ?? '0') ?? 0;
            final quantity = detail.productQuantity ?? 0;
            final total = price * quantity;

            return [
              _buildOrderItem(
                detail.productName ?? 'Unknown Item',
                quantity,
                total,
              ),
              const SizedBox(height: _sectionSpacing),
              _buildDivider(),
              const SizedBox(height: _sectionSpacing),
            ];
          }).toList()
          ..removeLast()
          ..removeLast(), // Remove the last divider and SizedBox
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, width: double.infinity, color: _dividerColor);
  }

  Widget _buildTotalAmount() {
    final orderDetails = widget.order.orderData.orderDetails ?? [];
    double totalAmount = 0;

    // Calculate total from order details
    if (orderDetails.isNotEmpty) {
      totalAmount = orderDetails.fold(0, (sum, item) {
        final price = double.tryParse(item.productPrice ?? '0') ?? 0;
        final quantity = item.productQuantity ?? 0;
        return sum + (price * quantity);
      });
    } else {
      // Fallback to net_amount if available
      totalAmount =
          double.tryParse(widget.order.orderData.netAmount ?? '0') ?? 0;
    }

    // Add VAT if available
    final vatAmount =
        double.tryParse(widget.order.orderData.vatAmount ?? '0') ?? 0;
    totalAmount += vatAmount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      decoration: BoxDecoration(
        color: _cardBackgroundColor,
        borderRadius: BorderRadius.circular(_buttonBorderRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontSize: 16, color: _secondaryTextColor),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/riyal.svg',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    (totalAmount - vatAmount).toStringAsFixed(2),
                    style: const TextStyle(fontSize: 16, color: _textColor),
                  ),
                ],
              ),
            ],
          ),
          if (vatAmount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'VAT',
                  style: TextStyle(fontSize: 16, color: _secondaryTextColor),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/riyal.svg',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      vatAmount.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 16, color: _textColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
          const Divider(height: 24, thickness: 1, color: _dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/riyal.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    totalAmount.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    if (_isOrderAccepted ||
        widget.order.status == 'Preparing' ||
        widget.order.status == 'In Progress' ||
        widget.order.status == 'Arrived') {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF2F5F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonBorderRadius),
            ),
            elevation: 0,
          ),
          child: Text(
            'Accepted at ${formatTimeWithoutDate(widget.order.orderData.updatedAt ?? DateTime.now().toIso8601String())}',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleAcceptOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonBorderRadius),
          ),
          elevation: 0,
        ),
        child: const Text('Accept', style: _buttonTextStyle),
      ),
    );
  }

  Widget _buildOrderItem(String itemName, int quantity, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(itemName, style: _bodyStyle)),
        const Spacer(),
        Text(
          '$quantity x',
          style: _bodyStyle.copyWith(color: _secondaryTextColor),
        ),
        const SizedBox(width: 8),
        Text(
          '${price.toStringAsFixed(2)} SAR',
          style: _bodyStyle.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
