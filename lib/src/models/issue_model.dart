class IssueModel {
  IssueModel({ 
    required this.title,
    required this.description,
    required this.label,
    required this.projects,
    required this.issueId,
    required this.isComplete
  });

  final String title;
  final String description;
  final String label;
  final String projects;
  final int issueId;
  bool isComplete;

  @override
  String toString() {
    return "title: $title, " + 
  "description: $description, " + 
  "label: $label, " + 
  "projects: $projects, " + 
  "issueId: $issueId, " + 
  "isComplete: $isComplete, ";
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'title': title,
    'isComplete': isComplete,
    'projects': projects,
    'label': label,
    'issueId': issueId,
  };
}