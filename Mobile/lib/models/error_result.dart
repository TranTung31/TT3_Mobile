class ErrorResult {
  String? error;
  String? errorDescription;

  ErrorResult({required this.error, required this.errorDescription});

  ErrorResult.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorDescription = json['error_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['error_description'] = this.errorDescription;
    return data;
  }
}
