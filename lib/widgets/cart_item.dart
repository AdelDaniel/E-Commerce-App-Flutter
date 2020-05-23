import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {

  final String productId ; // the key is the same of== product id
  final String id ; // is just time date
  final String title ;
  final double price;
  final int quantity ;
  CartItem({@required this.productId,@required this.id,@required this.quantity,@required this.price,@required this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
//      confirmDismiss: (dd){
//         return ;
//      },
      key: ValueKey(id)  ,
      background: Container(
        margin:  const EdgeInsets.symmetric(horizontal: 10 ,vertical: 5),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.centerRight,
        color: Colors.red ,
        child: Chip(
          elevation: 5,
          avatar: Icon(Icons.delete),
          label: Text('Remove' , style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold , color: Colors.black),),
        ),
      ),
      onDismissed: (dd){
        Provider.of<Cart>(context,listen: false).deleteItem(productId);
      },
      direction: DismissDirection.endToStart,

      child: Card(
        borderOnForeground: false,
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 10 ,vertical: 5),
        child: ListTile(
          isThreeLine: true,
          title: Text(title),
          subtitle: Text(' 1 picec: \$ ${price.toString()}'),
          trailing: Text(' x${quantity.toString()}' ,style: TextStyle(fontWeight: FontWeight.bold),),

          leading: Stack(
          alignment: Alignment.center,
          children:<Widget>[
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor,
              //child: Text( 'total'),
            ),
            Container(
              width: 60 ,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: FittedBox(child: Text( '${(price*quantity).toStringAsFixed(2)}')),
            )
          ] ,
            ),
          //trailing: ,

        ),
      ),
    );
  }
}
