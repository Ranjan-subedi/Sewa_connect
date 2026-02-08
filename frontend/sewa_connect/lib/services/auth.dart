import 'package:sewa_connect/model/userModel.dart';
import 'package:http/http.dart' as http;

class Auth {
  String baseUrl = "http://localhost:3000/";


  Future signIn({required UserModel userDetail})async{
    final response = await http.post(
      Uri.parse(baseUrl+"addUser"),
      headers: {"Content-Type": "applicatio/json"},
      body: userDetail.tojson(),
    );

    if(response.statusCode == 201){
      print("User added Successfully $response");
    }else{
      print("Something went wrong $response");
    }
  }

}