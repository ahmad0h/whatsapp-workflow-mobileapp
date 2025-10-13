import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/home_util.dart';
// import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/responsive_util.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';

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
    int? count,
  }) {
    // final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 12, right: 8, top: 8, bottom: 8),
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

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (count != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '(${count.toString()})',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderCardModel model) {
    // final isSmallCard =
    //     MediaQuery.of(context).orientation == Orientation.landscape &&
    //     !ResponsiveUtils.isLargeTablet(context);

    return OrderCard(
      model: model,
      isSmallCard: false,
      onTap: () => onOrderTap(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final orientation = MediaQuery.of(context).orientation;

    return SliverList(
      delegate: SliverChildListDelegate([
        // Orders header section
        // Container(
        //   padding: EdgeInsets.only(
        //     left: horizontalPadding,
        //     right: horizontalPadding,
        //     top: 32,
        //   ),
        //   child: Flex(
        //     direction:
        //         orientation == Orientation.landscape && screenWidth > 1000
        //         ? Axis.horizontal
        //         : Axis.vertical,
        //     crossAxisAlignment:
        //         orientation == Orientation.landscape && screenWidth > 1000
        //         ? CrossAxisAlignment.center
        //         : CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Orders',
        //         style: TextStyle(
        //           fontSize: headerFontSize,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       if (orientation == Orientation.landscape && screenWidth > 1000)
        //         Spacer()
        //       else
        //         SizedBox(height: 16),
        //       Wrap(
        //         spacing: 8,
        //         runSpacing: 8,
        //         children: [
        //           _buildTab(
        //             context,
        //             'All Orders',
        //             isSelected: selectedTab == 'All Orders',
        //             onTap: () => onTabChanged('All Orders'),
        //           ),
        //           _buildTab(
        //             context,
        //             'New Orders',
        //             isSelected: selectedTab == 'New Orders',
        //             onTap: () => onTabChanged('New Orders'),
        //           ),
        //           _buildTab(
        //             context,
        //             'In Progress',
        //             isSelected: selectedTab == 'In Progress',
        //             onTap: () => onTabChanged('In Progress'),
        //           ),
        //           _buildTab(
        //             context,
        //             'Arrived',
        //             isSelected: selectedTab == 'Arrived',
        //             onTap: () => onTabChanged('Arrived'),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        Container(
          padding: EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 20),
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
              : BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    final stats = state.orderStats;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Orders',
                          style: TextStyle(
                            fontSize: headerFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        // Tabs with counts
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                _buildTab(
                                  context,
                                  'All Orders',
                                  isSelected: selectedTab == 'All Orders',
                                  onTap: () => onTabChanged('All Orders'),
                                  // count: stats?.totalOrders,
                                ),
                                _buildTab(
                                  context,
                                  'New Orders',
                                  isSelected: selectedTab == 'New Orders',
                                  onTap: () => onTabChanged('New Orders'),
                                  count: stats?.newOrders,
                                ),
                                _buildTab(
                                  context,
                                  'In Progress',
                                  isSelected: selectedTab == 'In Progress',
                                  onTap: () => onTabChanged('In Progress'),
                                  count: stats?.preparingOrders,
                                ),
                                _buildTab(
                                  context,
                                  'Arrived',
                                  isSelected: selectedTab == 'Arrived',
                                  onTap: () => onTabChanged('Arrived'),
                                  count: stats?.arrivedCustomers,
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Orders list
                        SizedBox(height: 16),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: HomeUtils.filterOrders(
                            orders,
                            selectedTab,
                          ).length,
                          itemBuilder: (_, index) {
                            final filteredOrders = HomeUtils.filterOrders(
                              orders,
                              selectedTab,
                            );
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenWidth > 900 ? 16 : 10,
                                horizontal: 0,
                              ),
                              child: _buildOrderCard(
                                context,
                                filteredOrders[index],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
        ),
      ]),
    );
  }
}
