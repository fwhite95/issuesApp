import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:issues_application/src/models/issue_model.dart';
import 'package:issues_application/src/models/user.dart';
import 'package:issues_application/src/views/auth/login_form.dart';
import 'package:issues_application/src/views/auth/register_form.dart';
import 'package:issues_application/src/views/home/issues_home_screen.dart';
import 'package:issues_application/src/views/home/logged_out_home_screen.dart';
import 'package:issues_application/src/views/home/new_issues_screen.dart';

enum ApplicationLoginState {
  loggedOut,
  register,
  login,
  loggedIn,
  registering,
  //Adding new enums, eventually create issues_state? with new consumer under loggedIn
  newIssue,
}

class Authentication extends StatelessWidget {
  const Authentication({
    required this.loginState,
    required this.email,
    required this.startLoginFlow,
    required this.startRegisterFlow,
    required this.signInWithEmailAndPassword,
    required this.cancelRegistration,
    required this.registerAccount,
    required this.signOut,
    //issues
    required this.issuesList,
    required this.startCreateNewIssue,
    required this.viewIssues,
    required this.createNewIssue,
    required this.updateIsComplete,
    required this.deleteIssue,
  });

  final ApplicationLoginState loginState;
  final String? email;
  final void Function() startLoginFlow;
  final void Function() startRegisterFlow;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function(
    String email,
    String displayName,
    String password,
    void Function(Exception e) error,
  ) registerAccount;
  final void Function() signOut;

  //Issue functions, eventually moved?
  final List<IssueModel> issuesList;
  final void Function() startCreateNewIssue;
  final void Function() viewIssues;
  final void Function(
    IssueModel issue,
  ) createNewIssue;
  final void Function(bool isComplete, int index) updateIsComplete;
  final void Function(IssueModel issue) deleteIssue;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return LoggedOutHomePage(
          startLoginFlow: startLoginFlow,
          startRegisterFlow: startRegisterFlow,
        );
      case ApplicationLoginState.login:
        return LoginForm(
          login: (email, password) {
            signInWithEmailAndPassword(email, password,
                (e) => _showErrorDialog(context, 'Failed to sign in', e));
          },
          loggedOut: cancelRegistration,
        );
      case ApplicationLoginState.register:
        return RegisterForm(
          cancel: () {
            cancelRegistration();
          },
          registerAccount: (
            email,
            displayName,
            password,
          ) {
            registerAccount(
                email,
                displayName,
                password,
                (e) =>
                    _showErrorDialog(context, 'Failed to create account', e));
          },
        );
      case ApplicationLoginState.loggedIn:
        return IssuesHomeScreen(
          signOut: signOut,
          issuesList: issuesList,
          createNewIssue: startCreateNewIssue,
          updateIsComplete: updateIsComplete,
          deleteIssue: deleteIssue,
        );
      case ApplicationLoginState.newIssue:
        return NewIssuesScreen(
          viewIssues: viewIssues,
          createNewIssue: createNewIssue,
        );
      default:
        return Row(
          children: const [
            Text("Internal error, this shouldn't happen..."),
          ],
        );
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: const TextStyle(fontSize: 24),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    '${(e as dynamic).message}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          );
        });
  }
}
