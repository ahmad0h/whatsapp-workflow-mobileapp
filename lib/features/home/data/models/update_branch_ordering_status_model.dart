class UpdateBranchOrderingStatusResponseModel {
  bool? success;
  String? message;
  String? branchId;
  String? orderingStatus;

  UpdateBranchOrderingStatusResponseModel({
    this.success,
    this.message,
    this.branchId,
    this.orderingStatus,
  });

  UpdateBranchOrderingStatusResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    branchId = json['branchId'];
    orderingStatus = json['orderingStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['branchId'] = branchId;
    data['orderingStatus'] = orderingStatus;
    return data;
  }
}
