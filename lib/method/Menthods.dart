import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Account create Succesfull");
      user.updateProfile(displayName: name);
      await _firestore.collection("users").doc(_auth.currentUser?.uid).set({
        "name": name,
        "email": email,
        "status": "Unavalible",
        "uid": _auth.currentUser?.uid,
      });
      return user;
    } else {
      print("Account create Fail");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Login Sucessfull");
      return user;
    } else {
      print("Login Failed ");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    await _auth.signOut();
  } catch (e) {
    print("error");
  }
}

Future<bool> isFriendExists(String myEmail, String newfriend) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final querySnapshot = await _firestore
      .collection('friends')
      .doc(myEmail)
      .collection('friendlist')
      .where('email', isEqualTo: newfriend) // Giả sử newfriendA có trường 'email'
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Future<User?> addFriend(String emailA, String emailB) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> newfriendA = {
    "email": emailB,
    "time": FieldValue.serverTimestamp(),
  };
  Map<String, dynamic> newfriendB = {
    "email": emailA,
    "time": FieldValue.serverTimestamp(),
  };
  await _firestore
      .collection('friends')
      .doc(emailA)
      .collection('friendlist')
      .add(newfriendA);
  await _firestore
      .collection('friends')
      .doc(emailB)
      .collection('friendlist')
      .add(newfriendB);
}
