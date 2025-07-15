class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] == true, // an toàn hơn
      message: json['message']?.toString() ?? 'No message', // ✅ Luôn là String
      data: (json['data'] != null && fromJsonT != null)
          ? fromJsonT(json['data']) // ✅ Gọi hàm parse nếu có dữ liệu
          : null,
    );
  }
}
