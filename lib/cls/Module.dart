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
  Icon getAssessmentIcon(int index) => assessments[index].assessmentIcon;


}