import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursework_project/screens/Backend/settings.dart';

const String Settings_Collection_Ref = "settings";
//Doing this as it will be easier to reference this collection

class SettingsService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _settingsRef;

  SettingsService() {
    _settingsRef =
        _firestore.collection(Settings_Collection_Ref).withConverter<AppSettings>(
            fromFirestore: (snapshots, _) => AppSettings.fromJson(
              snapshots.data()!,
            ),
            toFirestore: (settings, _) => settings.toJson());
  }

  Stream<QuerySnapshot> getSettings() {
    return _settingsRef.snapshots();
  }

  void updateSetting(String settingID, AppSettings setting) {
    _settingsRef.doc(settingID).update(setting.toJson());
  }

}