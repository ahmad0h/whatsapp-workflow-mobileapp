class IsLinkedReponseModel {
  final String status;
  final String? branchId;
  final String? accessToken;
  final String? refreshToken;

  IsLinkedReponseModel({
    required this.status,
    this.branchId,
    this.accessToken,
    this.refreshToken,
  });

  factory IsLinkedReponseModel.fromJson(Map<String, dynamic> json) {
    return IsLinkedReponseModel(
      status: json['status'] as String,
      branchId: json['branchId'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (branchId != null) 'branchId': branchId,
      if (accessToken != null) 'accessToken': accessToken,
      if (refreshToken != null) 'refreshToken': refreshToken,
    };
  }
}
