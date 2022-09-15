class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.secondName,
  });

  // Receive
  factory UserModel.fromJson(json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      firstName: json['firstName'],
      secondName: json['secondName'],
    );
  }

  // Send
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
    };
  }
}
