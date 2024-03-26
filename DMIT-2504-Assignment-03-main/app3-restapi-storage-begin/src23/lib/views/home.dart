import 'package:flutter/material.dart';
import 'dart:async';
import '../services/stock-service.dart';
import '../services/db-service.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final StockService stockService = StockService();
  final SQFliteDbService databaseService = SQFliteDbService();
  List<Map<String, dynamic>> stockList = [];
  String stockSymbol = "";

  @override
  void initState() {
    super.initState();
    getOrCreateDbAndDisplayAllStocksInDb();
  }

  void getOrCreateDbAndDisplayAllStocksInDb() async {
    await databaseService.getOrCreateDatabaseHandle();
    stockList = await databaseService.getAllStocksFromDb();
    await databaseService.printAllStocksInDbToConsole();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Ticker'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text(
                'Delete All Records and Db',
              ),
              onPressed: () async {
                await databaseService.deleteDb();
                await databaseService.getOrCreateDatabaseHandle();
                stockList = await databaseService.getAllStocksFromDb();
                await databaseService.printAllStocksInDbToConsole();
                setState(() {});
              },
            ),
            ElevatedButton(
              child: const Text(
                'Add Stock',
              ),
              onPressed: () {
                inputStock();
              },
            ),
            Expanded(
              //TODO: Replace this Text child with a ListView.builder
              child: Text(''),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> inputStock() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Input Stock Symbol'),
            contentPadding: const EdgeInsets.all(5.0),
            content: TextField(
              decoration: const InputDecoration(hintText: "Symbol"),
              onChanged: (String value) {
                stockSymbol = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Add Stock"),
                onPressed: () async {
                  if (stockSymbol.isNotEmpty) {
                    print('User entered Symbol: $stockSymbol');
                    var symbol = stockSymbol;
                    var companyName = '';
                    var price = '';
                    try {} catch (e) {
                      print('HomeView inputStock catch: $e');
                    }
                  }
                  stockSymbol = "";
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
