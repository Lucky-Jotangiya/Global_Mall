
import 'dart:convert';
import 'dart:io';

import 'package:final_ecommerce/enter.dart';
import 'package:final_ecommerce/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String email = '';
  String password = '';
  String user = '';
  String userId = '';
  String number = '';
  String getImage = '';
  bool show = true;
  bool showIndicator = false;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    userId = Splash.pref.getString('userid')??"userid";
    viewData();

    Future.delayed(const Duration(seconds: 3),() {
      setState(() {
        show = false;
      });
    },);
  }

  TextEditingController conUser = TextEditingController();
  TextEditingController conPass = TextEditingController();
  TextEditingController conNumber = TextEditingController();

  ImagePicker picker = ImagePicker();
  XFile? image;

  Future<void>chooseImage(type) async{
    XFile? pickImage;
    if(type == "camera"){
      pickImage = await picker.pickImage(source: ImageSource.camera);
      Navigator.pop(context);
    }
    else if(type == "gallery"){
      pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      Navigator.pop(context);
    }

    if( pickImage!= null){
      setState(() {
        image = pickImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: const Text('Profile',style: TextStyle(fontFamily: 'Font-1'),),
        actions: [
          IconButton(onPressed: () {
            Splash.pref.setBool('login', false);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return const Login();
            },));
          }, icon: const Icon(Icons.logout)),
        ],
      ),

      body: show ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  Center(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {

                            showModalBottomSheet(context: context, builder: (context) {
                              return SizedBox(
                                height: 150,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Card(
                                      elevation: 10,
                                      color: Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                      child: InkWell(
                                        onTap: () {
                                          chooseImage("gallery");
                                        },
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle
                                          ),
                                          child: const Center(child: Icon(Icons.folder,color: Colors.grey,size: 50,),),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      elevation: 10,
                                      color: Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                      child: InkWell(
                                        onTap: () {
                                          chooseImage("camera");
                                        },
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                          ),
                                          child: const Center(child: Icon(Icons.camera_alt,color: Colors.grey,size: 50,),),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },);
                          },
                          child: Card(
                            elevation: 7,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                            child: image != null ? ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.file(File(image!.path),fit: BoxFit.cover,height: 160,width: 160,)) : getImage != '' ? ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.network("$path$getImage",fit: BoxFit.cover,height: 160,width: 160,))  :  Image.asset('images/user.png',height: 160,width: 160,fit: BoxFit.cover,),
                          ),
                        ),

                        const SizedBox(height: 15,),
                        Text(email,style: TextStyle(fontSize: 16,color: Colors.pink.shade400,fontFamily: 'Font-1'),),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80,),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: TextField(
                          controller: conUser,
                          decoration: InputDecoration(
                            hintText: 'Enter Username',
                            prefixIcon: Icon(Icons.person_outline_rounded,color: Colors.pink.shade400,),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: TextField(
                          controller: conNumber,
                          decoration: InputDecoration(
                            hintText: 'Enter Mobile Number',
                            prefixIcon: Icon(Icons.phone,color: Colors.pink.shade400,),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: TextField(
                          controller: conPass,
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            prefixIcon: Icon(Icons.key,color: Colors.pink.shade400,),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 5,right: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.grey.shade800
              ),
                onPressed: () async {

                setState(() {
                  showIndicator = true;
                });
                Future.delayed(const Duration(seconds: 5),() {
                  setState(() {
                    showIndicator = false;
                  });
                },);
                String store = '';

                Map map = {};
                if(image!=null){
                  store = 'thumb';
                  List<int> ll = File(image!.path).readAsBytesSync();
                  String thumbnail = base64Encode(ll);

                  map = {
                    'userid' : userId,
                    'username' : conUser.text,
                    'phone' : conNumber.text,
                    'password' : conPass.text,
                    'image' : thumbnail,
                    'store' : store
                  };
                  print('thumb');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated !')));

                }
                else if(image == null && user != conUser.text || number != conNumber.text || password != conPass.text){
                  store = 'other';
                  map = {
                    'userid' : userId,
                    'username' : conUser.text,
                    'phone' : conNumber.text,
                    'password' : conPass.text
                  };
                  print('other');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated !')));

                }
                else if(user == conUser.text && number == conNumber.text && password == conPass.text){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Up To Date')));
                }

                var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/updateProfileData.php");
                var response = await http.post(url,body: map).then((value) {});

                Splash.pref.setString('user', conUser.text);
                Splash.pref.setString('pass', conPass.text);
                Splash.pref.setString('number', conNumber.text);

                setState(() {
                  number = conNumber.text;
                  password = conPass.text;
                  user = conUser.text;
                });

            }, child: showIndicator ? const SizedBox(height: 30,width : 30,child: CircularProgressIndicator(color: Colors.white,)) : const Text('Update Profile',style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }
  Future<void> viewData() async {

    var id = Splash.pref.getString('userid')??"userid";
    Map map = {'userid' : id};
    var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/viewProfileData.php");
    var response = await http.post(url,body: map);

    var mm3 = jsonDecode(response.body);
    MyProfileClass myProfileClass = MyProfileClass.fromJson(mm3);

    print(response.body);
    setState(() {
      email = Splash.pref.getString('email')??"email";
      user = myProfileClass.profiledata!.username!;
      password = myProfileClass.profiledata!.password!;
      number = myProfileClass.profiledata!.number!;
      getImage = myProfileClass.profiledata!.image!;

      conUser.text = user;
      conPass.text = password;
      conNumber.text = number;
    });

    print(user);
    print(password);
  }
  String path = "https://swarming-sash.000webhostapp.com/php/";
}

class MyProfileClass {
  int? connection;
  int? result;
  Profiledata? profiledata;

  MyProfileClass({this.connection, this.result, this.profiledata});

  MyProfileClass.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    profiledata = json['profiledata'] != null
        ? Profiledata.fromJson(json['profiledata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['connection'] = connection;
    data['result'] = result;
    if (profiledata != null) {
      data['profiledata'] = profiledata!.toJson();
    }
    return data;
  }
}
class Profiledata {
  String? id;
  String? username;
  String? email;
  String? number;
  String? password;
  String? confirmpassword;
  String? image;

  Profiledata(
      {this.id,
        this.username,
        this.email,
        this.number,
        this.password,
        this.confirmpassword,
        this.image});

  Profiledata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    number = json['number'];
    password = json['password'];
    confirmpassword = json['confirmpassword'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['number'] = number;
    data['password'] = password;
    data['confirmpassword'] = confirmpassword;
    data['image'] = image;
    return data;
  }
}




