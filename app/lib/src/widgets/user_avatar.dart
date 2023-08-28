import 'dart:developer';

import 'package:flutter/material.dart';

const _kLogSource = 'widget(user_avatar)';

class UserAvatar extends StatelessWidget {
  final String id;
  final String name;
  final String avatarUrl;
  final double? radius;
  const UserAvatar(
      {super.key,
      required this.id,
      required this.name,
      this.radius,
      required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    try {
      final userAvatar = CircleAvatar(
        radius: radius,
        foregroundImage:
            null,
        // backgroundImage: AssetImage(Config.instance().logoPath),
        backgroundColor: Color.fromARGB(255, id.codeUnitAt(0) % 255,
            id.codeUnitAt(1) % 255, id.codeUnitAt(2) % 255),
        child: Text(
          name.isNotEmpty ? name.substring(0, 1) : id.substring(0, 1),
          style: const TextStyle(color: Colors.white),
        ),
      );
      return userAvatar;
    } catch (e) {
      log(name: _kLogSource, 'has exception($e)');
      return CircleAvatar(
          radius: radius,
          foregroundImage: const AssetImage('assets/images/logo/logo.png'));
    }
  }
}
