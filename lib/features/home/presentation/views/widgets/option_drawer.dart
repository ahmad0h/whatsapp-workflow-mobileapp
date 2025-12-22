import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_workflow_mobileapp/config/router/go_router_config.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:whatsapp_workflow_mobileapp/core/service_locator.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/shorebird_update_checker.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class OptionDrawer extends StatelessWidget {
  const OptionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Force rebuild when locale changes by using locale as part of the key
    final localeKey = context.locale.toString();

    return Drawer(
      key: ValueKey(localeKey), // Add key to force rebuild on locale change
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
              text: 'drawer.orders'.tr(),
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
              text: 'drawer.history'.tr(),
              onTap: () {
                GoRouter.of(context).pop();
                GoRouter.of(context).push(GoRouterConfig.historyView);
              },
            ),
            SizedBox(height: 22),
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.borderLight,
            ),
            SizedBox(height: 22),
            LanguageToggle(),
            SizedBox(height: 22),
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.borderLight,
            ),
            SizedBox(height: 22),
            _buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();

        final version = snapshot.data?.version ?? '';
        final buildNumber = snapshot.data?.buildNumber ?? '';

        return FutureBuilder<int?>(
          future: locator<ShorebirdUpdateChecker>().getCurrentPatchNumber(),
          builder: (context, patchSnapshot) {
            final patchNumber = patchSnapshot.data;

            // Check if update is available to decide whether to show the button
            // Check update status to decide button state
            return FutureBuilder<UpdateStatus>(
              future: locator<ShorebirdUpdateChecker>().getUpdateStatus(),
              builder: (context, statusSnapshot) {
                final status = statusSnapshot.data ?? UpdateStatus.unavailable;
                final isOutdated = status == UpdateStatus.outdated;
                final isRestartRequired =
                    status == UpdateStatus.restartRequired;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Version: $version+$buildNumber',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (patchNumber != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Patch: $patchNumber',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close drawer
                          if (isOutdated) {
                            locator<ShorebirdUpdateChecker>().downloadUpdate();
                          } else if (isRestartRequired) {
                            // Trigger check to show restart dialog
                            locator<ShorebirdUpdateChecker>().checkForUpdates();
                          } else {
                            locator<ShorebirdUpdateChecker>().checkForUpdates(
                              showUpToDateMessage: true,
                            );
                          }
                        },
                        icon: Icon(
                          isRestartRequired
                              ? Icons.restart_alt
                              : Icons.system_update,
                          size: 18,
                        ),
                        label: Text(
                          isOutdated
                              ? 'Update Now'
                              : isRestartRequired
                              ? 'Restart to Apply'
                              : 'Check for Updates',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRestartRequired
                              ? Colors.green
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class LanguageToggle extends StatefulWidget {
  final double scale;
  const LanguageToggle({super.key, this.scale = 1.0});

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale == const Locale('ar');

    return Container(
      padding: EdgeInsets.all(10 * widget.scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8 * widget.scale),
        border: Border.all(color: Color(0xFFE4E4E7), width: 1 * widget.scale),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(1 * widget.scale, 3 * widget.scale),
            blurRadius: 1 * widget.scale,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 67 * widget.scale,
            height: 49 * widget.scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isArabic ? AppColors.primary : AppColors.success,
              borderRadius: BorderRadius.circular(11 * widget.scale),
            ),
            child: Text(
              isArabic ? 'AR' : 'EN',
              style: TextStyle(
                color: AppColors.background,
                fontSize: 16 * widget.scale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16 * widget.scale),
          Expanded(
            child: Text(
              isArabic ? 'العربية' : 'English',
              style: TextStyle(
                fontSize: 16 * widget.scale,
                color: Color(0xFF343330),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 1.2 * widget.scale,
                child: GestureDetector(
                  onTap: () {
                    if (isArabic) {
                      context.setLocale(const Locale('en'));
                    } else {
                      context.setLocale(const Locale('ar'));
                    }
                  },
                  child: Container(
                    width: 52 * widget.scale,
                    height: 32 * widget.scale,
                    decoration: BoxDecoration(
                      color: isArabic ? AppColors.primary : AppColors.success,
                      borderRadius: BorderRadius.circular(16 * widget.scale),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 200),
                          left: isArabic ? 22 * widget.scale : 2 * widget.scale,
                          top: 2 * widget.scale,
                          child: Container(
                            width: 28 * widget.scale,
                            height: 28 * widget.scale,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.06,
                                  ),
                                  offset: Offset(0, 3 * widget.scale),
                                  blurRadius: 1 * widget.scale,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.15,
                                  ),
                                  offset: Offset(0, 3 * widget.scale),
                                  blurRadius: 8 * widget.scale,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
    final isArabic = context.locale == const Locale('ar');
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Transform.scale(
            scaleX: isArabic ? -1.0 : 1.0,
            child: SvgPicture.asset('assets/icons/arrow-right.svg'),
          ),
        ],
      ),
    );
  }
}
