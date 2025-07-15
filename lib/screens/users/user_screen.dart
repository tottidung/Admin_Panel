// lib/screens/users/users_screen.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../utility/constants.dart';
import '../../utility/extensions.dart'; // Nếu bạn có extension khác hãy giữ lại
import '../../core/data/data_provider.dart'; // đường dẫn tới DataProvider
import 'components/users_header.dart';
import 'components/user_list_section.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();

    // Gọi API lấy danh sách user một lần duy nhất
    Future.microtask(() {
      context.read<DataProvider>().getAllUsers(); // showSnack: true nếu muốn
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const UsersHeader(),
            const Gap(defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // Thanh tiêu đề + nút
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "User Management",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // showAddUserForm(context); // nếu bạn có form thêm user
                            },
                            icon: const Icon(Icons.person_add),
                            label: const Text("Add New"),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding,
                              ),
                            ),
                          ),
                          const Gap(20),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              context.dataProvider.getAllUsers(showSnack: true);
                            },
                          ),
                        ],
                      ),

                      const Gap(defaultPadding),

                      // Danh sách người dùng
                      const UserListSection(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
