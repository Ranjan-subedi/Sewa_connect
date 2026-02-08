
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/pages/log_in_page.dart';
import 'package:sewa_connect/services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late GlobalKey<FormState> fromKey;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController nameController;

  FocusNode nameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode submitNode = FocusNode();




  @override
  void initState() {
    super.initState();
    fromKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    // emailFirst();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(nameNode);
    },);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    nameNode.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    submitNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Register Page"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: fromKey,
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
                    focusNode: nameNode,
                    controller: nameController,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(emailNode);
                    },

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      if (!value.contains("@")) {
                        return "Name is not valid";
                      }
                      if (!value.contains(".")) {
                        return "Name is not valid";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Name",
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
                    focusNode: emailNode,
                    controller: emailController,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passwordNode);
                    },

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      if (!value.contains("@")) {
                        return "Email is not valid";
                      }
                      if (!value.contains(".")) {
                        return "Email is not valid";
                      }
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
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(confirmPasswordNode);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }
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

                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    focusNode: confirmPasswordNode,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(submitNode);
                    },
                    validator: (value) {
                      if(passwordController.text != value){
                        return "Password is not match";
                      }
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                    controller: confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Comform Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  child: Row(
                    children: [
                      RichText(text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Already have an account?  ",
                                style: TextStyle(color: Theme.of(context).colorScheme.primary)
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()..onTap= (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage(),));
                              },
                                text: "Login",
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
                    focusNode: submitNode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(),
                    ),
                    onPressed: () {
                      if(fromKey.currentState!.validate()){
                        print("Email: ${emailController.text}");
                        print("Password: ${passwordController.text}");

                        Map<String, dynamic> userDetail;
                        // userDetail = {
                        //   'name': emailController.text,
                        //   'email': emailController.text,
                        // }
                        // Auth().signIn(userDetail: )
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
