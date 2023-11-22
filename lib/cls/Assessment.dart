import 'package:flutter/material.dart';


/// Class to represent a single assessment. Many assessments comprise a single module
class Assessment{
  
  String assessmentName;
  int assessmentPercentageOfModule;
  double markPercentageOfAssessment;
  bool taken;
  String assessmentType;

  /// Default Constructor: requires all parameters to be specified
  Assessment(this.assessmentName, this.assessmentPercentageOfModule, this.markPercentageOfAssessment, this.assessmentType,  this.taken);

  /// Updates all values in the assessment
  void updateAssessment(assessmentName, assessmentPercentageOfModule, markPercentageOfAssessment, assessmentType, taken){
    this.assessmentName = assessmentName;
    this.assessmentPercentageOfModule = assessmentPercentageOfModule;
    this.markPercentageOfAssessment = markPercentageOfAssessment;
    this.assessmentType = assessmentType;
    this.taken = taken;
  }
}


