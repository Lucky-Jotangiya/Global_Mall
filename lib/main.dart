
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:final_ecommerce/cart.dart';
import 'package:final_ecommerce/enter.dart';
import 'package:final_ecommerce/login.dart';
import 'package:final_ecommerce/seller%20page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Splash(),
    routes: {
      '/home' : (context) => const Splash(),
      '/home1' : (context) => HomePage(),
      '/goto' : (context) => Seller1(),
      '/gocart' : (context) => Cart()
    },
  ));
}

class Splash extends StatefulWidget {

  static late SharedPreferences pref;

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {

  bool login = false;
  String? user;
  String? email;
  String? pass;
  String? userid;
  bool sellerMode = false;
  String? number = '';

  @override
  void initState() {
    loginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: AnimatedSplashScreen(
        backgroundColor: Colors.transparent,
        splash: Image.asset('images/lshop.png',height: 230,width: 230,),
        nextScreen: login ? sellerMode ? const Seller1() : Enter() : const Login(),
        splashTransition: SplashTransition.rotationTransition,
        splashIconSize: 230,
        animationDuration: const Duration(seconds: 2),
        curve: Curves.bounceIn,
      ),
    );
  }

  Future<void> loginStatus() async {
    Splash.pref = await SharedPreferences.getInstance();
    login = Splash.pref.getBool('login')??false;
    email = Splash.pref.getString('email')??'xyz@gmail.com';
    user = Splash.pref.getString('user')??'user';
    pass = Splash.pref.getString('pass')??'pass123';
    userid = Splash.pref.getString('userid')??'userid';
    sellerMode = Splash.pref.getBool('seller')??false;
    number = Splash.pref.getString('number')??'number';
    setState(() {
    });
  }
}



