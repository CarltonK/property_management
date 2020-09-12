import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseProvider {
  Firestore _firestore = Firestore.instance;

  DatabaseProvider() {
    print('An instance of Database Provider has been initialized');
  }

  Future fetchConcernedServiceProvider(String service) async {
    try {
      QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('designation', isEqualTo: 'Provider')
        .where('service', isEqualTo: service)
        .getDocuments();
      List<DocumentSnapshot> documents = [];
      snapshot.documents.forEach((element) {
        documents.add(element);
      });
    } catch (e) {
      return e.toString();
    }
  }
}
