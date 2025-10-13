import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_workflow_mobileapp/config/router/go_router_config.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';

class OptionDrawer extends StatelessWidget {
  const OptionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,
      backgroundColor: AppColors.background,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => GoRouter.of(context).pop(),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.close, size: 24, weight: 2.5),
                ),
              ),
            ),
            SizedBox(height: 41),
            OptionWidget(
              text: 'Orders',
              onTap: () {
                GoRouter.of(context).pop();
                GoRouter.of(context).go(GoRouterConfig.homeView);
              },
            ),
            SizedBox(height: 22),
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.borderLight,
            ),
            SizedBox(height: 22),
            OptionWidget(
              text: 'History',
              onTap: () {
                GoRouter.of(context).pop();
                GoRouter.of(context).push(GoRouterConfig.historyView);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OptionWidget extends StatelessWidget {
  const OptionWidget({super.key, required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          SvgPicture.asset('assets/icons/arrow-right.svg'),
        ],
      ),
    );
  }
}
