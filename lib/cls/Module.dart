import 'package:flutter/material.dart';

import 'Assessment.dart';

class Module{
  String? moduleName;
  String? moduleCode;
  int? credits;
  String? level;
  bool isQuickEdit;
  bool isListedToUser;
  List<Assessment> assessments = [];


  Module(this.isQuickEdit, this.isListedToUser);

  Module.setAllValues(this.moduleName, this.moduleCode, this.credits, this.level, this.isQuickEdit, this.isListedToUser);

  void updateInformation(modName, modCode, cred, lev, listToUsr){
    this.moduleName = modName;
    this.moduleCode = modCode;
    this.credits = cred;
    this.level = lev;
    this.isListedToUser = listToUsr;
  }

  void addAssessment(Assessment assToAdd){
    assessments.add(assToAdd);
  }

  int getNoOfAssessments(){
    return assessments.length;
  }

  void deleteAssessment(int index){
    assessments.removeAt(index);
  }

  String getAssessmentName(int index) => assessments[index].assessmentName;
  // String getAssessmentDisplaySubtext(int index) => "Score: ${assessments[index].markPercentageOfAssessment}% of ${assessments[index].assessmentPercentageOfModule}%";
  String getAssessmentDisplaySubtext(int index){
    if(assessments[index].taken){
      return "Score: ${assessments[index].markPercentageOfAssessment}% of ${assessments[index].assessmentPercentageOfModule}%";
    } else{
      return "Not yet taken. Assessment is ${assessments[index].assessmentPercentageOfModule}% of module";
    }
  }
  // IconData getAssessmentIcon(int index) => assessments[index].assessmentType.icon;
  IconData getAssessmentIcon(int index) => assessmentTypes[assessments[index].assessmentType]!.icon;

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
// double eachTotalPercent = ((each.assessmentPercent!.toDouble()/100) * each.markPercent!.toDouble());
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


}

List<String> moduleLevels = ["Level 4", "Level 5", "Level 6", "Level 7"];