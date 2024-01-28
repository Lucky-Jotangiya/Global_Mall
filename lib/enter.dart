import 'package:final_ecommerce/homepage.dart';
import 'package:final_ecommerce/profile%20screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'cart.dart';
import 'menu.dart';

class Enter extends StatefulWidget {

  int? i;
  Enter([this.i]);


  @override
  State<Enter> createState() => _EnterState();
}

class _EnterState extends State<Enter> {

  int selectedIndex = 0;

  List<Widget> pages = [
    HomePage(),
    const Cart(),
    const Menu(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();

    if(widget.i == 1){
      setState(() {
        selectedIndex = 1;
      });
    }
    else{
      setState(() {
        selectedIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.grey.shade800,
        child: Padding(
          padding:  const EdgeInsets.symmetric(horizontal: 15,vertical: 3),
          child: GNav(
            selectedIndex: selectedIndex,
            backgroundColor: Colors.transparent,
            color: Colors.white,
            activeColor: Colors.white,
            gap: 8,
            padding:  const EdgeInsets.all(16),
            tabs: const [
              GButton(icon: Icons.home_filled,text: 'Home',),
              GButton(icon: Icons.shopping_cart_outlined,text: 'Cart',),
              GButton(icon: Icons.menu,text: 'Menu',),
              GButton(icon: Icons.perm_identity_outlined,text: 'Profile',),
            ],

            onTabChange: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
        ),
      ),
      body: Center(child: pages.elementAt(selectedIndex)),
    );
  }
}
