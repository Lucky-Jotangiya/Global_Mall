import 'dart:convert';

import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:final_ecommerce/seller%20page.dart';
import 'package:final_ecommerce/update%20product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';


class SellerProductDetail extends StatefulWidget {

  String title1;
  String des1;
  String dis1;
  String price1;
  String rating1;
  String stock1;
  String brand1;
  String category1;
  String thumbnail1;
  List<String> images1;
  String? userid;
  String id1;
  SellerProductDetail(this.id1,this.title1, this.des1, this.price1, this.dis1, this.rating1, this.stock1, this.brand1, this.category1, this.thumbnail1,this.images1, this.userid, {super.key});


  @override
  State<SellerProductDetail> createState() => _SellerProductDetailState();
}

class _SellerProductDetailState extends State<SellerProductDetail> {

  String email = '';
  String password = '';
  String user = '';
  String userId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      email = Splash.pref.getString('email')??"email";
      password = Splash.pref.getString('pass')??"pass";
      user = Splash.pref.getString('user')??"user";
      userId = Splash.pref.getString('userid')??"userid";
    });

  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(backgroundColor: Colors.transparent,

        actions: [
          IconButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return UpdateProduct(
                widget.id1,
              widget.title1,
                widget.des1,
                widget.dis1,
                widget.price1,
                widget.rating1,
                widget.stock1,
                widget.brand1,
                widget.category1,
                widget.thumbnail1,
                widget.images1,
              );
            },));

          }, icon: const Icon(Icons.update)),

          IconButton(onPressed: () async {

            Map map = {'id' : widget.id1};
            var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/deleteProduct.php");
            var response = await http.post(url,body: map);

            var mm = jsonDecode(response.body);
            DeleteProduct deletePro = DeleteProduct.fromJson(mm);

            if(deletePro.result == 1){
              Navigator.pushNamedAndRemoveUntil(context, '/goto', (route) => false);
            }

          }, icon: const Icon(Icons.delete_outline))
        ],
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
                Text(widget.title1,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                Text(widget.brand1,style: TextStyle(color: Colors.pink.shade800),),
              ],
            ),
          ),

          const SizedBox(height: 50,),

          FanCarouselImageSlider(
            sliderHeight: 410,
            autoPlay: true,
            imagesLink: widget.images1,
            isAssets: false,
            initalPageIndex: 0,
            sidesOpacity: 0.7,
            imageFitMode: BoxFit.fitHeight,
          ),

          const SizedBox(height: 70,),

          ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,title: const Text('Description',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('${widget.price1} /-',style: TextStyle(fontSize: 30,color: Colors.pink.shade800,fontWeight: FontWeight.bold,fontFamily: 'Font-1'),),
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.only(left: 15,top: 20,bottom: 20),
                child: Text(widget.des1,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
                        Text(widget.category1,style: const TextStyle(fontSize: 15,color: Colors.pink),),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Text('Discount',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.pink.shade800,),),
                        const SizedBox(width: 50,),
                        Text('${widget.dis1} %',style: const TextStyle(fontSize: 15,color: Colors.pink),),
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
}


class DeleteProduct {
  int? connection;
  int? result;

  DeleteProduct({this.connection, this.result});

  DeleteProduct.fromJson(Map<String, dynamic> json) {
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
