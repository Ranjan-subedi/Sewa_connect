import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/model/userModel.dart';
import 'package:sewa_connect/pages/register_page.dart';
import 'package:sewa_connect/services/auth.dart';
import 'package:sewa_connect/services/sharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'adminpage.dart';

class AdminLogInPage extends StatefulWidget {
  const AdminLogInPage({super.key});

  @override
  State<AdminLogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<AdminLogInPage> {
  Auth auth = Auth();


  late GlobalKey<FormState> formKey;

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();


  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    // emailFirst();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(emailNode);
    },);
  }


  Future adminLogin()async{
  try{
    final result = await FirebaseFirestore.instance.
    collection("admin").where("user_name", isEqualTo: usernameController.text.trim()).get();

  if(result.docs.isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not found")));
    return ;
  }
  final adminData= result.docs.first.data();

  if(adminData["password"] != passwordController.text.trim()){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password is incorrect")));
    return ;
  }else{
    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage(),));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Log In Success")));
  }
  }catch(e){

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Admin LogIn"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),

                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    focusNode: emailNode,
                    controller: usernameController,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passwordNode);
                    },

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      // if (!value.contains("@")) {
                      //   return "Email is not valid";
                      // }
                      // if (!value.contains(".")) {
                      //   return "Email is not valid";
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    focusNode: passwordNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      // if (value.length < 8) {
                      //   return "Password must be at least 8 characters long";
                      // }
                      return null;
                    },
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  child: Row(
                    children: [
                      RichText(text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Don't have an account?  ",
                                style: TextStyle(color: Theme.of(context).colorScheme.primary)
                            ),
                            TextSpan(
                                recognizer: TapGestureRecognizer()..onTap=(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(),));
                                },
                                text: "Register",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    color: Theme.of(context).colorScheme.primary)
                            )
                          ]
                      ))
                      // Text("Don't have an account?"),

                    ],
                  ),
                ),

                SizedBox(height: 40),

                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(),
                    ),
                    onPressed: () async {
                      if(formKey.currentState!.validate()) {
                        print("Email: ${usernameController.text}");
                        print("Password: ${passwordController.text}");
                        adminLogin();
                      }
                    },
                    child: Text("Log In"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
