import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:rxdart/rxdart.dart';

import '../models/models.dart';

part 'me_state.dart';
part 'me_bloc.g.dart';

class MeCubit extends HydratedCubit<MeState> {
  MeCubit() : super(const MeState.meInitial());

  updateUserNamePwd({required final String name, required final String pwd}) {
    emit(state.copyWith(
        me: Me(name: name, pwd: pwd, backupDirPath: state.me.backupDirPath)));
  }

  cleanPwd() {
    emit(state.copyWith(
        me: Me(
            name: state.me.name,
            pwd: '',
            backupDirPath: '')));
  }

  updateBackupDir({required String dir}) {
    emit(state.copyWith(
        me: Me(name: state.me.name, pwd: state.me.pwd, backupDirPath: dir)));
  }

  updateIsAudoStart({required bool isAutoStart}) {
    emit(state.copyWith(isAutoStart: isAutoStart));
  }

  updateFirstTimeToFalse() {
    emit(state.copyWith(isFirstTime: false));
  }

  @override
  MeState? fromJson(Map<String, dynamic> json) {
    final meState = _$MeStateFromJson(json);
    return meState;
  }

  @override
  Map<String, dynamic>? toJson(MeState state) {
    return _$MeStateToJson(state);
  }
}
