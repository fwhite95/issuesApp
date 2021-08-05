import 'package:flutter/material.dart';
import 'package:issues_application/src/models/issue_model.dart';

// ignore: must_be_immutable
class IssueTile extends StatefulWidget {
  //should refactor to only pass the issueModel instead of attributes
  IssueTile({
    required this.title,
    required this.description,
    required this.label,
    required this.project,
    required this.issueId,
    required this.isComplete,
    required this.index,
    required this.updateIsComplete,
    required this.deleteIssue,
    required this.issueModel,
  });

  final String title;
  final String description;
  final String label;
  final String project;
  final int issueId;
  bool isComplete;
  late final int index;
  final void Function(bool isComplete, int index) updateIsComplete;
  final void Function (IssueModel issue) deleteIssue;
  final IssueModel issueModel;

  @override
  _IssueTileState createState() => _IssueTileState();
}

class _IssueTileState extends State<IssueTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(widget.label),
        title: Text('${widget.title}'),
        subtitle: Text(widget.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: widget.isComplete,
              onChanged: (bool? value) {
                setState(() {
                  widget.isComplete = value!;
                  widget.updateIsComplete(widget.isComplete, widget.index);
                });
              },
            ),
            IconButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Delete issue'),
                  content: Text('Do you want to delete this item?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        print('Delete function call here');
                        widget.deleteIssue(widget.issueModel);
                        Navigator.pop(context, 'OK');
                      },
                      child: Text('OK'),
                      ),
                  ],
                ),
              ),
              icon: Icon(Icons.delete),
              ),
          ],
        ),
        
        isThreeLine: true,
        onTap: () {},
      ),
    );
  }
}
