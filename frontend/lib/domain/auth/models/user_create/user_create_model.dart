import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_create_model.freezed.dart';
part 'user_create_model.g.dart';

@freezed
class UserCreateModel with _$UserCreateModel {
  const factory UserCreateModel({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
  }) = _UserCreateModel;

  factory UserCreateModel.fromJson(Map<String, dynamic> json) =>
      _$UserCreateModelFromJson(json);
}