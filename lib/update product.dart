import 'dart:convert';
import 'dart:io';

import 'package:final_ecommerce/seller%20page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class UpdateProduct extends StatefulWidget {

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
  String id1;
  UpdateProduct(this.id1,this.title1, this.des1, this.dis1, this.price1, this.rating1, this.stock1, this.brand1, this.category1, this.thumbnail1, this.images1, {super.key});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {

  String email = '';
  String password = '';
  String user = '';
  String userId = '';
  bool showIndicator = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      conTitle.text = widget.title1;
      conDescription.text = widget.des1;
      conDiscount.text = widget.dis1;
      conPrice.text = widget.price1;
      conStock.text = widget.stock1;
      conBrand.text = widget.brand1;
      conCategory.text = widget.category1;

       email = Splash.pref.getString('email')??'email';
       password = Splash.pref.getString('pass')??'pass';
       user = Splash.pref.getString('user')??'user';
       userId = Splash.pref.getString('userid')??'userid';
    });
  }

  TextEditingController conTitle = TextEditingController();
  TextEditingController conDescription = TextEditingController();
  TextEditingController conPrice = TextEditingController();
  TextEditingController conDiscount = TextEditingController();
  TextEditingController conStock = TextEditingController();
  TextEditingController conBrand = TextEditingController();
  TextEditingController conCategory = TextEditingController();
  String path = "https://swarming-sash.000webhostapp.com/php/";

  final ImagePicker picker = ImagePicker();
  XFile? image;
  List<XFile> images = [];
  List<String> base64Images = [];

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
    else{
      List<XFile>? pickImages = await picker.pickMultiImage();
      if(pickImages.isNotEmpty){
        setState(() {
          widget.images1.clear();
           images = pickImages;
        });
      }
    }

    if(pickImage!= null){
      setState(() {
        widget.thumbnail1 = '';
        image = pickImage;
      });
    }
  }
  Widget buildAddProduct(){
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),

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
                                    shape: BoxShape.circle
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: widget.thumbnail1 != '' ? ClipRRect(borderRadius: BorderRadius.circular(11),child: Image.network('$path${widget.thumbnail1}',fit: BoxFit.fill,)) : image!=null ? ClipRRect(borderRadius: BorderRadius.circular(11),child: Image.file(File(image!.path),fit: BoxFit.fill,)) : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(11),child: const Icon(Icons.add_a_photo,color: Colors.grey,size: 100,),),
                        const SizedBox(height: 20,),
                        const Text('Tap To Add Thumbnail',style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5,),
              
              images.isNotEmpty ?
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: images.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8,bottom: 8,right: 5),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.file(File(e.path),fit: BoxFit.fill,)),
                            ),
                          ),
                        );
                      }).toList(),
                    ) 
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        chooseImage('add more images');
                      },
                      child: const SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(child: Text('Add More Images',style: TextStyle(color: Colors.grey),)),
                      ),
                    ),
                  ),
                ],
              )
                  :
              Column(
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.images1.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8,bottom: 8,right: 5),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network(e,fit: BoxFit.fill,),),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        chooseImage('add more images');
                      },
                      child: const SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(child: Text('Add More Images',style: TextStyle(color: Colors.grey),)),
                      ),
                    ),
                  ),
                ],
              ) ,

              const SizedBox(height: 5),

              Card(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: conTitle,
                    decoration: const InputDecoration(
                        hintText: 'Title',
                        prefixIcon: Icon(Icons.title_outlined,color: Colors.grey,),
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: conDescription,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Description',
                        prefixIcon: Icon(Icons.description_outlined,color: Colors.grey,),
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller:  conPrice,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Price',
                        prefixIcon: Icon(Icons.currency_rupee_outlined,color: Colors.grey,),
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: conDiscount,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Discount Percentage',
                        prefixIcon: Icon(Icons.discount_outlined,color: Colors.grey,),
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: conStock,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Stock',
                        prefixIcon: Icon(Icons.production_quantity_limits_outlined,color: Colors.grey,),
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: conBrand,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Brand',
                        prefixIcon: Icon(Icons.branding_watermark_outlined,color: Colors.grey,),
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: conCategory,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Category',
                        prefixIcon: Icon(Icons.category,color: Colors.grey,),
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Update Product',style: TextStyle(fontFamily: 'Font-1'),),
      ),
       body:  Column(
         children: [
           Expanded(child: buildAddProduct()),
           Container(
             height: 50,
             width: double.infinity,
             margin: const EdgeInsets.all(10),
             child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.grey.shade800,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                   foregroundColor: Colors.white,
                 ),
                 onPressed: () async {

                   setState(() {
                     showIndicator  = true;
                   });
                   Future.delayed(const Duration(seconds: 6),() {
                     setState(() {
                       showIndicator = false;
                     });
                   },);
                   print(base64Images);
                   String id = widget.id1;
                   String title = conTitle.text;
                   String description = conDescription.text;
                   String discount = conDiscount.text;
                   String price = conPrice.text;
                   String stock = conStock.text;
                   String brand = conBrand.text;
                   String category = conCategory.text;
                   List<String> images2 = widget.images1;
                   String thumbnail2 = widget.thumbnail1;
                   String userId = Splash.pref.getString('userid')??"null";

                   for(var image in images){
                     List<int> imageBytes = await image.readAsBytes();
                     String base64Image = base64Encode(imageBytes);
                     print(base64Image);
                       base64Images.add(base64Image);
                   }

                   String thumbnail3 = '';
                   String length = base64Images.length.toString();
                   print('============ length $length');

                 //  true - convert // false - not convert
                   String store = '';

                   if(image != null){

                     List<int> ll = File(image!.path).readAsBytesSync();
                     thumbnail3 = base64Encode(ll);
                     setState(() {
                       store = 'thumb';
                     });
                     Map map = {
                        'id' : id,
                        'title' : title,
                        'description' : description,
                        'price' : price,
                        'discount' : discount,
                        'stock' : stock,
                        'brand' : brand,
                        'category' : category,
                       'thumbnail' : thumbnail3,
                       'userid' : userId,
                       'store' : store,
                     };
                      var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/updateProduct.php");
                      var response = await http.post(url,body: map);
                      print('thumb updated');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Update Successful !')));
                      setState(() {
                        image = null;
                      });
                     Navigator.pushNamedAndRemoveUntil(context, '/goto', (route) => false);


                   }
                   else if(images.isNotEmpty){
                     print('yes');
                     setState(() {
                       store = 'image';
                     });
                     Map  map = {
                        'id' : id,
                        'title' : title,
                        'description' : description,
                        'price' : price,
                        'discount' : discount,
                        'stock' : stock,
                        'brand' : brand,
                        'category' : category,
                       'images' : base64Images.join(','),
                       'userid' : userId,
                       'imageLength' : length,
                       'store' : store,
                     };

                     var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/updateProduct.php");
                     var response = await http.post(url,body: map);
                     print('sub updated');
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Update Successful !')));
                     setState(() {
                       images.clear();
                     });

                     Navigator.pushNamedAndRemoveUntil(context, '/goto', (route) => false);


                   }
                   else if(image != null && images.isNotEmpty){
                     setState(() {
                       store = 'both';
                     });

                     Map map = {
                       'id' : id,
                       'title' : title,
                       'description' : description,
                       'price' : price,
                       'discount' : discount,
                       'stock' : stock,
                       'brand' : brand,
                       'category' : category,
                       'thumbnail' : thumbnail3,
                       'images' : base64Images.join(','),
                       'userid' : userId,
                       'imageLength' : length,
                       'store' : store,
                     };

                     var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/updateProduct.php");
                     var response = await http.post(url,body: map);
                     print('thumb and sub updated');
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Update Successful !')));
                     setState(() {
                       image = null;
                       images.clear();
                     });
                     Navigator.pushNamedAndRemoveUntil(context, '/goto', (route) => false);


                   }
                   else if(conTitle.text != widget.title1 || conDescription.text != widget.des1 || conPrice.text != widget.price1 || conDiscount.text != widget.dis1 || conStock.text != widget.stock1 ||  conBrand.text != widget.brand1 || conCategory.text != widget.category1){
                     setState(() {
                       store = 'other';
                     });
                     Map map = {
                       'id' : id,
                       'title' : title,
                       'description' : description,
                       'price' : price,
                       'discount' : discount,
                       'stock' : stock,
                       'brand' : brand,
                       'category' : category,
                       'userid' : userId,
                       'store' : store,
                     };

                     var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/updateProduct.php");
                     var response = await http.post(url,body: map);
                     print('other updated');
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Update Successful !')));

                     Navigator.pushNamedAndRemoveUntil(context, '/goto', (route) => false);

                   }
                   else if(store == ''){
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product Up To Date")));
                     print('no updated');
                   }

                 }, child: showIndicator ? const SizedBox(height: 30,width: 30,child: CircularProgressIndicator(color: Colors.white,),) : const Text('Update Product')),

           ),
         ],
       ),
    );
  }
}
