import 'package:flutter/material.dart';
import 'package:issues_application/src/models/issue_model.dart';
import 'package:issues_application/src/widgets/issue_tile.dart';

class IssuesHomeScreen extends StatefulWidget {
  IssuesHomeScreen({
    required this.signOut,
    required this.issuesList,
    required this.createNewIssue,
    required this.updateIsComplete,
    required this.deleteIssue,
  });

  final void Function() signOut;
  //Use this to call to function to add new issues
  //final FutureOr<void> Function(IssueModel issue) newIssue;
  final void Function() createNewIssue;
  final void Function(bool isComplete, int index) updateIsComplete;
  final List<IssueModel> issuesList;
  final void Function(IssueModel issue) deleteIssue;

  @override
  _IssuesHomeScreenState createState() => _IssuesHomeScreenState();
}

class _IssuesHomeScreenState extends State<IssuesHomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: ElevatedButton(
                onPressed: () {
                  widget.createNewIssue();
                },
                child: Text('New Issue'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  widget.signOut();
                },
                child: Text('Sign out'),
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                obscureText: false,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: 'Search Issues',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        widget.issuesList.isEmpty
            ? Center(
                child: Text('No Issues'),
              )
            :  Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.issuesList.length,
                itemBuilder: (context, index) {
                  return IssueTile(
                    title: '${widget.issuesList[index].title}',
                    description: '${widget.issuesList[index].description}',
                    label: '${widget.issuesList[index].label}',
                    project: '${widget.issuesList[index].projects}',
                    issueId: widget.issuesList[index].issueId,
                    isComplete: widget.issuesList[index].isComplete,
                    index: index,
                    updateIsComplete: widget.updateIsComplete,
                    deleteIssue: widget.deleteIssue,
                    issueModel: widget.issuesList[index],
                  );
                },
              ),
            ),
            
      ],
    );
  }
}
