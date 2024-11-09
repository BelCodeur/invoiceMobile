import 'package:flutter/material.dart';

class ProformaPage extends StatefulWidget {
  ProformaPage({super.key});

  @override
  _ProformaPageState createState() => _ProformaPageState();
}

class _ProformaPageState extends State<ProformaPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  // Variables pour la pagination
  int _totalProformas =
      12; // Le nombre total de factures (à remplacer par des données réelles)
  int _ProformasPerPage = 5; // Le nombre de factures par page
  int _currentPage = 1; // La page actuelle

  int get _totalPages => (_totalProformas / _ProformasPerPage).ceil();

  List<Proforma> Proformas = List.generate(
    12,
    (index) => Proforma(
        number: 'INV00${index + 1}', clientName: 'Client ${index + 1}'),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(text: 'Global'),
                Tab(text: 'Payée'),
                Tab(text: 'Non envoyée'),
                Tab(text: 'Envoyée'),
                Tab(text: 'Annulée'),
              ],
            ),
            Expanded(
              // height: MediaQuery.of(context).size.height * 0.8, //
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProformaList(), // Global
                  _buildProformaList(), // Payée
                  _buildProformaList(), // Non envoyée
                  _buildProformaList(), // Envoyée
                  _buildProformaList(), // Annulée
                ],
              ),
            ),
            _buildPagination(),
          ],
        ));
  }

  Widget _buildProformaList() {
    int start = (_currentPage - 1) * _ProformasPerPage;
    int end = start + _ProformasPerPage;
    List<Proforma> currentPageProformas = Proformas.sublist(
      start,
      end > _totalProformas ? _totalProformas : end,
    );

    return ListView.builder(
      itemCount: currentPageProformas.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 2,
            child: ListTile(
              title: Text('N°Proforma ${currentPageProformas[index].number}'),
              subtitle: Text(
                  'Nom du client ${currentPageProformas[index].clientName}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Logique pour éditer la facture
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Logique pour supprimer la facture
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

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                : null,
          ),
          Text('$_currentPage/$_totalPages'),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: _currentPage < _totalPages
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class Proforma {
  final String number;
  final String clientName;

  Proforma({required this.number, required this.clientName});
}
