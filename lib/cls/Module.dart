import 'Assessment.dart';

class Module{
  String? moduleName;
  String? moduleCode;
  int? credits;
  bool isQuickEdit;
  List<Assessment> assessments = [];


  Module(this.isQuickEdit);
}