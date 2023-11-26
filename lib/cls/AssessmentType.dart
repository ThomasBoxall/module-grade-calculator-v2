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
  "ass": AssessmentType("Assessment - Generic", Icons.quiz_outlined, "ass"),
  "cwk": AssessmentType("Coursework", Icons.assignment_outlined, "cwk"),
  "prs": AssessmentType("Coursework - Presentation", Icons.co_present, "prs"),
  "pot": AssessmentType("Coursework - Portfolio", Icons.newspaper, "pot"),
  "rep": AssessmentType("Coursework - Report", Icons.layers_outlined, "rep"),
  "pct": AssessmentType("Coursework - Practical", Icons.science_outlined, "pct"),
  "exm": AssessmentType("Exam", Icons.edit_outlined, "exm"),
  "cbt": AssessmentType("Exam - Computer Based", Icons.computer, "cbt"),
  "quz": AssessmentType("Quiz", Icons.checklist_rtl, "quz")

};

/// Return the `name` value of the corresponding AssessmentType object in the assessmentTypes map
String getAssessmentTypeName(String shortCode){
  return assessmentTypes[shortCode]!.name;
}