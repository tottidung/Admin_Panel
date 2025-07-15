import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../models/user.dart';
import '../../../utility/constants.dart';
import '../../../utility/snack_bar_helper.dart';

class AdminUserProvider extends ChangeNotifier {
  final String _baseUrl = MAIN_URL;
  bool isLoading = false;
  List<User> users = [];

  /// Lấy tất cả người dùng
  Future<void> getAllUsers({bool showSnack = false}) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl/users'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['data'];

        users = list.map((json) => User.fromJson(json)).toList();

        if (showSnack) {
          SnackBarHelper.showSuccessSnackBar(
              "Lấy danh sách người dùng thành công.");
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            "Lỗi khi tải danh sách: ${response.statusCode}");
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar("Lỗi: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// Khóa hoặc mở khóa user
  Future<void> toggleUserBlock(String userId, bool currentStatus) async {
    try {
      final res = await http.put(
        Uri.parse('$_baseUrl/users/$userId/block'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'isBlocked': !currentStatus}),
      );

      if (res.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar(
          !currentStatus ? 'Đã khóa người dùng' : 'Đã mở khóa người dùng',
        );
        await getAllUsers(); // Refresh danh sách
      } else {
        SnackBarHelper.showErrorSnackBar(
            "Thao tác thất bại: ${res.statusCode}");
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar("Lỗi khi cập nhật trạng thái: $e");
    }
  }
}
