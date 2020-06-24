import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

launchUrl(BuildContext context, ScanModel scan) async {
  if(scan.type == 'http') {
    if (await canLaunch(scan.value)) {
      await launch(scan.value);
    } else {
      throw 'No se puede abrir ${ scan.value }';
    }
  } else {
    Navigator.pushNamed(context, 'map', arguments: scan);
  }
}