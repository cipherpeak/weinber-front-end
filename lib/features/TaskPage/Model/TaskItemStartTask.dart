class TaskItem {
  final String title;
  final bool isMandatory;
  final bool isCompleted;

  TaskItem({
    required this.title,
    this.isMandatory = false,
    this.isCompleted = false,
  });

  TaskItem copyWith({bool? isCompleted}) {
    return TaskItem(
      title: title,
      isMandatory: isMandatory,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}