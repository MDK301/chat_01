import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, dynamic>?> onOpen() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? curUserMap;

  try {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: currentUser.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        curUserMap = querySnapshot.docs[0].data();
        print(curUserMap);
      } else {
        print("User document not found");
      }
    } else {
      print("User not signed in");
    }
  } catch (e) {
    print("Error fetching user data: $e");
  }

  return curUserMap;
}
