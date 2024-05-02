import 'package:cloud_firestore/cloud_firestore.dart';

// Create Admin
Future<void> createAdmin(String uid, String name, String email) async {
  await FirebaseFirestore.instance.collection('Admins').doc(uid).set({
    'name': name,
    'email': email,
  });
}

// Create Gym
Future<void> createGym(
    String name, String address, List<String> adminIds) async {
  DocumentReference gymRef =
      await FirebaseFirestore.instance.collection('Gyms').add({
    'name': name,
    'address': address,
  });
  // Add admins to the gym
  for (String adminId in adminIds) {
    gymRef.collection('Admins').doc(adminId).set({'adminId': adminId});
  }
}

// Create Subscriber
Future<void> createSubscriber(String name, String email, String gymId) async {
  await FirebaseFirestore.instance.collection('Subscribers').add({
    'name': name,
    'email': email,
    'gymId': gymId,
  });
}

// Example usage:
void main() async {
  // Create admin
  await createAdmin('admin123', 'Admin Name', 'admin@example.com');

  // Create gym
  await createGym('Gym Name', 'Gym Address', ['admin123']);

  // Create subscriber
  await createSubscriber('Subscriber Name', 'subscriber@example.com', 'gym123');
}
