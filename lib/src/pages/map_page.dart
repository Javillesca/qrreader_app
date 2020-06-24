import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController mapController = new MapController();
  String typeMap = "streets-v11";


  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicacion QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              mapController.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _fabTypeView(context),
    );
  }

  Widget _createFlutterMap(ScanModel scan) {
    print(scan.getLatLng());
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _createMap(),
        _createMarkers(scan)
      ],
    );
  }

  _createMap() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/'
            '{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
          'accessToken':'pk.eyJ1IjoiamF2aWxsZXNjYSIsImEiOiJja2JtbDZjd3AxazE1MnlsOTRxcWN3aXUyIn0.qodQL3vkZ5MmymkyYDsBuw',
          'id': 'mapbox/$typeMap'
        }
    );
  }

  _createMarkers(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          height: 100.0,
          width: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
                Icons.location_on,
                size: 50.0,
                color: Theme.of(context).primaryColor,
            ),
          )
        )
      ]
    );
  }

  Widget _fabTypeView(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        //streets-v11, dark-v10, light-v10, outdoors-v11, satellite-v9
        setState(() {
          if(typeMap == "streets-v11") {
            typeMap = "dark-v10";
          } else if(typeMap == "dark-v10") {
            typeMap = "light-v10";
          } else if(typeMap == "light-v10") {
            typeMap = "outdoors-v11";
          } else if(typeMap == "outdoors-v11") {
            typeMap = "satellite-v9";
          } else {
            typeMap = "streets-v11";
          }
        });
      },
    );
  }
}
