import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:process_run/process_run.dart';
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
  bool isBeginBackup = false;
  @override
  Widget build(BuildContext context) {
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
                      child: const Text('选择或修改要备份的文件夹'),
                      onPressed: () async {
                        String? selectedDirectory =
                            await FilePicker.platform.getDirectoryPath();

                        if (selectedDirectory != null) {
                          if (context.mounted) {
                            context
                                .read<MeCubit>()
                                .updateBackupDir(dir: selectedDirectory);

                            var shell = Shell();
                            final name = context.read<MeCubit>().state.me.name;
                            final pwd = context.read<MeCubit>().state.me.pwd;
                            final backupDir =
                                context.read<MeCubit>().state.me.backupDirPath;
                            final lastDirName = basename(backupDir);
                            shell.run('''
# Display some text
echo $name
echo $pwd
echo $backupDir
assets/cmd/mc.exe alias set wumiao https://tenant0.env0.luojm.com:9443 $name $pwd
assets/cmd/mc.exe mirror --watch $backupDir wumiao/wumiao/$name/$lastDirName
                                        ''');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                    const SnackBar(content: Text('备份开始')));
                            }
                          }
                        }
                      }),
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
                const SizedBox(
                  height: 30,
                ),

                if (context.watch<MeCubit>().state.me.backupDirPath.isNotEmpty)
                  Center(
                    child: Column(children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '实时备份中',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      )
                    ]),
                  ),
                const SizedBox(
                  height: 30,
                ),
                // Text(
                //   '实时备份状态:',
                //   style: TextStyle(
                //       color: Theme.of(context).colorScheme.primary,
                //       fontSize: 20.0),
                // ),
                // Card(
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         const Text('实时备份状态'),
                //       ]),
                // ),
              ],
            ))));
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundStartColor = Theme.of(context).colorScheme.primary;
    final backgroundEndColor = Theme.of(context).colorScheme.primary;
    return WindowTitleBarBox(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundStartColor, backgroundEndColor],
              stops: const [0.0, 1.0]),
        ),
        child: Row(
          children: [
            Expanded(
              child: MoveWindow(),
            ),
            const WindowButtons()
          ],
        ),
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
      iconNormal: Theme.of(context).colorScheme.onPrimary,
      mouseOver: Theme.of(context).colorScheme.onPrimary,
      mouseDown: Theme.of(context).colorScheme.secondary,
      iconMouseOver: Theme.of(context).colorScheme.secondary,
      iconMouseDown: Theme.of(context).colorScheme.secondary,
    );

    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(
          colors: buttonColors,
          onPressed: () {},
        ),
      ],
    );
  }
}
