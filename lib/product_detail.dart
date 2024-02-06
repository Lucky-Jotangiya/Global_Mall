import 'dart:convert';

import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:final_ecommerce/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'cart.dart';

class ProductDetail extends StatefulWidget {

  String? title;
  String? des;
  String? price;
  String? dis;
  String? rating;
  String? stock;
  String? brand;
  String? category;
  List<String>? images;
  String? thumbnail;
  String? userid;
  String? productId;

  ProductDetail([this.title, this.des, this.price, this.dis, this.rating, this.stock, this.brand, this.category, this.images, this.thumbnail, this.userid, this.productId]);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {

  List stock = [];
  String path = "https://swarming-sash.000webhostapp.com/php/";
  bool check = false;
  bool showIndicator = false;

  @override
  void initState() {

     setState(() {
       check= Splash.pref.getBool('seller')??false;
     });
    // TODO: implement initState
    super.initState();

  }

  String selectedValue = '1';
  String qty1 = "1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.title}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  Text('${widget.brand}',style: TextStyle(color: Colors.pink.shade800),),
                ],
              ),
            ),

            const SizedBox(height: 15,),

            FanCarouselImageSlider(
              sliderHeight: 410,
              autoPlay: true,
              imagesLink: widget.images!,
              isAssets: false,
              initalPageIndex: 0,
              sidesOpacity: 0.7,
              imageFitMode: BoxFit.fitHeight,
            ),

            const SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('In Stock',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.pink.shade900),),
                  const SizedBox(width: 20,),
                  SizedBox(
                    width: 60,
                    child: DropDown(
                      items: const ["1", "2", "3","4","5","6","7","8","9","10"],
                      initialValue: "1",
                      isExpanded: true,
                      icon: Icon(
                        Icons.expand_more,
                        color: Colors.grey.shade900,
                      ),
                      onChanged: (p0) {
                        print('qty === $p0');
                        setState(() {
                          qty1 = p0!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(right: 10,left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {

                        setState(() {
                          showIndicator = true;
                        });

                        Future.delayed(const Duration(seconds: 5),() {
                          setState(() {
                            showIndicator = false;
                          });
                        },);

                        addToCartProcess();
                      },
                      child: Card(
                        color: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                        child: SizedBox(
                          height: 60,
                          child: showIndicator ? const Center(child: SizedBox(height: 30,width: 30,child: CircularProgressIndicator(color: Colors.white,),)) : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,color: Colors.white,),
                              SizedBox(width: 10,),
                              Text('Add To Cart',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        payment();
                      },
                      child: Card(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                        child: const SizedBox(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.currency_rupee,color: Colors.white,),
                              SizedBox(width: 10,),
                              Text('Buy Now',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20,),

            ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,title: const Text('Description',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('${widget.price} /-',style: TextStyle(fontSize: 30,color: Colors.pink.shade800,fontWeight: FontWeight.bold,fontFamily: 'Font-1'),),
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.only(left: 15,top: 20,bottom: 20),
                child: Text('${widget.des}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Category',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.pink.shade800,),),
                        const SizedBox(width: 50,),
                        Text('${widget.category}',style: const TextStyle(fontSize: 15,color: Colors.pink),),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Text('Discount',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.pink.shade800,),),
                        const SizedBox(width: 50,),
                        Text('${widget.dis} %',style: const TextStyle(fontSize: 15,color: Colors.pink),),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(),

            ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addToCartProcess() async {

    String userId = Splash.pref.getString('userid')??'userid';

     Map map = { 'userid' : userId };

     var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/getProductIds.php");
     var response = await http.post(url,body: map);
     print('===== ${response.body}');

     var m3 = jsonDecode(response.body);
    GetProductIds getProductIds = GetProductIds.fromJson(m3);

     if(getProductIds.productIds!.contains(widget.productId)){
       print('yes');
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Already Added In Cart')));
     }
     else{
       print(widget.productId);
       print(getProductIds.productIds);

       String qty = qty1;
       String title = widget.title!;
       String brand = widget.brand!;
       String thumbnail = widget.thumbnail!;
       String price = widget.price!;
       String? userid = widget.userid;
       String productId = widget.productId!;

       Map map = {
         'title' : title,
         'brand' : brand,
         'price' : price,
         'qty' : qty,
         'thumbnail' : thumbnail,
         'userid': userid,
         'productId' : productId
       };

       var url = Uri.parse('https://swarming-sash.000webhostapp.com/php/cart.php');
       var response = await http.post(url, body: map);
       print('response ====== ${response.statusCode}');
       var mm = jsonDecode(response.body);

       MyCartClass myCartClass = MyCartClass.fromJson(mm);

       if (myCartClass.connection == 1) {
         if (myCartClass.result == 1) {
           Navigator.pop(context);

           ScaffoldMessenger.of(context)
               .showSnackBar(const SnackBar(content: Text('Added To Cart !')));
           Navigator.push(context, MaterialPageRoute(builder: (context) {
             return const Cart();
           },));
         } else {
           ScaffoldMessenger.of(context)
               .showSnackBar(const SnackBar(content: Text('error')));
         }
       }
     }
  }

  void payment() {

    String? p1 = widget.price;
    int p2 = int.parse(p1!);
    int p3  = p2 * 100;

    Razorpay razorpay = Razorpay();
              var options = {
                'key': 'rzp_test_gMqVM0Rp9YRVxc',
                'amount': p3,
                'name': widget.title,
                'description': widget.des,
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

class MyCartClass {
  int? connection;
  int? result;

  MyCartClass({this.connection, this.result});

  MyCartClass.fromJson(Map<String, dynamic> json) {
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

class GetProductIds {
  List<String>? productIds;

  GetProductIds({this.productIds});

  GetProductIds.fromJson(Map<String, dynamic> json) {
    productIds = json['productIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productIds'] = productIds;
    return data;
  }
}


