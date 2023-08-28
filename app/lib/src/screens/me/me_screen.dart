import 'package:app/src/features/me/me.dart';
import 'package:app/src/routes/routes.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return MeScreenState();
  }
}

class MeScreenState extends State<MeScreen> {
  @override
  Widget build(BuildContext context) {
    return _MeScreen();
  }
}

class _MeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
          _PersonProfileForm(),
          _StartuSettingForm(),
          _SettingsForm()
        ])));
  }
}

class _PersonProfileForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 15, 20),
        child: Builder(builder: (context) {
          final meState = context.watch<MeCubit>().state;
          return Row(children: [
            UserAvatar(
                id: meState.me.name,
                name: meState.me.name,
                avatarUrl: meState.me.name,
                radius: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    meState.me.name.isEmpty
                        ? 'please set name'
                        : meState.me.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ]);
        }));
  }
}

class _StartuSettingForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StartuSettingFormState();
  }
}

class _StartuSettingFormState extends State<_StartuSettingForm> {
  @override
  build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(1, 20, 15, 20),
                  child: Row(children: <Widget>[
                    const SizedBox(width: 20),
                    const Text('设置开机启动: ',
                        style: TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.w500
                        )),
                    BlocBuilder<MeCubit, MeState>(builder: (context, state) {
                      return Checkbox(
                          value: state.isAutoStart,
                          onChanged: (value) async {
                            context
                                .read<MeCubit>()
                                .updateIsAudoStart(isAutoStart: value ?? false);
                            if (value ?? false) {
                              await launchAtStartup.enable();
                            } else {
                              await launchAtStartup.disable();
                            }
                          });
                    })
                  ])))
        ]);
  }
}

class _SettingsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          context.read<MeCubit>().cleanPwd();
          UserNameLoginScreenRoute().go(context);
        },
        child: const ItemCard(label: '退出账号', iconData: Icons.logout));
  }
}
