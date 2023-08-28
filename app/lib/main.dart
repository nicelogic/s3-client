import 'package:app/src/features/me/bloc/me_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/src/bloc_observer.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'dart:io';

import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageDir = kIsWeb
      ? HydratedStorage.webStorageDirectory
      : await getApplicationDocumentsDirectory();
  HydratedBloc.storage =
      await HydratedStorage.build(storageDirectory: storageDir);
  Bloc.observer = AppBlocObserver();
  Bloc.transformer = sequential<dynamic>();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
  );
  if (MeCubit().state.isFirstTime) {
    launchAtStartup.enable();
    MeCubit().updateFirstTimeToFalse();
  }

  runApp(const MyApp());

  // doWhenWindowReady(() {
  //   final win = appWindow;
  //   // const initialSize = Size(600, 450);
  //   // win.minSize = initialSize;
  //   // win.size = initialSize;
  //   win.alignment = Alignment.center;
  //   win.title = "伍瞄视频文件管理客户端";
  //   win.show();
  // });
}
