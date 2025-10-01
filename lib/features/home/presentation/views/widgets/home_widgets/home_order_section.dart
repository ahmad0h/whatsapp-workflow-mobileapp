import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/home_util.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/responsive_util.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card.dart';

class HomeOrdersSection extends StatelessWidget {
  final double horizontalPadding;
  final double headerFontSize;
  final String selectedTab;
  final List<OrderCardModel> orders;
  final bool isLoading;
  final Function(String) onTabChanged;
  final Function(OrderCardModel) onOrderTap;

  const HomeOrdersSection({
    super.key,
    required this.horizontalPadding,
    required this.headerFontSize,
    required this.selectedTab,
    required this.orders,
    required this.isLoading,
    required this.onTabChanged,
    required this.onOrderTap,
  });

  Widget _buildTab(
    BuildContext context,
    String text, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 1200 ? 18 : 15,
          vertical: screenWidth > 1200 ? 10 : 7.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.5),
          color: isSelected ? AppColors.background : Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.textPrimary.withValues(alpha: 0.06)
                  : Colors.transparent,
              blurRadius: isSelected ? 2.5 : 0,
              offset: isSelected ? Offset(1, 3) : Offset.zero,
            ),
          ],
        ),
        margin: EdgeInsets.only(left: screenWidth > 900 ? 16 : 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: screenWidth > 1200 ? 19 : 17.5,
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderCardModel model) {
    final isSmallCard =
        MediaQuery.of(context).orientation == Orientation.landscape &&
        !ResponsiveUtils.isLargeTablet(context);

    return OrderCard(
      model: model,
      isSmallCard: isSmallCard,
      onTap: () => onOrderTap(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    return SliverList(
      delegate: SliverChildListDelegate([
        // Orders header section
        Container(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: 32,
          ),
          child: Flex(
            direction:
                orientation == Orientation.landscape && screenWidth > 1000
                ? Axis.horizontal
                : Axis.vertical,
            crossAxisAlignment:
                orientation == Orientation.landscape && screenWidth > 1000
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                'Orders',
                style: TextStyle(
                  fontSize: headerFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (orientation == Orientation.landscape && screenWidth > 1000)
                Spacer()
              else
                SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTab(
                    context,
                    'All Orders',
                    isSelected: selectedTab == 'All Orders',
                    onTap: () => onTabChanged('All Orders'),
                  ),
                  _buildTab(
                    context,
                    'New Orders',
                    isSelected: selectedTab == 'New Orders',
                    onTap: () => onTabChanged('New Orders'),
                  ),
                  _buildTab(
                    context,
                    'In Progress',
                    isSelected: selectedTab == 'In Progress',
                    onTap: () => onTabChanged('In Progress'),
                  ),
                  _buildTab(
                    context,
                    'Arrived',
                    isSelected: selectedTab == 'Arrived',
                    onTap: () => onTabChanged('Arrived'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Grid container
        Container(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: 32,
          ),
          child: isLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Lottie.asset(
                      'assets/loading.json',
                      width: screenWidth > 1200 ? 180 : 150,
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: HomeUtils.filterOrders(orders, selectedTab).length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: screenWidth > 900 ? 32 : 24,
                    mainAxisSpacing: screenWidth > 900 ? 32 : 24,
                    childAspectRatio: ResponsiveUtils.getGridAspectRatio(
                      context,
                    ),
                  ),
                  itemBuilder: (_, index) {
                    final filteredOrders = HomeUtils.filterOrders(
                      orders,
                      selectedTab,
                    );
                    return _buildOrderCard(context, filteredOrders[index]);
                  },
                ),
        ),
      ]),
    );
  }
}
