import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String imageUrl;
  final int sale;
  final String description;
  final String shopId;
  final String thumbnail;
  final String title;
  final Timestamp timestamp;
  final int cost;

  ProductModel(
      {this.title,
      this.id,
      this.shopId,
      this.description,
      this.sale,
      this.cost,
      this.imageUrl,
      this.thumbnail,
      this.timestamp});

  factory ProductModel.fromDoc(DocumentSnapshot doc) {
    return ProductModel(
      id: doc.documentID,
      imageUrl: doc['imageUrl'],
      shopId: doc['shopId'],
      description: doc['description'],
      title: doc['title'],
      thumbnail: doc['thumbnail'],
      cost: doc['cost'],
      sale: doc['sale'],
      timestamp: doc['timestamp'],
    );
  }
}
