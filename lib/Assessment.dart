import 'package:flutter/material.dart';


class Assessment{
  /// Class to represent a single assessment. Many assessments comprise a single module
  
  String assessmentName;
  int assessmentPercentageOfModule;
  int markPercentageOfAssessment;
  Icon assessmentIcon;


  Assessment(this.assessmentName, this.assessmentPercentageOfModule, this.markPercentageOfAssessment, this.assessmentIcon);
}

enum AssessmentTypes {
  exam('Exam', Icons.edit),
  cbt('Computer Based Test', Icons.computer);
  
  const AssessmentTypes(this.label, this.icon);
  final String label;
  final IconData icon;
}