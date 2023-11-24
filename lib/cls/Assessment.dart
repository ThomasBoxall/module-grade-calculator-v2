import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'Assessment.g.dart';

/// Class to represent a single assessment. Many assessments comprise a single module
@HiveType(typeId: 1)
class Assessment{
  @HiveField(0)
  String assessmentName;
  @HiveField(1)
  int assessmentPercentageOfModule;
  @HiveField(2)
  double markPercentageOfAssessment;
  @HiveField(3)
  bool taken;
  @HiveField(4)
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

  Map toJson(){
    return{
      'assessmentName': this.assessmentName,
      'assessmentPercentageOfModule': this.assessmentPercentageOfModule,
      'markPercentageOfAssessment': this.markPercentageOfAssessment,
      'taken': this.taken,
      'assessmentType': this.assessmentType
    };
  }
}


