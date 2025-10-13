String formatTime(String isoTime) {
  try {
    final dateTime = DateTime.parse(isoTime).toLocal();

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
    
    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
        ? 12
        : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    
    return '$day $month at ${hour.toString().padLeft(2, '0')}:$minute $period';
  } catch (e) {
    return '-- -- at --:-- --';
  }
} 
