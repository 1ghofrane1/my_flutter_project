import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void generateInvoice(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Invoice'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Invoice Number: ${generateInvoiceNumber()}'),
              Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
              Text(
                  'Due Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 30)))}'),
              const SizedBox(height: 10),
              const Text('Subscriber Information:'),
              // Add subscriber information here
              const SizedBox(height: 10),
              const Text('Membership Details:'),
              // Add membership details here
              const SizedBox(height: 10),
              const Text(
                  'Total Amount Due: \$XXXX.XX'), // Replace XXXX.XX with the actual total amount due
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Action to perform when "Print" button is pressed
              printInvoice();
            },
            child: const Text('Print'),
          ),
          TextButton(
            onPressed: () {
              // Action to perform when "Send" button is pressed
              sendInvoice();
            },
            child: const Text('Send'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

String generateInvoiceNumber() {
  // Generate a unique invoice number here
  return 'INV-${DateTime.now().millisecondsSinceEpoch}';
}

void printInvoice() {
  // Action to perform when "Print" button is pressed
  print('Invoice printed');
}

void sendInvoice() {
  // Action to perform when "Send" button is pressed
  print('Invoice sent');
}
