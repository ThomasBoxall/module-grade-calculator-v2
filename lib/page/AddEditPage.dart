import '../main.dart';
import 'package:flutter/material.dart';

import '../cls/AssessmentType.dart';
import '../cls/Assessment.dart';

class AddEditPage extends StatefulWidget {
  const AddEditPage({super.key, required this.isEdit});


  final bool isEdit;


  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {

  late TextEditingController assessmentNameController = TextEditingController();
  late TextEditingController assessmentPercentageOfModuleController = TextEditingController();
  late TextEditingController markPercentageOfAssessmentController = TextEditingController();
  late TextEditingController assessmentIconController = TextEditingController();
  bool assessmentTakenCheckboxValue = true;
  
  final _addEditFormKey = GlobalKey<FormState>();

  String assessmentTypeCode = "ass";

  int totalModuleAssessmentsPercentage = myModules[currentModule].getAssessmentTotalAssValue();

  void updateAssessmentTypeCode(String code){
    assessmentTypeCode = code;
  }

  @override
  Widget build(BuildContext context) {

    List<DropdownMenuEntry<AssessmentType>> buildAssessmentTypeDropdownItems() {
      /// Construct list used to populate Assessment Type DropdownMenu
      List<DropdownMenuEntry<AssessmentType>> menuItems = [];
      assessmentTypes.forEach((key, value) {
        menuItems.add(
          DropdownMenuEntry<AssessmentType>(
            value: value,
            label: value.name,
            leadingIcon: Icon(value.icon)
          ),
        );
      });
      return menuItems;
    }

    if(widget.isEdit){
      // set the totalModAssPerc to use total - val for current ass
      totalModuleAssessmentsPercentage - myModules[currentModule].assessments[assessmentToEdit].assessmentPercentageOfModule;
    }

    if(widget.isEdit && assessmentFirstSetState){
      // we have to set some of the values now
      assessmentNameController.text = myModules[currentModule].assessments[assessmentToEdit].assessmentName;
      assessmentPercentageOfModuleController.text = myModules[currentModule].assessments[assessmentToEdit].assessmentPercentageOfModule.toString();
      markPercentageOfAssessmentController.text = myModules[currentModule].assessments[assessmentToEdit].markPercentageOfAssessment.toString();
      assessmentIconController.text = getAssessmentTypeName(myModules[currentModule].assessments[assessmentToEdit].assessmentType);
      assessmentTakenCheckboxValue = myModules[currentModule].assessments[assessmentToEdit].taken;
      assessmentFirstSetState = false;
      print("setting all the things");
    }

    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.isEdit? "Edit Assessment" : "Add Assessment"),
      ),
      body: Center(
        child: Form(
          key: _addEditFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    return DropdownMenu<AssessmentType>(
                      controller: assessmentIconController,
                      leadingIcon: const Icon(Icons.search),
                      label: const Text('Assessment Type'),
                      dropdownMenuEntries: buildAssessmentTypeDropdownItems(),
                      width: constraints.maxWidth,
                      requestFocusOnTap: false,
                      enableFilter: false,
                      onSelected: (AssessmentType? value) {
                        // setState(() {
                        //   print(value!.code);
                        //   assessmentTypeCode = value.code;
                        // });
                        print(value!.code);
                        updateAssessmentTypeCode(value!.code);
                      },
                    );
                  }
                ),
              ),
              Padding(  
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: TextFormField(
                  controller: assessmentNameController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Assessment Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  }
                  ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: TextFormField(
                  controller: assessmentPercentageOfModuleController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), suffix: Text("%"), labelText: 'Assessment Percentage'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    } else if(!isInt(value)){
                      return 'Please enter a whole number';
                    } else if(int.parse(value) > 100 || int.parse(value) < 0){
                      return 'Please enter a value between 0 and 100';
                    } else if(totalModuleAssessmentsPercentage + int.parse(value) > 100){
                      return "Please enter a value which total your overall assessment percentage to less than 100%";
                    }
                    return null;
                  },
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: CheckboxListTile(
                  value: assessmentTakenCheckboxValue,
                  onChanged: (bool? value){
                    print("checkbox value ${value}");
                    setState(() {
                      assessmentTakenCheckboxValue = value!;
                      markPercentageOfAssessmentController.clear();
                    });
                  },
                  title: const Text("Taken Assessment")
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: TextFormField(
                  controller: markPercentageOfAssessmentController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), suffix: Text("%"), labelText: 'Your Mark'),
                  enabled: assessmentTakenCheckboxValue,
                  validator: (value) {
                    if (assessmentTakenCheckboxValue){
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      if(!isDouble(value)){
                        return 'Please enter a value';
                      } else{
                        if(double.parse(value) > 100 || double.parse(value) < 0){
                          return 'Please enter a value between 0 and 100';
                        }
                      }
                    }
                    return null;
                  }
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 12,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () { clearAssessmentEditOptions(); Navigator.pop(context); },
                      child: const Text("Back")
                    ),
                    FilledButton(
                      onPressed: () { 
                        if(_addEditFormKey.currentState!.validate()){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const SizedBox(
                                height: 40.0,
                                child: Center(child: Text('Processing...')),
                              ),
                              duration: const Duration(milliseconds: 500),
                              width: 100.0, // Width of the SnackBar.
                              padding: const EdgeInsets.symmetric(
                                horizontal:8.0, // Inner padding for SnackBar content.
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              backgroundColor: Colors.black.withOpacity(0.7),
                            ),
                          );
                          if(!widget.isEdit){
                            // Adding assessment
                            print("ASS TO ADD:");
                            print("TYPE: ${assessmentTypeCode}");
                            print("NAME: ${assessmentNameController.text}");
                            print("ASS % OF MOD: ${assessmentPercentageOfModuleController.text}");
                            print("TAKEN: ${assessmentTakenCheckboxValue}");
                            print("% OF ASS: ${markPercentageOfAssessmentController.text}");
                            print("Total ASS%: ${totalModuleAssessmentsPercentage}");
                            if(assessmentTakenCheckboxValue){
                              // assessment has been taken and therefore can be shoved in as usual.
                              myModules[currentModule].addAssessment(Assessment(assessmentNameController.text, int.parse(assessmentPercentageOfModuleController.text), double.parse(markPercentageOfAssessmentController.text), assessmentTypeCode, assessmentTakenCheckboxValue));
                            } else {
                              //assessment hasn't been taken or checkbox is having a fit. We need to be *quirky* in how we insert the assessment by specifying some values.
                              myModules[currentModule].addAssessment(Assessment(assessmentNameController.text, int.parse(assessmentPercentageOfModuleController.text), 0.0, assessmentTypeCode, assessmentTakenCheckboxValue));
                            }
                            
                            print("Total ASS% with new: ${myModules[currentModule].getAssessmentTotalAssValue()}");

                            } else{
                              // Saving edited assessment
                              print("ASS TO EDIT:");
                              print("TYPE: ${assessmentTypeCode}");
                              print("NAME: ${assessmentNameController.text}");
                              print("ASS % OF MOD: ${assessmentPercentageOfModuleController.text}");
                              print("TAKEN: ${assessmentTakenCheckboxValue}");
                              print("% OF ASS: ${markPercentageOfAssessmentController.text}");
                              print("Total ASS%: ${totalModuleAssessmentsPercentage}");
                              if(assessmentTakenCheckboxValue){
                                // assessment has been taken and therefore can be shoved in as usual.
                                myModules[currentModule].assessments[assessmentToEdit].updateAssessment(assessmentNameController.text, int.parse(assessmentPercentageOfModuleController.text), double.parse(markPercentageOfAssessmentController.text), assessmentTypeCode, assessmentTakenCheckboxValue);
                              } else {
                                //assessment hasn't been taken or checkbox is having a fit. We need to be *quirky* in how we insert the assessment by specifying some values.
                                myModules[currentModule].assessments[assessmentToEdit].updateAssessment(assessmentNameController.text, int.parse(assessmentPercentageOfModuleController.text), 0.0, assessmentTypeCode, assessmentTakenCheckboxValue);
                              }
                            }
                            
                            Future.delayed(const Duration(milliseconds: 1505), (){
                              clearAssessmentEditOptions();
                              Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text("Save")
                    ),
                  ],
                ),
              )
            ]
          )
        ),
      ),
    );
  }
}