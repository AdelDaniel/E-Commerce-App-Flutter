import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}


/// cart items is => key: is product id & its Value: cartItem class >>> price and quantity etc
/// so map contain many keys >>> each jey is a product
class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  /// to return cart map
  Map<String, CartItem> get getCartItems {
    return {..._cartItems};
  }

  /// return the number of products in cart
  int get totalItemsCount {
    int _total = 0 ;
    _cartItems.forEach((k,v){
      _total += _cartItems[k].quantity ;
    }
    );
    return _total;
  }


  int get numberOfDifferentProducts{
    return _cartItems.length;
  }

  double get totalCost {
    double _totalCost =0 ;
    _cartItems.forEach((k,v){
      _totalCost += _cartItems[k].price * _cartItems[k].quantity ;
    }
    );
    return _totalCost;
  }


  void deleteItem(String id){
    _cartItems.remove(id);
    notifyListeners();
  }

  void addItem(String productId, double price, String title,) {
    if (_cartItems.containsKey(productId)) {
      // change quantity Only...
      _cartItems.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),

      );
    } else {
      _cartItems.putIfAbsent(
        productId,
            () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }


  void removeSingleItem(String productId){
    if(!_cartItems.containsKey(productId)) {
        return ;
      }else if(_cartItems[productId].quantity > 1) {
          _cartItems.update(productId, (existingCartItem)=>CartItem(
            id: existingCartItem.id,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity -1 ,
            title: existingCartItem.title,
          ));
    }else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }
  /// after adding cart to order
  void clear(){
    _cartItems= {} ;
    notifyListeners();
  }
}
