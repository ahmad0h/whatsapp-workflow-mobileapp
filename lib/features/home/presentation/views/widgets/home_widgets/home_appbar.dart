import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/responsive_util.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const HomeAppBar({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      leading: const SizedBox.shrink(),
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: false,
      pinned: true,
      toolbarHeight: kToolbarHeight,
      expandedHeight: orientation == Orientation.landscape ? 70 : 80,
      actions: [SizedBox.shrink()],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Responsive logo sizing
                Image.asset(
                  'assets/ryze-logo.png',
                  height: screenWidth > 1200 ? 50 : 40,
                ),
                BlocConsumer<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state.getBranchesDataStatus ==
                        ResponseStatus.success) {}
                    if (state.getBranchesDataStatus ==
                        ResponseStatus.failure) {}
                  },
                  builder: (context, state) {
                    var branchData = state.getBranchesData;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CachedNetworkImage(
                          imageUrl: branchData?.business?.businessLogoUrl ?? '',
                          height: screenWidth > 1200 ? 45 : 35,
                          placeholder: (context, url) =>
                              const SizedBox.shrink(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        SizedBox(width: screenWidth > 900 ? 12 : 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              branchData?.business?.businessName ?? '',
                              style: TextStyle(
                                color: AppColors.background,
                                fontSize: screenWidth > 1200 ? 14 : 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              branchData?.branchName ?? '',
                              style: TextStyle(
                                color: AppColors.backgroundLight,
                                fontSize: screenWidth > 1200 ? 12 : 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: screenWidth > 900 ? 32 : 24),
                        Container(
                          height: screenWidth > 1200 ? 40 : 33,
                          color: Colors.white,
                          width: 1,
                        ),
                        SizedBox(width: screenWidth > 900 ? 32 : 24),
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: AppColors.background,
                            size: screenWidth > 1200 ? 36 : 32,
                          ),
                          onPressed: onMenuPressed,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
