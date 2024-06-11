import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/services/firestore_service.dart'; // Ensure you have this import

void generateInvoice(BuildContext context, String fname, String lname,
    String selected_duration, String docID) async {
  print('Generating invoice...');
  final FirestoreService firestoreService = FirestoreService();
  int? pricing = await firestoreService.getPricing(selected_duration);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF171717),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: const Color(0xFF171717),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Invoice',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                'Invoice Number: ${generateInvoiceNumber(docID)}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Divider(color: Color(0xFFBEF264), thickness: 2),
              const SizedBox(height: 20),
              const Text(
                'Subscriber Information:',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Name: $fname $lname',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Membership Details:',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Duration: $selected_duration',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                'Pricing: ${pricing != null ? 'TND ${pricing.toStringAsFixed(2)}' : 'N/A'}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              const Divider(color: Color(0xFFBEF264), thickness: 2),
              const SizedBox(height: 20),
              Text(
                'Total: ${pricing != null ? 'TND ${pricing.toStringAsFixed(2)}' : 'N/A'}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      // Action to perform when "Save" button is pressed
                      final invoiceDocRef = await FirebaseFirestore.instance
                          .collection('Invoice')
                          .doc(docID) // Use the docID as the document ID
                          .set({
                        'firstName': fname,
                        'lastName': lname,
                        'duration': selected_duration,
                        'pricing': pricing,
                        'date': DateTime.now(),
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Color(0xFF171717)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}

String generateInvoiceNumber(String docID) {
  return 'INV-$docID'; // Using the document ID as the invoice number
}
