String formatTime(String isoTime) {
  try {
    final dateTime = DateTime.parse(isoTime).toLocal();

    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
        ? 12
        : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final timeString =
        '${hour.toString()}:${dateTime.minute.toString().padLeft(2, '0')} $period';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayOfWeek = days[dateTime.weekday - 1];
    final month = months[dateTime.month - 1];
    final dateString = '$dayOfWeek, $month ${dateTime.day}, ${dateTime.year}';

    return '$timeString - $dateString';
  } catch (e) {
    return '--:-- - --';
  }
}
