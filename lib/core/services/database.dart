import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Simple web-compatible database using Firestore
  Future<void> insertUser(String uid, String email) async {
    if (kIsWeb) {
      // Use Firestore for web
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      // For mobile, we'll implement drift later
      // For now, just log that mobile database is not implemented
      print('Mobile database not implemented yet');
    }
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    if (kIsWeb) {
      var doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } else {
      // For mobile, return null for now
      print('Mobile database not implemented yet');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    if (kIsWeb) {
      var snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } else {
      // For mobile, return empty list for now
      print('Mobile database not implemented yet');
      return [];
    }
  }
}
