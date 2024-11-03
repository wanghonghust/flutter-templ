import 'package:kms/models/user.dart';

class Log {
  final int id;
  final String message;
  final String actionTime;
  final User user;
  final int level;
  final dynamic data;

  const Log({
    required this.id,
    required this.message,
    required this.actionTime,
    required this.user,
    required this.level,
    required this.data,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      message: json['message'],
      actionTime: json['action_time'],
      user: User.fromJson(json['user']),
      level: json['level'],
      data: json['data'],
    );
  }
}
