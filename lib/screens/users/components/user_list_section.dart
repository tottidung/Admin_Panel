import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserListSection extends StatefulWidget {
  const UserListSection({super.key});

  @override
  State<UserListSection> createState() => _UserListSectionState();
}

class _UserListSectionState extends State<UserListSection> {
  List users = [];
  bool loading = true;
  final String baseUrl = 'http://10.0.2.2:3000';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() => loading = true);
    final res = await http.get(Uri.parse('$baseUrl/users'));

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      setState(() {
        users = json['data'];
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> toggleBlock(String userId, bool isBlocked) async {
    final res = await http.put(
      Uri.parse('$baseUrl/users/$userId/block'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'isBlocked': !isBlocked}),
    );

    if (res.statusCode == 200) {
      fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const CircularProgressIndicator();

    return Column(
      children: users.map((user) {
        final isBlocked = user['isBlocked'] == true;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                user['picture'] != null ? NetworkImage(user['picture']) : null,
            child: user['picture'] == null ? const Icon(Icons.person) : null,
          ),
          title: Text(user['name'] ?? 'No name'),
          subtitle: Text(user['email'] ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isBlocked ? "Blocked" : "Active"),
              Switch(
                value: !isBlocked,
                onChanged: (_) => toggleBlock(user['_id'], isBlocked),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
