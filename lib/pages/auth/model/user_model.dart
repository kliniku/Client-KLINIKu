class UserModel {
  String? email;
  String? address;
  String? firstName;
  String? lastName;
  String? phoneNum;
  String? tokenUser;

  UserModel(
      {this.email,
      this.address,
      this.firstName,
      this.lastName,
      this.phoneNum,
      this.tokenUser});

  // Terima data dari server
  factory UserModel.fromMap(map) {
    return UserModel(
        email: map['email'],
        address: map['address'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        phoneNum: map['phoneNum'],
        tokenUser: map['tokenUser']);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': address,
      'lastName': lastName,
      'address': address,
      'phoneNum': phoneNum,
      'tokenUser': tokenUser
    };
  }
}
