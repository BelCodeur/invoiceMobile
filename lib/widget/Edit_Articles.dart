import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:invoicehub/functions/publics_functions.dart';

class EditArticlePage extends StatefulWidget {
  final int ArticleId; // Ajoutez cet attribut

  EditArticlePage({required this.ArticleId});

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  late TextEditingController _designationController;
  late TextEditingController _UnitPriceController;
  late TextEditingController _DescriptionController;

  @override
  void initState() {
    super.initState();
    _designationController = TextEditingController();
    _UnitPriceController = TextEditingController();
    _DescriptionController = TextEditingController();

    _loadArticleData();
  }

  void _loadArticleData() async {
    // Appel à la fonction pour récupérer les données du client
    try {
      var ArticleData = await getArticleById(widget.ArticleId);
      print(ArticleData);
      setState(() {
        _designationController.text = ArticleData['designation'];
        _UnitPriceController.text = ArticleData['unit_price'].toString();
        _DescriptionController.text = ArticleData['description'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des données : $e")),
      );
    }
  }

  Future<Map<String, dynamic>> getArticleById(int ArticleId) async {
    String url = "http://invoiceshub.imagic-community.com/api/article.php";

    Map<String, dynamic> json = {"SelectedID": ArticleId};
    var operation = "getArticleById";
    final Map<String, dynamic> queryParams = {
      "operation": operation,
      "json": jsonEncode(json),
    };
    // Assurez-vous d'utiliser le bon type de méthode (GET ou POST)
    http.Response response =
        await http.get(Uri.parse(url).replace(queryParameters: queryParams));
    print(response.body);
    if (response.statusCode == 200) {
      var Article = jsonDecode(response.body);
      return Article;
    } else {
      throw Exception(
          "Erreur lors de la récupération des données : ${response.statusCode}");
    }
  }

  Future<bool> updateArticle(Map<String, dynamic> ArticleData) async {
    String url =
        "http://invoiceshub.imagic-community.com/api/article.php"; // Mettez l'URL de votre API ici

    final Map<String, dynamic> jsonData = {
      "id": ArticleData['id'],
      "designation": ArticleData['designation'],
      "unit_price": ArticleData['unit_price'],
      "description": ArticleData['description'],
    };
    final Map<String, dynamic> data = {
      "operation": 'updateArticle',
      "json": jsonEncode(jsonData),
    };
    // Envoyer les données à l'API
    http.Response response =
        await http.get(Uri.parse(url).replace(queryParameters: data));
    print(response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result['success'] == true; // Vérifiez si la mise à jour a réussi
    } else {
      showMessageBox(context, "success!",
          "Erreur lors de la mise à jour : ${response.statusCode}");
      print(response.statusCode);
      throw Exception("Erreur lors de la mise à jour : ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Article'),
        actions: [
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
      // Récupérer les valeurs des champs
      var ArticleData = {
        'id': widget
            .ArticleId, // Assurez-vous d'envoyer l'ID du client pour la mise à jour
        'designation': _designationController.text,
        'unit_price': _UnitPriceController.text,
        'description': _DescriptionController.text,
      };

      // Appeler la fonction pour envoyer les données à l'API
      try {
        var success = await updateArticle(ArticleData);
        if (success) {
          // Si la mise à jour réussit, rediriger vers la page des clients
          Navigator.pop(context, true);
          // ScaffoldMessenger.of(context).showSnackBar(
          showMessageBox(context, "success!", "Données modifiées avec succès");
        } else {
          // Gérer l'échec de la mise à jour
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Erreur lors de la mise à jour des données.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la mise à jour : $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tous les champs doivent être remplis.")),
      );
    }
  }
}
