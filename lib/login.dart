import 'dart:convert';

import 'package:final_ecommerce/enter.dart';
import 'package:final_ecommerce/main.dart';
import 'package:final_ecommerce/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController conEmail = TextEditingController();
  TextEditingController conPass = TextEditingController();
  bool loginIndicator = false;
  bool hidePass = true;
  var icon = Icons.remove_red_eye_rounded;

  Widget loginScreen() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 600,
              // color: Colors.blue,
              child: Stack(
                children: [
                  Center(
                    child: Card(
                      color: Colors.grey.shade400,
                      child: SizedBox(
                          height: 400,
                          width: 325,
                          child: Column(
                            children: [
                              Container(
                                height: 55,
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 70),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: TextField(
                                    controller: conEmail,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.grey.shade600,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 55,
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: TextField(
                                    obscureText: hidePass,
                                    controller: conPass,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (hidePass == true) {
                                              icon =
                                                  Icons.remove_red_eye_outlined;
                                              hidePass = false;
                                            } else {
                                              icon =
                                                  Icons.remove_red_eye_rounded;
                                              hidePass = true;
                                            }
                                          });
                                        },
                                        icon: Icon(icon),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.key,
                                        color: Colors.grey.shade600,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 165),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forget Password ?',
                                      style: TextStyle(
                                          color: Colors.grey.shade800),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 85),
                                child: InkWell(
                                  onTap: () {
                                    onPressLogin(conEmail.text, conPass.text);
                                  },
                                  child: Card(
                                    color: Colors.grey.shade800,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      margin:
                                          const EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                          child: loginIndicator
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : const Text(
                                                  'Login',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Positioned(
                    left: 165,
                    top: 35,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/user.png'),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 155),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't Have An Account ?",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return const Signup();
                          },
                        ));
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 15),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('images/loginbg.jpg')),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: loginScreen(),
      ),
    );
  }

  Future<void> onPressLogin(String email, String password) async {
    if (email == '' || password == '') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Enter Required Information')));
    } else {
      setState(() {
        loginIndicator = true;
      });
      Future.delayed(
        const Duration(seconds: 2),
        () {
          setState(() {
            loginIndicator = false;
          });
        },
      );

      Map map = {
        'email': email,
        'password': password,
      };

      var url =
          Uri.parse("https://swarming-sash.000webhostapp.com/php/login.php");
      var response = await http.post(url, body: map);
      print('response ====== ${response.statusCode}');
      print('response ====== ${response.body}');

      var mm = jsonDecode(response.body);

      MyLoginClass myLoginClass = MyLoginClass.fromJson(mm);

      if (myLoginClass.result == 1) {
        String? email = myLoginClass.register!.email;
        String? password = myLoginClass.register!.password;
        String? userid = myLoginClass.register!.id;
        String? user = myLoginClass.register!.username;
        Splash.pref.setString('email', email!);
        Splash.pref.setString('user', user!);
        Splash.pref.setString('pass', password!);
        Splash.pref.setString('userid', userid!);

        Splash.pref.setBool('login', true);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login Successful !')));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Enter();
          },
        ));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No User Found')));
      }
    }
  }
}

class MyLoginClass {
  int? connection;
  int? result;
  Register? register;

  MyLoginClass({this.connection, this.result, this.register});

  MyLoginClass.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    register = json['register'] != null
        ? Register.fromJson(json['register'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['connection'] = connection;
    data['result'] = result;
    if (register != null) {
      data['register'] = register!.toJson();
    }
    return data;
  }
}

class Register {
  String? id;
  String? username;
  String? email;
  String? number;
  String? password;
  String? confirmpassword;

  Register(
      {this.id,
        this.username,
        this.email,
        this.number,
        this.password,
        this.confirmpassword});

  Register.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    number = json['number'];
    password = json['password'];
    confirmpassword = json['confirmpassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['number'] = number;
    data['password'] = password;
    data['confirmpassword'] = confirmpassword;
    return data;
  }
}



