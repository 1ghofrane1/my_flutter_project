import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/components/expandable_fab.dart';
import 'package:my_flutter_project/components/expandable_fab.dart';
import 'package:my_flutter_project/forms/membershipTypeForm.dart';
import 'package:my_flutter_project/forms/subForm.dart';
import 'package:my_flutter_project/services/firestore.dart';
import 'package:my_flutter_project/voids/openSubBox.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class GymMembers extends StatefulWidget {
  const GymMembers({super.key});

  @override
  State<GymMembers> createState() => _GymMembersState();
}

class _GymMembersState extends State<GymMembers> {
  String? gymId;
  final List<String> membershipNames = [];
  List<String> subList = [];
  final FirestoreService _firestoreService = FirestoreService();

  String? _selectedMembership;
  late TextEditingController startDate = TextEditingController();

  late TextEditingController endDate = TextEditingController();
  String? membershipDuration = '';

  @override
  void initState() {
    super.initState();
    _initializeMembershipDuration();
    _fetchGymId();
  }

  void _initializeMembershipDuration() async {
    String? duration =
        await _firestoreService.getMembershipDuration(_selectedMembership!);
    setState(() {
      membershipDuration = duration ?? '';
    });
  }

  void _fetchGymId() async {
    gymId = await _getGymId();

    print('Gym ID: ${gymId.runtimeType}');
    _fetchMembershipNames(); // Call _fetchMembershipNames after updating gymId
    //_getSub();
    setState(() {});
  }

  Future<String?> _getGymId() async {
    return (await _firestoreService.getCurrentGymId())?.trim();
  }

  Future<void> _fetchMembershipNames() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Membership').get();

    for (final membership in snapshot.docs) {
      final String membershipGymId = membership['gym id'].trim();
      print('Membership Gym ID type: ${membershipGymId.runtimeType}');

      if (membershipGymId == gymId) {
        final membershipName = membership['Membership Name'];
        setState(() {
          membershipNames.add(membershipName);
          print('true');
        });
      } else {
        print('maha2ah');
      }

      print(
          'membershipGymId: $membershipGymId, gymId: $gymId'); // Add this line
    }
  }

  Future<void> _getSub() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Subscriber').get();

    setState(() {
      subList.clear(); // Clear the list before updating with new data
    });

    for (final sub in snapshot.docs) {
      final String subGymId = sub['gym id'].trim();
      print('Subscription Gym ID type: ${subGymId.runtimeType}');

      if (subGymId == gymId) {
        //final String id = sub.id;
        final String firstName = sub['fname'];
        final String lastName = sub['lname'];
        final String fullName = '$firstName $lastName';
        final String email = sub['email'];
        setState(() {
          subList.add(fullName);
          print('trueeeeeeeeeeeeeeee');
        });
      } else {
        print('maha2ah subbbb');
      }
    }
  }

  Stream<QuerySnapshot> subscribersListStream(String gymId) {
    final CollectionReference subRef =
        FirebaseFirestore.instance.collection('Subscriber');

    // Query for documents
    Stream<QuerySnapshot> subStream =
        subRef.where('gym id', isEqualTo: gymId).snapshots();

    return subStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Subscribers',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: 'add a membership type',
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: const Text(
                                      'Add Membership Type',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    content: MembershipForm(),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: membershipNames.isEmpty
                                ? const SizedBox
                                    .shrink() // If membershipNames is empty, don't show anything
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: membershipNames.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Chip(
                                          label: Text(membershipNames[index]),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                      top: 0,
                      child: Text(
                        'Membership Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Total Subscribers: ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: subscribersListStream(gymId!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        return Text(
                          "${snapshot.data!.docs.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        );
                      } else {
                        return const Text(
                          "0",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: subscribersListStream(gymId!),
                builder: (context, snapshot) {
                  // if connection state is waiting, show a loading indicator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // if data available
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List listSub = snapshot.data!.docs;

                    // display as list
                    return ListView.builder(
                      shrinkWrap: true, // Add this line
                      itemCount: listSub.length,
                      itemBuilder: (context, index) {
                        // get each individual doc
                        DocumentSnapshot document = listSub[index];

                        //get sub from each doc
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String firstName = data['fname'];
                        String lastName = data['lname'];
                        String fullName = '$firstName $lastName';
                        final String email = data['email'];

                        // display as list tile
                        return GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Details'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      // Text(
                                      //   id,
                                      //   style: const TextStyle(
                                      //     color: Colors.black,
                                      //     fontSize: 16.0,
                                      //   ),
                                      // ),
                                      Text(
                                        fullName,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        email,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final Uri _emailLaunchUri = Uri(
                                            scheme: 'mailto',
                                            path: email,
                                          );
                                          launch(_emailLaunchUri.toString());
                                        },
                                        icon: const Icon(Icons.email),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final text =
                                              'sms:${data['phone_number']}';
                                          if (await canLaunch(text)) {
                                            await launch(text);
                                          } else {
                                            throw 'Could not launch $text';
                                          }
                                        },
                                        icon: const Icon(Icons.message),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final text =
                                              'tel:${data['phone_number']}';
                                          if (await canLaunch(text)) {
                                            await launch(text);
                                          } else {
                                            throw 'Could not launch $text';
                                          }
                                        },
                                        icon: const Icon(Icons.phone),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Membership Type',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  DropdownButtonFormField<String>(
                                    value: _selectedMembership,
                                    onChanged: (newValue) async {
                                      setState(() {
                                        _selectedMembership = newValue;
                                      });
                                      print(_selectedMembership);
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Membership Type',
                                      labelStyle: TextStyle(fontSize: 14.0),
                                    ),
                                    items: membershipNames
                                        .map((String membershipName) {
                                      return DropdownMenuItem<String>(
                                        value: membershipName,
                                        child: Text(membershipName),
                                      );
                                    }).toList(),
                                  ),
                                  TextField(
                                    controller: startDate,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      labelText: "Start Date",
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          startDate.text =
                                              pickedDate.toString();
                                          if (membershipDuration == 'Monthly') {
                                            DateTime endDateValue = pickedDate
                                                .add(const Duration(days: 30));
                                            endDate.text =
                                                endDateValue.toString();
                                          } else if (membershipDuration ==
                                              'Quarterly') {
                                            DateTime endDateValue = pickedDate
                                                .add(const Duration(days: 90));
                                            endDate.text =
                                                endDateValue.toString();
                                          } else if (membershipDuration ==
                                              'Semi-annual') {
                                            DateTime endDateValue = pickedDate
                                                .add(const Duration(days: 180));
                                            endDate.text =
                                                endDateValue.toString();
                                          } else if (membershipDuration ==
                                              'Annual') {
                                            DateTime endDateValue = pickedDate
                                                .add(const Duration(days: 365));
                                            endDate.text =
                                                endDateValue.toString();
                                          }
                                          print(endDate.text);
                                          print("duration $membershipDuration");
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("End Date: ${endDate.text}"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 100, // Set the desired width
                                    height: 30, // Set the desired height
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Action to perform when button is pressed
                                      },
                                      style: ElevatedButton.styleFrom(
                                        // You can also customize the button's appearance further using styleFrom
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      child: const Text(
                                        'Generate Invoice',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () {},
                                          child: const Text("Save")),
                                      TextButton(
                                          onPressed: () {},
                                          child: const Text("Cancel")),
                                    ],
                                  )
                                ],
                              );
                            },
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 39, 38, 38),
                            margin: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            child: ListTile(
                              title: Text(
                                fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),

                              // tO DO: UPDATE SUBSCRIBER'S INFO : optional

                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFFBEF264),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        title: Text('Edit Subscriber'),
                                        content: SubForm(),
                                        actions: [], // You can add actions if needed
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // no subscribers
                    return const Center(
                      child: Text(
                        "No Subscribers Yet :/",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const ExpandableFab(),
    );
  }
}

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({Key? key}) : super(key: key);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildFab(_animationController, Icons.event, () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("Membership Form"),
                content: MembershipForm(),
                actions: <Widget>[],
              );
            },
          );
        }),
        const SizedBox(height: 8),
        _buildFab(_animationController, Icons.person_add, () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text('Add Subscriber'),
                  content: SubForm(),
                  actions: <Widget>[],
                );
              });

          print("Second fab button pressed!");
        }),
        const SizedBox(height: 16),
        FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFBEF264),
          onPressed: _toggleExpanded,
          tooltip: 'Toggle',
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animationController,
          ),
        ),
      ],
    );
  }

  Widget _buildFab(AnimationController animationController, IconData iconData,
      VoidCallback onPressed) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
      child: FloatingActionButton(
        backgroundColor: const Color(0xFFBEF264),
        onPressed: onPressed,
        tooltip: 'Add',
        child: Icon(
          iconData,
          color: const Color(0xFF171717),
        ),
      ),
    );
  }
}
