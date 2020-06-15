import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:stagebook/models/product_model.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/profile_screen/profile_screen.dart';

import 'description_text_widget.dart';

class ProductView extends StatefulWidget {
  final String currentUserId;
  final ProductModel product;
  final User author;
  ProductView({this.currentUserId, this.product, this.author});
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  int sale = 0;
  void _pay() {
    // InAppPayments.startCardEntryFlow(
    //     onCardNonceRequestSuccess: _cardNonceRequestSuccess,
    //     onCardEntryCancel: Navigator.of(context).pop);
  }

  void _cardNonceRequestSuccess(CardDetails result) {
    print(result);
    // InAppPayments.requestGooglePayNonce(
    //   currencyCode: widget.product.id,
    //   price: widget.product.cost >= widget.product.sale
    //       ? widget.product.cost.toString()
    //       : widget.product.sale.toString(),
    //   priceStatus: widget.product.cost >= widget.product.sale
    //       ? widget.product.cost
    //       : widget.product.sale,
    //   onGooglePayCanceled: () {},
    //   onGooglePayNonceRequestFailure: (ErrorInfo errorInfo) {
    //     print(errorInfo);
    //   },
    //   onGooglePayNonceRequestSuccess: (CardDetails result) {
    //     print(result);
    //   },
    // );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.comment,
                  //     color: Colors.black,
                  //   ),
                  //   iconSize: 30.0,
                  //   onPressed: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => CommentsScreen(
                  //         liveShowproduct: widget.product ,
                  //         starCount: _starCount,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 12.0,
                      right: 6.0,
                    ),
                    child: Text(
                      'Cost',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      (widget.product.cost >= widget.product.sale)
                          ? (widget.product.sale <= 0)
                              ? '${widget.product.cost.toString()}\$'
                              : 'Sale ${widget.product.sale} \$'
                          : '${widget.product.cost.toString()}\$',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                        fontSize: 20.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  FlatButton(
                    onPressed: _pay,
                    color: Colors.red,
                    child: Text(
                      'Buy',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '${widget.product.title}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DescriptionTextWidget(
                        text: widget.product.description.toString()),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              )
            ],
          ),
        ),
      ],
    );
  }
}
