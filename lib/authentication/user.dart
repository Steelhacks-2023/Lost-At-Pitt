import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final GeoPoint? location;

  MyUser({required this.uid, this.email, this.firstName, this.lastName, this.location});

factory MyUser.fromFirestore(
    QueryDocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    try {
      return MyUser(
          uid: data['uid'],
          email: data['email'],
          firstName: data['firstName'],
          lastName: data['lastName'],
          location: data['location']);
    } catch (e) {
      return MyUser(
          uid: 'UserID',
          email: 'someone@example.com',
          firstName: "First",
          lastName: "Last",
          location: GeoPoint(0, 0));
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      "firstName": firstName,
      "lastName": lastName,
      "location": location,
    };
  }

}

