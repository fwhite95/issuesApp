import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:issues_application/src/models/application_login_state.dart';
import 'package:issues_application/src/models/issue_model.dart';

import 'package:issues_application/src/models/user.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        _user = user;

        //Subscription to issues from db
        _issueSubscription = FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          _issueList = [];
          //error if list is empty

          if (snapshot.data()!.containsKey('issues')) {
            for (var item in snapshot.get('issues')) {
              //Checks if values are null, if null just prints error but adds remaining full items
              try {
                _issueList.add(
                  IssueModel(
                      title: item['title'],
                      description: item['description'],
                      label: item['label'],
                      projects: item['projects'],
                      issueId: item['issueId'],
                      isComplete: item['isComplete']),
                );
              } catch (e) {
                print("Error: $e");
              }
            }
          }
        });

        notifyListeners();
      } else {
        _loginState = ApplicationLoginState.loggedOut;

        _issueList = [];
        _issueSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  User? _user;
  User? get user => _user;

  //Subscription to database
  StreamSubscription<DocumentSnapshot>? _issueSubscription;
  List<IssueModel> _issueList = [];
  List<IssueModel> get issueList => _issueList;

  void startLoginFlow() {
    _loginState = ApplicationLoginState.login;
    notifyListeners();
  }

  void startRegisterFlow() {
    _loginState = ApplicationLoginState.register;
    notifyListeners();
  }

  void signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void registerAccount(
    String email,
    String displayName,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(displayName);
      print(credential.user?.uid);

      addUserToDb(UserModel(
        displayName: credential.user!.displayName.toString(),
        email: credential.user!.email.toString(),
        uid: user!.uid,
      ));
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void startCreateNewIssue() {
    _loginState = ApplicationLoginState.newIssue;
    notifyListeners();
  }

  void viewIssues() {
    _loginState = ApplicationLoginState.loggedIn;
    notifyListeners();
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.loggedOut;
    notifyListeners();
  }

  void updateIsComplete(bool isComplete, int index) async {
    try {
      issueList[index].isComplete = isComplete;
      List<Map> list = [];

      issueList.forEach((model) {
        list.add(model.toJson());
      });

      var userRef =
          FirebaseFirestore.instance.collection('Users').doc(user?.uid);
      await userRef.set({
        'issues': FieldValue.arrayUnion(list),
      });
    } catch (e) {
      print('Error in updateIsComplete @auth_provider: ${e.toString()}');
    }
  }

  Future<void> addUserToDb(UserModel user) {
    return FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      'displayName': user.displayName,
      'email': user.email,
      'uid': user.uid,
    });
  }

  void createNewIssue(
    IssueModel issue,
  ) async {
    try {
      issueList.add(issue);
      List<Map> list = [];

      issueList.forEach((model) {
        list.add(model.toJson());
      });
      var userRef =
          FirebaseFirestore.instance.collection('Users').doc(user?.uid);
      await userRef.update({
        'issues': FieldValue.arrayUnion(list),
      });
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

//or void deleteIssue(int index) async {
//issueList.remove(issueList[index]);
//}
  void deleteIssue(
    IssueModel issue,
  ) async {
    try {
      issueList.remove(issue);
      List<Map> list = [];

      issueList.forEach((model) {
        list.add(model.toJson());
      });
      var userRef =
          FirebaseFirestore.instance.collection('Users').doc(user?.uid);
      await userRef.update({
        'issues': FieldValue.arrayUnion(list),
      });
    } on FirebaseException catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}
