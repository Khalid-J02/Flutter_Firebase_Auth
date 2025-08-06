import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/userModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      print('Sign in error: $e');
      throw e;
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      if (result.user != null) {
        await _saveUserToFirestore(
          uid: result.user!.uid,
          email: email,
          fullName: fullName,
        );
      }

      return result;
    } catch (e) {
      print('Register error: $e');
      throw e;
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserToFirestore({
    required String uid,
    required String email,
    required String fullName,
  }) async {
    try {
      UserModel user = UserModel(
        uid: uid,
        email: email,
        fullName: fullName,
      );

      await _firestore.collection('users').doc(uid).set(user.toMap());
    } catch (e) {
      print('Error saving user to Firestore: $e');
      throw e;
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      throw e;
    }
  }

  // Check if user exists
  Future<bool> doesUserExist(String email) async {
    try {
      // This is a simple check - in production, you might want a more robust method
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }
}