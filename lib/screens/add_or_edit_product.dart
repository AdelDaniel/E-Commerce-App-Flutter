import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider_model.dart';
import '../providers/product_list_provider.dart';

class AddOREditProduct extends StatefulWidget {
  static const String routeName = 'Add Or Editing Product ';
  @override
  _AddOREditProductState createState() => _AddOREditProductState();
}

class _AddOREditProductState extends State<AddOREditProduct> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _productTitleEditingController = TextEditingController();
  final _priceEditingController = TextEditingController();
  final _descriptionEditingController = TextEditingController();
  final _imageUrlEditingController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  /// _editingProduct (product we will work on) --------- existingProduct(product we will get to edit)
  Product _editingProduct = Product(title: null,price: 0 ,id: null,description: null,imageUrl: null,isFavorite: false);
  Product existingProduct;
  bool firstTime = true , _startSaving = false ;
    //  bool _editingProductImage =false ;
  Map<String , Object> _initValues={
    'id': null,
    'title' : null,
    'description': null  ,
    'imageUrl': null ,
    'price' : null ,
    'isFavorite': false ,
  };





  /// check is it editing or Adding New
  @override
  void didChangeDependencies() {
    print('didnot change dependancies');
    if (firstTime) {
      final existingProduct = ModalRoute.of(context).settings.arguments as Product;
      if(existingProduct != null ){
        _editingProduct = existingProduct ;
        _initValues = {
          'id': _editingProduct.id,
          'title' : _editingProduct.title,
          'description': _editingProduct.description ,
          'imageUrl': _editingProduct.imageUrl,
          'price' : _editingProduct.price.toString(),
          'isFavorite': _editingProduct.isFavorite.toString() ,
        };
        _productTitleEditingController.text =existingProduct.title ;
        _priceEditingController.text  =existingProduct.price.toStringAsFixed(2);
        _descriptionEditingController.text =  existingProduct.description;
        _imageUrlEditingController.text = existingProduct.imageUrl ;
        print(existingProduct.id);
        print(_initValues['id']);
    //    _editingProductImage =true;
      }
    }
    firstTime =false ;
    _updateImageUrl();
   // _editingProductImage =false;
    super.didChangeDependencies();
  }



  /// **************************************************************************
  /// **************************************************************************
  /// to preview the image tou bring from internet before save

  final _imageUrlFocusNode = FocusNode();
  bool _loadingImage;
  ImageProvider _image;
  Image _imageScreen = Image.asset('Assets/images/no-image-available.jpg' , fit: BoxFit.cover,);

  @override
  void initState() {
    _updateImageUrl();
    _loadingImage = false;
    ///addlistner used to >>>>  preview the image >>> when changes
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    setState(() {
      /// NetworkImage returns NetworkImage Provider
      _image =  NetworkImage(_imageUrlEditingController.text);
    });

    /// Text form field is not empty >> then Load Image depending on _image
      if (_imageUrlEditingController.text.isNotEmpty && _image !=null) {
        setState(() {
          _loadImage();
        });
      }
  }

  void _loadImage()async {

    _loadingImage = true;
    await precacheImage(_image, context, onError: (e, stackTrace) {
      // log.fine('Image ${widget.url} failed to load with error $e.');
      print('**error When Loading** $e');
      setState(() {
        _loadingImage = false;
        print(_loadingImage);
      });
    });

    /// _loadingImage == true  >>>> that mean no error happened up
    /// and there is an image exist in this specific url
    if (_loadingImage) {
      _imageScreen = Image.network(
        _imageUrlEditingController.text,
        fit: BoxFit.cover,
      );
    }else{
      _imageScreen = Image.asset('Assets/images/no-image-available.jpg' , fit: BoxFit.cover,);
    }
  }











//  final _imageUrlFocusNode = FocusNode();
//  ///to make the listener >>>> In the so to preview the image
//  @override
//  void initState() {
//    print('intiState');
//    _imageUrlFocusNode.addListener(_updateImageUrl);
//    super.initState();
//  }
//  var img ;
//  void _updateImageUrl() {
//    try{
//      img = ImageCache(img).
//        imageUrl: url,
//        placeholder: (context,url) => CircularProgressIndicator(),
//        errorWidget: (context,url,error) => new Icon(Icons.error),
//      ),
//          Image.network(
//        _imageUrlEditingController.text,
//        fit: BoxFit.cover,);
//      validImage =true ;
//    }catch(ex){
//      validImage = false ;
//      img = Image.network(
//        'https://uh.edu/pharmacy/_images/directory-staff/no-image-available.jpg',
//        fit: BoxFit.cover,);}
//    setState(() { });
//   // if (!_imageUrlFocusNode.hasFocus) {
//    //}
//  }
  /// **************************************************************************
  /// **************************************************************************




  ///********** Save Form **************
  void _saveForm() async {
    if(_keyForm.currentState.validate()){
      setState(() {
        _startSaving = true ;
      });
      _keyForm.currentState.save();
      /// check if the id still null then you will add anew product
      /// else it is editing

      _editingProduct = Product(
          id:  _initValues['id'] == null ?DateTime.now().toString():_editingProduct.id  ,
          title : _initValues['title'] ,
          description : _initValues['description'],
          imageUrl:_initValues['imageUrl'],
          price: double.parse(_initValues['price']) ,
          isFavorite: _initValues['id'] == null  ? false :_editingProduct.isFavorite ,
        );

      if(_initValues['id'] == null ){
        Provider.of<ProductProvider>(context , listen: false ).addProducts(_editingProduct)
            .catchError((e){
         setState(() {
           _startSaving = false ;
         });
         return showCupertinoDialog(context: context, builder:(_)=>CupertinoAlertDialog(
           content: Text('Error During Save,please \n Check Your Internet Connection '),
           title: Icon(CupertinoIcons.clear_thick_circled ,color:  Colors.red,),
           actions: <Widget>[
             CupertinoButton(child: Text('close' , style:TextStyle(color: Colors.red)),onPressed: ()=>Navigator.pop(context),),
           ],
         ),
         );
       }).then((_){_showSnackBarAndPop(); print('End All');});
      }else{
        /// updating product
        try{
          await Provider.of<ProductProvider>(context , listen: false ).updateProduct(_editingProduct);
        }catch(e) {
          await _errorDuringSave();
          //_showSnackBarAndPop();
        }
      }

      _productTitleEditingController.clear();
      _priceEditingController.clear();
      _descriptionEditingController.clear();
      _imageUrlEditingController.clear();
      _updateImageUrl();
      print('Saved entered ');
    }else{
      print('problem happend while Svaing');
    }
  }


//
//  Future _errorDuringSave() async {
//      setState(() {
//        _startSaving = false ;
//      });
//      try{
//        final res = await showCupertinoDialog(context: context, builder:(_)=>CupertinoAlertDialog(
//          content: Text('Error During Save,please \n Check Your Internet Connection '),
//          title: Icon(CupertinoIcons.clear_thick_circled ,color:  Colors.red,),
//          actions: <Widget>[
//            CupertinoButton(child: Text('close' , style:TextStyle(color: Colors.red)),onPressed: ()=>Navigator.pop(context),),
//          ],
//        ),
//        );
//        throw res ;
//      }catch(e){
//        throw e ;
//      }
//
//  }




  /// catcherror  and then work good with show dialog but
  /// with http use try and catch the responce return number so
  /// it doesn't go to catch error
  ///
  Future _errorDuringSave(){
    setState(() {
      _startSaving = false ;
    });
    // try{
      return showCupertinoDialog(context: context, builder:(_)=>CupertinoAlertDialog(
        content: Text('Error During Save,please \n Check Your Internet Connection '),
        title: Icon(CupertinoIcons.clear_thick_circled ,color:  Colors.red,),
        actions: <Widget>[
          CupertinoButton(child: Text('close' , style:TextStyle(color: Colors.red)),onPressed: ()=>Navigator.pop(context),),
        ],
      ),
      ).catchError((e){
        print('error Happen');
      }).then((_){
        _showSnackBarAndPop();
      });
      // throw res ;
//    }catch(e){
//      throw e ;
//    }

  }



  void _showSnackBarAndPop() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Product Saved'))
    );
      Future.delayed(Duration(seconds:2 ,microseconds: 200))
          .then((_){ _startSaving = false ; Navigator.of(context).pop(); } );
    }

  ///********** _validation Function **************
  String _validation(String value , bool _isNumber ){
    double _num ;
    if (value.isEmpty){
      return "No Value Entered !" ;
    }else if(_isNumber){
      try{
         _num = double.parse(value) ;
         if(_num.isNegative ) {return "Enter A Valid Nunber !";}
         return null ;
      }catch (ex){
        print (ex.hashCode) ;
        return "Enter A Valid Nunber !" ;
      }


    }else if(!_isNumber){ /// if the user entered number in text field
      try{
        _num = double.parse(value) ;
        return "All Numbers !";

      }catch (ex){
        return null ;
      }
    } else{
      return null ;
    }
  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
        'add product',
      )),
      body: _startSaving?
      Center(child: CircularProgressIndicator(),)
          :Padding(
        padding: const EdgeInsets.all(5),
        child: Form(
            key: _keyForm,
            child: ListView(
              children: <Widget>[

                /// Product Name*****************************************
                TextFormField(
                  //initialValue: _initValues['title'] == null? 'adel' : _initValues['title'],
                  controller: _productTitleEditingController,
                    onChanged: (value){print('$value Change ') ;},
                  decoration: InputDecoration(
                      labelText: 'Product Name', hintText: 'ex: Nike Shoes'),
                  textInputAction: TextInputAction.next,
                  /// When next button on keyBoard clicked => then go to price form field
                  /// on submitted that current only field
                    /// onFieldSubmitted woks only preesed on next at keyboard
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                    print('on field sumitted name ') ;
                  },
                  /// on saved to save the hole Form
                  onSaved: (value){
                    _initValues['title'] = value ;
                  },
                  validator: (value){return _validation( value, false);}

                ),


                /// Price ***********************************
                TextFormField(
                  //initialValue: _initValues['price'],
                    controller: _priceEditingController,
                  onChanged: (value){print('$value Change ') ;},
                  decoration: InputDecoration(
                      labelText: 'Product Price', hintText: 'ex: 350'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,

                  /// the fous node of the current field is _priceFocusNode
                  ///
                  /// and after click next go to _descriptionFocusNode
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value){
                    _initValues['price'] = value ;
                  },
                    validator: (value){return _validation( value, true);}
                ),



                /// description ***************************
                TextFormField(
                    //initialValue: _initValues['description'],
                    controller: _descriptionEditingController,
                    onChanged: (value){print('$value Change ') ;},
                  decoration: InputDecoration(
                      labelText: 'Product Description',
                      hintText: 'your description'),
                  textInputAction: TextInputAction.newline,
                  maxLines: 8,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                      _initValues['description'] = value ;
                  },
                    validator: (value){return _validation( value, false);}
                ),




                Row(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2)),
                    child: _imageScreen
                  ),
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                  //    onChanged: (value){_updateImageUrl();},

//                      validator: (value){
//                        if (value.isEmpty) {
//                          return 'Please enter an image URL.';
//                        }
//                        if (!value.startsWith('http') &&
//                            !value.startsWith('https')) {
//                          return 'Please enter a valid URL.';
//                        }
//                        if (!value.endsWith('.png') &&
//                            !value.endsWith('.jpg') &&
//                            !value.endsWith('.jpeg')) {
//                          return 'Please enter a valid image URL.';
//                        }
//                        return null;
//                      },
                      controller: _imageUrlEditingController,
                      onSaved: (value){
                        if(_loadingImage){
                          _initValues['imageUrl'] = value ;
                        }else {
                          _initValues['imageUrl'] = null ;
                        }
                        },
                      onFieldSubmitted: (value){
                        _saveForm();
                      },
                      decoration: InputDecoration(
                          labelText: 'Product Image URL',
                          hintText: 'ex: www.example.com'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlFocusNode,
                    ),
                  ),
                ]),

                Center(
                  child: CupertinoButton(child: Text('Save'), color: Theme.of(context).primaryColor,onPressed: _saveForm),
                )
              ],
            )),
      ),
    );
  }


  /// dispose like distractor this to remove the 2 focus nodes from memory
  /// because they doesn't removed automatically
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _productTitleEditingController.dispose();
    _imageUrlEditingController.dispose();
    _priceEditingController.dispose();
    _descriptionEditingController.dispose() ;
    super.dispose();
  }
}
