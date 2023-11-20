import 'package:flutter/material.dart';

import 'cls/Assessment.dart';
import 'cls/Module.dart';


int currentPageIndex = 1;

const navigationDestinations = [
    NavigationDestination(icon: Icon(Icons.folder_open_outlined), selectedIcon: Icon(Icons.folder_open), label: 'Load Module'),
    NavigationDestination(icon: Icon(Icons.calculate_outlined), selectedIcon: Icon(Icons.calculate), label: 'Edit Module'),
    NavigationDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info), label: 'About'),
  ];

String getNewPageIndexStr(int newPageIndexInt){
  currentPageIndex = newPageIndexInt;
  switch(newPageIndexInt){
    case 0:
      return "/load-module";
    case 2:
      return "/about";
    case 1:
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

void main() {
  // lines below add assessments for testing
  myModules.add(Module(true));
  myModules[0].addAssessment(Assessment("Exam", 20, 80, "cbt", true));
  myModules[0].addAssessment(Assessment("Exam", 20, 81, "cbt", true));
  myModules[0].addAssessment(Assessment("Exam", 20, 82, "cbt", true));
  print("myModules length ${myModules.length}");
  print("myModules[0] assessments length: ${myModules[0].assessments.length}");

  currentModule = 0;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Module Grade Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EditModule(title: 'Quick Calculator'),
      routes: <String, WidgetBuilder> {
        "/load-module":(context) => const LoadModule(title: 'Load Module'),
        "/about":(context) => const About(title: 'About')
        }
    );
  }
}


class AddEditPage extends StatefulWidget {
  const AddEditPage({super.key});

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

    List<DropdownMenuEntry<AssessmentType>> buildDropdownMenuItems() {
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

    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Add Edit Thing DO SOMEBETTERTITLINGHERE SOMETIME"),
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
                      enableFilter: true,
                      leadingIcon: const Icon(Icons.search),
                      label: const Text('Assessment Type'),
                      dropdownMenuEntries: buildDropdownMenuItems(),
                      width: constraints.maxWidth,
                      onSelected: (AssessmentType? value) {
                        setState(() {
                          print(value!.code);
                          assessmentTypeCode = value.code;
                        });
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
                      onPressed: () { Navigator.pop(context); },
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
                          print("Added assessment:");
                          print("TYPE: ${assessmentTypeCode}");
                          print("NAME: ${assessmentNameController.text}");
                          print("ASS % OF MOD: ${assessmentPercentageOfModuleController.text}");
                          print("TAKEN: ${assessmentTakenCheckboxValue}");
                          print("% OF ASS: ${markPercentageOfAssessmentController.text}");
                          print("Total ASS%: ${myModules[currentModule].getAssessmentTotalAssValue()}");
                          myModules[currentModule].addAssessment(Assessment(assessmentNameController.text, int.parse(assessmentPercentageOfModuleController.text), double.parse(markPercentageOfAssessmentController.text), assessmentTypeCode, assessmentTakenCheckboxValue));
                          print("Total ASS% with new: ${myModules[currentModule].getAssessmentTotalAssValue()}");
                          Future.delayed(const Duration(milliseconds: 1505), (){
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
  const EditModule({super.key, required this.title});

  final String title;

  @override
  State<EditModule> createState() => _EditModuleState();
}

class _EditModuleState extends State<EditModule> {

  void refreshRoute(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 75,
              minWidth: 300,
            ),
            child: Card(
              child: Center(
                child: Text(
                  "${myModules[currentModule].getAssessmentTotalAssValue().toString()}% of xx%", 
                  style: TextStyle(
                    fontSize: 25,
                  )
                ),
              ),
            ),
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
                    // OPEN ADD EDIT ROUTE HERE AND EDIT THE ASSESSMENT
                  },
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
                        print("$index - 1");
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
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditPage())).then((value) => refreshRoute());},
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