import '../main.dart';
import 'package:flutter/material.dart';

class AssessmentType{
  String name;
  IconData icon;
  String code;

  AssessmentType(this.name, this.icon, this.code);
}

final Map<String, AssessmentType> assessmentTypes = {
  "ass": AssessmentType("generic Assessment", Icons.question_mark, "ass"),
  "exm": AssessmentType("Exam", Icons.edit, "exm"),
  "cbt": AssessmentType("Computer Based Test", Icons.computer, "cbt")
};

String getAssessmentTypeName(String shortCode){
  return assessmentTypes[shortCode]!.name;
}