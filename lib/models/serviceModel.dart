import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  String type;
  String url;

  ServiceModel({this.type, this.url});

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) =>
      ServiceModel(type: doc.data['type'] ?? '', url: doc.data['url'] ?? '');
}
