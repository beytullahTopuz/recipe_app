import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recepiesapp/core/models/food.dart';
import 'package:recepiesapp/core/models/user.dart';

class MyFireStoreServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime zaman = DateTime.now();

  Future<void> addFood(Food food) async {
    await _firestore.collection("food").doc().set(food.toJson());
  }

  Future<List<Food>> getAllFood() async {
    List<Food> list = [];

    QuerySnapshot snap = await _firestore.collection("food").get();

    snap.docs.forEach((DocumentSnapshot doc) {
      Food f = Food.fromJson(doc.data());
      list.add(f);
    });
    return list;
  }

  Future<void> addUser(UserModel user) async {
    await _firestore.collection("user").doc(user.userId).set(user.toJson());
  }

  Future<void> updateUser(String id, UserModel userModel) async {
    await _firestore.collection("user").doc(id).update(userModel.toJson());
  }

  Future<UserModel> getUser(id) async {
    DocumentSnapshot doc = await _firestore.collection("user").doc(id).get();
    if (doc.exists) {
      UserModel user = UserModel.fromJson(doc.data());
      print("object");
      print(user.userAdSoyad);
      return user;
    }
    return null;
  }
}
