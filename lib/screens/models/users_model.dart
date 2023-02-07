import 'package:firebase_database/firebase_database.dart';

class Users {
  String? email;
  String? uid;
  String? phoneNumber;
  String? fullName;
  String? dt;
  String? address;

  Users(
      {this.email,
      this.uid,
      this.phoneNumber,
      this.fullName,
      this.dt,
      this.address});

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    uid = (dataSnapshot.child("uid").value.toString());
    email = (dataSnapshot.child("email").value.toString());
    fullName = (dataSnapshot.child("name").value.toString());
    phoneNumber = (dataSnapshot.child("phoneNumber").value.toString());
    dt = (dataSnapshot.child("dt").value.toString());
    address = (dataSnapshot.child("address").value.toString());
  }
}
