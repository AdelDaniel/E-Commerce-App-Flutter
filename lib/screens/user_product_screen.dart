import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';

import '../providers/product_provider_model.dart';
import '../widgets/my_drawer.dart';
import '../screens/add_or_edit_product.dart';
import '../providers/product_list_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = "User Product Screen";
  final _scaffoldKey = GlobalKey<ScaffoldState>();

//  @override
//  _UserProductScreenState createState() => _UserProductScreenState();
//}
//
//class _UserProductScreenState extends State<UserProductScreen> {
  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    List<Product> productList = productProvider.getProducts;
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      appBar: AppBar(
        elevation: 5,
        title: Text('Your Products'),
        actions: <Widget>[
          CupertinoButton(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Theme.of(context).accentColor,
                  ),
                  Text('ADD NEW',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                ],
              ),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddOREditProduct.routeName))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: Provider.of<ProductProvider>(context).refresh,
        child: ListView.builder(
//          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//            maxCrossAxisExtent: 450,
//            childAspectRatio: 4/1
//          ),
            itemCount: productList.length,
            itemBuilder: (ctx, index) {
              return Card(
                // clipBehavior: Clip.antiAlias,
                child: ExpandablePanel(
                  hasIcon: false,
//            builder: (ctx , col , exp){
//              return Card(
//                child: Expandable(
//                  collapsed: col,
//                  expanded: exp,
//                ),
//              );
//            },
                  expanded: Column(
                    children: <Widget>[
                      Text(
                        productList[index].price.toStringAsFixed(2).toString(),
                        style: Theme.of(context).textTheme.title,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Text(productList[index].description),
                      ),
                    ],
                  ),
                  header: ListTile(
                    title: Text(productList[index].title),
                    leading: CircleAvatar(
                      backgroundImage: productList[index].imageUrl != null
                          ? NetworkImage(productList[index].imageUrl)
                          : AssetImage(
                              'Assets/images/no-image-available.jpg',
                            ),
                    ),
                    trailing: FittedBox(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    AddOREditProduct.routeName,
                                    arguments: productList[index]);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () {
                                var _con = ScrollController();
                                return showCupertinoDialog<bool>(
                                    context: context,
                                    builder: (_) => CupertinoAlertDialog(
                                          insetAnimationDuration:
                                              Duration(seconds: 5),
                                          insetAnimationCurve: Curves.easeInSine,
                                          content: Text(
                                              'Are you sure that you need to delete This product !'),
                                          title: Icon(
                                            CupertinoIcons.delete_simple,
                                            color: Colors.red,
                                          ),
                                          actions: <Widget>[
                                            FlatButton.icon(
                                              label: Text('Confirm',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                                return true;
                                              },
                                              icon: Icon(Icons.delete),
                                            ),
                                            FlatButton.icon(
                                              label: Text('Cancel',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                                return false;
                                              },
                                              icon: Icon(Icons.cancel),
                                            ),
                                          ],
                                        )).catchError((e) {
                                  print(
                                      'Error During deleting Confirm message ');
                                }).then((res) {
                                  print(res);
                                  if (res) {
                                    String out = "Deleted Succefully";
                                    productProvider.deleteProduct(productList[index].id)
                                        .catchError((e){out = "Deleted Failed";})
                                        .then((_){
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                            elevation: 5,
                                            content: Text(out),
                                          ),);
                                    },
                                    );
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
        ),
      ),
    );
  }
}
