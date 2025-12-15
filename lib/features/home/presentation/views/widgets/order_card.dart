import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_workflow_mobileapp/core/api/api_constants.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/get_color_from_string.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';

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

class _OrderCardState extends State<OrderCard>
    with SingleTickerProviderStateMixin {
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
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

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

      homeBloc.add(const HomeEvent.getOrdersData());
      homeBloc.add(const HomeEvent.getOrderStats());

      if (mounted) {
        setState(() {
          widget.model.status = 'orderDetails.finished'.tr();
        });
      }
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

      homeBloc.add(const HomeEvent.getOrdersData());
      homeBloc.add(const HomeEvent.getOrderStats());

      if (mounted) {
        setState(() {
          widget.model.status = 'orderDetails.completed'.tr();
        });
      }
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
          final glowOpacity = _shouldBlink
              ? 0.03 + (_animation.value * 0.2)
              : 0.0;
          final glowSpread = _shouldBlink
              ? 0.01 + (_animation.value * 2.5)
              : 1.0;
          final glowBlur = _shouldBlink ? 1 + (_animation.value * 8.0) : 1.0;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(color: widget.model.statusColor, width: 18),
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
                    color: widget.model.statusColor.withValues(
                      alpha: glowOpacity,
                    ),
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

  // Widget _buildOrderHeader(TabletResponsiveConfig config) {
  //   return Row(
  //     children: [
  //       // Order number and type
  //       // Expanded(
  //       //   child: Wrap(
  //       //     spacing: config.spacing,
  //       //     runSpacing: config.runSpacing,
  //       //     crossAxisAlignment: WrapCrossAlignment.center,
  //       //     children: [
  //       //       // Container(
  //       //       //   padding: EdgeInsets.symmetric(
  //       //       //     horizontal: config.tagPaddingHorizontal,
  //       //       //     vertical: config.tagPaddingVertical,
  //       //       //   ),
  //       //       //   decoration: BoxDecoration(
  //       //       //     color: Colors.grey[100],
  //       //       //     borderRadius: BorderRadius.circular(config.tagBorderRadius),
  //       //       //   ),
  //       //       //   child: Text(
  //       //       //     model.orderType.capitalize(),
  //       //       //     style: TextStyle(
  //       //       //       fontSize: isSmallCard
  //       //       //           ? config.orderTypeFontSize * 0.8
  //       //       //           : config.orderTypeFontSize,
  //       //       //       fontWeight: FontWeight.w500,
  //       //       //     ),
  //       //       //   ),
  //       //       // ),
  //       //     ],
  //       //   ),
  //       // ),

  //       // Status badge

  //     ],
  //   );

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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 4),

              // Time
              Text(
                widget.model.time,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

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
                spacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 8,
                    children: [
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

      // Divider
      // Container(height: 1, width: double.infinity, color: Colors.grey[200]),

      // SizedBox(height: config.sectionSpacing),

      // // Order type specific info
      // if (model.orderType.toLowerCase() == "branch")
      //   ..._buildBranchInfo(config),
      // if (model.orderType.toLowerCase() == "delivery")
      //   ..._buildDeliveryInfo(config),
      // if (model.orderType.toLowerCase() == "curbside")
      //   ..._buildCurbsideInfo(config),
    ];
  }

  // List<Widget> _buildBranchInfo(TabletResponsiveConfig config) {
  //   return [
  //     Container(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: config.curbsideTagPadding,
  //         vertical: config.curbsideTagPadding * 0.1,
  //       ),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[100],
  //         borderRadius: BorderRadius.circular(config.tagBorderRadius),
  //       ),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           SvgPicture.asset(
  //             'assets/icons/branch.svg',
  //             colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
  //             height: 24,
  //           ),
  //           SizedBox(width: config.infoSpacing),
  //           Text(
  //             "order.pickedUp".tr(),
  //             style: TextStyle(
  //               fontSize: config.infoFontSize,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ];
  // }

  // List<Widget> _buildDeliveryInfo(TabletResponsiveConfig config) {
  //   return [
  //     Container(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: config.curbsideTagPadding,
  //         vertical: config.curbsideTagPadding * 0.1,
  //       ),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[100],
  //         borderRadius: BorderRadius.circular(config.tagBorderRadius),
  //       ),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           SvgPicture.asset(
  //             'assets/icons/delivery.svg',
  //             colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
  //             height: 24,
  //           ),
  //           SizedBox(width: config.infoSpacing),
  //           Text(
  //             "Delivery",
  //             style: TextStyle(
  //               fontSize: config.infoFontSize,
  //               fontWeight: FontWeight.bold,
  //               height: 1.3,
  //             ),
  //             maxLines: 3,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ],
  //       ),
  //     ),
  //   ];
  // }

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
                  ? ApiConstants.getCarLogoUrl(
                      widget.model.orderData.vehicle!.image!,
                    )
                  : '',
              width: 25,
              height: fixedHeight,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: Colors.red),
            ),
            SizedBox(width: 8),

            // Plate number
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: (12 * 0.2),
              ),
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
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: (12 * 0.2),
              ),
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
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: Text(
          'orderDetails.orderIsReady'.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: Text(
          'orderDetails.markAsCompleted'.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }

  // TabletResponsiveConfig _getTabletResponsiveConfig({
  //   required bool isLargeTablet,
  //   required bool isMediumTablet,
  //   required bool isSmallTablet,
  //   required bool isPortrait,
  //   required double screenWidth,
  // }) {
  //   if (isLargeTablet) {
  //     return TabletResponsiveConfig.large(isPortrait: isPortrait);
  //   } else if (isMediumTablet) {
  //     return TabletResponsiveConfig.medium(isPortrait: isPortrait);
  //   } else {
  //     return TabletResponsiveConfig.small(isPortrait: isPortrait);
  //   }
  // }
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

          Text(
            translationKey.tr(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
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
    } else if (model.orderType == "delivery" &&
        model.status.toLowerCase() == "arrived") {
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
              color:
                  model.status == "Is Finished" ||
                      model.status.toLowerCase() == "in progress"
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

// class TabletResponsiveConfig {
//   final double orderNumberFontSize;
//   final double timeFontSize;
//   final double statusFontSize;
//   final double orderTypeFontSize;
//   final double customerNameFontSize;
//   final double infoFontSize;
//   final double curbsideFontSize;
//   final double cardPadding;
//   final double borderWidth;
//   final double borderRadius;
//   final double spacing;
//   final double runSpacing;
//   final double sectionSpacing;
//   final double infoSpacing;
//   final double curbsideSpacing;
//   final double tagPaddingHorizontal;
//   final double tagPaddingVertical;
//   final double tagBorderRadius;
//   final double statusPaddingHorizontal;
//   final double statusPaddingVertical;
//   final double statusBorderRadius;
//   final double curbsideTagPadding;
//   final double iconSize;
//   final double infoIconSize;
//   final double colorIndicatorSize;
//   final double iconSpacing;
//   final double shadowSpread;
//   final double shadowBlur;
//   final double shadowOffset;
//   final int carDetailsMaxLength;

//   const TabletResponsiveConfig({
//     required this.orderNumberFontSize,
//     required this.timeFontSize,
//     required this.statusFontSize,
//     required this.orderTypeFontSize,
//     required this.customerNameFontSize,
//     required this.infoFontSize,
//     required this.curbsideFontSize,
//     required this.cardPadding,
//     required this.borderWidth,
//     required this.borderRadius,
//     required this.spacing,
//     required this.runSpacing,
//     required this.sectionSpacing,
//     required this.infoSpacing,
//     required this.curbsideSpacing,
//     required this.tagPaddingHorizontal,
//     required this.tagPaddingVertical,
//     required this.tagBorderRadius,
//     required this.statusPaddingHorizontal,
//     required this.statusPaddingVertical,
//     required this.statusBorderRadius,
//     required this.curbsideTagPadding,
//     required this.iconSize,
//     required this.infoIconSize,
//     required this.colorIndicatorSize,
//     required this.iconSpacing,
//     required this.shadowSpread,
//     required this.shadowBlur,
//     required this.shadowOffset,
//     required this.carDetailsMaxLength,
//   });

//   // Large tablets (iPad Pro, Galaxy Tab S8+)
//   factory TabletResponsiveConfig.large({required bool isPortrait}) {
//     return TabletResponsiveConfig(
//       orderNumberFontSize: isPortrait ? 32.0 : 28.0,
//       timeFontSize: isPortrait ? 14.0 : 13.0,
//       statusFontSize: isPortrait ? 15.0 : 14.0,
//       orderTypeFontSize: isPortrait ? 14.0 : 13.0,
//       customerNameFontSize: isPortrait ? 22.0 : 20.0,
//       infoFontSize: isPortrait ? 18.0 : 20.0,
//       curbsideFontSize: isPortrait ? 18.0 : 20.0,
//       cardPadding: isPortrait ? 24.0 : 20.0,
//       borderWidth: isPortrait ? 16.0 : 14.0,
//       borderRadius: 16.0,
//       spacing: isPortrait ? 14.0 : 12.0,
//       runSpacing: 6.0,
//       sectionSpacing: isPortrait ? 18.0 : 16.0,
//       infoSpacing: isPortrait ? 8.0 : 6.0,
//       curbsideSpacing: 10.0,
//       tagPaddingHorizontal: isPortrait ? 14.0 : 12.0,
//       tagPaddingVertical: isPortrait ? 8.0 : 6.0,
//       tagBorderRadius: 8.0,
//       statusPaddingHorizontal: isPortrait ? 12.0 : 10.0,
//       statusPaddingVertical: isPortrait ? 6.0 : 4.0,
//       statusBorderRadius: 24.0,
//       curbsideTagPadding: 10.0,
//       iconSize: isPortrait ? 18.0 : 16.0,
//       infoIconSize: isPortrait ? 28.0 : 26.0,
//       colorIndicatorSize: isPortrait ? 28.0 : 26.0,
//       iconSpacing: isPortrait ? 12.0 : 10.0,
//       shadowSpread: 2.0,
//       shadowBlur: 4.0,
//       shadowOffset: 2.0,
//       carDetailsMaxLength: isPortrait ? 12 : 10,
//     );
//   }

//   // Medium tablets (Standard iPad, Galaxy Tab A)
//   factory TabletResponsiveConfig.medium({required bool isPortrait}) {
//     return TabletResponsiveConfig(
//       orderNumberFontSize: isPortrait ? 28.0 : 26.0,
//       timeFontSize: isPortrait ? 13.0 : 12.0,
//       statusFontSize: isPortrait ? 14.0 : 13.0,
//       orderTypeFontSize: isPortrait ? 13.0 : 12.0,
//       customerNameFontSize: isPortrait ? 20.0 : 18.0,
//       infoFontSize: isPortrait ? 13.0 : 12.0,
//       curbsideFontSize: isPortrait ? 12.0 : 11.0,
//       cardPadding: isPortrait ? 20.0 : 18.0,
//       borderWidth: isPortrait ? 14.0 : 12.0,
//       borderRadius: 14.0,
//       spacing: isPortrait ? 12.0 : 10.0,
//       runSpacing: 5.0,
//       sectionSpacing: isPortrait ? 16.0 : 14.0,
//       infoSpacing: isPortrait ? 8.0 : 6.0,
//       curbsideSpacing: 8.0,
//       tagPaddingHorizontal: isPortrait ? 12.0 : 10.0,
//       tagPaddingVertical: isPortrait ? 6.0 : 5.0,
//       tagBorderRadius: 7.0,
//       statusPaddingHorizontal: isPortrait ? 14.0 : 12.0,
//       statusPaddingVertical: isPortrait ? 6.0 : 5.0,
//       statusBorderRadius: 22.0,
//       curbsideTagPadding: 9.0,
//       iconSize: isPortrait ? 16.0 : 15.0,
//       infoIconSize: isPortrait ? 26.0 : 24.0,
//       colorIndicatorSize: isPortrait ? 26.0 : 24.0,
//       iconSpacing: isPortrait ? 10.0 : 9.0,
//       shadowSpread: 1.5,
//       shadowBlur: 3.0,
//       shadowOffset: 1.5,
//       carDetailsMaxLength: isPortrait ? 10 : 8,
//     );
//   }

//   // Small tablets (iPad mini, small Android tablets)
//   factory TabletResponsiveConfig.small({required bool isPortrait}) {
//     return TabletResponsiveConfig(
//       orderNumberFontSize: isPortrait ? 26.0 : 24.0,
//       timeFontSize: isPortrait ? 12.0 : 11.0,
//       statusFontSize: isPortrait ? 13.0 : 12.0,
//       orderTypeFontSize: isPortrait ? 12.0 : 11.0,
//       customerNameFontSize: isPortrait ? 18.0 : 16.0,
//       infoFontSize: isPortrait ? 12.0 : 11.0,
//       curbsideFontSize: isPortrait ? 11.0 : 10.0,
//       cardPadding: isPortrait ? 18.0 : 16.0,
//       borderWidth: isPortrait ? 12.0 : 10.0,
//       borderRadius: 12.0,
//       spacing: isPortrait ? 10.0 : 8.0,
//       runSpacing: 4.0,
//       sectionSpacing: isPortrait ? 14.0 : 12.0,
//       infoSpacing: isPortrait ? 8.0 : 6.0,
//       curbsideSpacing: 6.0,
//       tagPaddingHorizontal: isPortrait ? 10.0 : 8.0,
//       tagPaddingVertical: isPortrait ? 5.0 : 4.0,
//       tagBorderRadius: 6.0,
//       statusPaddingHorizontal: isPortrait ? 10.0 : 8.0,
//       statusPaddingVertical: isPortrait ? 5.0 : 4.0,
//       statusBorderRadius: 20.0,
//       curbsideTagPadding: 8.0,
//       iconSize: isPortrait ? 15.0 : 14.0,
//       infoIconSize: isPortrait ? 24.0 : 22.0,
//       colorIndicatorSize: isPortrait ? 24.0 : 22.0,
//       iconSpacing: isPortrait ? 8.0 : 7.0,
//       shadowSpread: 1.0,
//       shadowBlur: 2.0,
//       shadowOffset: 1.0,
//       carDetailsMaxLength: isPortrait ? 8 : 6,
//     );
//   }
// }
