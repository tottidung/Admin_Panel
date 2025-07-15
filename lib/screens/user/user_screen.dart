import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

import 'components/user_list_section.dart';
import 'components/user_header.dart';
import 'provider/user_provider.dart';
import 'package:admin/utility/constants.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().refreshUserList(showSnack: false);
    });

    final userProvider = context.watch<UserProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const UserHeader(),
            const Gap(defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "User Management",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<UserProvider>().refreshUserList(showSnack: true);
                            },
                            icon: const Icon(Icons.refresh),
                            tooltip: "Tải lại danh sách người dùng",
                          ),
                        ],
                      ),
                      const Gap(defaultPadding),
                      userProvider.filteredUsers.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const UserListSection(),
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