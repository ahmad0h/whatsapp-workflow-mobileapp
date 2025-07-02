String formatStatus(String status) {
  switch (status.toLowerCase()) {
    case 'new_order':
      return 'New Order';
    case 'in_progress':
      return 'In Progress';
    case 'active':
      return 'New Order';
    case 'completed':
      return 'Completed';
    case 'cancelled':
      return 'Cancelled';
    case 'rejected':
      return 'Rejected';
    default:
      return status
          .split('_')
          .map((s) => s[0].toUpperCase() + s.substring(1))
          .join(' ');
  }
}
