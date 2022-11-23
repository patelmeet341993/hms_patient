import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController {
  static FirestoreController? _instance;

  factory FirestoreController() {
    _instance ??= FirestoreController._();
    return _instance!;
  }

  FirestoreController._();

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
}