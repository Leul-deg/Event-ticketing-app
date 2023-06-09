

import 'package:equatable/equatable.dart';

class EmailAddress extends Equatable {
  final email;
  final RegExp emailRegex = RegExp(
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""");
  EmailAddress(this.email) {
    if (email.isEmpty) {
      throw Exception('Name can not be empty');
    }
    if (!emailRegex.hasMatch(email)) {
      throw Exception('Name must contain only alphabets');
    }
    if (email.isEmpty) {
      throw Exception('Name can not be empty');
    }
  }

  isValid() {
    return emailRegex.hasMatch(email);
  }

  factory EmailAddress.fromJson(Map<String, dynamic> json) {
    return EmailAddress(json['email']);
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  @override
  List<Object> get props => [email];

}
