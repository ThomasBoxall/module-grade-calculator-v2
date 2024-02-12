import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'Assessment.g.dart';

/// Class to represent a single assessment. Many assessments comprise a single module
@HiveType(typeId: 1)
class Assessment{
  @HiveField(0)
  String assessmentName;
  @HiveField(1)
  double assessmentPercentageOfModule;
  @HiveField(2)
  double markPercentageOfAssessment;
  @HiveField(3)
  bool taken;
  @HiveField(4)
  String assessmentType;

  /// Default Constructor: requires all parameters to be specified
  Assessment(this.assessmentName, this.assessmentPercentageOfModule, this.markPercentageOfAssessment, this.assessmentType,  this.taken);

  /// Updates all values in the assessment
  /// 
  /// [assessmentName] is the name of the assessment
  /// [assessmentPercentageOfModule] is the percentage of the module's overall assessments of which this assessment comprises
  /// [markPercentageOfAssessment] is the user-inputted percentage which they scored in the assessment
  /// [assessmentType] is the internal type type of the assessment which the app uses to display a suitable icon
  /// [taken] is a boolean value for if the assessment has been taken or not 
  void updateAssessment(assessmentName, assessmentPercentageOfModule, markPercentageOfAssessment, assessmentType, taken){
    this.assessmentName = assessmentName;
    this.assessmentPercentageOfModule = assessmentPercentageOfModule;
    this.markPercentageOfAssessment = markPercentageOfAssessment;
    this.assessmentType = assessmentType;
    this.taken = taken;
  }

  /// Converts single Assessment to JSON format
  Map toJson(){
    return{
      "assessmentName": this.assessmentName,
      "assessmentPercentageOfModule": this.assessmentPercentageOfModule,
      "markPercentageOfAssessment": this.markPercentageOfAssessment,
      "taken": this.taken,
      "assessmentType": this.assessmentType
    };
  }

  /// Constructs Assessment from [json] passed into it. 
  factory Assessment.fromJson(Map<String, dynamic> json){
    return Assessment(
      json['assessmentName'] as String,
      json['assessmentPercentageOfModule'] as double,
      json['markPercentageOfAssessment'] as double,
      json['assessmentType'] as String,
      json['taken'] as bool
    );
  }
}


