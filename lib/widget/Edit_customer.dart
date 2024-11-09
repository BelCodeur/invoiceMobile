import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:invoicehub/functions/publics_functions.dart';

class EditCustomerPage extends StatefulWidget {
  final int customerId; // Cet attribut est requis pour identifier le client

  EditCustomerPage({required this.customerId});

  @override
  State<EditCustomerPage> createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _NiuController;
  late TextEditingController _RccmController;
  late TextEditingController _BpController;
  late TextEditingController _BankController;
  late TextEditingController _NumCompteController;
  final String apiUrl =
      "http://invoiceshub.imagic-community.com/api/client.php";

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
    _loadCustomerData(); // Charger les données du client à l'initialisation
  }

  void _loadCustomerData() async {
    // Appel à la fonction pour récupérer les données du client
    try {
      var customerData = await getCustomerById(widget.customerId);
      print(customerData);
      setState(() {
        _nameController.text = customerData['nom'];
        _addressController.text = customerData['adresse'];
        _phoneController.text = customerData['telephone'];
        _NiuController.text = customerData['NIU'];
        _RccmController.text = customerData['RCCM'];
        _BpController.text = customerData['BP'];
        _BankController.text = customerData['Bank'];
        _NumCompteController.text = customerData['numeroCompteBancaire'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des données : $e")),
      );
    }
  }

  Future<Map<String, dynamic>> getCustomerById(int customerId) async {
    Map<String, dynamic> json = {"SelectedID": customerId};
    var operation = "getClientById";
    final Map<String, dynamic> queryParams = {
      "operation": operation,
      "json": jsonEncode(json),
    };

    // Méthode POST pour obtenir les données
    http.Response response =
        await http.get(Uri.parse(apiUrl).replace(queryParameters: queryParams));
    print(response.body);
    if (response.statusCode == 200) {
      var customer = jsonDecode(response.body);
      return customer; // Assurez-vous de retourner le premier client
    } else {
      throw Exception(
          "Erreur lors de la récupération des données : ${response.statusCode}");
    }
  }

  Future<bool> updateCustomer(Map<String, dynamic> customerData) async {
    String url =
        "http://invoiceshub.imagic-community.com/api/client.php"; // Mettez l'URL de votre API ici

    final Map<String, dynamic> jsonData = {
      "id": customerData['id'],
      "nom": customerData['nom'],
      "adresse": customerData['adresse'],
      "telephone": customerData['telephone'],
      "NIU": customerData['NIU'],
      "RCCM": customerData['RCCM'],
      "BP": customerData['BP'],
      "Bank": customerData['Bank'],
      "numeroCompteBancaire": customerData['numeroCompteBancaire']
    };
    final Map<String, dynamic> data = {
      "operation": 'updateClient',
      "json": jsonEncode(jsonData),
    };
    // Envoyer les données à l'API pour mise à jour

    http.Response response =
        await http.get(Uri.parse(url).replace(queryParameters: data));
    print(response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result['success'] == true; // Vérifiez si la mise à jour a réussi
    } else {
      throw Exception("Erreur lors de la mise à jour : ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submitForm,
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
              buildTextField('Numéro Compte', _NumCompteController),
              buildTextField('Banque', _BankController),
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
        _NumCompteController.text.isNotEmpty &&
        _BankController.text.isNotEmpty) {
      // Récupérer les valeurs des champs
      var customerData = {
        'id': widget.customerId, // ID du client
        'nom': _nameController.text,
        'adresse': _addressController.text,
        'telephone': _phoneController.text,
        'NIU': _NiuController.text,
        'RCCM': _RccmController.text,
        'BP': _BpController.text,
        'Bank': _BankController.text,
        'numeroCompteBancaire': _NumCompteController.text,
      };

      // Appeler la fonction pour envoyer les données à l'API
      try {
        var success = await updateCustomer(customerData);
        if (success) {
          Navigator.pop(context, true);
          showMessageBox(context, "Success!", "Données modifiées avec succès");
        } else {
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
