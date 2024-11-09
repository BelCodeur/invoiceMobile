// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
// import 'package:fl_chart_app/presentation/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:invoicehub/widget/add_articles.dart';
import 'package:invoicehub/widget/add_customer.dart';
import 'package:invoicehub/widget/article_page.dart';
import 'package:invoicehub/widget/client_page.dart';
import 'package:invoicehub/widget/dashboard_page.dart';
import 'package:invoicehub/widget/facture_page.dart';
import 'package:invoicehub/widget/my_dawer_header.dart';
import 'package:invoicehub/widget/proforma_page.dart';
import 'package:invoicehub/widget/setting_page.dart';

class AcceilPage extends StatefulWidget {
  final int userId;
  final String userlName;
  final String userEmail;

  const AcceilPage(
      {required this.userId, required this.userlName, required this.userEmail});

  @override
  State<AcceilPage> createState() => _AcceilPageState();
}

class _AcceilPageState extends State<AcceilPage> {
  // final GlobalKey<_CustomersPageState> _customersPageKey =
  //   GlobalKey<_CustomersPageState>();

  // final GlobalKey<CustomersPageState> _customersPageKey =
  //     GlobalKey<CustomersPageState>();
  final GlobalKey<CustomersPageState> customerPageKey =
      GlobalKey<CustomersPageState>();
  final GlobalKey<ArticlesPageState> articlePageKey =
      GlobalKey<ArticlesPageState>();
  bool _isSearching = true;

  void reloadCustomerList() {
    print("Rechargement de la liste des clients depuis AcceilPage");

    // Vérifier que la clé est bien attachée et appeler la fonction de recharge
    if (customerPageKey.currentState != null) {
      customerPageKey.currentState!.reloadCustomers();
    }
  }

  void toggleSearchCustomer() {
    // Vérifier que la clé est bien attachée et appeler la fonction de recharge
    if (customerPageKey.currentState != null) {
      customerPageKey.currentState!.toggleSearch();
    }
  }

  void toggleSearchArticles() {
    // Vérifier que la clé est bien attachée et appeler la fonction de recharge
    if (articlePageKey.currentState != null) {
      articlePageKey.currentState!.toggleSearch();
    }
  }

  void reloadArticleList() {
    print("Rechargement de la liste des clients depuis AcceilPage");

    // Vérifier que la clé est bien attachée et appeler la fonction de recharge
    if (articlePageKey.currentState != null) {
      articlePageKey.currentState!.reloadArticles();
    }
  }

  int _selectedIndex = 0;
  bool visible = true;
  toggle() {
    setState(() {
      visible = !visible;
    });
  }

  // Méthode pour changer l'index de la barre de navigation
  // void _onItemTapped(int index) {
  void _onItemTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      print("erreur");
    }
  }

  // }
  late List _pages; // Declaration without initializing

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardsPage(),
      ProformaPage(),
      InvoicePage(),
      SettingPage(),
      CustomersPage(key: customerPageKey),
      ArticlesPage(key: articlePageKey)
    ];
  }

  // Liste des widgets de chaque page
  final List _title = [
    'Dashboard',
    'Proforma',
    'Factures',
    'Settings',
    'Clients',
    'Articles'
  ];

  void _showBottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(
                    context); // Ferme le Modal Bottom Sheet après le clic
                _onItemTapped(3); // Navigue vers la page Paramètres
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Clients'),
              onTap: () {
                _isSearching = true;
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 4;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Article'),
              onTap: () {
                _isSearching = true;
                Navigator.pop(
                    context); // Ferme le Modal Bottom Sheet après le clic
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ClientPage()),
                // );
                setState(() {
                  _selectedIndex = 5;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title[_selectedIndex]),
        actions: [
          IconButton(
            onPressed: () {
              if (_selectedIndex == 4) {
                toggleSearchCustomer();

                // Alterner l'état de recherche
              }
              if (_selectedIndex == 5) {
                toggleSearchArticles();
                // Alterner l'état de recherche
              }
              setState(() {
                _isSearching = !_isSearching;
                // Inverse l'état
              });
            },
            icon: Icon(_isSearching ? Icons.search : Icons.close),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          )
        ],
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            MyHeaderDrawer(
                userlName: widget.userlName, userEmail: widget.userEmail),
            Builder(
              builder: (context) {
                return ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Dashboard"),
                  onTap: () {
                    Navigator.pop(context); // Ferme le Drawer
                    setState(() {
                      _selectedIndex = 0; // Navigue vers la page Dashboard
                    });
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                return ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text("Proforma"),
                  onTap: () {
                    Navigator.pop(context); // Ferme le Drawer
                    setState(() {
                      _selectedIndex = 1; // Navigue vers la page Proforma
                    });
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                return ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text("Factures"),
                  onTap: () {
                    Navigator.pop(context); // Ferme le Drawer
                    setState(() {
                      _selectedIndex = 2; // Navigue vers la page Factures
                    });
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                return ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Paramètres"),
                  onTap: () {
                    Navigator.pop(context); // Ferme le Drawer
                    setState(() {
                      _selectedIndex = 3; // Navigue vers la page Paramètres
                    });
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                return ListTile(
                  leading: Icon(Icons.people),
                  title: Text("Client"),
                  onTap: () {
                    Navigator.pop(context); // Ferme le Drawer
                    setState(() {
                      _selectedIndex = 4; // Navigue vers la page Factures
                    });
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text("Article"),
                  onTap: () {
                    Navigator.pop(context); // Ferme le Drawer
                    setState(() {
                      _selectedIndex = 5; // Navigue vers la page Factures
                    });
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text("Quittez"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context); // Ferme le Drawer
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: _pages[_selectedIndex],
      ),
      floatingActionButton: _selectedIndex != 0 &&
              _selectedIndex !=
                  3 // Assurez-vous que l'index 3 correspond à la page Paramètres
          ? FloatingActionButton(
              onPressed: () {
                // Définissez ici l'action spécifique en fonction de l'index de page
                switch (_selectedIndex) {
                  case 1:
                    // Action pour la page Proforma

                    break;
                  case 2:
                    // Action pour la page Factures
                    break;
                  case 4:
                    // Action pour la page Clients
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCustomer()),
                    ).then((_) {
                      // Utiliser le callback pour demander à CustomerPage de se recharger
                      reloadCustomerList();
                    });
                    break;
                  case 5:
                    // Action pour la page Clients

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddArticle()),
                    ).then((_) {
                      // Utiliser le callback pour demander à CustomerPage de se recharger
                      reloadArticleList();
                    });
                    break;
                }
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.teal,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ajoutez cette ligne
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Proforma',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Factures',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex < 4 ? _selectedIndex : 3,
        selectedItemColor: Colors.teal,
        onTap: (index) {
          if (index == 3) {
            _showBottomSheetMenu();
          } else {
            _onItemTapped(index);
          }
        },
      ),
    );
  }
}
// class _AcceilPageState extends State<AcceilPage> {
//   int _selectedIndex = 1; // Démarrer avec le Dashboard
//   bool isLoggedIn = false; // État de connexion

//   // Méthode pour changer l'état de connexion
//   void toggleLoginState() {
//     setState(() {
//       isLoggedIn = !isLoggedIn;
//     });
//   }

//   // Méthode pour changer l'index de la barre de navigation
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index +
//           (isLoggedIn
//               ? 1
//               : 0); // Ajuste l'index si l'utilisateur n'est pas connecté
//     });
//   }

//   // Liste des widgets de chaque page
//   final List _title = ['Dashboard', 'Proforma', 'Factures', 'Settings'];
//   final List _pages = [
//     DashboardsPage(),
//     ProformaPage(),
//     InvoicePage(),
//     SettingPage()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: isLoggedIn
//           ? AppBar(
//               title: Text(
//                   _title[_selectedIndex - 1]), // Ajuste l'index pour l'AppBar
//               actions: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.search),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.more_vert),
//                 ),
//               ],
//               backgroundColor: Colors.teal,
//             )
//           : null, // Pas d'AppBar si non connecté
//       drawer: isLoggedIn
//           ? Drawer(
//               child: ListView(
//                 children: [
//                   MyHeaderDrawer(),
//                   // Items du Drawer...
//                   Builder(
//                     builder: (context) {
//                       return ListTile(
//                         leading: Icon(Icons.home),
//                         title: Text("Dashboard"),
//                         onTap: () {
//                           Navigator.pop(context); // Ferme le Drawer
//                           setState(() {
//                             _selectedIndex =
//                                 0; // Navigue vers la page Dashboard
//                           });
//                         },
//                       );
//                     },
//                   ),
//                   Builder(
//                     builder: (context) {
//                       return ListTile(
//                         leading: Icon(Icons.assignment),
//                         title: Text("Proforma"),
//                         onTap: () {
//                           Navigator.pop(context); // Ferme le Drawer
//                           setState(() {
//                             _selectedIndex = 1; // Navigue vers la page Proforma
//                           });
//                         },
//                       );
//                     },
//                   ),
//                   Builder(
//                     builder: (context) {
//                       return ListTile(
//                         leading: Icon(Icons.receipt),
//                         title: Text("Factures"),
//                         onTap: () {
//                           Navigator.pop(context); // Ferme le Drawer
//                           setState(() {
//                             _selectedIndex = 2; // Navigue vers la page Factures
//                           });
//                         },
//                       );
//                     },
//                   ),
//                   Builder(
//                     builder: (context) {
//                       return ListTile(
//                         leading: Icon(Icons.settings),
//                         title: Text("Paramètres"),
//                         onTap: () {
//                           Navigator.pop(context); // Ferme le Drawer
//                           setState(() {
//                             _selectedIndex =
//                                 3; // Navigue vers la page Paramètres
//                           });
//                         },
//                       );
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.close),
//                     title: Text("Quittez"),
//                     trailing: Icon(Icons.chevron_right),
//                     onTap: () {
//                       Navigator.pop(context); // Ferme le Drawer
//                     },
//                   ),
//                 ],
//               ),
//             )
//           : null, // Pas de Drawer si non connecté
//       body: isLoggedIn
//           ? _pages[_selectedIndex - 1] // Afficher les autres pages si connecté
//           : Center(
//               child: SingleChildScrollView(
//                 child: Login(toggleLoginState), // Afficher la page de connexion
//               ),
//             ),
//       bottomNavigationBar: isLoggedIn
//           ? BottomNavigationBar(
//               type: BottomNavigationBarType.fixed, // Ajoutez cette ligne

//               items: const <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home),
//                   label: 'Dashboard',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.assignment),
//                   label: 'Proforma',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.receipt),
//                   label: 'Factures',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.settings),
//                   label: 'Paramètres',
//                 ),
//               ],
//               currentIndex: _selectedIndex -
//                   1, // Ajuste l'index pour le BottomNavigationBar
//               selectedItemColor: Colors.teal,
//               onTap: _onItemTapped,
//             )
//           : null, // Pas de BottomNavigationBar si non connecté
//     );
//   }
// }
