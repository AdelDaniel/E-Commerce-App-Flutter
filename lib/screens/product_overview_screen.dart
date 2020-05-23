
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_product_screen.dart';
import '../providers/product_list_provider.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid_view.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import '../widgets/my_drawer.dart';

enum selectFavorite{
  Favorite,
  all,
  yourProducts
}
class ProductOverviewScreen extends StatefulWidget {
  static const String routeName ='Product Overview Screen';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}



class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorite = false , _showSpinner = true  ;

/// same as didChange......
//  @override
//  void initState() async {
//    await Provider.of<ProductProvider>(context,listen: false).getDataFromFirebase();
//    super.initState();
//  }


  bool firstTime = true ;
  @override
  void didChangeDependencies() async {
    if(firstTime){
      await Provider.of<ProductProvider>(context,listen: true).getDataFromFirebase();
      _showSpinner = false ;
    }
    firstTime =false ;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final cart = Provider.of<Cart>(context,listen: false);
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (selectedFavorite){
              setState(() {
                if(selectedFavorite == selectFavorite.Favorite ){
                  _showOnlyFavorite=true;
                }else if(selectedFavorite == selectFavorite.all ){
                  _showOnlyFavorite=false;
                }else{
                  Navigator.of(context).pushNamed(UserProductScreen.routeName);
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_)=> [
              PopupMenuItem(child: Text('All.'),value: selectFavorite.all ,),
              PopupMenuItem(child: Text('Favorite.'),value: selectFavorite.Favorite ,),
              PopupMenuItem(child: Text('Your Products.'),value: selectFavorite.yourProducts ,),
            ],
          ),

          Consumer<Cart>(
            builder: (ctx , cart , child )=> Badge(
                child: child,
                value: cart.totalItemsCount.toString() ),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: (){
                  Navigator.of(context).pushNamed(CartScreen.routeName) ;
                }),
          ),

        ],
        title: Text('The Shop'),
      ),
       body: _showSpinner ? Center(child: CircularProgressIndicator())
           :RefreshIndicator(
           onRefresh: Provider.of<ProductProvider>(context).refresh ,child: ProductsGridView(_showOnlyFavorite)),
//      body: Consumer<ProductProvider>(
//        builder: (_,products,child) => ProductsGridView(),),
    );
  }
}
