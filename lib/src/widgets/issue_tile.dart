import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IssueTile extends StatefulWidget {
  IssueTile({
    required this.title, 
    required this.description, 
    required this.label, 
    required this.project, 
    required this.issueId, 
    required this.isComplete,
    required this.index,
    required this.updateIsComplete,
  });

  final String title;
  final String description;
  final String label;
  final String project;
  final int issueId;
  bool isComplete;
  late final int index;
  final void Function(bool isComplete, int index) updateIsComplete;

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
        trailing: Checkbox(
          value: widget.isComplete,
          onChanged: (bool? value) {
            setState((){
              widget.isComplete = value!;
              widget.updateIsComplete(widget.isComplete, widget.index);
            });
          },
        ),
        isThreeLine: true,
        onTap: () {
          
        },
      ),
    );
  }
}
