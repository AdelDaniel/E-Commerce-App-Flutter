import 'package:flutter/material.dart';


import '../screens/product_overview_screen.dart';
import '../screens/user_product_screen.dart';
import '../screens/oder_screen.dart';
class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Welcome to The Shop'),
            automaticallyImplyLeading: false,
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('The Shop'),
            onTap: (){
              Navigator.of(context).pushNamed(ProductOverviewScreen.routeName);
            },
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.face),
            title: Text('Your Products'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
            },
          ),

        ],
      ),
    );
  }
}
