import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/model/userModel.dart';
import 'package:sewa_connect/pages/register_page.dart';
import 'package:sewa_connect/services/auth.dart';
import 'nav_bar.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  Auth auth = Auth();

  late GlobalKey<FormState> formKey;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();


  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // emailFirst();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(emailNode);
    },);
  }

  @override
  void dispose() {
    emailController.dispose();
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
        title: Text("LogIn Page"),
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
                      if(formKey.currentState!.validate()){
                        print("Email: ${emailController.text}");
                        print("Password: ${passwordController.text}");

                        try{
                          final result = await auth.logIn(context: context, loginDetail:  LogInModel(

                            email: emailController.text.trim().toLowerCase(),
                            password: passwordController.text.trim()
                        ));

                        if(!mounted){return ;}
                        print(result);
                        if(result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login Successful')));
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => NavBar(),));
                        }
                        }catch(e){
                          if(!mounted){return ;}
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed $e')));
                        }



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
