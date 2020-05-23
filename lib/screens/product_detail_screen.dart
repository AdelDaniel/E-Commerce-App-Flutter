import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider_model.dart';

import '../providers/product_list_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String pageRoute = 'Product Detail Screen' ;

  @override
  Widget build(BuildContext context) {

    final String id = ModalRoute.of(context).settings.arguments as String;
    final currentProduct =
      Provider.of<ProductProvider>(context).getProducts.firstWhere(
        (product) => product.id == id
      );



//    final Product currentProduct = Provider.of<Product>(context,listen: true) ;

    return Scaffold(
      appBar: AppBar(title: Text(currentProduct.title),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 10 ,bottom: 5),
              alignment: Alignment.bottomLeft,
              height: MediaQuery.of(context).size.height /4,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: currentProduct.imageUrl !=null ?
                  NetworkImage(currentProduct.imageUrl ,)
                      :AssetImage('Assets/images/no-image-available.jpg' , ),


//                  NetworkImage(
//                    currentProduct.imageUrl,
//                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Text(
                currentProduct.title ,
                style: Theme.of(context).textTheme.title.copyWith(
                    backgroundColor: Theme.of(context).primaryColor,
                    decorationThickness: 30 ,
                )
              )
            ),
            const SizedBox(height: 10,),
            const Text('Product Detail' , style: TextStyle(color: Colors.black45),),
            const SizedBox(height: 5,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(currentProduct.price.toString()),
                  Text(currentProduct.description),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
