class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? fcmToken;
  final String? subscribePlan;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.fcmToken,
    required this.subscribePlan,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    print(data);
    return UserModel(
      id: data["id"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
      fcmToken: data["fcmToken"],
      subscribePlan: data["subscribePlan"],
    );
  }
}
