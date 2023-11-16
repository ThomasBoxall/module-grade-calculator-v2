import 'package:flutter/material.dart';


class Assessment{
  /// Class to represent a single assessment. Many assessments comprise a single module
  
  String assessmentName;
  int assessmentPercentageOfModule;
  double markPercentageOfAssessment;
  Icon assessmentIcon;
  bool taken;


  Assessment(this.assessmentName, this.assessmentPercentageOfModule, this.markPercentageOfAssessment, this.assessmentIcon,  this.taken);
}

enum AssessmentTypes {
  exam('Exam', Icons.edit),
  cbt('Computer Based Test', Icons.computer);
  
  const AssessmentTypes(this.label, this.icon);
  final String label;
  final IconData icon;
}