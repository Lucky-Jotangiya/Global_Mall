import 'dart:convert';
import 'dart:io';

import 'package:final_ecommerce/seller%20page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'main.dart';


class AddProduct extends StatefulWidget {
  const AddProduct({super.key});
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  String? email = '';
  String? password = '';
  String? user = '';
  String? userId = '';

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    base64Images.clear();
    email = Splash.pref.getString('email');
    password = Splash.pref.getString('pass');
    user = Splash.pref.getString('user');
    userId = Splash.pref.getString('userid');

    Future.delayed(const Duration(seconds: 10),() {
      setState(() {
        showIndicator = false;
      });
    },);
  }

  TextEditingController conTitle = TextEditingController();
  TextEditingController conDescription = TextEditingController();
  TextEditingController conPrice = TextEditingController();
  TextEditingController conDiscount = TextEditingController();
  TextEditingController conStock = TextEditingController();
  TextEditingController conBrand = TextEditingController();
  TextEditingController conCategory = TextEditingController();

  final ImagePicker picker = ImagePicker();
  XFile? image;
  List<XFile> images = [];
  List<String> base64Images = [];
  bool showIndicator = false;

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
      setState(() {
        images = images + pickImages;
      });
        }

    if( pickImage!= null){
      setState(() {
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
                    child: image!=null ? ClipRRect(borderRadius: BorderRadius.circular(11),child: Image.file(File(image!.path),fit: BoxFit.fill,)) : Column(
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

              images != null ?
                  Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: images.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8,bottom: 8,right: 5),
                              child: InkWell(
                                onLongPress: () {
                                  setState(() {
                                    for(int i=0; i<images.length; i++){
                                      if(images[i] == e){
                                        images.removeAt(i);
                                      }
                                    }
                                  });
                                },
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
                              ),
                            );
                          }).toList(),
                        ),
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
      appBar: AppBar(
        title: const Text('Add Product',style: TextStyle(fontFamily: 'Font-1'),),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.grey.shade300,
      body: Column(
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
                    showIndicator = true;
                  });
              String title = conTitle.text;
              String description = conDescription.text;
              String price = conPrice.text;
              String discount = conDiscount.text;
              String stock = conStock.text;
              String brand = conBrand.text;
              String category = conCategory.text;
              String? userId = Splash.pref.getString('userid');

              List<int> ll = File(image!.path).readAsBytesSync();
              String thumbnail = base64Encode(ll);


              for(var image in images){
                List<int> imageBytes = await image.readAsBytes();
                String base64Image = base64Encode(imageBytes);
                print(base64Image);
                base64Images.add(base64Image);
              }

              String length = base64Images.length.toString();

              Map map = {
                'title' : title,
                'description' : description,
                'price' : price,
                'discount' : discount,
                'stock' : stock,
                'brand' : brand,
                'category' : category,
                'thumbnail' : thumbnail,
                'images' : base64Images.join(','),
                'userid' : userId,
                'imageLength' : length
              };

              if(image == null || title == '' || description == '' || price == '' || discount == '' || stock == '' || brand == '' || category == ''){
                print('nono');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Fill Required Info")));
              }
              else{
                print('hello');
                var url = Uri.parse("https://swarming-sash.000webhostapp.com/php/addProduct.php");
                var response = await http.post(url,body: map);
                print(response.body);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Added !')));
                Navigator.pushNamedAndRemoveUntil(context, '/goto', (route) => false);
              }

            }, child: showIndicator ? const SizedBox(height: 30,width: 30,child: CircularProgressIndicator(color: Colors.white,),) : const Text('Add Product')),

          ),
        ],
      ),
    );
  }
}
