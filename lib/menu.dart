import 'package:final_ecommerce/categories.dart';
import 'package:final_ecommerce/main.dart';
import 'package:flutter/material.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  String passEmail = '';
  String passPassword = '';
  String passUser = '';
  String passUserid = '';

  List cat = ['Toys','Mobiles','Books','Fashion','Electronic'];
  List catImages = [
    "https://m.media-amazon.com/images/I/91BWoyChTRL._SX522_.jpg",
    "https://m.media-amazon.com/images/I/818VqDSKpCL._SX569_.jpg",
    "https://m.media-amazon.com/images/I/81TwewImvVL._SL1500_.jpg",
    "https://m.media-amazon.com/images/I/61ai5LJMmjL._SY879_.jpg",
    "https://m.media-amazon.com/images/I/71PonEAqrmL._SX522_.jpg"
  ];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      passEmail = Splash.pref.getString('email')??"null";
      passPassword = Splash.pref.getString('password')??"null";
      passUser = Splash.pref.getString('user')??"null";
      passUserid = Splash.pref.getString('userid')??"null";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(backgroundColor: Colors.grey.shade400,title: const Text('Menu',style: TextStyle(fontFamily: 'Font-1'),),),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisExtent: 190), itemBuilder: (context, index) {

          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: InkWell(
              onTap: () {
                String? userid = Splash.pref.getString('userid');
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Categories(cat[index].toString().toLowerCase(), userid);
                },));
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(alignment: Alignment.topLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text('${cat[index]}',style: const TextStyle(fontFamily: 'Font-1',fontSize: 15),),
                      )),
                      ClipRRect(borderRadius: BorderRadius.circular(5),child: Image.network('${catImages[index]}',height: 110,width: 110,)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: cat.length,
        ),
      ),
    );
  }
}
