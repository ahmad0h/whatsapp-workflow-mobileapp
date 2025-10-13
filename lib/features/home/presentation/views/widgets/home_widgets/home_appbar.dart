import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
// import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/responsive_util.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const HomeAppBar({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    // final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
    // final screenWidth = MediaQuery.of(context).size.width;
    // final orientation = MediaQuery.of(context).orientation;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      leading: const SizedBox.shrink(),
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: false,
      pinned: true,
      toolbarHeight: 80,
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
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Responsive logo sizing
                // Image.asset(
                //   'assets/ryze-logo.png',
                //   height: screenWidth > 1200 ? 50 : 40,
                // ),
                Expanded(
                  child: BlocConsumer<HomeBloc, HomeState>(
                    listener: (context, state) {
                      if (state.getBranchesDataStatus ==
                          ResponseStatus.success) {}
                      if (state.getBranchesDataStatus ==
                          ResponseStatus.failure) {}
                    },
                    builder: (context, state) {
                      var branchData = state.getBranchesData;
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 600) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 8,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 4,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              branchData
                                                  ?.business
                                                  ?.businessLogoUrl ??
                                              '',
                                          height: 50,
                                          placeholder: (context, url) =>
                                              const SizedBox.shrink(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              branchData
                                                      ?.business
                                                      ?.businessName ??
                                                  '',
                                              style: TextStyle(
                                                color: AppColors.background,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              branchData?.branchName ?? '',
                                              style: TextStyle(
                                                color:
                                                    AppColors.backgroundLight,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    color: AppColors.background,
                                    size: 32,
                                  ),
                                  onPressed: onMenuPressed,
                                ),
                              ],
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        branchData?.business?.businessLogoUrl ??
                                        '',
                                    height: 50,
                                    placeholder: (context, url) =>
                                        const SizedBox.shrink(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    branchData?.business?.businessName ?? '',
                                    style: TextStyle(
                                      color: AppColors.background,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    branchData?.branchName ?? '',
                                    style: TextStyle(
                                      color: AppColors.backgroundLight,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              // Container(
                              //   height: 33,
                              //   color: Colors.white,
                              //   width: 1,
                              // ),
                              // SizedBox(width: 24),
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: AppColors.background,
                                  size: 38,
                                ),
                                onPressed: onMenuPressed,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
