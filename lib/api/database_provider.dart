import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseProvider {
  Firestore _firestore = Firestore.instance;

  DatabaseProvider() {
    print('An instance of Database Provider has been initialized');
  }

  Future<List<DocumentSnapshot>> fetchConcernedServiceProvider(
      String service) async {
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
      print('How many providers? ' + documents.length.toString());
      return documents;
    } catch (e) {
      throw e;
    }
  }

  Stream<DocumentSnapshot> getUser(String uid) {
    return _firestore.collection('users').document(uid).snapshots();
  }

  Future<void> sendServiceRequest(String by, String byToken, String to,
      String toToken, String byName, String description) async {
    try {
      String collection = 'service_requests';
      await _firestore.collection(collection).document().setData({
        'by': by,
        'byToken': byToken,
        'to': to,
        'description': description,
        'toToken': toToken,
        'date': DateTime.now(),
        'byName': byName,
        'status': 'Pending',
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<DocumentSnapshot>> getServices() async {
    try {
      QuerySnapshot query =
          await _firestore.collection('services').getDocuments();

      List<DocumentSnapshot> documents = [];
      query.documents.forEach((element) {
        documents.add(element);
      });
      return documents;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<DocumentSnapshot>> getDistinctions(String type) async {
    try {
      QuerySnapshot query = await _firestore
          .collectionGroup('distinctions')
          .where('type', isEqualTo: type)
          .getDocuments();

      List<DocumentSnapshot> documents = [];
      query.documents.forEach((element) {
        documents.add(element);
      });
      return documents;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<DocumentSnapshot>> receiveServiceRequests(String uid) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('service_requests')
          .where('to', isEqualTo: uid)
          .where('status', whereIn: ['Pending'])
          .orderBy('date', descending: true)
          .getDocuments();
      List<DocumentSnapshot> documents = [];
      query.documents.forEach((element) {
        documents.add(element);
      });
      return documents;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<DocumentSnapshot>> receiveServiceHistory(String uid) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('service_requests')
          .where('to', isEqualTo: uid)
          .where('status', isEqualTo: 'Complete')
          .orderBy('date', descending: true)
          .getDocuments();
      List<DocumentSnapshot> documents = [];
      query.documents.forEach((element) {
        documents.add(element);
      });
      print('How many providers? ' + documents.length.toString());
      return documents;
    } catch (e) {
      throw e.toString();
    }
  }
}
