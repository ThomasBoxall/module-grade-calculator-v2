import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../main.dart';

import 'Assessment.dart';
import 'AssessmentType.dart';

part 'Module.g.dart';

/// Class to represent a Module.
/// Modules comprise of a number of options and an array of assessments
@HiveType(typeId: 0)
class Module{
  @HiveField(0)
  String? moduleName;
  @HiveField(1)
  String? moduleCode;
  @HiveField(2)
  int? credits;
  @HiveField(3)
  String? level;
  @HiveField(4)
  bool isQuickEdit;
  @HiveField(5)
  bool isListedToUser; // true="saved", false="un-saved" in terms of how the user sees it.
  @HiveField(6)
  String university;
  @HiveField(7)
  List<Assessment> assessments = [];

  // Default constructor: only requires isQuickEdit and isListedToUser to be defined because "un-saved" modules don't require any other info.
  Module(this.isQuickEdit, this.isListedToUser, this.university);

  // Additional constructor: Instantiates a new module with all parameters defined (primarily used for testing)
  Module.setAllValues(this.moduleName, this.moduleCode, this.credits, this.level, this.isQuickEdit, this.isListedToUser, this.university);

  // Another additional constructor for use when importing from Json 
  Module.setAllValuesIncAssessments(this.moduleName, this.moduleCode, this.credits, this.level, this.isQuickEdit, this.isListedToUser, this.university, this.assessments);

  void updateInformation(modName, modCode, cred, lev, listToUsr){
    /// Updates all values in the Module
    this.moduleName = modName;
    this.moduleCode = modCode;
    this.credits = cred;
    this.level = lev;
    this.isListedToUser = listToUsr;
  }

  /// Adds a new assessment object to the Module's array of assessment
  void addAssessment(Assessment assToAdd){
    assessments.add(assToAdd);
  }

  /// Returns number of assessments in the module.
  /// NB: counting starts at 1 so this value is non-iterable
  int getNoOfAssessments(){
    return assessments.length;
  }

  /// Deletes the assessment at specified index
  void deleteAssessment(int index){
    assessments.removeAt(index);
  }

  /// Returns the name of the assessment at specified index
  String getAssessmentName(int index) => assessments[index].assessmentName;

  /// Returns the "subtext" of an assessment
  /// which is used when building ModuleEdit's list of assessments
  String getAssessmentDisplaySubtext(int index){
    if(assessments[index].taken){
      return "Score: ${assessments[index].markPercentageOfAssessment}% of ${assessments[index].assessmentPercentageOfModule}%";
    } else{
      return "Not yet taken. Assessment is ${assessments[index].assessmentPercentageOfModule}% of module";
    }
  }

  /// Returns the icon of the assessment at a specified index
  IconData getAssessmentIcon(int index) => assessmentTypes[assessments[index].assessmentType]!.icon;

  /// Returns the overall assessment percentage for taken assessments for a given module
  int getAssessmentTotalAssValue(){
    /// Function to return the overall assessment percentage for a given module.
    int total = 0;
    for(int i=0; i<assessments.length; i++){
      print(assessments[i].assessmentPercentageOfModule);
      if(assessments[i].taken){
        total += assessments[i].assessmentPercentageOfModule;        
      }
    }
    return total;
  }

  /// Returns the overall mark percentage of taken assessments
  /// Rounds to 2dp
  double getTotalMarkPercentageOfTakenAss(){
    double total = 0;
    for(int i=0; i<assessments.length; i++){
      print(assessments[i].markPercentageOfAssessment);
      if(assessments[i].taken){
        total += ((assessments[i].assessmentPercentageOfModule/100) * assessments[i].markPercentageOfAssessment.toDouble());
      }
    }
    return ((total * 100).round().toDouble()) / 100;
  }

  Map toJson(){
    // List<Map> assessmentsToJson = assessments != null ? assessments.toJson() : null;
    
    return{
    'moduleName': moduleName,
    'moduleCode': moduleCode,
    'credits': credits,
    'level': level,
    'isQuickEdit': isQuickEdit,
    'isListedToUser': isListedToUser,
    'university': university,
    'assessments': jsonEncode(assessments)
    };
  }

  factory Module.fromJson(Map<String, dynamic> json){
    List<Assessment> newAssessments = [];
    for(Map<String, dynamic> ass in json['assessments']){
        newAssessments.add(Assessment.fromJson(ass));
    }
    return Module.setAllValuesIncAssessments(
      json['moduleName'] as String?, 
      json['moduleCode'] as String?,
      json['credits'] as int?,
      json['level'] as String?,
      json['isQuickEdit'] as bool,
      json['isListedToUser'] as bool,
      json['university'] as String,
      newAssessments 
    );
  }
}

/// List of module level values to be used in the module level dropdown
List<String> moduleLevels = ["Level 4", "Level 5", "Level 6", "Level 7"];

Map<String, String> universities = {
  "quick": "Quick Calculator",
  "port": "University of Portsmouth"
};