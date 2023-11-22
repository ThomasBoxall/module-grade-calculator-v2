import '../main.dart';
import 'package:flutter/material.dart';

/// Class to represent the types of assessment supported by the app.
/// Stores information that is required about the module
class AssessmentType{
  
  String name;
  IconData icon;
  String code; // this exists to deal with ListView strangeness

  /// Default constructor: requires all parameters to be specified
  AssessmentType(this.name, this.icon, this.code);
}

/// Map containing the different available assessment types
final Map<String, AssessmentType> assessmentTypes = {
  "ass": AssessmentType("generic Assessment", Icons.question_mark, "ass"),
  "exm": AssessmentType("Exam", Icons.edit, "exm"),
  "cbt": AssessmentType("Computer Based Test", Icons.computer, "cbt")
};

/// Return the `name` value of the corresponding AssessmentType object in the assessmentTypes map
String getAssessmentTypeName(String shortCode){
  return assessmentTypes[shortCode]!.name;
}