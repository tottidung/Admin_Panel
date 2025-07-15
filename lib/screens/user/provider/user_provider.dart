import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../core/data/data_provider.dart';

class UserProvider extends ChangeNotifier {
  final DataProvider _dataProvider;

  List<User> _filteredUsers = [];
  List<User> get filteredUsers => _filteredUsers;

  UserProvider(this._dataProvider);

  /// 🔄 Làm mới danh sách người dùng từ server
  Future<void> refreshUserList({bool showSnack = false}) async {
    try {
      await _dataProvider.getAllUsers(showSnack: showSnack);
      _filteredUsers = List.from(_dataProvider.users);
      notifyListeners();
      log('[UserProvider] 🔄 Danh sách người dùng đã được làm mới. Tổng: ${_filteredUsers.length}');
    } catch (e, stackTrace) {
      log('[UserProvider] ❌ Lỗi khi làm mới danh sách user: $e', stackTrace: stackTrace);
    }
  }

  /// 🔍 Tìm kiếm người dùng theo tên hoặc email
  void searchUser(String query) {
    query = query.toLowerCase().trim();
    final allUsers = _dataProvider.users;

    if (query.isEmpty) {
      _filteredUsers = List.from(allUsers);
    } else {
      _filteredUsers = allUsers.where((user) {
        final name = user.name?.toLowerCase() ?? '';
        final email = user.email?.toLowerCase() ?? '';
        return name.contains(query) || email.contains(query);
      }).toList();
    }

    notifyListeners();
  }

  /// ✅ Khóa hoặc mở tài khoản người dùng (gọi API + làm mới danh sách)
  Future<void> toggleBlockStatus(User user) async {
    final newStatus = !(user.isBlocked ?? false);

    if (user.id == null) {
      log('[UserProvider] ⚠️ user.id == null, không thể cập nhật trạng thái.');
      return;
    }

    try {
      await _dataProvider.updateUserBlockStatus(user.id!, newStatus);
      await refreshUserList(); // Làm mới để cập nhật trạng thái từ backend
      log('[UserProvider] ✅ Trạng thái khoá của ${user.email} đã được cập nhật thành $newStatus');
    } catch (e, stackTrace) {
      log('[UserProvider] ❌ Lỗi khi cập nhật trạng thái khoá user ${user.email}: $e',
          stackTrace: stackTrace);
    }
  }
}
