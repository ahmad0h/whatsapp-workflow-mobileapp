import 'package:flutter/material.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';

class OrderTrackingTimeline extends StatelessWidget {
  final String updatedAt;

  const OrderTrackingTimeline({super.key, required this.updatedAt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 25),
        TimelineItem(
          title: 'Accepted Order',
          time: formatTimeWithoutDate(updatedAt),
          isCompleted: true,
          isFirst: true,
        ),
        TimelineItem(title: 'Arrived', time: '10:55 AM', isCompleted: true),
        TimelineItem(
          title: 'Completed',
          time: '10:57 AM',
          isCompleted: true,
          isLast: true,
        ),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String title;
  final String time;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.title,
    required this.time,
    this.isCompleted = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? (isLast ? AppColors.statusArrived : AppColors.primary)
                      : AppColors.border,
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: AppColors.background,
                        size: 16,
                      )
                    : null,
              ),
              // Vertical line (except for last item)
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? (isLast ? AppColors.statusArrived : AppColors.primary)
                        : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String formatTimeWithoutDate(String dateTimeString) {
  try {
    // Parse the date string as UTC
    final dateTime = DateTime.parse(dateTimeString);
    // Convert to local timezone
    final localTime = dateTime.toLocal();

    final hour = localTime.hour % 12 == 0 ? 12 : localTime.hour % 12;
    final minute = localTime.minute.toString().padLeft(2, '0');
    final period = localTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  } catch (e) {
    debugPrint('Error parsing date: $e');
    return '--:--';
  }
}
