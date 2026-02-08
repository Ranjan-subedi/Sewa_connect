

class UserModel {
  final String name;
  final String email;
  final String password;


  UserModel({
    required this.name,
    required this.email,
    required this.password,
});


  factory UserModel.fromjson(Map<String, dynamic> json){
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password']
  );
  }

  Map<String, dynamic> tojson(){
    return{
      'name': name,
      'email': email,
      'password': password,
    };
  }

}