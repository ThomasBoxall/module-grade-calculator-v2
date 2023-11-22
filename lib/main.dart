import 'package:flutter/material.dart';

import 'cls/Assessment.dart';
import 'cls/Module.dart';


int currentPageIndex = 2;

const navigationDestinations = [
    NavigationDestination(icon: Icon(Icons.folder_open_outlined), selectedIcon: Icon(Icons.folder_open), label: 'Templates'),
    NavigationDestination(icon: Icon(Icons.view_list_outlined), selectedIcon: Icon(Icons.view_list), label: 'My'),
    NavigationDestination(icon: Icon(Icons.calculate_outlined), selectedIcon: Icon(Icons.calculate), label: 'Edit'),
    NavigationDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info), label: 'About'),
  ];

String getNewPageIndexStr(int newPageIndexInt){
  currentPageIndex = newPageIndexInt;
  switch(newPageIndexInt){
    case 0:
      return "/load-module";
    case 1:
      return "/my-modules";
    case 3:
      return "/about";
    case 2:
    default:
      return "/";
    
  }
}

bool isInt(String? s){
  if (s == null){
    return false;
  } 
  return int.tryParse(s) != null;
}

bool isDouble(String? s){
  if(s == null){
    return false;
  }
  return double.tryParse(s) != null;
}

List <Module> myModules = [];
int currentModule = -1; //this is used to set which module in myModules should be displayed on EdiModule. -1 means quick calculator
int assessmentToEdit = -1; // used to set which assessment should be edited when editMode in AddEditPage is true. Set back to -1 when not in use.
bool assessmentFirstSetState = true;

void clearAssessmentEditOptions(){
  /// Resets variables used when editing assessments after they're used to sort whacky behaviour out.
  assessmentToEdit = -1;
  assessmentFirstSetState = true;
}

void main() {
  // lines below add assessments for testing
  // myModules.add(Module(true, true));
  myModules.add(Module.setAllValues("Test module", "MXXXX", 40, "Level 4", false, true));
  myModules[0].addAssessment(Assessment("Exam", 20, 80, "cbt", true));
  myModules[0].addAssessment(Assessment("Exam", 20, 81, "cbt", true));
  myModules[0].addAssessment(Assessment("Exam", 20, 82, "cbt", true));
  print("myModules length ${myModules.length}");
  print("myModules[0] assessments length: ${myModules[0].assessments.length}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // get currentModule value and if it's -1 this means we need to add a module to the module array so app can open on quick calculator. We have to setup a quick calculator module as this is what the app relies on to open.
    if(currentModule == -1){
      myModules.add(Module(true, false));
      currentModule = myModules.length-1;
    }


    return MaterialApp(
      title: 'Module Grade Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EditModule(),
      routes: <String, WidgetBuilder> {
        "/load-module":(context) => const LoadModule(title: 'Load Module'),
        "/about":(context) => const About(title: 'About'),
        "/my-modules":(context) => const MyModules()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


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

    // build the list used to populate 
    // final List<DropdownMenuEntry<AssessmentTypes>> assessmentTypes = <DropdownMenuEntry<AssessmentTypes>>[];
    // for(final AssessmentTypes assessmentType in AssessmentTypes.values){
    //   assessmentTypes.add(DropdownMenuEntry<AssessmentTypes>(value:assessmentType, label: assessmentType.label, leadingIcon: Icon(assessmentType.icon)));
    // }

    // final List<DropdownMenuEntry<AssessmentType>> assessmentTypesForDropdown = <DropdownMenuEntry<AssessmentType>>[];
    // // for (int i=0; i<assessmentTypes.length; i++){
    // //   assessmentTypesForDropdown.add(DropdownMenuEntry<AssessmentType>(value: assessmentTypes[i], label: assessmentTypes[i]!.name));
    // // }
    // for(String current in assessmentTypes.keys){
    //   assessmentTypesForDropdown.add(DropdownMenuEntry<AssessmentType>(value: current, label: assessmentTypes[current]!.name));
    // }

    List<DropdownMenuEntry<AssessmentType>> buildAssessmentTypeDropdownItems() {
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

class EditModule extends StatefulWidget {
  const EditModule({super.key});

  @override
  State<EditModule> createState() => _EditModuleState();
}

class _EditModuleState extends State<EditModule> {

  void refreshRoute(){
    clearAssessmentEditOptions();
    setState(() {
      
    });
  }

  

  @override
  Widget build(BuildContext context) {

    String editModulePageName = myModules[currentModule].isListedToUser ? "${myModules[currentModule].moduleName!} (${myModules[currentModule].moduleCode!})" : "Quick Calculator";
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(editModulePageName),
        actions: [
          IconButton(
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const EditModuleInfo())).then((value) => refreshRoute());},
            icon: const Icon(Icons.edit_attributes)
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // FractionallySizedBox(
          //     widthFactor: 0.9,
          //     heightFactor: 0.2,
          //     alignment: FractionalOffset.center,
          //     child: Card(
          //       child: Text("Test"),
          //     )
          //   ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          //   child: ConstrainedBox(
          //     constraints: const BoxConstraints(
          //       minHeight: 75,
          //       minWidth: 300,
          //     ),
          //     child: Card(
          //       child: Center(
          //         child: Text(
          //           "${myModules[currentModule].getTotalMarkPercentageOfTakenAss().toString()}% of ${myModules[currentModule].getAssessmentTotalAssValue().toString()}%", 
          //           style: Theme.of(context).textTheme.headlineMedium
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 75,
                  minWidth: 150,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Text(
                          "My Marks"
                        ),
                        Center(
                          child: Text(
                            "${myModules[currentModule].getTotalMarkPercentageOfTakenAss().toString()}%", 
                            style: Theme.of(context).textTheme.headlineMedium
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 75,
                  minWidth: 150,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        children: [
                          const Text(
                            "Assessments Taken"
                          ),
                          Center(
                            child: Text(
                              "${myModules[currentModule].getAssessmentTotalAssValue().toString()}%", 
                              style: Theme.of(context).textTheme.headlineMedium
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
              ),
            ),
            ]
          ),
          Expanded(
            child: ListView.builder(
              itemCount: myModules[currentModule].getNoOfAssessments(),
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  title: Text(myModules[currentModule].getAssessmentName(index)),
                  subtitle: Text(myModules[currentModule].getAssessmentDisplaySubtext(index)),
                  leading: Icon(myModules[currentModule].getAssessmentIcon(index)),
                  onTap: () {
                    assessmentToEdit = index;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditPage(isEdit: true))).then((value) => refreshRoute());                  },
                  trailing: PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.edit),
                            Text("Edit"),
                          ]
                        )
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.delete),
                            Text("Delete"),
                          ]
                        )
                      )
                    ],
                    onSelected:(value){
                      if(value == 1){
                        // edit
                        print("$index - 1");
                        assessmentToEdit = index;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditPage(isEdit: true))).then((value) => refreshRoute());
                      } else if (value == 2){
                        //delete
                        myModules[currentModule].deleteAssessment(index);
                        refreshRoute();
                      }
                    },
                  ),
                );
              }
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditPage(isEdit: false))).then((value) => refreshRoute());},
        tooltip: 'Add new assessment',
        label: const Text("Add"),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: navigationDestinations,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          if(index != currentPageIndex){
            Navigator.pushReplacementNamed(context, getNewPageIndexStr(index));
          }
        },
      ),
    );
  }
}

class EditModuleInfo extends StatefulWidget {
  const EditModuleInfo({super.key});

  @override
  State<EditModuleInfo> createState() => _EditModuleInfoState();
}

class _EditModuleInfoState extends State<EditModuleInfo> {

  late TextEditingController moduleNameController = TextEditingController();
  late TextEditingController moduleCodeController = TextEditingController();
  late TextEditingController moduleCreditController = TextEditingController();
  late TextEditingController moduleLevelController = TextEditingController();

  final _editModueFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    List<DropdownMenuEntry<String>> buildModuleLevelDropdownItems(){
      List<DropdownMenuEntry<String>> menuItems = [];
      moduleLevels.forEach((element) {
        menuItems.add(
          DropdownMenuEntry<String>(
            value: element,
            label: element
          ),
        );
      });
      return menuItems;
    }

    String moduleSaveStateWarning = myModules[currentModule].isListedToUser ? "Module saved" : "Module not saved"; // make this look prettier somehow? snackbar time???

    // if module options are not null then we want to render them
    if(myModules[currentModule].moduleName != null){
      moduleNameController.text = myModules[currentModule].moduleName!;
    }
    if(myModules[currentModule].moduleCode != null){
      moduleCodeController.text = myModules[currentModule].moduleCode!;
    }
    if(myModules[currentModule].credits != null){
      moduleCreditController.text = myModules[currentModule].credits!.toString();
    }
    if(myModules[currentModule].level != null){
      moduleLevelController.text = myModules[currentModule].level!;
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Edit Module Info"),
      ),
      body:  Center(
        child: Form (
          key: _editModueFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child:Column(
            
            children: <Widget>[
              Text(
                moduleSaveStateWarning
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: TextFormField(
                  controller: moduleNameController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Module Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: TextFormField(
                  controller: moduleCodeController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Module Code"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: TextFormField(
                  controller: moduleCreditController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Credits"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    } else if(!isInt(value)){
                      return "Please enter a whole number";
                    } else if (int.parse(value) % 20 != 0 || int.parse(value) == 0){
                      return "Module credits must be a multiple of 20";
                    }
                    return null;
                  },
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    return DropdownMenu<String>(
                      controller: moduleLevelController,
                      leadingIcon: const Icon(Icons.search),
                      label: const Text('Module Level'),
                      dropdownMenuEntries: buildModuleLevelDropdownItems(),
                      width: constraints.maxWidth,
                      requestFocusOnTap: false,
                      enableFilter: false,
                      onSelected: (String? value) {
                        // setState(() {
                        //   print(value!.code);
                        //   assessmentTypeCode = value.code;
                        // });
                        print(value!);
                      },
                    );
                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 12,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {Navigator.pop(context); },
                      child: const Text("Back")
                    ),
                    FilledButton(
                      onPressed: () { 
                        if(_editModueFormKey.currentState!.validate()){
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
                          
                          myModules[currentModule].updateInformation(moduleNameController.text, moduleCodeController.text, int.parse(moduleCreditController.text), moduleLevelController.text, true);
                          print(myModules[currentModule].isListedToUser);
                            
                            Future.delayed(const Duration(milliseconds: 1505), (){
                              
                              Navigator.pop(context);
                          });
                        } //end of validated code
                      },
                      child: const Text("Save")
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}


// Center(
//         child: Form(
//           key: _addEditFormKey,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: const Ed




class LoadModule extends StatefulWidget {
  const LoadModule({super.key, required this.title});

  final String title;

  @override
  State<LoadModule> createState() => _LoadModuleState();
}

class _LoadModuleState extends State<LoadModule> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Load Module',
            )
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: navigationDestinations,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          if(index != currentPageIndex){
            Navigator.pushReplacementNamed(context, getNewPageIndexStr(index));
          }
        },
      ),
    );
  }
}

class MyModules extends StatefulWidget {
  const MyModules({super.key});

  @override
  State<MyModules> createState() => _MyModulesState();
}

class _MyModulesState extends State<MyModules> {

  List<Widget> getModulesToDisplay(){
    List<Widget> modulesToDisplay = [];
    for(int i=0; i<myModules.length; i++){
      print("checking $i (${myModules[i].isListedToUser})");
      if(myModules[i].isListedToUser){
        print("adding $i");
        //add to the array
        modulesToDisplay.add(ListTile(
          title: Text(myModules[i].moduleName!),
          subtitle: Text("(${myModules[i].moduleCode!})"),
          onTap: (){
            // eventually do something more here,
            print("tapped $i module");
            currentModule = i;
            currentPageIndex = 2;
            Navigator.pushReplacementNamed(context, "/");
          },
        ));
      }
    }
    return modulesToDisplay;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("My Modules"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: getModulesToDisplay()
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'New Module',
        label: const Text("Add"),
        icon: const Icon(Icons.add),
        onPressed: (){
          myModules.add(Module(true, false));
          currentModule = myModules.length-1;
          currentPageIndex = 2;
          print(myModules.length);
          Navigator.pushReplacementNamed(context, "/");
        }
      ),
      bottomNavigationBar: NavigationBar(
        destinations: navigationDestinations,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          if(index != currentPageIndex){
            Navigator.pushReplacementNamed(context, getNewPageIndexStr(index));
          }
        },
      ),
    );
  }
}

class About extends StatefulWidget {
  const About({super.key, required this.title});

  final String title;

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'About',
            )
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: navigationDestinations,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          if(index != currentPageIndex){
            Navigator.pushReplacementNamed(context, getNewPageIndexStr(index));
          }
        },
      ),
    );
  }
}