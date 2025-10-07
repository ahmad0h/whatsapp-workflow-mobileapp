import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';

class HomeStatsSection extends StatelessWidget {
  final double horizontalPadding;

  const HomeStatsSection({super.key, required this.horizontalPadding});

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String count,
    Color color,
    String icon,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth > 1200 ? 20 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  offset: Offset(1, 3),
                  blurRadius: 1,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth > 1200 ? 18 : 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      icon,
                      width: screenWidth > 1200 ? 28 : 24,
                      height: screenWidth > 1200 ? 28 : 24,
                    ),
                  ],
                ),
                SizedBox(height: screenWidth > 1200 ? 22 : 18),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: screenWidth > 1200 ? 38 : 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: screenWidth > 1200 ? 70 : 49,
              height: screenWidth > 1200 ? 58 : 39,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.getOrderStatsStatus == ResponseStatus.failure) {}
      },
      builder: (context, state) {
        if (state.getOrderStatsStatus == ResponseStatus.loading) {
          return SliverToBoxAdapter(
            child: Center(
              child: Lottie.asset(
                'assets/loading.json',
                width: screenWidth > 1200 ? 180 : 150,
              ),
            ),
          );
        }

        var stats = state.orderStats;
        return SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              top: 32,
            ),
            child: orientation == Orientation.landscape && screenWidth > 1200
                ? Row(
                    children: [
                      _buildStatCard(
                        context,
                        'New Orders',
                        stats?.newOrders.toString() ?? '0',
                        AppColors.primary,
                        'assets/icons/user.svg',
                      ),

                      SizedBox(width: 16),
                      _buildStatCard(
                        context,
                        'Preparing',
                        stats?.preparingOrders.toString() ?? '0',
                        AppColors.statusPreparing,
                        'assets/icons/pot.svg',
                      ),

                      SizedBox(width: 16),
                      _buildStatCard(
                        context,
                        'Arrived',
                        stats?.arrivedCustomers.toString() ?? '0',
                        AppColors.statusArrived,
                        'assets/icons/car.svg',
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _buildStatCard(
                        context,
                        'New Orders',
                        stats?.newOrders.toString() ?? '0',
                        AppColors.primary,
                        'assets/icons/user.svg',
                      ),
                      SizedBox(width: 12),

                      _buildStatCard(
                        context,
                        'Preparing',
                        stats?.preparingOrders.toString() ?? '0',
                        AppColors.statusPreparing,
                        'assets/icons/pot.svg',
                      ),
                      SizedBox(width: 12),
                      _buildStatCard(
                        context,
                        'Arrived',
                        stats?.arrivedCustomers.toString() ?? '0',
                        AppColors.statusArrived,
                        'assets/icons/car.svg',
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
