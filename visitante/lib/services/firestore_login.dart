import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreLoginService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Colección de usuarios
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // Crear un nuevo usuario en Firestore
  Future<void> addUser(String uid, String email, {required String name}) async {
    try {
      await users.doc(uid).set({
        'email': email,
        'name': name,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Error al agregar usuario: $e");
    }
  }

  // Obtener un usuario por UID
  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      return await users.doc(uid).get();
    } catch (e) {
      throw Exception("Error al obtener el usuario: $e");
    }
  }

  // Actualizar la información de un usuario
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await users.doc(uid).update(data);
    } catch (e) {
      throw Exception("Error al actualizar el usuario: $e");
    }
  }

  // Obtener todos los usuarios
  Stream<QuerySnapshot> getUsersStream() {
    return users.snapshots();
  }
}
