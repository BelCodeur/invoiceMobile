import 'package:flutter/material.dart';

class InvoicePage extends StatefulWidget {
  InvoicePage({super.key});

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  // Variables pour la pagination
  int _totalInvoices =
      12; // Le nombre total de factures (à remplacer par des données réelles)
  int _invoicesPerPage = 5; // Le nombre de factures par page
  int _currentPage = 1; // La page actuelle

  int get _totalPages => (_totalInvoices / _invoicesPerPage).ceil();

  List<Invoice> invoices = List.generate(
    12,
    (index) =>
        Invoice(number: 'INV00${index + 1}', clientName: 'Client ${index + 1}'),
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
                  _buildInvoiceList(), // Global
                  _buildInvoiceList(), // Payée
                  _buildInvoiceList(), // Non envoyée
                  _buildInvoiceList(), // Envoyée
                  _buildInvoiceList(), // Annulée
                ],
              ),
            ),
            _buildPagination(),
          ],
        ));
  }

  Widget _buildInvoiceList() {
    int start = (_currentPage - 1) * _invoicesPerPage;
    int end = start + _invoicesPerPage;
    List<Invoice> currentPageInvoices = invoices.sublist(
      start,
      end > _totalInvoices ? _totalInvoices : end,
    );

    return ListView.builder(
      itemCount: currentPageInvoices.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 2,
            child: ListTile(
              title: Text('N°Facture ${currentPageInvoices[index].number}'),
              subtitle: Text(
                  'Nom du client ${currentPageInvoices[index].clientName}'),
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

class Invoice {
  final String number;
  final String clientName;

  Invoice({required this.number, required this.clientName});
}
