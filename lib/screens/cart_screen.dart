
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' ;


import 'oder_screen.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/order_provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName ='Cart Screen';

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context,listen: true) ;
    final orderNow = Provider.of<Orders>(context , listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart'),),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: RaisedButton.icon(
                onPressed: (){
                  orderNow.addOrder(cart.getCartItems.values.toList(), cart.totalCost );
                  cart.clear();
                  Navigator.pushNamed(context, OrderScreen.routeName);
                },
                elevation: 5,
                icon: Icon(Icons.shopping_cart), label: Text('Order Now'),
              ),
            ),
          ),

          Card(
            elevation: 8,
            margin: const EdgeInsets.all(8),
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Total:  ' , style: TextStyle(fontSize: 25,),),
                    Chip(
                      label: Text(
                        '\$ ${cart.totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold , fontSize: 20),
                      ),
                      elevation: 5,
                      backgroundColor: Theme.of(context).primaryColor,
                      ),
                    const Spacer(),
                  ],
                ),
            )
          ),

          const SizedBox(height: 5,),
          Expanded(
            child: ListView.builder(
                itemCount: cart.numberOfDifferentProducts,
                itemBuilder: (_ , index){
                  return CartItem(
                    /// instanceaName.getter.values of map . to list

                    productId :cart.getCartItems.keys.toList()[index],
                    id :cart.getCartItems.values.toList()[index].id,
                    title :cart.getCartItems.values.toList()[index].title,
                    price : cart.getCartItems.values.toList()[index].price,
                    quantity : cart.getCartItems.values.toList()[index].quantity,
                  );
                }),
          )
        ],
      ),
    );
  }
}
