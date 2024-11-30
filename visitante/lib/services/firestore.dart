import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore get _Firestore => FirebaseFirestore.instance;

  // Colección de usuarios
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // Crear un nuevo usuario en Firestore
  Future<void> addUser(String uid, String email, String name) async {
    try {
      await users.doc(uid).set({
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al guardar el usuario en Firestore: $e');
    }
  }

  // Obtener la información de un usuario por su UID
  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      return await users.doc(uid).get();
    } catch (e) {
      throw Exception('Error al obtener el usuario de Firestore: $e');
    }
  }

  // Actualizar la información de un usuario en Firestore
  Future<void> updateUser(String uid, Map<String, dynamic> updatedData) async {
    try {
      await users.doc(uid).update(updatedData);
    } catch (e) {
      throw Exception('Error al actualizar el usuario en Firestore: $e');
    }
  }

  // Métodos adicionales, si no son necesarios puedes eliminarlos:
  void addVisitor(Map<String, String> map) {}

  void updateVisitor(String docID, Map<String, String> map) {}

  getVisitorsStream() {}

  deleteVisitor(String docID) {}
}

