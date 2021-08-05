import 'package:flutter/material.dart';
import 'package:issues_application/src/models/application_login_state.dart';
import 'package:issues_application/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("My Issues"),
        backgroundColor: Colors.redAccent,
        
      ),
      body: Consumer<ApplicationState>(
          builder: (context, appState, _) => Authentication(
              loginState: appState.loginState,
              email: appState.email,
              startLoginFlow: appState.startLoginFlow,
              startRegisterFlow: appState.startRegisterFlow,
              signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut,
              //issues
              issuesList: appState.issueList,
              startCreateNewIssue: appState.startCreateNewIssue,
              viewIssues: appState.viewIssues,
              createNewIssue: appState.createNewIssue,
              updateIsComplete: appState.updateIsComplete,
              ),
        ),
    );
  }
}
