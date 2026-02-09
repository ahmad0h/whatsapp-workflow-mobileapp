import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_workflow_mobileapp/core/api/api_constants.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/get_color_from_string.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';

class OrderCard extends StatefulWidget {
  final OrderCardModel model;
  final bool isSmallCard;
  final VoidCallback? onTap;
  final bool showFullDetails;

  const OrderCard({
    super.key,
    required this.model,
    this.isSmallCard = false,
    this.onTap,
    this.showFullDetails = true,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool get _isNewOrder => widget.model.status.toLowerCase() == 'new order';
  bool get _isArrived => widget.model.status.toLowerCase() == 'arrived';
  bool get _shouldBlink => _isNewOrder || _isArrived;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    if (_shouldBlink) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(OrderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update animation when status changes
    if (_shouldBlink && !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    } else if (!_shouldBlink && _animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleFinishOrder() async {
    if (!mounted) return;

    final homeBloc = context.read<HomeBloc>();
    final orderId = widget.model.orderData.id ?? '';

    try {
      homeBloc.add(HomeEvent.updateOrderStatus(orderId, 'is_finished'));

      await homeBloc.stream
          .where((state) => state.updateOrderStatus != ResponseStatus.loading)
          .first;

      if (!mounted) return;

      // Refresh orders to get the updated data from server
      homeBloc.add(const HomeEvent.getOrdersData());
      homeBloc.add(const HomeEvent.getOrderStats());
    } catch (e) {
      log('Failed to finish order: $e');
    }
  }

  Future<void> _handleCompleteOrder() async {
    if (!mounted) return;

    final homeBloc = context.read<HomeBloc>();
    final orderId = widget.model.orderData.id ?? '';

    try {
      homeBloc.add(HomeEvent.updateOrderStatus(orderId, 'completed'));

      await homeBloc.stream
          .where((state) => state.updateOrderStatus != ResponseStatus.loading)
          .first;

      if (!mounted) return;

      // Refresh orders to get the updated data from server
      homeBloc.add(const HomeEvent.getOrdersData());
      homeBloc.add(const HomeEvent.getOrderStats());
    } catch (e) {
      log('Failed to complete order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Calculate the glow effect intensity for new/arrived orders
          final glowOpacity = _shouldBlink ? 0.1 + (_animation.value * 0.2) : 0.0;
          final glowSpread = _shouldBlink ? 0.1 + (_animation.value * 1) : 1.0;
          final glowBlur = _shouldBlink ? 1 + (_animation.value * 8.0) : 1.0;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: BorderDirectional(
                start: BorderSide(color: widget.model.statusColor, width: 18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
                // Blinking glow effect for new/arrived orders
                if (_shouldBlink)
                  BoxShadow(
                    color: widget.model.statusColor.withValues(alpha: glowOpacity),
                    spreadRadius: glowSpread,
                    blurRadius: glowBlur,
                    offset: Offset.zero,
                  ),
              ],
            ),
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order number and status row
            if (widget.showFullDetails) ..._buildFullDetails(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFullDetails(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                "#${widget.model.orderNumber}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.2),
              ),
              SizedBox(height: 4),

              // Time
              Text(widget.model.time, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),

              SizedBox(height: 4),

              // Customer name
              Text(
                widget.model.customerName.length > 15
                    ? "${widget.model.customerName.substring(0, 15)}..."
                    : widget.model.customerName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 12),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 8,
                    children: [
                      SchedulingBadge(model: widget.model),
                      OrderTypeBadge(model: widget.model),
                      StatusBadge(model: widget.model),
                    ],
                  ),
                  if (widget.model.orderType.toLowerCase() != "curbside")
                    SizedBox(width: 200, child: _buildActionButtons()),
                ],
              ),
              if (widget.model.orderType.toLowerCase() == "curbside") ...[
                SizedBox(height: 5),
                ...buildCurbsideInfo(),
                SizedBox(height: 5),
                SizedBox(width: 200, child: _buildActionButtons()),
              ],
            ],
          ),
        ],
      ),
    ];
  }

  List<Widget> buildCurbsideInfo() {
    const double fixedHeight = 30.0;

    return [
      SizedBox(
        height: fixedHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImage(
              imageUrl: widget.model.orderData.vehicle?.image != null
                  ? ApiConstants.getCarLogoUrl(widget.model.orderData.vehicle!.image!)
                  : '',
              width: 25,
              height: fixedHeight,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
            ),
            SizedBox(width: 8),

            // Plate number
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: (12 * 0.2)),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  widget.model.plateNumber,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),

            SizedBox(width: 8),

            // Car details
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: (12 * 0.2)),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _getCarDetailsText(widget.model.carDetails.split('(')[0]),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),

            SizedBox(width: 8),

            // Color indicator
            Container(
              width: 25,
              decoration: BoxDecoration(
                color: getColorFromString(widget.model.carColor),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  String _getCarDetailsText(String carDetails) {
    final maxLength = 12;
    final cleanText = carDetails.split('(')[0].trim();

    if (cleanText.length > maxLength) {
      return '${cleanText.substring(0, maxLength)}...';
    }
    return cleanText;
  }

  Widget _buildActionButtons() {
    final status = widget.model.status.toLowerCase();

    // "Order Is Ready" button for In Progress status
    if (status == 'in progress' || status == 'in_progress') {
      return ElevatedButton(
        onPressed: _handleFinishOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.statusPreparing,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0,
        ),
        child: Text(
          'orderDetails.orderIsReady'.tr(),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    }

    // "Complete Order" button for Arrived or Delivered status
    // EXCLUDING "is finished" / "ready" status based on user feedback
    if (status == 'arrived' || status == 'delivered') {
      return ElevatedButton(
        onPressed: _handleCompleteOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.statusCompleted,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0,
        ),
        child: Text(
          'orderDetails.markAsCompleted'.tr(),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    }

    return SizedBox.shrink();
  }
}

class OrderTypeBadge extends StatelessWidget {
  const OrderTypeBadge({super.key, required this.model, this.color});

  final OrderCardModel model;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final orderType = model.orderType.toLowerCase();

    // Map order types to their translation keys based on existing translations
    final orderTypeMap = {
      'branch': 'order.branch',
      'delivery': 'order.delivery',
      'curbside': 'order.curbside',
    };

    // Get the translation key, default to the original type if not found
    final translationKey = orderTypeMap[orderType] ?? orderType;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(141.18),
        border: Border.all(
          color: orderType == "branch"
              ? const Color(0xFFF2994A)
              : orderType == "delivery"
              ? const Color(0xFFC5FF00)
              : orderType == "curbside"
              ? const Color(0xFFBDD6FF)
              : model.statusColor,
          width: 1.41,
        ),
      ),
      child: Row(
        spacing: 4,
        children: [
          SvgPicture.asset("assets/icons/$orderType.svg"),
          Text(translationKey.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

/// Standalone status badge widget that can be used in OrderCard and OrderDetailsDrawer
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.model});

  final OrderCardModel model;

  String _getStatusText() {
    if (model.status == "Is Finished") {
      return "order.ready".tr();
    } else if (model.orderType == "delivery" && model.status.toLowerCase() == "arrived") {
      return "order.delivered".tr();
    } else if (model.status.toLowerCase() == "in progress") {
      return "order.inProgress".tr();
    } else if (model.status.toLowerCase() == "arrived") {
      return "order.arrived".tr();
    } else if (model.status.toLowerCase() == "new order") {
      return "order.newOrder".tr();
    }
    return model.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: model.status.toLowerCase() == "new order"
            ? const Color(0xFFEFF4FF)
            : model.status.toLowerCase() == "in progress"
            ? model.statusColor.withValues(alpha: 0.1)
            : model.status.toLowerCase() == "is finished"
            ? model.statusColor.withValues(alpha: 0.1)
            : model.status.toLowerCase() == "arrived"
            ? model.statusColor.withValues(alpha: 0.05)
            : model.status.toLowerCase() == "completed"
            ? model.statusColor.withValues(alpha: 0.05)
            : model.statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(141.18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 4),
          Text(
            _getStatusText(),
            style: TextStyle(
              color: model.status == "Is Finished" || model.status.toLowerCase() == "in progress"
                  ? const Color(0xFFEEB128)
                  : model.statusColor.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (model.status == "Preparing")
            Icon(Icons.wb_sunny_outlined, size: 15, color: model.statusColor)
          else if (model.status.toLowerCase() == "arrived")
            SizedBox(width: 4),
        ],
      ),
    );
  }
}

class SchedulingBadge extends StatelessWidget {
  const SchedulingBadge({super.key, required this.model});

  final OrderCardModel model;

  @override
  Widget build(BuildContext context) {
    // Check if order has scheduled date or time
    final isScheduled =
        model.orderData.scheduledDate != null || model.orderData.scheduledTime != null;

    final type = isScheduled ? 'Scheduled' : 'Instant';
    final color = isScheduled ? const Color(0xFFF2C94C) : const Color(0xFF2D9CDB); // Purple vs Blue

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        // color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(141.18),
        border: Border.all(color: color, width: 1.41),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            isScheduled ? Icons.calendar_today_outlined : Icons.flash_on_rounded,
            size: 24,
            color: color,
          ),
          if (isScheduled) SizedBox(width: 4),
          Text(
            type,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
