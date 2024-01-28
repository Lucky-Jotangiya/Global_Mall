import 'dart:convert';

import 'package:final_ecommerce/enter.dart';
import 'package:final_ecommerce/main.dart';
import 'package:final_ecommerce/product_detail.dart';
import 'package:final_ecommerce/productdata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';


class Cart extends StatefulWidget {

  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  bool progress = true;
  int itemLength = 0;
  late GetData getData;
  int checkout = 0;
  String userid = "";


  String passEmail = '';
  String passPassword = '';
  String passUser = '';
  String passUserid = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userid = Splash.pref.getString('userid')??'userid';
    Future.delayed(const Duration(seconds: 3),() {
      setState(() {
        progress = false;
      });
    },
    );

    setState(() {
       passEmail = Splash.pref.getString('email')??"null";
       passPassword = Splash.pref.getString('password')??"null";
       passUser = Splash.pref.getString('user')??"null";
       passUserid = Splash.pref.getString('userid')??"null";
    });
    print('print userid ==== $userid');
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
      toolbarHeight: 65,
        backgroundColor: Colors.grey.shade400,
        title:Text('$checkout /-',style: const TextStyle(fontFamily: 'Font-1',color: Colors.black,fontSize: 25,),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: InkWell(
              onTap: () {
                payment();
              },
              child: Card(
                color: Colors.deepOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(child: Icon(Icons.currency_rupee,color: Colors.white,size: 20,),),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Card(
              color: Colors.deepOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                onTap: () async {

                  String userId = passUserid;
                  Map map = {'userid' : userId};

                  var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/deleteallCartdata.php");
                  var response = await http.post(url,body: map);
                  var mm = jsonDecode(response.body);

                  DeleteAllCartData deleteAll = DeleteAllCartData.fromJson(mm);

                  if(deleteAll.result == 1){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Items Deleted !')));
                    cartRefresh();
                  }

                },
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(child: Icon(Icons.delete,color: Colors.white,size: 20,),),
                ),
              ),
            ),
          ),
        ],
      ),
      body: progress ? const Center(child: CircularProgressIndicator()) : itemLength == 0 ? const Center(child: Text('No Items')) :  Column(
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 15),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: InkWell(
                        onTap: () {
                          String? getDes = getData.mydata![index].productid;
                          int i = int.parse(getDes!);
                          print('product id ====== $i');

                          String? title = getData.mydata![index].title;
                          String des = Data.productList[i-1]['description'].toString();
                          String? price = getData.mydata![index].price;
                          String? dis = Data.productList[i-1]['discountPercentage'].toString();
                          String? rating = Data.productList[i-1]['rating'].toString();
                          String? stock = Data.productList[i-1]['stock'].toString();
                          String? brand = getData.mydata![index].brand;
                          String? category = Data.productList[i-1]['category'].toString();
                          List<String>? images = Data.productList[i-1]['images'];
                          String? thumbnail = getData.mydata![index].thumbnail;
                          String? userid = getData.mydata![index].userid;
                          String? productId = getData.mydata![index].productid;

                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return ProductDetail(title,des,price,dis,rating,stock,brand,category,images,thumbnail,userid,productId);
                          },));
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),image: DecorationImage(image: NetworkImage('${getData.mydata![index].thumbnail}'),fit: BoxFit.fill)),
                                  ),
                                ),

                                const SizedBox(height: 20,),

                                Row(
                                  children: [
                                    Card(
                                      color: Colors.grey.shade800,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      child: InkWell(
                                        onTap: () async {
                                          String? qty = getData.mydata![index].qty;
                                          int qty1 = int.parse(qty!);
                                          if(qty1 !=1){
                                            setState(() {
                                              qty1--;
                                              getData.mydata![index].qty = qty1.toString();
                                            });

                                            Map map = {
                                              'id' : getData.mydata![index].id,
                                              'qty' : getData.mydata![index].qty
                                            };

                                            var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/updateQty.php");
                                            var response = await http.post(url,body: map);

                                            var mm = jsonDecode(response.body);

                                            UpdateClass updateClass = UpdateClass.fromJson(mm);

                                            if(updateClass.connection == 1){
                                              if(updateClass.result == 1){
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantity Removed')));
                                              }
                                            }
                                            cartRefresh();
                                          }

                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                          child: const Icon(Icons.remove,color: Colors.white,size: 15,),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 15,),
                                    Text('${getData.mydata![index].qty}',style: const TextStyle(fontSize: 15),),
                                    const SizedBox(width: 15,),

                                    Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      child: InkWell(
                                        onTap: () async {
                                          String? qty = getData.mydata![index].qty;
                                          int qty1 = int.parse(qty!);
                                            if(qty1!=10){
                                              setState(() {
                                                qty1++;
                                              });
                                              getData.mydata![index].qty = qty1.toString();
                                              print('++tapped');
                                              print('==========  ${getData.mydata![index].qty}');

                                              Map map = {
                                                'id' : getData.mydata![index].id,
                                                'qty' : getData.mydata![index].qty
                                              };

                                              var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/updateQty.php");
                                              var response = await http.post(url,body: map);

                                              var mm = jsonDecode(response.body);

                                              UpdateClass updateClass = UpdateClass.fromJson(mm);

                                              if(updateClass.connection == 1){
                                                if(updateClass.result == 1){
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantity Added')));
                                                }
                                              }
                                              cartRefresh();
                                            }
                                            else{
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock finished !')));
                                            }
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                                          child: const Icon(Icons.add,size: 15,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 20,),
                            SizedBox(
                              height: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${getData.mydata![index].title}',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                  Text('${getData.mydata![index].brand}',style: TextStyle(color: Colors.pink.shade800,fontSize: 13),),
                                  const SizedBox(height: 25,),
                                  SizedBox(
                                    width: 240,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${getData.mydata![index].price} /-',style: TextStyle(color: Colors.red.shade600,fontSize: 25,fontFamily: 'Font-1'),),
                                        const SizedBox(width: 30,),
                                        Card(elevation: 6,color: Colors.grey.shade800,child: InkWell(

                                          onTap: () async {
                                            Map map = {'id' : getData.mydata![index].id};
                                            var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/deleteCartData.php");
                                            var response = await http.post(url,body: map);
                                            var m2 = jsonDecode(response.body);
                                            print('response === ${response.body}');
                                            print('response ====== ${response.statusCode}');

                                            DeleteCartData deleteCartData = DeleteCartData.fromJson(m2);

                                            if(deleteCartData.result == 1){
                                              cartRefresh();
                                            }
                                          },

                                          child: const SizedBox(height: 40,width: 40,
                                            child: Center(child: Icon(Icons.delete,color: Colors.white,),),
                                          ),
                                        ),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                  }, separatorBuilder: (context, index) {
                return const SizedBox(height: 50,child: Divider(),);
              }, itemCount: itemLength),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getMyData() async {

    Map map = {'userid' : userid};

    var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/viewcartdata.php");
    var response = await http.post(url,body: map);

    var mm = jsonDecode(response.body);
    getData = GetData.fromJson(mm);
    print('response ====== ${response.statusCode}');
    print(response.body);

    setState(() {
      itemLength = getData.mydata!.toList().length;
      for(int i=0; i<getData.mydata!.toList().length; i++){
        String? amount = getData.mydata![i].price;
        int amount1 = int.parse(amount!);
        String? qty = getData.mydata![i].qty;
        int qty1 = int.parse(qty!);
        int finalAmount = amount1 * qty1;
        checkout = checkout + finalAmount;
      }
    });
  }

  cartRefresh(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Enter(1);
    },));
  }

  void payment() {
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_gMqVM0Rp9YRVxc',
      'amount': checkout*100,
      'name': 'Acp-er',
      'description': 'this is description',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response){
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message){

    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class GetData {
  List<Mydata>? mydata;

  GetData({this.mydata});

  GetData.fromJson(Map<String, dynamic> json) {
    if (json['mydata'] != null) {
      mydata = <Mydata>[];
      json['mydata'].forEach((v) {
        mydata!.add(Mydata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mydata != null) {
      data['mydata'] = mydata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mydata {
  String? id;
  String? title;
  String? brand;
  String? price;
  String? qty;
  String? thumbnail;
  String? userid;
  String? productid;

  Mydata(
      {this.id,
        this.title,
        this.brand,
        this.price,
        this.qty,
        this.thumbnail,
        this.userid,
        this.productid});

  Mydata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    brand = json['brand'];
    price = json['price'];
    qty = json['qty'];
    thumbnail = json['thumbnail'];
    userid = json['userid'];
    productid = json['productid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['brand'] = brand;
    data['price'] = price;
    data['qty'] = qty;
    data['thumbnail'] = thumbnail;
    data['userid'] = userid;
    data['productid'] = productid;
    return data;
  }
}

class UpdateClass {
  int? connection;
  int? result;

  UpdateClass({this.connection, this.result});

  UpdateClass.fromJson(Map<String, dynamic> json) {
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

class DeleteCartData {
  int? connection;
  int? result;

  DeleteCartData({this.connection, this.result});

  DeleteCartData.fromJson(Map<String, dynamic> json) {
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

class DeleteAllCartData {
  int? connection;
  int? result;

  DeleteAllCartData({this.connection, this.result});

  DeleteAllCartData.fromJson(Map<String, dynamic> json) {
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



















