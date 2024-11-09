import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:invoicehub/widget/Edit_customer.dart';

bool _isSearching = false;

class CustomersPage extends StatefulWidget {
  CustomersPage({Key? key}) : super(key: key);

  @override
  CustomersPageState createState() => CustomersPageState();
}

class CustomersPageState extends State<CustomersPage> {
  List<dynamic> _customersList = [];
  TextEditingController _searchController = TextEditingController();
  final String apiUrl =
      "http://invoiceshub.imagic-community.com/api/client.php";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCustomerList();
  }

  // Fonction pour charger la liste des clients
  Future<void> _loadCustomerList() async {
    List myList = await getCustomers();
    setState(() {
      _customersList = myList;
    });
  }

  void reloadCustomers() {
    _loadCustomerList();
  }

  void toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Center(
        child: Column(
          children: [
            // Barre de recherche
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Rechercher...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        List searchResults =
                            await searchClients(_searchController.text);
                        print(searchResults);
                        setState(() {
                          _customersList = searchResults;
                        });
                      },
                    ),
                  ),
                ),
              ),

            // Liste des clients
            Expanded(
              child: FutureBuilder(
                future: getCustomers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20.0),
                        Text("Chargement en cours..."),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("Erreur : ${snapshot.error}");
                  } else {
                    return customersListView();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customersListView() {
    return ListView.builder(
      itemCount: _customersList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text(_customersList[index]['telephone']),
              subtitle: Text(_customersList[index]['nom']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCustomerPage(
                            customerId: _customersList[index]['id'],
                          ),
                        ),
                      );
                      if (result == true) {
                        _loadCustomerList();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _confirmDelete(index),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List> getCustomers() async {
    final response = await http.get(Uri.parse("$apiUrl?operation=getClients"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  Future<void> deleteClient(int clientId) async {
    Map<String, dynamic> json = {"deletionId": clientId};
    var operation = "deleteClient";
    final Map<String, dynamic> queryParams = {
      "operation": operation,
      "json": jsonEncode(json),
    };

    final response =
        await http.get(Uri.parse(apiUrl).replace(queryParameters: queryParams));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _customersList.removeWhere((client) => client['id'] == clientId);
      });
    }
  }

  Future<List> searchClients(String query) async {
    print(query);
    Map<String, dynamic> json = {"searchKey": query};
    var operation = "searchClients";
    final Map<String, dynamic> queryParams = {
      "operation": operation,
      "json": jsonEncode(json),
    };
    http.Response response = await http.get(
        Uri.parse("http://invoiceshub.imagic-community.com/api/client.php")
            .replace(queryParameters: queryParams));
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      print(decodedResponse);
      // Vérifiez que la réponse est une liste
      if (decodedResponse is List) {
        return decodedResponse;
      } else {
        return []; // Renvoyer une liste vide si la réponse n'est pas une liste
      }
    } else {
      return [];
    }
  }

  void _confirmDelete(int index) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmation"),
        content: Text("Voulez-vous vraiment supprimer ce client ?"),
        actions: [
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("Supprimer"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirmDelete == true) {
      int clientId = _customersList[index]['id'];
      await deleteClient(clientId);
    }
  }
}
