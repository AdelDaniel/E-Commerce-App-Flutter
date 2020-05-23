
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';

import '../providers/product_provider_model.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';
class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    /// instance of class provider ==> Product ..... to get each product data
    final Product currentProduct = Provider.of<Product>(context,listen: false) ;
    ///another instance of cart class provider to add new product ;
    final Cart currentCart = Provider.of<Cart>(context,listen: false) ;

    print('rebuild product item test ');


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation:  5,
          borderRadius: BorderRadius.circular(15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GridTile(

            child:GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.pageRoute,
                  arguments: currentProduct.id,
                );
              },
              child: currentProduct.imageUrl !=null ?
                Image.network(currentProduct.imageUrl ,fit: BoxFit.cover,)
                :Image.asset('Assets/images/no-image-available.jpg' , fit: BoxFit.cover,),
//            Image.network(
//              currentProduct.imageUrl,
//              fit: BoxFit.cover,
//            ),
            ),
            header: Container(
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15)),
              child: ExpandablePanel(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                header:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    currentProduct.title ,
                    textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.white , fontWeight: FontWeight.w800),),
                ),
                expanded: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    currentProduct.description,
                    textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white ,)
                  ),
                ),
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: FittedBox(child: Text(currentProduct.price.toStringAsFixed(2) , textAlign: TextAlign.center,)),
              ///consumer is the same as provider but changes only a small part in code .. Icon ..
              /// rebuild part of widget tree
              leading:  Consumer<Product>(
                builder: (ctx , product , child )=>IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(currentProduct.isFavorite ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      currentProduct.setFavorite();
                    },
                  ),
              ),
              trailing: IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  currentCart.addItem(currentProduct.id, currentProduct.price, currentProduct.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to Cart'),
                      duration: Duration(seconds: 2),
                      elevation: 10,
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: ()=>currentCart.removeSingleItem(currentProduct.id),
                      ),
                    )
                  );
                },
              ),

            ),

            //        footer: GridTileBar(
            //          backgroundColor: Colors.black87,
            //          leading: IconButton(
            //            icon: Icon(Icons.favorite),
            //            color: Theme.of(context).accentColor,
            //            onPressed: () {},
            //          ),
            //          title: Text(
            //            title,
            //            textAlign: TextAlign.center,
            //          ),
            //          trailing: IconButton(
            //            icon: Icon(
            //              Icons.shopping_cart,
            //            ),
            //            onPressed: () {},
            //            color: Theme.of(context).accentColor,
            //          ),
            //        ),

//          header: Text(
//            '${productData[index].id}',
//            textScaleFactor: 0.6,
//          ),
          ),
        ),
      ),
    );
  }
}