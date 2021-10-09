import 'package:chat_app/fireBAseHelper.dart';
import 'package:chat_app/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login Page',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter Your E-mail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                ),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80)
                ),
                onPressed: () async {
                  SharedPreferences pref = await SharedPreferences.getInstance();

                  if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                    service.loginUser(context, emailController.text, passwordController.text);
                    
                    // chek if have one user logged
                    pref.setString("email", emailController.text);
                  } else {
                    service.errorBox(context, "Fields must not em,pty please provide valid email and password");
                  }
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Text("I don't have any account?"),
              )
            ],
          ),
        ),
      ),
    );
  }
}