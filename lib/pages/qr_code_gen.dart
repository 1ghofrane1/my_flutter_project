import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: '1234567890',
      version: QrVersions.auto,
      size: 200.0,
    );
  }
}








































/*
class QRCodeGenerator extends StatelessWidget {
  final String managerIdentifier;

  QRCodeGenerator({required this.managerIdentifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan to Associate'),
      ),
      body: Center(
        child: QrImage(
          data: managerIdentifier,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class qr_code_gen extends StatefulWidget {
  const qr_code_gen({super.key});

  @override
  State<qr_code_gen> createState() => _qr_code_genState();
}
/////////////////

class _qr_code_genState extends State<qr_code_gen> {
  final GlobalKey globalKey = GlobalKey();
  String qrData = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Generate QR Code"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              RepaintBoundary(
                key: globalKey,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: qrData.isEmpty
                        ? Text(
                            'data',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          )
                        : QrImage(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 200,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
*/