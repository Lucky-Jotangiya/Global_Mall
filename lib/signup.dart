import 'dart:convert';
import 'dart:math';

import 'package:final_ecommerce/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController conEmail = TextEditingController();
  TextEditingController conNumber = TextEditingController();
  TextEditingController conPass = TextEditingController();
  TextEditingController conConPass = TextEditingController();
  bool signupIndicator = false;
  bool hidePass = true;
  bool hidePass1 = true;

  var icon = Icons.remove_red_eye_rounded;
  var icon1 = Icons.remove_red_eye_rounded;

  Widget buildSignupScreen() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const SizedBox(
            height: 55,
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
                          height: 450,
                          width: 330,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Container(
                                height: 55,
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
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
                                    controller: conNumber,
                                    decoration: InputDecoration(
                                      hintText: 'Phone Number',
                                      prefixIcon: Icon(
                                        Icons.phone,
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
                                    obscureText: hidePass1,
                                    controller: conConPass,
                                    decoration: InputDecoration(
                                      hintText: 'Confirm Password',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (hidePass1 == true) {
                                              icon1 =
                                                  Icons.remove_red_eye_outlined;
                                              hidePass1 = false;
                                            } else {
                                              icon1 =
                                                  Icons.remove_red_eye_rounded;
                                              hidePass1 = true;
                                            }
                                          });
                                        },
                                        icon: Icon(icon1),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: Colors.grey.shade600,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 53),
                                child: InkWell(
                                  onTap: () {
                                    onPressSignup(conEmail.text, conNumber.text,
                                        conPass.text, conConPass.text);
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
                                          child: signupIndicator
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : const Text(
                                                  'Sign Up',
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
                    bottom: 500,
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
            padding: const EdgeInsets.only(top: 50, left: 170),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Already Have An Account ?",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const Login();
                        },
                      ));
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontSize: 15),
                    )),
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
        body: buildSignupScreen(),
      ),
    );
  }

  Future<void> onPressSignup(String email, String number, String password,
      String confirmPassword) async {
    if (email == '' ||
        number == '' ||
        password == '' ||
        confirmPassword == '') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Enter required Information')));
    } else if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please Match the Passwords')));
    } else {
      setState(() {
        signupIndicator = true;
      });
      Future.delayed(
        const Duration(seconds: 2),
        () {
          setState(() {
            signupIndicator = false;
          });
        },
      );

      Map map = {
        'email': email,
        'number': number,
        'username' : 'user${Random().nextInt(1000)}',
        'password': password,
        'conpass': confirmPassword
      };

      var url =
          Uri.parse("https://swarming-sash.000webhostapp.com/php/register.php");
      var response = await http.post(url, body: map);
      print('response ====== ${response.statusCode}');
      var mm = jsonDecode(response.body);

      MyRegisterClass myRegisterClass = MyRegisterClass.fromJson(mm);

      if (myRegisterClass.connection == 1) {
        if (myRegisterClass.result == 1) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Sign up Successful !')));
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const Login();
            },
          ));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('User Already Exists')));
        }
      }
    }
  }
}

class MyRegisterClass {
  int? connection;
  int? result;

  MyRegisterClass({this.connection, this.result});

  MyRegisterClass.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['connection'] = connection;
    data['result'] = result;
    return data;
  }
}
