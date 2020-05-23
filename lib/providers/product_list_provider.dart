
import 'package:flutter/cupertino.dart';
import 'product_provider_model.dart';
/// htttp to firebase
import 'package:http/http.dart' as http;

/// convert product to map >>
import 'dart:convert';

/// -1- install package and import provider
/// -2-  with ChangeNotifier
/// -3- the root widget
/// -4- all properties are private
/// -5- getter to get data
/// -6- any function don't forget  >> notifyListeners(); <<
/// -7- final var_pro_name = Provider.of<pro_name>(context)
/// -8- don'y forget consumer



// easy to understand: provider mode for the changes of class properties ex: List of products ...
class ProductProvider with ChangeNotifier{
  List<Product> _deletedProducts = <Product>[];

  List<Product> _products = <Product>[
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  Future<void> getDataFromFirebase() async{
    try{
      String _url = 'https://my-shop-8888.firebaseio.com/' + 'Products.json';
      final res = await http.get(_url);
      print(res);
      ///dart can not ubderstand a map inside another map ??????
      ///Map<String , Map<String , dynamic> > ;
      final data = json.decode(res.body) as Map<String , dynamic> ;
      // List<Product> dawnloaddedPro = [] ;
      data.forEach((k,v){
        _products.add(Product(
          id: k ,
          title: v['title'],
          price: v['price'],
          description: v['description'],
          imageUrl: v['imageUrl']
        ));
      });
      print('loaddding');
      notifyListeners();
    }catch(e){
      throw e ;
    }
  }

  Future<void> refresh () async {
    _products.clear();
    await getDataFromFirebase();
  }


//  bool _isFavorite = false ;
//  void setFavorite(bool value){
//    _isFavorite  =value ;
//    print(_isFavorite);
//    notifyListeners();
//  }




  List<Product> get getProducts {
//    if(_isFavorite) {
//      return (_products.where((product)=> product.isFavorite)).toList();
//    }
    return [..._products] ;
  }

  /// using await and async >>> instead of return future
  Future addProducts(Product product) async {
    /// access to firebase >>>>>> then create a container Products
    /// >>final result  url = 'https://my-shop-8888.firebaseio.com/Products.json'
    const String url = 'https://my-shop-8888.firebaseio.com/' + 'Products.json';
    try{

      final res =  await http.post(url , body:json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl
      }));
        _products.add(Product(
          isFavorite: product.isFavorite,
          id: json.decode(res.body)['name'],
          title: product.title ,
          description :product.description,
          price: product.price,
          imageUrl: product.imageUrl,)
        );
        print(res);
        print(res.body);
        print((res.body));
        print(json.decode(res.body));
        print(json.decode(res.body)['name']);
        notifyListeners();

    }catch(e){
      print('error') ;
      throw e ;
    }
  }


  //  /// WHEN MAKING FUNCTION RETURN FUTURE IT MUST >>> contain return   >> 2- <void>
//  Future addProducts(Product product) {
//    /// access to firebase >>>>>> then create a container Products
//    /// >>final result  url = 'https://my-shop-8888.firebaseio.com/Products.json'
//    const String url = 'https://my-shop-8888.firebaseio.com/' + 'Products.json';
//    return http.post(url , body:json.encode({
//      'title': product.title,
//      'description': product.description,
//      'price': product.price,
//      'imageUrl': product.imageUrl
//    }
//    )).then((response){
//      _products.add(Product(
//        isFavorite: product.isFavorite,
//        id: json.decode(response.body)['name'],
//        title: product.title ,
//        description :product.description,
//        price: product.price,
//        imageUrl: product.imageUrl,)
//      );
//      print(response);
//      print(response.body);
//      print((response.body));
//      print(json.decode(response.body));
//      print(json.decode(response.body)['name']);
//      notifyListeners();
//    }).catchError((e){
//      print('error') ;
//      throw e ;
//    });
//  }




  Future<void> updateProduct(Product editedProduct) async {

    /// ${editedProduct.id} >>>> id you want to target in firebase
    String _url = 'https://my-shop-8888.firebaseio.com/' + 'Products/${editedProduct.id}.json';
    try{
      await http.patch(_url,body: json.encode({
        'title': editedProduct.title,
        'description': editedProduct.description,
        'price': editedProduct.price,
        'imageUrl': editedProduct.imageUrl
      }));
      int index =  _products.indexWhere((product)=> product.id == editedProduct.id  );
      _products[index] = editedProduct ;
      notifyListeners() ;
    }catch(e){
      throw e ;
    }
  }

  Future<void> deleteProduct(String deletedProductId ) async {
    try{
      String _url = 'https://my-shop-8888.firebaseio.com/' + 'Products/$deletedProductId.json';
      await http.delete(_url);
      int index = _products.indexWhere((product)=> product.id == deletedProductId );
      _deletedProducts.add(_products[index]);
      _products.removeAt(index);
      notifyListeners() ;
    }catch(e){
      throw e ;
    }
  }

}