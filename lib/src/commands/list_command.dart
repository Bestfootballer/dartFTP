enum ListCommand { nlst, list, mlsd }

extension CommandListTypeEnum on ListCommand {
  String get describeEnum =>
      toString().toUpperCase().substring(toString().indexOf('.') + 1);
}
