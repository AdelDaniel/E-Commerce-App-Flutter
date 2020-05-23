import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../widgets/order_screen_item.dart';
import '../widgets/my_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = 'Order Screen';
  @override
  Widget build(BuildContext context) {
    /// instance of provider
    final Orders orders= Provider.of<Orders>(context);

    /// using the instance of provider to use getter ;
    final List<OrderItem> allOrders= orders.getOrders;


    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Chip(
            avatar:  Icon(Icons.shopping_cart , color: Theme.of(context).primaryColor,),
            label:Text('Your Cart'),),
        ),
      ),

      body: ListView.builder(
          itemCount: orders.getOrders.length ,
          itemBuilder: (_,index){
            return OrderItemWidget(
              allOrders[index]
            );
          })
    );
  }
}
