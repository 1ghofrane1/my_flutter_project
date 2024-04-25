import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/manager_pages/m_home_page.dart';

class ManageSub extends StatelessWidget {
  const ManageSub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Subscription"),
        // Adding a leading icon button to navigate back to MHomePage
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to MHomePage
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
