import 'package:flutter/material.dart';

import 'Assessment.dart';

class Module{
  String? moduleName;
  String? moduleCode;
  int? credits;
  bool isQuickEdit;
  List<Assessment> assessments = [];


  Module(this.isQuickEdit);

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
  String getAssessmentDisplaySubtext(int index) => "Score: ${assessments[index].markPercentageOfAssessment}% of ${assessments[index].assessmentPercentageOfModule}%";  
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


}