class OrderStatsReponseModel {
  int? newOrders;
  int? preparingOrders;
  int? arrivedCustomers;

  OrderStatsReponseModel({
    this.newOrders,
    this.preparingOrders,
    this.arrivedCustomers,
  });

  OrderStatsReponseModel.fromJson(Map<String, dynamic> json) {
    newOrders = json['newOrders'];
    preparingOrders = json['preparingOrders'];
    arrivedCustomers = json['arrivedCustomers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['newOrders'] = newOrders;
    data['preparingOrders'] = preparingOrders;
    data['arrivedCustomers'] = arrivedCustomers;
    return data;
  }
}
