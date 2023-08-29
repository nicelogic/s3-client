import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/me/bloc/me_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  Future<Process>? _mirrorProcess;
  String lastString = '';
  String lastError = '';

  late String name;
  late String pwd;
  late String backupDir;

  backup(String name, String pwd, String backupDir) {
    if (backupDir.isEmpty) {
      return;
    }

    final lastDirName = basename(backupDir);
    // final textLast =
    //     'mc.exe mirror --watch $backupDir wumiao/wumiao/$name/$lastDirName';
    // final carriageReturn = Platform.isWindows ? '\r\n' : '\n';
    // pty.write(const Utf8Encoder().convert('SET HOMEDRIVE=C:$carriageReturn'));
    // pty.write(const Utf8Encoder()
    //     .convert('SET HOMEPATH=\\Users\\%USERNAME%$carriageReturn'));
    // pty.write(const Utf8Encoder().convert(
    //     'SET HOMESHARE=\\\\localhost\\C\$\\Users\\%USERNAME%$carriageReturn'));
    // pty.write(const Utf8Encoder().convert('cd data $carriageReturn'));
    // pty.write(const Utf8Encoder().convert('cd flutter_assets $carriageReturn'));
    // pty.write(const Utf8Encoder().convert('cd assets\\cmd $carriageReturn'));
    // pty.write(const Utf8Encoder().convert(textLast + carriageReturn));
    setState(() {
      try {
        if (kDebugMode) {
          _mirrorProcess = Process.start(
            'assets\\cmd\\mc.exe',
            [
              'mirror',
              '--watch',
              '--remove',
              '--overwrite',
              '--md5',
              '--debug',
              backupDir,
              'wumiao/wumiao/$name/$lastDirName'
            ],
            runInShell: false,
            // mode: ProcessStartMode.detachedWithStdio,
          );
        } else {
          _mirrorProcess = Process.start(
            // 'assets\\cmd\\mc.exe',
            'data\\flutter_assets\\assets\\cmd\\mc.exe',
            [
              'mirror',
              '--watch',
              '--remove',
              '--overwrite',
              '--md5',
              '--debug',
              backupDir,
              'wumiao/wumiao/$name/$lastDirName'
            ],
            runInShell: false,
            // mode: ProcessStartMode.detachedWithStdio,
          );
        }
      } catch (e) {
        backup(name, pwd, backupDir);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    name = context.read<MeCubit>().state.me.name;
    pwd = context.read<MeCubit>().state.me.pwd;
    backupDir = context.read<MeCubit>().state.me.backupDirPath;
    backup(name, pwd, backupDir);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("实时备份文件"),
        ),
        body: Align(
            alignment: const Alignment(0, -1 / 3),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Center(
                  child: ElevatedButton(
                      onPressed: context
                              .watch<MeCubit>()
                              .state
                              .me
                              .backupDirPath
                              .isNotEmpty
                          ? null
                          : () async {
                              String? selectedDirectory =
                                  await FilePicker.platform.getDirectoryPath();

                              if (selectedDirectory != null) {
                                if (context.mounted) {
                                  context
                                      .read<MeCubit>()
                                      .updateBackupDir(dir: selectedDirectory);

                                  final name =
                                      context.read<MeCubit>().state.me.name;
                                  final pwd =
                                      context.read<MeCubit>().state.me.pwd;
                                  final backupDir = context
                                      .read<MeCubit>()
                                      .state
                                      .me
                                      .backupDirPath;
                                  backup(name, pwd, backupDir);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                          content: Text('备份开始')));
                                  }
                                }
                              }
                            },
                      child: const Text('选择要备份的文件夹')),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<MeCubit, MeState>(builder: (context, state) {
                  return TextButton(
                      onPressed: () {
                        launchUrl(Uri.directory(
                            context.read<MeCubit>().state.me.backupDirPath));
                      },
                      child: Text(
                          context.read<MeCubit>().state.me.backupDirPath,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)));
                }),
                // const SizedBox(
                //   height: 30,
                // ),
                // if (context.watch<MeCubit>().state.me.backupDirPath.isNotEmpty)
                //   Center(
                //     child: Column(children: [
                //       Row(children: [
                //         Text(
                //           '实时备份中',
                //           style: TextStyle(
                //               color: Theme.of(context).colorScheme.primary),
                //         ),
                //         const CircularProgressIndicator(),
                //       ])
                //     ]),
                //   ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                    child: Text(
                  '实时传输状态：',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                )),
                const SizedBox(
                  height: 20,
                ),
                if (_mirrorProcess != null)
                  FutureBuilder(
                      future: _mirrorProcess,
                      builder: (BuildContext context,
                          AsyncSnapshot<Process> snapshot) {
                        if (snapshot.hasData) {
                          return StreamBuilder<String>(
                            stream:
                                snapshot.data!.stdout.transform(utf8.decoder),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                lastString = snapshot.data!;
                                return Center(
                                    child: SizedBox(
                                        width: 500,
                                        child: Text(
                                          snapshot.data!,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        )));
                              } else {
                                return Center(
                                    child: SizedBox(
                                        width: 500,
                                        child: Text(
                                          lastString,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        )));
                              }
                            },
                          );
                        } else {
                          return Center(
                              child: SizedBox(
                                  width: 500,
                                  child: Text(
                                    lastString,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  )));
                        }
                      }),
                if (_mirrorProcess != null)
                  FutureBuilder(
                      future: _mirrorProcess,
                      builder: (BuildContext context,
                          AsyncSnapshot<Process> snapshot) {
                        if (snapshot.hasData) {
                          return StreamBuilder<String>(
                            stream:
                                snapshot.data!.stderr.transform(utf8.decoder),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                lastError = snapshot.data!;
                                return Column(children: [
                                  Center(
                                      child: Text(
                                    '调试打印：',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                      child: SizedBox(
                                          width: 500,
                                          child: Text(
                                            snapshot.data!,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                          )))
                                ]);
                              } else {
                                return Center(
                                    child: SizedBox(
                                        width: 500,
                                        child: Text(
                                          lastError,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        )));
                              }
                            },
                          );
                        } else {
                          return Center(
                              child: SizedBox(
                                  width: 500,
                                  child: Text(
                                    lastError,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  )));
                        }
                      }),
              ],
            ))));
  }
}
