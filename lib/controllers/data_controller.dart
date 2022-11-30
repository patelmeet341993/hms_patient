import 'package:hms_models/hms_models.dart';
import 'package:uuid/uuid.dart';

class DataController {
  static DataController? _instance;

  factory DataController() {
    _instance ??= DataController._();
    return _instance!;
  }

  DataController._();

  Future<NewDocumentDataModel> getNewDocIdAndTimeStamp({bool isGetTimeStamp = true}) async {
    String docId = "";
    Timestamp? timestamp;

    await FirebaseNodes.timestampCollectionReference.add({"temp_timestamp": FieldValue.serverTimestamp()}).then((DocumentReference<Map<String, dynamic>> reference) async {
      docId = reference.id;

      if(isGetTimeStamp) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await reference.get();
        timestamp = documentSnapshot.data()?['temp_timestamp'];
      }

      await reference.delete();
    })
    .catchError((e, s) {
      // reportErrorToCrashlytics(e, s, reason: "Error in DataController.getNewDocId()");
    });

    if(docId.isEmpty) {
      docId = Uuid().v1().replaceAll("-", "");
    }

    return NewDocumentDataModel(docId: docId, timestamp: timestamp ?? Timestamp.now());
  }
}
