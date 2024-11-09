import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:invoicehub/functions/publics_functions.dart';
import 'package:invoicehub/widget/client_page.dart';

class AddArticle extends StatefulWidget {
  @override
  State<AddArticle> createState() => _AddArticlerState();
}

class _AddArticlerState extends State<AddArticle> {
  late TextEditingController _designationController;
  late TextEditingController _UnitPriceController;
  late TextEditingController _DescriptionController;

  @override
  void initState() {
    super.initState();
    _designationController = TextEditingController();
    _UnitPriceController = TextEditingController();
    _DescriptionController = TextEditingController();
  }

  Future<void> _loadDefaultValues() async {
    // Vous pouvez ajouter ici la logique pour charger des valeurs par défaut si nécessaire
    // Par exemple :
    // await getArticlerById(0); // Récupérer les données d'un client fictif avec ID 0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter Article'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Action pour le bouton supprimer
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _submitForm();
            },
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 2,
            child: SizedBox(
              height: 300, // Définissez la hauteur maximale souhaitée
              child: ListView(
                shrinkWrap: true, // Pour limiter la taille du ListView
                children: [
                  buildTextField('Designation', _designationController),
                  buildTextField('Prix Unitaire', _UnitPriceController),
                  buildTextField('Description', _DescriptionController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_designationController.text.isNotEmpty &&
        _UnitPriceController.text.isNotEmpty &&
        _DescriptionController.text.isNotEmpty) {
      var ArticlerData = {
        'id':
            0, // Vous pouvez utiliser un ID généré ou 0 pour un nouveau client
        'designation': _designationController.text,
        'unit_price': _UnitPriceController.text,
        'description': _DescriptionController.text,
      };

      try {
        var success = await addArticle(ArticlerData);
        if (success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Données ajoutées avec succès")),
          );
          // Charger la liste des clients après l'ajout réussi
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur lors de l'ajout des données.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'ajout : $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tous les champs doivent être remplis.")),
      );
    }
  }

  Future<bool> addArticle(Map<String, dynamic> ArticlerData) async {
    String url =
        "http://invoiceshub.imagic-community.com/api/article.php"; // Mettez l'URL de votre API ici

    final Map<String, dynamic> jsonData = {
      "id": ArticlerData['id'],
      "designation": ArticlerData['designation'],
      "unit_price": ArticlerData['unit_price'],
      "description": ArticlerData['description'],
    };
    final Map<String, dynamic> data = {
      "operation": 'addArticle',
      "json": jsonEncode(jsonData),
    };
    http.Response response =
        await http.get(Uri.parse(url).replace(queryParameters: data));
    print(response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result['success'] == true;
    } else {
      throw Exception("Erreur lors de l'ajout : ${response.statusCode}");
    }
  }
}
