import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';

class HomeStatusToggle extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final Function(bool)? onChanged;

  const HomeStatusToggle({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isToggleEnabled = onChanged != null && !isLoading;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE4E4E7)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(1, 3),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 67,
            height: 49,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isEnabled ? Colors.green : AppColors.error,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              isEnabled ? 'OPEN' : 'CLOSED',
              style: TextStyle(
                color: AppColors.background,
                fontSize: screenWidth > 1200 ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              isEnabled
                  ? 'You are currently accepting all orders'
                  : 'You are not accepting orders',
              style: TextStyle(
                fontSize: screenWidth > 1200 ? 18 : 16,
                color: Color(0xFF343330),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 1.2,
                child: GestureDetector(
                  onTap: isToggleEnabled ? () => onChanged!(!isEnabled) : null,
                  child: Container(
                    width: 52,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? AppColors.success
                          : AppColors.textHint.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 200),
                          left: isEnabled ? 22 : 2,
                          top: 2,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.06,
                                  ),
                                  offset: Offset(0, 3),
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.15,
                                  ),
                                  offset: Offset(0, 3),
                                  blurRadius: 8,
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
