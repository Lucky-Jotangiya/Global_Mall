import 'package:final_ecommerce/product_detail.dart';
import 'package:final_ecommerce/productdata.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {

  String text;
  String? userid;
  Categories(this.text, this.userid, {super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List showData = [];

  @override
  void initState() {
    // TODO: implement initState
    if(widget.text == "toys"){
      setState(() {
        showData.addAll(Data.toys);
      });
    }
    else if(widget.text == "mobiles"){
      setState(() {
        showData.addAll(Data.mobile);
      });
    }
    else if(widget.text == "books"){
      setState(() {
        showData.addAll(Data.books);
      });
    }
    else if(widget.text == "fashion"){
      setState(() {
        showData.addAll(Data.fashion);
      });
    }
    else if(widget.text == "electronic"){
      setState(() {
        showData.addAll(Data.electronic);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.text,style: const TextStyle(fontFamily: 'Font-1'),),
      ),
      body: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 270,childAspectRatio: 12), itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            String productId = showData[index]['id'].toString();
            String title = showData[index]['title'].toString();
            String des = showData[index]['description'].toString();
            String price = showData[index]['price'].toString();
            String dis = showData[index]['discountPercentage'].toString();
            String rating = showData[index]['rating'].toString();
            String stock = showData[index]['stock'].toString();
            String brand = showData[index]['brand'].toString();
            String category = showData[index]['category'].toString();
            String thumbnail = showData[index]['thumbnail'].toString();
            List<String> images = showData[index]['images'];
            String? userid = widget.userid;

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
                      image: DecorationImage(image: NetworkImage('${showData[index]['thumbnail']}'),filterQuality: FilterQuality.high,fit: BoxFit.cover),
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
                          Text('${showData[index]['title']}',maxLines: 1,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          Text('${showData[index]['brand']}',style: TextStyle(fontSize: 12,color: Colors.pink.shade800),),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Align(alignment: Alignment.bottomRight,child: Text('${showData[index]['price']} /-',style: const TextStyle(fontSize: 15,color: Colors.pink,fontWeight: FontWeight.bold),)),
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
        itemCount: showData.length,
      ),
    );
  }
}
