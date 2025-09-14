import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/get_color_from_string.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';

class OrderCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive font sizes and spacing
    final orderNumberFontSize = screenWidth > 1200 ? 28.0 : 25.33;
    final timeFontSize = screenWidth > 1200 ? 12.0 : 11.08;
    final statusFontSize = screenWidth > 1200 ? 13.0 : 12.0;
    final orderTypeFontSize = screenWidth > 1200 ? 13.0 : 12.0;
    final cardPadding = screenWidth > 1200 ? 20.0 : 16.0;
    final borderWidth = screenWidth > 1200 ? 14.0 : 12.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isSmallCard ? cardPadding * 0.8 : cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.66),
          border: Border(
            left: BorderSide(
              color: model.statusColor,
              width: isSmallCard ? borderWidth * 0.8 : borderWidth,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order number and status row
              Row(
                children: [
                  // Order number and type
                  Expanded(
                    child: Wrap(
                      spacing: screenWidth > 1200 ? 10 : 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "#${model.orderNumber}",
                          style: TextStyle(
                            fontSize: isSmallCard ? 20 : orderNumberFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth > 1200 ? 10 : 8,
                            vertical: screenWidth > 1200 ? 5 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            model.orderType.capitalize(),
                            style: TextStyle(
                              fontSize: isSmallCard ? 10 : orderTypeFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 1200 ? 12 : 10,
                      vertical: screenWidth > 1200 ? 5 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: model.statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: screenWidth > 1200 ? 10 : 8),
                        Text(
                          _getStatusText(model),
                          style: TextStyle(
                            color: model.statusColor,
                            fontSize: isSmallCard ? 10 : statusFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (model.status == "Preparing")
                          Icon(
                            Icons.wb_sunny_outlined,
                            size: screenWidth > 1200 ? 16 : 14,
                            color: model.statusColor,
                          )
                        else if (model.status.toLowerCase() == "arrived")
                          Icon(
                            Icons.check_circle_outline,
                            size: screenWidth > 1200 ? 16 : 14,
                            color: model.statusColor,
                          ),
                        SizedBox(width: screenWidth > 1200 ? 10 : 8),
                      ],
                    ),
                  ),
                ],
              ),

              if (showFullDetails)
                ..._buildFullDetails(
                  context,
                  model,
                  timeFontSize,
                  orderTypeFontSize,
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFullDetails(
    BuildContext context,
    OrderCardModel model,
    double timeFontSize,
    double orderTypeFontSize,
  ) {
    return [
      SizedBox(height: 4),
      // Time
      Text(
        model.time,
        style: TextStyle(
          fontSize: timeFontSize,
          fontWeight: FontWeight.w500,
          height: 1.2,
          color: Colors.grey[800],
        ),
      ),
      SizedBox(height: 4),
      // Customer name
      Text(
        model.customerName,
        style: TextStyle(
          fontSize: isSmallCard ? 18 : 20,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: 16),
      // Divider
      Container(height: 1, width: double.infinity, color: Colors.grey[200]),
      SizedBox(height: 16),
      // Order type specific info
      if (model.orderType.toLowerCase() == "branch")
        ..._buildBranchInfo(orderTypeFontSize),
      if (model.orderType.toLowerCase() == "delivery")
        ..._buildDeliveryInfo(model, orderTypeFontSize),
      if (model.orderType.toLowerCase() == "curbside")
        ..._buildCurbsideInfo(model, orderTypeFontSize),
    ];
  }

  List<Widget> _buildBranchInfo(double fontSize) {
    return [
      Row(
        children: [
          SvgPicture.asset(
            'assets/icons/CheckCircle.svg',
            colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
            height: 24,
          ),
          SizedBox(width: 12),
          Text(
            "Picked from this branch",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildDeliveryInfo(OrderCardModel model, double fontSize) {
    return [
      Row(
        children: [
          SvgPicture.asset(
            'assets/icons/MapPinArea.svg',
            colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
            height: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              model.orderData.customerAddress ?? 'No address provided',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildCurbsideInfo(OrderCardModel model, double fontSize) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 6,
        children: [
          Image.asset('assets/icons/car-logo.png', height: 24),

          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              textAlign: TextAlign.center,
              model.plateNumber,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              textAlign: TextAlign.center,
              model.carDetails.split('(')[0].length > 8
                  ? '${model.carDetails.split('(')[0].substring(0, 8)}...'
                  : model.carDetails.split('(')[0],
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            height: 23,
            width: 23,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: getColorFromString(model.carColor),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    ];
  }

  String _getStatusText(OrderCardModel model) {
    if (model.status == "Is Finished") {
      return "Finished";
    } else if (model.orderType == "Delivery" &&
        model.status.toLowerCase() == "arrived") {
      return "Delivered";
    }
    return model.status;
  }
}
