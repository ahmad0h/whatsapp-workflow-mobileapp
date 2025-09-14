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
    final _ = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    // Tablet-specific breakpoints and responsive values
    final isLargeTablet = screenWidth >= 1024; // iPad Pro and similar
    final isMediumTablet =
        screenWidth >= 768 && screenWidth < 1024; // Standard iPad
    final isSmallTablet =
        screenWidth >= 600 && screenWidth < 768; // Small tablets
    final isPortrait = orientation == Orientation.portrait;

    // Responsive sizing for tablets
    final responsiveConfig = _getTabletResponsiveConfig(
      isLargeTablet: isLargeTablet,
      isMediumTablet: isMediumTablet,
      isSmallTablet: isSmallTablet,
      isPortrait: isPortrait,
      screenWidth: screenWidth,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          isSmallCard
              ? responsiveConfig.cardPadding * 0.8
              : responsiveConfig.cardPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsiveConfig.borderRadius),
          border: Border(
            left: BorderSide(
              color: model.statusColor,
              width: isSmallCard
                  ? responsiveConfig.borderWidth * 0.8
                  : responsiveConfig.borderWidth,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: responsiveConfig.shadowSpread,
              blurRadius: responsiveConfig.shadowBlur,
              offset: Offset(0, responsiveConfig.shadowOffset),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order number and status row
              _buildOrderHeader(responsiveConfig),

              if (showFullDetails)
                ..._buildFullDetails(context, responsiveConfig),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader(TabletResponsiveConfig config) {
    return Row(
      children: [
        // Order number and type
        Expanded(
          child: Wrap(
            spacing: config.spacing,
            runSpacing: config.runSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "#${model.orderNumber}",
                style: TextStyle(
                  fontSize: isSmallCard
                      ? config.orderNumberFontSize * 0.8
                      : config.orderNumberFontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: config.tagPaddingHorizontal,
              //     vertical: config.tagPaddingVertical,
              //   ),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[100],
              //     borderRadius: BorderRadius.circular(config.tagBorderRadius),
              //   ),
              //   child: Text(
              //     model.orderType.capitalize(),
              //     style: TextStyle(
              //       fontSize: isSmallCard
              //           ? config.orderTypeFontSize * 0.8
              //           : config.orderTypeFontSize,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),

        // Status badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: config.statusPaddingHorizontal,
            vertical: config.statusPaddingVertical,
          ),
          decoration: BoxDecoration(
            color: model.statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(config.statusBorderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: config.iconSpacing),
              Text(
                _getStatusText(model),
                style: TextStyle(
                  color: model.statusColor,
                  fontSize: isSmallCard
                      ? config.statusFontSize * 0.8
                      : config.statusFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (model.status == "Preparing")
                Icon(
                  Icons.wb_sunny_outlined,
                  size: config.iconSize,
                  color: model.statusColor,
                )
              else if (model.status.toLowerCase() == "arrived")
                Icon(
                  Icons.check_circle_outline,
                  size: config.iconSize,
                  color: model.statusColor,
                ),
              SizedBox(width: config.iconSpacing),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFullDetails(
    BuildContext context,
    TabletResponsiveConfig config,
  ) {
    return [
      SizedBox(height: config.sectionSpacing * 0.5),

      // Time
      Text(
        model.time,
        style: TextStyle(
          fontSize: config.timeFontSize,
          fontWeight: FontWeight.w500,
          height: 1.3,
          color: Colors.grey[700],
        ),
      ),

      SizedBox(height: config.sectionSpacing * 0.5),

      // Customer name
      Text(
        model.customerName,
        style: TextStyle(
          fontSize: config.customerNameFontSize,
          fontWeight: FontWeight.w400,
          height: 1.2,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      SizedBox(height: config.sectionSpacing),

      // Divider
      Container(height: 1, width: double.infinity, color: Colors.grey[200]),

      SizedBox(height: config.sectionSpacing),

      // Order type specific info
      if (model.orderType.toLowerCase() == "branch")
        ..._buildBranchInfo(config),
      if (model.orderType.toLowerCase() == "delivery")
        ..._buildDeliveryInfo(config),
      if (model.orderType.toLowerCase() == "curbside")
        ..._buildCurbsideInfo(config),
    ];
  }

  List<Widget> _buildBranchInfo(TabletResponsiveConfig config) {
    return [
      Row(
        children: [
          SvgPicture.asset(
            'assets/icons/CheckCircle.svg',
            colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
            height: config.infoIconSize,
          ),
          SizedBox(width: config.infoSpacing),
          Expanded(
            child: Text(
              "Picked from this branch",
              style: TextStyle(
                fontSize: config.infoFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildDeliveryInfo(TabletResponsiveConfig config) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/MapPinArea.svg',
            colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
            height: config.infoIconSize,
          ),
          SizedBox(width: config.infoSpacing),
          Expanded(
            child: Text(
              model.orderData.customerAddress ?? 'No address provided',
              style: TextStyle(
                fontSize: config.infoFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildCurbsideInfo(TabletResponsiveConfig config) {
    return [
      Row(
        children: [
          Image.asset('assets/icons/car-logo.png', height: config.infoIconSize),
          SizedBox(width: config.infoSpacing),

          // Plate number
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: config.curbsideTagPadding,
              vertical: config.curbsideTagPadding * 0.7,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(config.tagBorderRadius),
            ),
            child: Text(
              model.plateNumber.split(' ')[0].length > 8
                  ? '${model.plateNumber.split(' ')[0].substring(0, 8)}...'
                  : model.plateNumber.split(' ')[0],
              style: TextStyle(
                fontSize: config.curbsideFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),

          SizedBox(width: config.curbsideSpacing),

          // Car details
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: config.curbsideTagPadding,
              vertical: config.curbsideTagPadding * 0.7,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(config.tagBorderRadius),
            ),
            child: Text(
              _getCarDetailsText(
                model.carDetails.split('(')[0].length > 8
                    ? '${model.carDetails.split('(')[0].substring(0, 8)}...'
                    : model.carDetails.split('(')[0],
                config,
              ),
              style: TextStyle(
                fontSize: config.curbsideFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),

          SizedBox(width: config.curbsideSpacing),

          // Color indicator
          Container(
            height: config.colorIndicatorSize,
            width: config.colorIndicatorSize,
            decoration: BoxDecoration(
              color: getColorFromString(model.carColor),
              borderRadius: BorderRadius.circular(config.tagBorderRadius),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
          ),
        ],
      ),
    ];
  }

  String _getCarDetailsText(String carDetails, TabletResponsiveConfig config) {
    final maxLength = config.carDetailsMaxLength;
    final cleanText = carDetails.split('(')[0].trim();

    if (cleanText.length > maxLength) {
      return '${cleanText.substring(0, maxLength)}...';
    }
    return cleanText;
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

  TabletResponsiveConfig _getTabletResponsiveConfig({
    required bool isLargeTablet,
    required bool isMediumTablet,
    required bool isSmallTablet,
    required bool isPortrait,
    required double screenWidth,
  }) {
    if (isLargeTablet) {
      return TabletResponsiveConfig.large(isPortrait: isPortrait);
    } else if (isMediumTablet) {
      return TabletResponsiveConfig.medium(isPortrait: isPortrait);
    } else {
      return TabletResponsiveConfig.small(isPortrait: isPortrait);
    }
  }
}

class TabletResponsiveConfig {
  final double orderNumberFontSize;
  final double timeFontSize;
  final double statusFontSize;
  final double orderTypeFontSize;
  final double customerNameFontSize;
  final double infoFontSize;
  final double curbsideFontSize;
  final double cardPadding;
  final double borderWidth;
  final double borderRadius;
  final double spacing;
  final double runSpacing;
  final double sectionSpacing;
  final double infoSpacing;
  final double curbsideSpacing;
  final double tagPaddingHorizontal;
  final double tagPaddingVertical;
  final double tagBorderRadius;
  final double statusPaddingHorizontal;
  final double statusPaddingVertical;
  final double statusBorderRadius;
  final double curbsideTagPadding;
  final double iconSize;
  final double infoIconSize;
  final double colorIndicatorSize;
  final double iconSpacing;
  final double shadowSpread;
  final double shadowBlur;
  final double shadowOffset;
  final int carDetailsMaxLength;

  const TabletResponsiveConfig({
    required this.orderNumberFontSize,
    required this.timeFontSize,
    required this.statusFontSize,
    required this.orderTypeFontSize,
    required this.customerNameFontSize,
    required this.infoFontSize,
    required this.curbsideFontSize,
    required this.cardPadding,
    required this.borderWidth,
    required this.borderRadius,
    required this.spacing,
    required this.runSpacing,
    required this.sectionSpacing,
    required this.infoSpacing,
    required this.curbsideSpacing,
    required this.tagPaddingHorizontal,
    required this.tagPaddingVertical,
    required this.tagBorderRadius,
    required this.statusPaddingHorizontal,
    required this.statusPaddingVertical,
    required this.statusBorderRadius,
    required this.curbsideTagPadding,
    required this.iconSize,
    required this.infoIconSize,
    required this.colorIndicatorSize,
    required this.iconSpacing,
    required this.shadowSpread,
    required this.shadowBlur,
    required this.shadowOffset,
    required this.carDetailsMaxLength,
  });

  // Large tablets (iPad Pro, Galaxy Tab S8+)
  factory TabletResponsiveConfig.large({required bool isPortrait}) {
    return TabletResponsiveConfig(
      orderNumberFontSize: isPortrait ? 32.0 : 28.0,
      timeFontSize: isPortrait ? 14.0 : 13.0,
      statusFontSize: isPortrait ? 15.0 : 14.0,
      orderTypeFontSize: isPortrait ? 14.0 : 13.0,
      customerNameFontSize: isPortrait ? 22.0 : 20.0,
      infoFontSize: isPortrait ? 14.0 : 13.0,
      curbsideFontSize: isPortrait ? 13.0 : 12.0,
      cardPadding: isPortrait ? 24.0 : 20.0,
      borderWidth: isPortrait ? 16.0 : 14.0,
      borderRadius: 16.0,
      spacing: isPortrait ? 14.0 : 12.0,
      runSpacing: 6.0,
      sectionSpacing: isPortrait ? 18.0 : 16.0,
      infoSpacing: isPortrait ? 8.0 : 6.0,
      curbsideSpacing: 10.0,
      tagPaddingHorizontal: isPortrait ? 14.0 : 12.0,
      tagPaddingVertical: isPortrait ? 8.0 : 6.0,
      tagBorderRadius: 8.0,
      statusPaddingHorizontal: isPortrait ? 12.0 : 10.0,
      statusPaddingVertical: isPortrait ? 6.0 : 4.0,
      statusBorderRadius: 24.0,
      curbsideTagPadding: 10.0,
      iconSize: isPortrait ? 18.0 : 16.0,
      infoIconSize: isPortrait ? 28.0 : 26.0,
      colorIndicatorSize: isPortrait ? 28.0 : 26.0,
      iconSpacing: isPortrait ? 12.0 : 10.0,
      shadowSpread: 2.0,
      shadowBlur: 4.0,
      shadowOffset: 2.0,
      carDetailsMaxLength: isPortrait ? 12 : 10,
    );
  }

  // Medium tablets (Standard iPad, Galaxy Tab A)
  factory TabletResponsiveConfig.medium({required bool isPortrait}) {
    return TabletResponsiveConfig(
      orderNumberFontSize: isPortrait ? 28.0 : 26.0,
      timeFontSize: isPortrait ? 13.0 : 12.0,
      statusFontSize: isPortrait ? 14.0 : 13.0,
      orderTypeFontSize: isPortrait ? 13.0 : 12.0,
      customerNameFontSize: isPortrait ? 20.0 : 18.0,
      infoFontSize: isPortrait ? 13.0 : 12.0,
      curbsideFontSize: isPortrait ? 12.0 : 11.0,
      cardPadding: isPortrait ? 20.0 : 18.0,
      borderWidth: isPortrait ? 14.0 : 12.0,
      borderRadius: 14.0,
      spacing: isPortrait ? 12.0 : 10.0,
      runSpacing: 5.0,
      sectionSpacing: isPortrait ? 16.0 : 14.0,
      infoSpacing: isPortrait ? 8.0 : 6.0,
      curbsideSpacing: 8.0,
      tagPaddingHorizontal: isPortrait ? 12.0 : 10.0,
      tagPaddingVertical: isPortrait ? 6.0 : 5.0,
      tagBorderRadius: 7.0,
      statusPaddingHorizontal: isPortrait ? 14.0 : 12.0,
      statusPaddingVertical: isPortrait ? 6.0 : 5.0,
      statusBorderRadius: 22.0,
      curbsideTagPadding: 9.0,
      iconSize: isPortrait ? 16.0 : 15.0,
      infoIconSize: isPortrait ? 26.0 : 24.0,
      colorIndicatorSize: isPortrait ? 26.0 : 24.0,
      iconSpacing: isPortrait ? 10.0 : 9.0,
      shadowSpread: 1.5,
      shadowBlur: 3.0,
      shadowOffset: 1.5,
      carDetailsMaxLength: isPortrait ? 10 : 8,
    );
  }

  // Small tablets (iPad mini, small Android tablets)
  factory TabletResponsiveConfig.small({required bool isPortrait}) {
    return TabletResponsiveConfig(
      orderNumberFontSize: isPortrait ? 26.0 : 24.0,
      timeFontSize: isPortrait ? 12.0 : 11.0,
      statusFontSize: isPortrait ? 13.0 : 12.0,
      orderTypeFontSize: isPortrait ? 12.0 : 11.0,
      customerNameFontSize: isPortrait ? 18.0 : 16.0,
      infoFontSize: isPortrait ? 12.0 : 11.0,
      curbsideFontSize: isPortrait ? 11.0 : 10.0,
      cardPadding: isPortrait ? 18.0 : 16.0,
      borderWidth: isPortrait ? 12.0 : 10.0,
      borderRadius: 12.0,
      spacing: isPortrait ? 10.0 : 8.0,
      runSpacing: 4.0,
      sectionSpacing: isPortrait ? 14.0 : 12.0,
      infoSpacing: isPortrait ? 8.0 : 6.0,
      curbsideSpacing: 6.0,
      tagPaddingHorizontal: isPortrait ? 10.0 : 8.0,
      tagPaddingVertical: isPortrait ? 5.0 : 4.0,
      tagBorderRadius: 6.0,
      statusPaddingHorizontal: isPortrait ? 10.0 : 8.0,
      statusPaddingVertical: isPortrait ? 5.0 : 4.0,
      statusBorderRadius: 20.0,
      curbsideTagPadding: 8.0,
      iconSize: isPortrait ? 15.0 : 14.0,
      infoIconSize: isPortrait ? 24.0 : 22.0,
      colorIndicatorSize: isPortrait ? 24.0 : 22.0,
      iconSpacing: isPortrait ? 8.0 : 7.0,
      shadowSpread: 1.0,
      shadowBlur: 2.0,
      shadowOffset: 1.0,
      carDetailsMaxLength: isPortrait ? 8 : 6,
    );
  }
}
