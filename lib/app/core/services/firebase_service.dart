import 'package:get/get.dart';

/// FirebaseService — centralizes all Firebase operations.
/// Uncomment and add firebase_core, firebase_auth, cloud_firestore to pubspec.yaml
/// to enable Firebase. Firebase is initialized in main.dart before runApp().
class FirebaseService extends GetxService {
  // ─── Singleton ────────────────────────────────────────────────────────────
  static FirebaseService get to => Get.find();

  Future<FirebaseService> init() async {
    // Firebase is already initialized by main.dart via Firebase.initializeApp()
    // Put any additional setup here (e.g. Crashlytics, RemoteConfig)
    return this;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // AUTH METHODS
  // ══════════════════════════════════════════════════════════════════════════

  // Sign Up with Email & Password
  // Future<UserCredential?> signUpWithEmail(String email, String password) async {
  //   try {
  //     return await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email, password: password,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     throw e.message ?? 'Registration failed';
  //   }
  // }

  // Sign In with Email & Password
  // Future<UserCredential?> signInWithEmail(String email, String password) async {
  //   try {
  //     return await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email, password: password,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     throw e.message ?? 'Login failed';
  //   }
  // }

  // Sign Out
  // Future<void> signOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }

  // ══════════════════════════════════════════════════════════════════════════
  // FIRESTORE METHODS (generic)
  // ══════════════════════════════════════════════════════════════════════════

  // Get a document
  // Future<DocumentSnapshot> getDocument(String collection, String docId) {
  //   return FirebaseFirestore.instance.collection(collection).doc(docId).get();
  // }

  // Set a document
  // Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) {
  //   return FirebaseFirestore.instance.collection(collection).doc(docId).set(data, SetOptions(merge: true));
  // }

  // Add a document (auto ID)
  // Future<DocumentReference> addDocument(String collection, Map<String, dynamic> data) {
  //   return FirebaseFirestore.instance.collection(collection).add(data);
  // }

  // Update a document
  // Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) {
  //   return FirebaseFirestore.instance.collection(collection).doc(docId).update(data);
  // }

  // Delete a document
  // Future<void> deleteDocument(String collection, String docId) {
  //   return FirebaseFirestore.instance.collection(collection).doc(docId).delete();
  // }

  // Stream a document
  // Stream<DocumentSnapshot> streamDocument(String collection, String docId) {
  //   return FirebaseFirestore.instance.collection(collection).doc(docId).snapshots();
  // }

  // Stream a collection
  // Stream<QuerySnapshot> streamCollection(String collection) {
  //   return FirebaseFirestore.instance.collection(collection).snapshots();
  // }

  // ══════════════════════════════════════════════════════════════════════════
  // FIREBASE STORAGE METHODS
  // ══════════════════════════════════════════════════════════════════════════

  // Upload file
  // Future<String> uploadFile(String storagePath, Uint8List bytes) async {
  //   final ref = FirebaseStorage.instance.ref().child(storagePath);
  //   await ref.putData(bytes);
  //   return await ref.getDownloadURL();
  // }

  // Delete file
  // Future<void> deleteFile(String storagePath) async {
  //   await FirebaseStorage.instance.ref().child(storagePath).delete();
  // }

  // ══════════════════════════════════════════════════════════════════════════
  // CLOUD MESSAGING (FCM)
  // ══════════════════════════════════════════════════════════════════════════

  // Future<String?> getFCMToken() async {
  //   return await FirebaseMessaging.instance.getToken();
  // }
}
