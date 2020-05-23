import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/user_product_screen.dart';
import './screens/oder_screen.dart';
import './providers/order_provider.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './providers/product_list_provider.dart';
import './providers/product_provider_model.dart';
import './screens/add_or_edit_product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // at the root of all widgets the need the provider we add " ChangeProviderNotifier"
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
        value :ProductProvider(),),

        ChangeNotifierProvider.value(
            value: Cart()),

        ChangeNotifierProvider.value(
            value: Orders()),
      ],

          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: ProductOverviewScreen(),
            routes: {
              ProductOverviewScreen.routeName : (context) => ProductOverviewScreen(),
              ProductDetailScreen.pageRoute : (context) => ProductDetailScreen(),
              CartScreen.routeName : (context) => CartScreen(),
              OrderScreen.routeName : (context) => OrderScreen(),
              UserProductScreen.routeName : (context) => UserProductScreen(),
              AddOREditProduct.routeName : (context) => AddOREditProduct(),
            },
          ),

    );
  }
}
