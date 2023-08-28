part of 'me_bloc.dart';

@JsonSerializable(explicitToJson: true)
class MeState extends Equatable {
  final Me me;
  final bool isAutoStart;
  final bool isFirstTime;

  @override
  List<Object> get props => [me, isAutoStart, isFirstTime];

  const MeState(
      {required this.me, required this.isAutoStart, required this.isFirstTime});
  const MeState.meInitial()
      : this(me: const Me.empty(), isAutoStart: true, isFirstTime: true);

  MeState copyWith(
      {final Me? me, final bool? isAutoStart, final bool? isFirstTime}) {
    return MeState(
        me: me ?? this.me,
        isAutoStart: isAutoStart ?? this.isAutoStart,
        isFirstTime: isFirstTime ?? this.isFirstTime);
  }
}
