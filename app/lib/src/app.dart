import 'dart:io';

import 'package:app/src/features/me/bloc/me_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/src/routes/routes.dart';
import 'package:system_tray/system_tray.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final SystemTray _systemTray = SystemTray();
  final AppWindow _appWindow = AppWindow();
  final Menu _menuMain = Menu();

  Future<void> initSystemTray() async {
    // We first init the systray menu and then add the menu entries
    await _systemTray.initSystemTray(
        iconPath: 'assets/images/logo/app_icon.ico');
    _systemTray.setTitle("伍瞄视频文件管理客户端");
    _systemTray.setToolTip("伍瞄视频文件管理客户端");

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? _appWindow.show() : _systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? _systemTray.popUpContextMenu() : _appWindow.show();
      }
    });

    await _menuMain.buildFrom(
      [
        MenuItemLabel(label: '退出', onClicked: (menuItem) => exit(0)),
      ],
    );
    _systemTray.setContextMenu(_menuMain);
  }

  @override
  void initState() {
    super.initState();
    initSystemTray();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => MeCubit(),
            lazy: false,
          ),
        ],
        child: MaterialApp.router(
          // restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(centerTitle: true),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            // colorSchemeSeed: Colors.blue,
            //  primarySwatch: Colors.blue
          ),
          darkTheme: ThemeData.dark(),
          // themeMode: settingsController.themeMode,
          routerConfig: appRouter,
        ));
  }
}
