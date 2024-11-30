import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visitante/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firestore service
  final FirestoreService firestoreService = FirestoreService();

  // Text controllers for visitor details
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController personToVisitController = TextEditingController();
  final TextEditingController entryTimeController = TextEditingController();
  final TextEditingController exitTimeController = TextEditingController();
  final TextEditingController transportController = TextEditingController();
  final TextEditingController companionController = TextEditingController();

  // Open dialog box to add or update a visitor
  void openVisitorBox({String? docID}) {
    if (docID == null) {
      // Clear fields for new entry
      nameController.clear();
      idController.clear();
      purposeController.clear();
      personToVisitController.clear();
      entryTimeController.clear();
      exitTimeController.clear();
      transportController.clear();
      companionController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docID == null ? "Ingresar Visita" : "Actualizar Visita"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: "Identificación"),
              ),
              TextField(
                controller: purposeController,
                decoration: const InputDecoration(labelText: "Motivo de Visita"),
              ),
              TextField(
                controller: personToVisitController,
                decoration: const InputDecoration(labelText: "A quién visita"),
              ),
              TextField(
                controller: entryTimeController,
                decoration: const InputDecoration(labelText: "Hora de Entrada"),
              ),
              TextField(
                controller: exitTimeController,
                decoration: const InputDecoration(labelText: "Hora de Salida"),
              ),
              TextField(
                controller: transportController,
                decoration: const InputDecoration(labelText: "Medio de Transporte"),
              ),
              TextField(
                controller: companionController,
                decoration: const InputDecoration(labelText: "Acompañante"),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Create or update a visitor
              if (docID == null) {
                firestoreService.addVisitor({
                  'name': nameController.text,
                  'id': idController.text,
                  'purpose': purposeController.text,
                  'personToVisit': personToVisitController.text,
                  'entryTime': entryTimeController.text,
                  'exitTime': exitTimeController.text,
                  'transport': transportController.text,
                  'companion': companionController.text,
                });
              } else {
                firestoreService.updateVisitor(docID, {
                  'name': nameController.text,
                  'id': idController.text,
                  'purpose': purposeController.text,
                  'personToVisit': personToVisitController.text,
                  'entryTime': entryTimeController.text,
                  'exitTime': exitTimeController.text,
                  'transport': transportController.text,
                  'companion': companionController.text,
                });
              }

              // Clear text fields
              nameController.clear();
              idController.clear();
              purposeController.clear();
              personToVisitController.clear();
              entryTimeController.clear();
              exitTimeController.clear();
              transportController.clear();
              companionController.clear();

              // Close the dialog box
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Visitas")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Welcome Visitor",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.blue.shade100,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestoreService.getVisitorsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List visitorsList = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: visitorsList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = visitorsList[index];
                            String docID = document.id;

                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;

                            return ListTile(
                              title: Text(data['name'] ?? ''),
                              subtitle: Text(
                                "Motivo: ${data['purpose'] ?? ''}\nVisita a: ${data['personToVisit'] ?? ''}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        openVisitorBox(docID: docID), // Update
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        firestoreService.deleteVisitor(docID),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text("No hay visitas registradas."));
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openVisitorBox(),
        child: const Icon(Icons.add),
        tooltip: "Ingresar visita",
      ),
    );
  }
}

