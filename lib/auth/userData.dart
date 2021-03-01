import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = FirebaseFirestore.instance;
class userDatabaseService{
  userDatabaseService({this.uid});
  final String uid;


  final CollectionReference brewCollection = _firestore.collection('brews');

  Future updateUserData(String name,String email,String branch,String year,int vehicle,String vehicle_no) async {
    return await brewCollection.doc(uid).set({
      'name': name,
      'email': email,
      'branch': branch,
      'year': year,
      'vehicle': vehicle,
      'vehicle_no': vehicle_no,
    });
  }
}