import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_workflow_mobileapp/core/api/api_constants.dart';
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
    // final screenWidth = MediaQuery.of(context).size.width;
    // final _ = MediaQuery.of(context).size.height;
    // final orientation = MediaQuery.of(context).orientation;

    // // Tablet-specific breakpoints and responsive values
    // final isLargeTablet = screenWidth >= 1024; // iPad Pro and similar
    // final isMediumTablet =
    //     screenWidth >= 768 && screenWidth < 1024; // Standard iPad
    // final isSmallTablet =
    //     screenWidth >= 600 && screenWidth < 768; // Small tablets
    // final isPortrait = orientation == Orientation.portrait;

    // Responsive sizing for tablets
    // final responsiveConfig = _getTabletResponsiveConfig(
    //   isLargeTablet: isLargeTablet,
    //   isMediumTablet: isMediumTablet,
    //   isSmallTablet: isSmallTablet,
    //   isPortrait: isPortrait,
    //   screenWidth: screenWidth,
    // );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: model.statusColor, width: 18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order number and status row
            if (showFullDetails) ..._buildFullDetails(context),
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
  // }

  Container statusBadge() {
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
            _getStatusText(model),
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
            // Icon(
            //   Icons.check_circle_outline,
            //   size: config.iconSize,
            //   color: model.statusColor,
            // ),
            SizedBox(width: 4),
        ],
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
                "#${model.orderNumber}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 4),

              // Time
              Text(
                model.time,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

              SizedBox(height: 4),

              // Customer name
              Text(
                model.customerName.length > 15
                    ? "${model.customerName.substring(0, 15)}..."
                    : model.customerName,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 8,
                children: [
                  OrderTypeBadge(model: model),
                  statusBadge(),
                ],
              ),
              if (model.orderType.toLowerCase() == "curbside") ...[
                SizedBox(height: 10),
                ...buildCurbsideInfo(),
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
  //             "Picked Up",
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
              imageUrl: model.orderData.vehicle?.image != null
                  ? ApiConstants.getCarLogoUrl(model.orderData.vehicle!.image!)
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
                  model.plateNumber,
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
                  _getCarDetailsText(model.carDetails.split('(')[0]),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),

            SizedBox(width: 8),

            // Color indicator
            Container(
              width: 25,
              decoration: BoxDecoration(
                color: getColorFromString(model.carColor),
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

  String _getStatusText(OrderCardModel model) {
    if (model.status == "Is Finished") {
      return "Ready";
    } else if (model.orderType == "delivery" &&
        model.status.toLowerCase() == "arrived") {
      return "Delivered";
    }
    return model.status;
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(141.18),
        border: Border.all(
          color: model.orderType.toLowerCase() == "branch"
              ? const Color(0xFFF2994A)
              : model.orderType.toLowerCase() == "delivery"
              ? const Color(0xFFC5FF00)
              : model.orderType.toLowerCase() == "curbside"
              ? const Color(0xFFBDD6FF)
              : model.statusColor,
          width: 1.41,
        ),
      ),
      child: Row(
        spacing: 4,
        children: [
          SvgPicture.asset("assets/icons/${model.orderType.toLowerCase()}.svg"),
          Text(
            model.orderType.toLowerCase().capitalize(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
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
