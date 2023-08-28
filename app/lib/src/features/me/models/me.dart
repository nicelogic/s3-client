import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'me.g.dart';

@JsonSerializable(explicitToJson: true)
class Me extends Equatable {
  final String name;
  final String pwd;
  final String backupDirPath;

  const Me(
      {required this.name, required this.pwd, required this.backupDirPath});
  const Me.empty() : this(name: '', pwd: '', backupDirPath: '');

  Me copyWith({
    final String? pwd,
    final String? name,
    final String? backupDirPath,
  }) {
    return Me(
        name: name ?? this.name,
        pwd: pwd ?? this.pwd,
        backupDirPath: backupDirPath ?? this.backupDirPath);
  }

  factory Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);
  Map<String, dynamic> toJson() => _$MeToJson(this);

  @override
  List<Object?> get props => [name, pwd, backupDirPath];
}
