import 'dart:convert';
import 'package:final_ecommerce/add_product.dart';
import 'package:final_ecommerce/main.dart';
import 'package:final_ecommerce/seller%20product%20detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Seller1 extends StatefulWidget {
  const Seller1({super.key});
  @override
  State<Seller1> createState() => _Seller1State();
}

class _Seller1State extends State<Seller1> {

  ViewProduct? viewPro;
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
  bool progress = true;
  String getImage = '';
  String email = '';
  String user = '';

  @override
  void initState() {
    // TODO: implement initState
    viewData();
    getProfileImage();

    Future.delayed(const Duration(seconds: 3),() {
      setState(() {
        progress = false;
      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        title: const Text('My Products',style: TextStyle(fontFamily: 'Font-1',),),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade300,
        child: ListView(
          children: [
            DrawerHeader(padding: const EdgeInsets.all(10),child: Container(
              child: Row(
                children: [
                  Card(
                    elevation: 10,
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
                  Splash.pref.setBool('seller', false);
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                tileColor: Colors.grey.shade800,
                leading: Icon(Icons.shopping_cart_rounded,color: Colors.grey.shade200,),title: const Text('Normal Mode',style: TextStyle(fontSize: 15,fontFamily: 'Font-1',color: Colors.white
              ),),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AddProduct();
                  },));
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                tileColor: Colors.grey.shade800,
                leading: Icon(Icons.add,color: Colors.grey.shade200),title: const Text('Add Product',style: TextStyle(fontSize: 15,fontFamily: 'Font-1',color: Colors.white
              ),),),
            ),
          ],
        ),
      ),
      body: progress ? const Center(child: CircularProgressIndicator(),) : viewPro!.productdata!.isNotEmpty ?  GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 270,childAspectRatio: 12), itemBuilder: (context, index) {
        return InkWell(

          onTap: () {

            String id1 = id[index];
            String title1 = title[index];
            String des1 = description[index];
            String price1 = price[index];
            String dis1 = discount[index];
            String rating1 = '24';
            String stock1 = stock[index];
            String brand1 = brand[index];
            String category1 = category[index];
            String thumbnail1 = thumbnail[index];
            List<String> images1 = imgUrls[index];
            String? userid = Splash.pref.getString('userid')??'userid';

           Navigator.push(context, MaterialPageRoute(builder: (context) {
             return SellerProductDetail(id1,title1,des1,price1,dis1,rating1,stock1,brand1,category1,thumbnail1,images1,userid);
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
                      image: DecorationImage(image: NetworkImage('$path${thumbnail[index]}'),filterQuality: FilterQuality.high,fit: BoxFit.cover),
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
                          Text(title[index],maxLines: 1,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          Text(brand[index],style: TextStyle(fontSize: 12,color: Colors.pink.shade800),),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Align(alignment: Alignment.bottomRight,child: Text('${price[index]} /-',style: const TextStyle(fontSize: 15,color: Colors.pink,fontWeight: FontWeight.bold),)),
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
        itemCount: length,
      ) : const Center(child: Text('No Products Added')),
    );
  }

  Future<void> viewData() async {
    String userid  = Splash.pref.getString('userid')??'userid';

    Map map = {'userid' : userid};

    var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/viewAddedProduct.php");
    var response = await http.post(url,body: map);
    var mm2 = jsonDecode(response.body);
    viewPro = ViewProduct.fromJson(mm2);

    print(response.body);

      setState(() {
        length = viewPro!.productdata!.length;
      });

     for(int i=0; i<viewPro!.productdata!.length; i++){
       setState(() {
         id.add(viewPro!.productdata![i].id);
         title.add(viewPro!.productdata![i].title);
         description.add(viewPro!.productdata![i].description);
         price.add(viewPro!.productdata![i].price);
         discount.add(viewPro!.productdata![i].discountPercentage);
         stock.add(viewPro!.productdata![i].stock);
         brand.add(viewPro!.productdata![i].brand);
         category.add(viewPro!.productdata![i].category);
         category.add(viewPro!.productdata![i].category);
         thumbnail.add(viewPro!.productdata![i].thumbnail);
         images.add(viewPro!.productdata![i].images);
       });
     }

     for(List<String> imgList in images){
       List<String> imgUrlList = [];
       for(String imgName in imgList){
         String imgUrl = '$path$imgName';
         imgUrlList.add(imgUrl);
       }
       imgUrls.add(imgUrlList);
     }

     print(imgUrls);

  }
  int length=0;
  String path = "https://swarming-sash.000webhostapp.com/php/";
  List<List<String>> imgUrls = [];
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
class ViewProduct {
  List<Productdata>? productdata;

  ViewProduct({this.productdata});

  ViewProduct.fromJson(Map<String, dynamic> json) {
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
        this.images,
      });

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



