import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../utility/constants.dart';
import '../provider/user_provider.dart';

class UserListSection extends StatefulWidget {
  const UserListSection({super.key});

  @override
  State<UserListSection> createState() => _UserListSectionState();
}

class _UserListSectionState extends State<UserListSection> {
  String? _processingUserId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final users = userProvider.filteredUsers;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tất cả người dùng",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (users.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      "Không tìm thấy người dùng nào.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 900),
                      child: DataTable(
                        columnSpacing: 85,
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey.withOpacity(0.2),
                        ),
                        columns: const [
                          DataColumn(label: Text("Tên")),
                          DataColumn(label: Text("Email")),
                          DataColumn(label: Text("Ngày tạo")),
                          DataColumn(label: Text("Trạng thái")),
                          DataColumn(label: Text("Khoá/Mở")),
                        ],
                        rows: List.generate(
                          users.length,
                          (index) {
                            final user = users[index];
                            final isBlocked = user.isBlocked == true;
                            final isProcessing = _processingUserId == user.id;

                            return DataRow(
                              cells: [
                                DataCell(Text(user.name ?? 'Không có tên')),
                                DataCell(Text(user.email ?? 'Không có email')),
                                DataCell(
                                  Text(
                                    user.createdAt
                                            ?.toIso8601String()
                                            .split('T')
                                            .first ??
                                        'Không rõ',
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      isBlocked ? "Đã khoá" : "Đang hoạt động",
                                      style: TextStyle(
                                        color: isBlocked
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: isProcessing
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isBlocked
                                                  ? Colors.green
                                                  : Colors.red,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                            ),
                                            onPressed: () async {
                                              setState(() =>
                                                  _processingUserId = user.id);
                                              await userProvider
                                                  .toggleBlockStatus(user);
                                              setState(() =>
                                                  _processingUserId = null);
                                            },
                                            icon: Icon(isBlocked
                                                ? Icons.lock_open
                                                : Icons.lock),
                                            label: Text(
                                                isBlocked ? "Mở khoá" : "Khoá"),
                                          ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
