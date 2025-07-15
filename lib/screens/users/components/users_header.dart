import 'package:flutter/material.dart';

class UsersHeader extends StatelessWidget {
  const UsersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "All Users",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
      ],
    );
  }
}
