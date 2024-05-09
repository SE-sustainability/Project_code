import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursework_project/screens/Backend/modes.dart';

const String Mode_Collection_Ref = "modes";

class ModeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _modesRef = FirebaseFirestore.instance.collection('modes');

  ModeService() {
    _modesRef = _firestore.collection(Mode_Collection_Ref).withConverter<Mode>(
        fromFirestore: (snapshot, _) => Mode.fromJson(snapshot.data()!),
        toFirestore: (mode, _) => mode.toJson());
  }

  Future<List<Mode>> getModes() async {
    QuerySnapshot querySnapshot = await _firestore.collection('modes').get();
    List<Mode> modes = querySnapshot.docs.map((doc) => Mode.fromJson(doc.data() as Map<String, dynamic>)).toList();
    return modes;
  }
  // Add mode to database
  void addMode(Mode mode) async {
    _modesRef.add(mode);
  }


  // Update mode


  Future<void> updateMode(String modeId, Mode updatedMode) async {
    await _firestore.collection('modes').doc(modeId).set(updatedMode.toJson());
  }


  // Delete mode
  void deleteMode(String modeId) {
    _modesRef.doc(modeId).delete();
  }

  // Navigate to mode options page
  void navigateToModeOptions(String modeId) {
    // You can implement navigation logic here
  }
}
