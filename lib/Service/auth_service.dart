import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('Users');
  final CollectionReference _resultsCollection =
  FirebaseFirestore.instance.collection('results');

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password, String fullName, bool isTeacher) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save additional user data to Firestore
      await _usersCollection.doc(userCredential.user!.uid).set({
        'Email': email,
        'FullName': fullName,
        'IsTeacher': isTeacher,
      });

      return userCredential;
    } catch (e) {
      // Handle sign-up errors
      print('Sign up error: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential;
    } catch (e) {
      // Handle sign-in errors
      print('Sign in error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Handle sign-out errors
      print('Sign out error: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>> fetchQuizResults(String quizId) async {
    final docSnapshot = await _resultsCollection.doc(quizId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        return data;
      }
    }

    return {};
  }

  Future<Map<String, dynamic>> fetchQuizData(String quizId) async {
    final quizSnapshot = await FirebaseFirestore.instance
        .collection('examquestion')
        .doc(quizId)
        .get();

    if (quizSnapshot.exists) {
      final data = quizSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        return data;
      }
    }

    return {};
  }
}
