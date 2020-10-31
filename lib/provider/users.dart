import 'package:basetraining/components/validators/validator_login.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/services/api_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../locator.dart';

class Users with ChangeNotifier {
  ApiUsers _api = locator<ApiUsers>();
  UserModal userLogged;
  bool userAdm;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  get getUserAdm {
    return userAdm;
  }

  void setUserLogged(user) {
    userLogged = user;
    if (userLogged.role == 'adm') {
      userAdm = true;
    } else
      userAdm = false;
  }

  get getScaffoldKey {
    return scaffoldKey;
  }

  void setScaffoldKey(valeuKey) {
    if (scaffoldKey != null) {
      this.scaffoldKey = valeuKey;
    }
  }

  void notify() {
    notifyListeners();
  }

  List<UserModal> users;

  Future<UserModal> findUserId(String id) async {
    var result = await _api.getDocumentById(id);

    UserModal user = UserModal.fromMap(result.data(), result.id);
    return user;
  }

  Future<List<UserModal>> findAll() async {
    var result = await _api.getDataCollection();
    users = result.docs
        .map((doc) => UserModal.fromMap(doc.data(), doc.id))
        .toList();
    return users;
  }

  Future<List<UserModal>> findQuery(dynamic field, dynamic value) async {
    var result = await _api.getQueryCollection(field, value);
    users = result.docs
        .map((doc) => UserModal.fromMap(doc.data(), doc.id))
        .toList();
    return users;
  }

  int get count {
    return users.length;
  }

  Future<String> put(UserModal user, context) async {
    String message;
    if (user == null) {
      message = 'Erro inconsistencia nos dados';
    }

    if (user.id != null) {
      await _api.updateDocument(user.toJson(), user.id);
    } else {
      try {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final UserCredential userId = await auth.createUserWithEmailAndPassword(
            email: user.email, password: user.password);
        UserModal userFinal = UserModal(
          idAuth: userId.user.uid,
          name: user.name,
          email: user.email,
          password: user.password,
          phone: user.phone,
        );

        DocumentReference doc = await _api.addDocument(userFinal.toJson());
        if (doc != null) {
          UserModal user = UserModal(
            id: doc.id,
            idAuth: userFinal.idAuth,
            name: userFinal.name,
            email: userFinal.email,
            password: userFinal.password,
            phone: userFinal.phone,
            role: '',
          );
          await _api.updateDocument(user.toJson(), doc.id);
        }

        message = '';
      } catch (e) {
        message = ValidatorLogin.validate(e.code);
      }
    }

    notifyListeners();
    return message;
  }

  Future remove(UserModal user) async {
    if (user != null && user.id != null) {
      await _api.removeDocument(user.id);
      notifyListeners();
      return;
    }
  }
}
