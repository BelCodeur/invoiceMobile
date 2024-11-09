import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:invoicehub/functions/publics_functions.dart';
import 'package:invoicehub/widget/client_page.dart';

class AddCustomer extends StatefulWidget {
  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _NiuController;
  late TextEditingController _RccmController;
  late TextEditingController _BpController;
  late TextEditingController _BankController;
  late TextEditingController _NumCompteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _NiuController = TextEditingController();
    _RccmController = TextEditingController();
    _BpController = TextEditingController();
    _BankController = TextEditingController();
    _NumCompteController = TextEditingController();
  }

  Future<void> _loadDefaultValues() async {
    // Vous pouvez ajouter ici la logique pour charger des valeurs par défaut si nécessaire
    // Par exemple :
    // await getCustomerById(0); // Récupérer les données d'un client fictif avec ID 0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter Client'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          child: ListView(
            children: [
              buildTextField('Prénom', _nameController),
              buildTextField('Adresse', _addressController),
              buildTextField('Téléphone', _phoneController),
              buildTextField('NIU', _NiuController),
              buildTextField('RCCM', _RccmController),
              buildTextField('BP', _BpController),
              buildTextField('Banque', _BankController),
              buildTextField('Numéro Compte', _NumCompteController),
            ],
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
    if (_nameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _NiuController.text.isNotEmpty &&
        _RccmController.text.isNotEmpty &&
        _BpController.text.isNotEmpty &&
        _BankController.text.isNotEmpty &&
        _NumCompteController.text.isNotEmpty) {
      var customerData = {
        'id':
            0, // Vous pouvez utiliser un ID généré ou 0 pour un nouveau client
        'nom': _nameController.text,
        'adresse': _addressController.text,
        'telephone': _phoneController.text,
        'NIU': _NiuController.text,
        'RCCM': _RccmController.text,
        'BP': _BpController.text,
        'Bank': _BankController.text,
        'numeroCompteBancaire': _NumCompteController.text,
      };

      try {
        var success = await addCustomer(customerData);
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

  Future<bool> addCustomer(Map<String, dynamic> customerData) async {
    String url =
        "http://invoiceshub.imagic-community.com/api/addCustomer.php"; // Mettez l'URL de votre API ici

    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(customerData));
    print(response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result['success'] == true;
    } else {
      throw Exception("Erreur lors de l'ajout : ${response.statusCode}");
    }
  }
}
