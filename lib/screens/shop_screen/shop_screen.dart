import 'package:flutter/material.dart';
import 'package:stagebook/models/product_model.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/widgets/product_view.dart';
import 'package:stagebook/services/database_service.dart';

class ShopScreen extends StatefulWidget {
  static final String id = "shopscreen_screen";

  String currentUserId;
  String userId;
  ShopScreen({this.currentUserId, this.userId});
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  User _profileUser;
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _setupProfileUser();
    _setupProducts();
  }

  _setupProducts() async {
    List<ProductModel> products =
        await DatabaseService.getUserProducts('5ntPAjgTiigidS85eXl5z9oY9Wc2');
    setState(() {
      _products = products;
    });
    print(_products);
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseService.getUserWithId(widget.userId);
    setState(() {
      _profileUser = profileUser;
    });
  }

  _buildDisplayProducts() {
    //column
    List<ProductView> productsView = [];
    _products.forEach((product) {
      productsView.add(ProductView(
        currentUserId: widget.currentUserId,
        author: _profileUser,
        product: product,
      ));
    });
    return Column(children: productsView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        titleSpacing: 2,
        centerTitle: true,
        backgroundColor: Colors.red[700],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SingleChildScrollView(child: _buildDisplayProducts()),
        ],
      ),
    );
  }
}
