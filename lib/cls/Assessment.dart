import 'package:flutter/material.dart';


class Assessment{
  /// Class to represent a single assessment. Many assessments comprise a single module
  
  String assessmentName;
  int assessmentPercentageOfModule;
  double markPercentageOfAssessment;
  // Icon assessmentIcon;
  bool taken;
  String assessmentType;


  Assessment(this.assessmentName, this.assessmentPercentageOfModule, this.markPercentageOfAssessment, this.assessmentType,  this.taken);
}

// enum AssessmentTypes {
//   exam('Exam', Icons.edit),
//   cbt('Computer Based Test', Icons.computer);
  
//   const AssessmentTypes(this.label, this.icon);
//   final String label;
//   final IconData icon;
// }

class AssessmentType{
  String name;
  IconData icon;

  AssessmentType(this.name, this.icon);
}

final Map<String, AssessmentType> assessmentTypes = {
  "exam": AssessmentType("Exam", Icons.edit),
  "cbt": AssessmentType("Computer Based Test", Icons.computer)
};