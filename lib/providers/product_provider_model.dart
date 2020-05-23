
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';



// we added a provider to model >>> ChangeNotifier >> so any change in only one of products can detected
// easy to understand: provider mode for the changes of class properties ex: id title ..... etc
// changes of class properties  depends on method

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });


  void setFavorite(){
    isFavorite = !isFavorite ;
    // notify Listeners >>>
    // when the property changes
    // and need the wedgit that use this property to rebuild
    // so we should use notifyListener() >>>> to rebuild Like setstate()
    notifyListeners();
  }
}