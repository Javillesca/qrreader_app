import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:barcode_scan/barcode_scan.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/bloc/scan_bloc.dart';

import 'package:qrreaderapp/src/pages/maps_page.dart';
import 'package:qrreaderapp/src/pages/directions_page.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
          )
        ],
      ),
      body: _callPage(currentIndex),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _createFloatingActionButton(),
        bottomNavigationBar: _createBottomNavBar()
    );
  }

  Widget _callPage(int ActPage ) {
    switch(ActPage) {
      case 0: return MapsPage();
      case 1: return DirectionPage();
      default:
        return MapsPage();
    }
  }

  Widget _createBottomNavBar() {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon( Icons.map ),
              title: Text('Ubicación')
          ),
          BottomNavigationBarItem(
              icon: Icon( Icons.directions),
              title: Text('Direcciones')
          ),
        ]
    );
  }

  Widget _createFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () => _scanQR(context),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  _scanQR(BuildContext context) async {
    //http://javillesca.com/
    //geo:36.596957722052494,-4.50831785639652
    dynamic futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch(e) {
      futureString = e.toString();
    }

    if(futureString != null) {

      final scan = ScanModel(value: futureString.rawContent);
      scansBloc.addScan(scan);

      if(Platform.isIOS) {
        Future.delayed(Duration( milliseconds: 750), () {
          utils.launchUrl(context, scan);
        });
      } else {
        utils.launchUrl(context, scan);
      }
    }
  }
}


