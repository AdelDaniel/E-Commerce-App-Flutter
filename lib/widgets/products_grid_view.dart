import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/product_list_provider.dart';
import '../providers/product_provider_model.dart';
import 'product_item.dart';

class ProductsGridView extends StatelessWidget {
  final bool _showOnlyFavorite ;
  const ProductsGridView(this._showOnlyFavorite);


  @override
  Widget build(BuildContext context) {

    ///this is for create object (instance) of class ProductProvider .... to get favorite or all products;
    final productProvide = Provider.of<ProductProvider>(context, listen: true);
    /// this to call only the getter method
    List<Product> productData;
    _showOnlyFavorite ?
      productData = productProvide.getProducts.where((product)=> product.isFavorite).toList()
      : productData = productProvide.getProducts;


    return GridView.builder(
        itemCount: productData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2/3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),

//        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//          childAspectRatio: 3 / 2,
//          maxCrossAxisExtent: 200,
//          crossAxisSpacing: 10,
//          mainAxisSpacing: 10,
//        ),
        itemBuilder: (ctx, index) {
          //to use the provider at widget put notifier in the root
          return ChangeNotifierProvider.value(
            // root of product provider model
            value: productData[index],
            child:  ProductItem(),
          );
        });
  }
}

