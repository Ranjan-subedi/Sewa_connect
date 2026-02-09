import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sewa_connect/model/userModel.dart';
import 'package:http/http.dart' as http;

class Auth {
  //postman
  // String baseUrl = "http://localhost:3000/";
  // emulator
  // String baseUrl = "http://10.0.2.2:3000/";
  // real phone
  String baseUrl = "http://192.168.1.70:3000/";




  Future signIn({required UserModel registrationDetail})async{
    final response = await http.post(
      Uri.parse(baseUrl+"registerUser"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(registrationDetail.tojson()),
    );

    if(response.statusCode == 201){
      print("User added Successfully $response");
    }else{
      print("Something went wrong $response");
    }
  }

  Future logIn({required BuildContext context, required LogInModel loginDetail})async{
    try{
      String message;
      final response = await http.post(
        Uri.parse(baseUrl+"loginUser"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginDetail.tojson()),
      );

      print(response.statusCode);
      print(response.body);

      if(response.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully LogIn".toString())));
        return jsonDecode(response.body);
      }else{
        print("Something went wrong $response");
        final errmessage = jsonDecode(response.body)['message'] ?? "SomeSomething went wrong";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errmessage.toString())));
        return null;
      }

    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      print("Something went wrong while logIn : $e");
      return null ;
    }
  }

}