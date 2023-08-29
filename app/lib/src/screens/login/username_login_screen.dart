import 'dart:io';

import 'package:app/src/features/me/bloc/me_bloc.dart';
import 'package:app/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minio_new/minio.dart';

class UserNameLoginScreen extends StatefulWidget {
  UserNameLoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return UserNameLoginScreenState();
  }
}

class UserNameLoginScreenState extends State<UserNameLoginScreen> {
  @override
  Widget build(BuildContext context) {
    widget.usernameController.text = context.read<MeCubit>().state.me.name;
    final listViewChildren = [
      _UsernameInput(widget.usernameController),
      const SizedBox(height: 12),
      _PasswordInput(widget.passwordController),
      _LoginButton(
        onTap: () async {
          final userName = widget.usernameController.text;
          final password = widget.passwordController.text;
          try {
            final minio = Minio(
              endPoint: 'tenant0.env0.luojm.com',
              port: 9443,
              useSSL: true,
              accessKey: userName,
              secretKey: password,
            );
            final isExist = await minio.bucketExists("wumiao");
            if (context.mounted && isExist) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('登录成功')));
              Process.start('assets/cmd/mc.exe', [
                'alias',
                'set',
                'wumiao',
                'https://tenant0.env0.luojm.com:9443',
                userName,
                password
              ]);
              context
                  .read<MeCubit>()
                  .updateUserNamePwd(name: userName, pwd: password);
              const HomeScreenRoute().go(context);
            }
            if (context.mounted && !isExist) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('服务器存储文件夹不存在，请联系管理员创建')));
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }
        },
      ),
    ];

    return Scaffold(
      // appBar: AppBar(title: const Text('登录'), centerTitle: true),
      body: Align(
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 54),
          children: listViewChildren,
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput(this.usernameController);

  final TextEditingController? usernameController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: TextField(
          textInputAction: TextInputAction.next,
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: '用户名',
          ),
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput(this.passwordController);

  final TextEditingController? passwordController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: '密码',
          ),
          obscureText: true,
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.login),
            label: const Text(
              '登录',
            ),
          )),
    );
  }
}
