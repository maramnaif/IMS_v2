class UserModel {
  UserModel(this._fullName, this._username, this._email, this._phoneNumber);

  String? _fullName;
  String? _username;
  String? _email;
  String? _phoneNumber;

  // Getters
  String get fullName => _fullName!;
  String get username => _username!;
  String get email => _email!;
  String get phoneNumber => _phoneNumber!;

  // Setters
  set fullName(String value) {
    _fullName = value;
  }

  set username(String value) {
    _username = value;
  }

  set email(String value) {
    _email = value;
  }

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  // toJson method
  Map<String, dynamic> toJson() => {
    'fullName': _fullName,
    'username': _username,
    'email': _email,
    'phoneNumber': _phoneNumber,
  };

  // fromJson method
  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    json['fullName'] as String,
    json['username'] as String,
    json['email'] as String,
    json['phoneNumber'] as String,
  );
}
