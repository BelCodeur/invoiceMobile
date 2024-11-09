import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:invoicehub/widget/Edit_Articles.dart';

bool _isSearching = false;

class ArticlesPage extends StatefulWidget {
  ArticlesPage({Key? key}) : super(key: key);

  @override
  ArticlesPageState createState() => ArticlesPageState();
}

class ArticlesPageState extends State<ArticlesPage> {
  List<dynamic> _ArticlesList = [];
  TextEditingController _searchController = TextEditingController();

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   List myList = await getArticless();
  //   print(myList);
  //   setState(() {
  //     _ArticlessList = myList;
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadArticlesList();
  }

  // Fonction pour charger la liste des articles
  Future<void> _loadArticlesList() async {
    List myList = await getArticles();
    print(myList);
    setState(() {
      _ArticlesList = myList;
    });
  }

  void reloadArticles() {
    _loadArticlesList();
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
                            await searchArticles(_searchController.text);
                        print(searchResults);
                        setState(() {
                          _ArticlesList = searchResults;
                        });
                      },
                    ),
                  ),
                ),
              ),
            //listview
            Expanded(
              flex: 7,
              child: FutureBuilder(
                  future: getArticles(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text("Loading...")
                          ],
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text("Error : ${snapshot.error}");
                        }
                        //display listview
                        return ArticlesListView();
                      default:
                        return Text("Error : ${snapshot.error}");
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget ArticlesListView() {
    return ListView.builder(
      itemCount: _ArticlesList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text(_ArticlesList[index]['unit_price'].toString()),
              subtitle: Text(_ArticlesList[index]['designation']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        // Ouvrir la page d'édition du article et attendre le résultat
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditArticlePage(
                                ArticleId: _ArticlesList[index]['id']),
                          ),
                        );
                        // Recharger la liste si le résultat est positif
                        if (result == true) {
                          _loadArticlesList();
                        }
                      }),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Logique pour supprimer la facture
                      _confirmDelete(
                          index); // Appel de la fonction de confirmation
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List> getArticles() async {
    // await Future.delayed((Duration(seconds: 2)));
    String url = "http://invoiceshub.imagic-community.com/api/article.php";

    try {
      final response = await http.get(Uri.parse("$url?operation=getArticles"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Erreur de connexion à l'API");
      }
    } catch (e) {
      print("Erreur de récupération des articles : ${e.toString()}");
      return [];
    }
    // } catch (e) {}
  }

  Future<List> searchArticles(String query) async {
    print(query);
    Map<String, dynamic> json = {"searchKey": query};
    var operation = "searchArticles";
    final Map<String, dynamic> queryParams = {
      "operation": operation,
      "json": jsonEncode(json),
    };
    http.Response response = await http.get(
        Uri.parse("http://invoiceshub.imagic-community.com/api/article.php")
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

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Êtes-vous sûr de vouloir supprimer cet article ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                deleteArticles(
                    _ArticlesList[index]['id'], index); // Suppression
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteArticles(int ArticlesId, int index) async {
    String url = "http://invoiceshub.imagic-community.com/api/article.php";
    Map<String, dynamic> json = {"deletionId": ArticlesId};
    var operation = "deleteArticle";
    final Map<String, dynamic> queryParams = {
      "operation": operation,
      "json": jsonEncode(json),
    };

    try {
      final response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);

        if (responseData == 1) {
          setState(() {
            _ArticlesList.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("article supprimé avec succès")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur lors de la suppression du article")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur de connexion à l'API")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.toString()}")),
      );
    }
  }
}
