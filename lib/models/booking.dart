// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String? id;
  String? c_id;
  String? b_id;
  num? total_price;
  num? rating;
  String? comment;
  String? customer_name;
  String? barber_name;
  String? date;
  String? time;
  bool is_cancelled = false;
  bool? is_completed;
  bool? is_paid;
  List<dynamic>? services;

// default constructor
  Booking({
    this.id,
    this.c_id,
    this.b_id,
    this.total_price,
    this.rating,
    this.comment,
    this.date,
    this.time,
    this.is_cancelled = false,
    this.is_completed,
    this.customer_name,
    this.barber_name,
    this.is_paid,
    this.services,
  });

// booking from firestore
// you pass in the data from firestore snapshot
// e.g.
// final docRef = db.collection("users").doc("1111111111");
// docRef.get().then(
//   (DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final user = User.fromFirestore(data);
//     // ...
//   },
//   onError: (e) => print("Error getting document: $e"),
// );

  // from json
  factory Booking.fromJson(Map<String, dynamic>? json) {
    return Booking(
      id: json!['id'] as String,
      c_id: json['c_id'] as String,
      b_id: json['b_id'] as String,
      total_price: json['total_price'] as num,
      rating: json['rating'] as num,
      comment: json['comment'] as String,
      customer_name: json['customer_name'] as String,
      barber_name: json['barber_name'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      is_cancelled: json['is_cancelled'] as bool,
      is_completed: json['is_completed'] as bool,
      is_paid: json['is_paid'] as bool,
      services: json['services'] as List<dynamic>,
    );
  }

// from firebase snapshot
  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final id = doc.id;
    // print("thi is my: " + id);

    return Booking(
      id: id,
      c_id: data['c_id'] as String?,
      b_id: data['b_id'] as String?,
      total_price: data['total_price'] as num?,
      rating: data['rating'] as num?,
      comment: data['comment'] as String?,
      customer_name: data['customer_name'] as String?,
      barber_name: data['barber_name'] as String?,
      date: data['date'] as String?,
      time: data['time'] as String?,
      is_cancelled: data['is_cancelled'] as bool,
      is_completed: data['is_completed'] as bool?,
      is_paid: data['is_paid'] as bool?,
      services: data['services'] as List<dynamic>?,
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        "c_id": c_id,
        "b_id": b_id,
        "total_price": total_price,
        "date": date,
        "time": time,
        "customer_name": customer_name,
        "barber_name": barber_name,
        "is_cancelled": is_cancelled,
        "is_completed": is_completed,
        "is_paid": is_paid,
        "services": services,
      };
}
