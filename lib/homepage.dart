
import 'dart:async';
import 'dart:convert';

import 'package:final_ecommerce/categories.dart';
import 'package:final_ecommerce/menu.dart';
import 'package:final_ecommerce/product_detail.dart';
import 'package:final_ecommerce/seller%20page.dart';
import 'package:final_ecommerce/productdata.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

import 'login.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  static List foundUser = [];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String userId = '';
  MyAllProducts? myAllProducts;
  List userDataS = [];
  bool showProgress = true;
  bool showAll = false;
  String getImage = '';
  String email = '';
  String user = '';
  List id = [];
  List title = [];
  List description = [];
  List price = [];
  List discount = [];
  List stock = [];
  List brand = [];
  List category = [];
  List thumbnail = [];
  List images = [];
  int totalLength = 0;
  List<Map<String,dynamic>> combinedList = [];


  TextEditingController controller = TextEditingController();
  late PageController pageController;
  List adds = ['images/add1.jpg','images/add2.jpg','images/add3.jpg'];
  bool listen = false;
  int itemLength = 0;

  SpeechToText speechToText = SpeechToText();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget endDrawer(){
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () {
          scaffoldKey.currentState!.openEndDrawer();
        },
        child: Card(
          color: Colors.grey.shade800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
          child: const SizedBox(
            height: 47,
            width: 47,
            child: Icon(Icons.menu,color: Colors.white,),
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    HomePage.foundUser.clear();
    // TODO: implement initState
    super.initState();
    viewData();

    setState(() {
      userId = Splash.pref.getString('userid')??'user';
    });

    print('method s legth ========== $totalLength');
    getProfileImage();

    pageController = PageController(initialPage: 0);
    HomePage.foundUser.addAll(Data.productList);
    userDataS.addAll(Data.productList);

    Future.delayed(const Duration(seconds: 2),() {
      setState(() {
        showProgress = false;
      });
    },);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: Drawer(
          backgroundColor: Colors.grey.shade300,
          child: ListView(
            children: [
              DrawerHeader(padding: const EdgeInsets.all(10),child: Container(
                child: Row(
                  children: [
                     Card(
                       elevation : 5,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                       child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: getImage != '' ? ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.network("$path$getImage",fit: BoxFit.cover,height: 100,width: 100,)) : Image.asset("images/user.png",fit: BoxFit.cover,height: 100,width: 100,),
                                           ),
                     ),
                    const SizedBox(width: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user,style: const TextStyle(fontWeight: FontWeight.bold),),
                        Text(email,style: TextStyle(fontSize: 11,color: Colors.pink.shade800),),
                      ],
                    ),
                  ],
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    showDialog(
                      barrierColor: Colors.grey,
                      context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text('Seller Mode'),
                        content: SizedBox(
                          height: 300,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(image: AssetImage('images/seller.png'))
                                ),
                              ),
                              const SizedBox(height: 50,),
                              Text("in Seller Mode you don't able to view or buy any other Products.",style: TextStyle(color: Colors.pink.shade900),),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: const Text('Back')),

                          TextButton(onPressed: () {
                            Splash.pref.setBool('seller', true);
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                              return const Seller1();
                            },));
                          }, child: const Text('Continue')),
                        ],
                      );
                    },
                      barrierDismissible: false,
                    );
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  tileColor: Colors.grey.shade800,
                  leading: Icon(Icons.shopping_cart_rounded,color: Colors.grey.shade200,),title: const Text('Start Selling',style: TextStyle(fontSize: 15,fontFamily: 'Font-1',color: Colors.white
                ),),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    Splash.pref.setBool('login', false);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return const Login();
                    },));
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  tileColor: Colors.grey.shade800,
                  leading: Icon(Icons.logout,color: Colors.grey.shade200,),title: const Text('Log Out',style: TextStyle(fontSize: 15,fontFamily: 'Font-1',color: Colors.white
                ),),),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
            toolbarHeight: 75,
            backgroundColor: Colors.transparent,
            title: Container(
              height: 175,
              width: 155,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('images/lshop.png'),fit: BoxFit.cover,filterQuality: FilterQuality.high)),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 1),
                child: InkWell(
                  onTap: () {
                    setState(()  async {
                      if(listen == false){
                        var available = await speechToText.initialize();
                        if(available){
                          listen = true;
                          speechToText.listen(
                            onResult: (result) {
                              controller.text = result.recognizedWords;
                              runVal(controller.text);
                            },
                          );
                        }

                        Future.delayed(const Duration(seconds: 3),() {
                          setState(() {
                            listen = false;
                          });
                        },);
                      }
                      else{
                        listen = false;
                        speechToText.stop();
                      }
                    });
                  },
                  child: Card(
                    color: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                    child: const SizedBox(
                      height: 47,
                      width: 47,
                      child: Icon(Icons.mic,color: Colors.white,),
                    ),
                  ),
                ),
              ),

              endDrawer(),
            ],
            bottom: PreferredSize(preferredSize: const Size(double.infinity, 50), child: Padding(
              padding: const EdgeInsets.only(left: 5,right: 5),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: TextField(
                    controller: controller,
                    onChanged: (value) {
                      runVal(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,color: Colors.grey.shade600,),
                      suffixIcon: InkWell(onTap: () {
                        setState(() {
                          controller.text = '';
                          runVal(controller.text);
                        });
                      },child: Icon(Icons.clear,color: Colors.grey.shade600,)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ))
        ),
        body: showProgress ? const Center(child: CircularProgressIndicator()) : HomePage.foundUser.isNotEmpty ? SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: Colors.grey.shade400,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7,left: 5,top: 10,bottom: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                String text = "toys";
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return Categories(text,userId);
                                },));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 5,
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset('images/toys.png',height: 70,width: 70,),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text('Toys',style: TextStyle(fontSize: 15,fontFamily: 'Font-1',color: Colors.grey.shade900),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7,top: 10,bottom: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                String text = "mobiles";
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return Categories(text, userId);
                                },));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 5,
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: Image.asset('images/iphone.png',width: 58,height: 58,),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text('Mobiles',style: TextStyle(fontSize: 15,fontFamily: 'Font-1',color: Colors.grey.shade900),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7,top: 10,bottom: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                String text = "books";
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return Categories(text, userId);
                                },));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 5,
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset('images/books.png',height: 58,width: 58),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text('Books',style: TextStyle(fontSize: 15,fontFamily: 'Font-1',color: Colors.grey.shade900),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7,top: 10,bottom: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                String text = "fashion";
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return Categories(text, userId);
                                },));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 5,
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset('images/fashion.png',height: 48,width: 45,),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text('Fashion',style: TextStyle(fontSize: 15,fontFamily: 'Font-1',color: Colors.grey.shade900),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7,top: 10,bottom: 10,),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                String text = "electronic";
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return Categories(text, userId);
                                },));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 5,
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset('images/headphone.png',height: 55,width: 55),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text('Electro..',style: TextStyle(fontSize: 15,fontFamily: 'Font-1',color: Colors.grey.shade900),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7,top: 10,bottom: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const Menu();
                                },));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 5,
                                child: const CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text('...',style: TextStyle(fontSize: 25),)
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text('More..',style: TextStyle(fontSize: 15,fontFamily: 'Font-1',color: Colors.grey.shade900),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4,),
              SizedBox(
                height: 240,
                child: PageView.builder(itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(image: AssetImage('${adds[index]}'),fit: BoxFit.fill,filterQuality: FilterQuality.high),
                      ),
                    ),
                  );
                },
                  itemCount: adds.length,
                  controller: pageController,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 270,childAspectRatio: 12), itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    String productId = HomePage.foundUser[index]['id'].toString();
                    String title = HomePage.foundUser[index]['title'].toString();
                    String des = HomePage.foundUser[index]['description'].toString();
                    String price = HomePage.foundUser[index]['price'].toString();
                    String dis = HomePage.foundUser[index]['discountPercentage'].toString();
                    String rating = HomePage.foundUser[index]['rating'].toString();
                    String stock = HomePage.foundUser[index]['stock'].toString();
                    String brand = HomePage.foundUser[index]['brand'].toString();
                    String category = HomePage.foundUser[index]['category'].toString();
                    String thumbnail = HomePage.foundUser[index]['thumbnail'].toString();
                    List<String> images = HomePage.foundUser[index]['images'];
                    String userid = userId;

                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ProductDetail(title,des,price,dis,rating,stock,brand,category,images,thumbnail,userid,productId);
                    },));
                  },
                  child: Card(
                    color: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Container(
                            height: 170,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(image: NetworkImage('${HomePage.foundUser[index]['thumbnail']}'),filterQuality: FilterQuality.high,fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            height: 76,
                            width: 200,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10,top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${HomePage.foundUser[index]['title']}',maxLines: 1,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                  Text('${HomePage.foundUser[index]['brand']}',style: TextStyle(fontSize: 12,color: Colors.pink.shade800),),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Align(alignment: Alignment.bottomRight,child: Text('${HomePage.foundUser[index]['price']} /-',style: const TextStyle(fontSize: 15,color: Colors.pink,fontWeight: FontWeight.bold),)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
                itemCount: HomePage.foundUser.length,
              ),
            ],
          ),
        ) : const Center(child: Text('No Item Found')),
      ),
    );
  }

  void runVal(String enterKeyword) {

    List result = [];

    if (enterKeyword.isEmpty) {
      result = userDataS;
    } else {
      result = userDataS
          .where((element) => element['title']
          .toLowerCase()
          .contains(enterKeyword.toLowerCase().trim()))
          .toList();
    }

    setState(() {
      HomePage.foundUser = result;
    });
  }

  Future<void> getProfileImage() async {

    String userid = Splash.pref.getString('userid')??"userid";
    Map map = {'userid' : userid};
    var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/viewProfileData.php");
    var response = await http.post(url,body: map);
    var mm = jsonDecode(response.body);
    MyRegisterClass myRegisterClass = MyRegisterClass.fromJson(mm);
    setState(() {
      getImage = myRegisterClass.profiledata!.image!;
      email = myRegisterClass.profiledata!.email!;
      user = myRegisterClass.profiledata!.username!;
    });

  }

  String path = "https://swarming-sash.000webhostapp.com/php/";
  List<List<String>> imgUrls = [];
  Map map = {};

  Future<void> viewData() async {

    var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/viewAllProducts.php");
    var response = await http.get(url);

    var mm = jsonDecode(response.body);
    myAllProducts = MyAllProducts.fromJson(mm);
    print(response.body);

    List<String> imgPath = [];

    print('imgPath length == == == ${imgPath.length}');
    print('imgPath length == == == ${imgPath}');
    print('imgPath length == == == ${imgPath.runtimeType}');

      for(int i=0; i<myAllProducts!.productdata!.length; i++){
        imgPath = myAllProducts!.productdata![i].images!.map((e) => '$path$e').toList();
        combinedList.add({
          "id": myAllProducts!.productdata![i].id!,
          "title": myAllProducts!.productdata![i].title!,
          "description": myAllProducts!.productdata![i].description!,
          "price": myAllProducts!.productdata![i].price!,
          "discountPercentage": myAllProducts!.productdata![i].discountPercentage!,
          "stock": myAllProducts!.productdata![i].discountPercentage!,
          "brand": myAllProducts!.productdata![i].brand!,
          "category": myAllProducts!.productdata![i].category!,
          "thumbnail": '$path${myAllProducts!.productdata![i].thumbnail!}',
          "images" : imgPath
        });

      }
    setState(() {

      print('founduser l before === ${HomePage.foundUser.length}');
      HomePage.foundUser.addAll(combinedList);
      print('founduser l after === ${HomePage.foundUser.length}');

    });

      print('combinedList =========== ============ ========= $combinedList');
      print('combinedList =========== ============ ========= ${combinedList.length}');

  }
}

class MyRegisterClass {
  Profiledata? profiledata;

  MyRegisterClass({this.profiledata});

  MyRegisterClass.fromJson(Map<String, dynamic> json) {
    profiledata = json['profiledata'] != null
        ? Profiledata.fromJson(json['profiledata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

class MyAllProducts {
  List<Productdata>? productdata;

  MyAllProducts({this.productdata});

  MyAllProducts.fromJson(Map<String, dynamic> json) {
    if (json['productdata'] != null) {
      productdata = <Productdata>[];
      json['productdata'].forEach((v) {
        productdata!.add(Productdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productdata != null) {
      data['productdata'] = productdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Productdata {
  String? id;
  String? title;
  String? description;
  String? price;
  String? discountPercentage;
  String? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;

  Productdata(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.discountPercentage,
        this.stock,
        this.brand,
        this.category,
        this.thumbnail,
        this.images});

  Productdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    discountPercentage = json['discountPercentage'];
    stock = json['stock'];
    brand = json['brand'];
    category = json['category'];
    thumbnail = json['thumbnail'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['discountPercentage'] = discountPercentage;
    data['stock'] = stock;
    data['brand'] = brand;
    data['category'] = category;
    data['thumbnail'] = thumbnail;
    data['images'] = images;
    return data;
  }
}







