import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'cls/Assessment.dart';
import 'cls/AssessmentType.dart';
import 'cls/Module.dart';

import 'page/AboutPage.dart';
import 'page/AddEditPage.dart';
import 'page/EditModuleInfoPage.dart';
import 'page/EditModulePage.dart';
import 'page/LoadModulePage.dart';
import 'page/MyModulesPage.dart';


int currentPageIndex = 2;

const navigationDestinations = [
    NavigationDestination(icon: Icon(Icons.cloud_download_outlined), selectedIcon: Icon(Icons.cloud_download), label: 'Load'),
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

List<Module> templateModules = [];

List<dynamic> testArr = [];

void clearAssessmentEditOptions(){
  /// Resets variables used when editing assessments after they're used to sort whacky behaviour out.
  assessmentToEdit = -1;
  assessmentFirstSetState = true;
}

void main() async {
  // lines below add assessments for testing
  // myModules.add(Module(true, true));
  myModules.add(Module.setAllValues("Test module", "MXXXX", 40, "Level 4", false, true, "quick"));
  myModules[0].addAssessment(Assessment("Exam", 20, 80, "cbt", true));
  myModules[0].addAssessment(Assessment("Exam", 20, 81, "cbt", true));
  myModules[0].addAssessment(Assessment("Exam", 20, 82, "cbt", true));
  print("myModules length ${myModules.length}");
  print("myModules[0] assessments length: ${myModules[0].assessments.length}");

  WidgetsFlutterBinding.ensureInitialized();
  await initHiveDB();
  print("success init hive");
  dbImportToArray();
  print("success import DB to arr");

  await importTemplateModules();
  print("success importing template modules");
  print("templateModules length ${templateModules.length} \n first item:");
  print(templateModules[0]);
  // print(testArr);

  print("NOMOD: ${myModules.length}");
  runApp(const MyApp());
}

Future<void> initHiveDB() async{
  if(!kIsWeb){
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);
  } else{
    await Hive.initFlutter();
  }
  
  Hive.registerAdapter(ModuleAdapter());
  Hive.registerAdapter(AssessmentAdapter());
  // Hive.deleteBoxFromDisk("myModulesBox");
  await Hive.openBox("myModulesBox");

}

Future<void> importTemplateModules() async {
  String response = await rootBundle.loadString('assets/templateModules.json'); // open the json file and load it as a string
  Map<String, dynamic> decodedJson = json.decode(response); // decode the string into Map
  for(Map<String, dynamic> current in decodedJson['modules']){
    // iterate through the Map and for each entry in the 'modules' arr, add it to the templateModules List in the correct format.
    templateModules.add(Module.fromJson(current));
  }
  templateModules.sort((a, b) => a.moduleCode!.compareTo(b.moduleCode!));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // get currentModule value and if it's -1 this means we need to add a module to the module array so app can open on quick calculator. We have to setup a quick calculator module as this is what the app relies on to open.
    if(currentModule == -1){
      myModules.add(Module(true, false, "quick"));
      currentModule = myModules.length-1;
    }


    return MaterialApp(
      title: 'Module Grade Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EditModulePage(),
      routes: <String, WidgetBuilder> {
        "/load-module":(context) => const LoadModulePage(),
        "/about":(context) => const AboutPage(title: 'About'),
        "/my-modules":(context) => const MyModules()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


void dbFlush() async{
  Hive.box("myModulesBox").clear();
}

void dbAdd() async{
  Hive.box("myModulesBox").addAll(myModules);
}

void dbImportToArray() async{
  for(int i=0; i<Hive.box("myModulesBox").length; i++){
    myModules.add(Hive.box("myModulesBox").getAt(i));
  }
}

void dbTestPrint() async{
  print("START OF HIVE TEST PRINT");
  for(int i=0; i<Hive.box("myModulesBox").length; i++){
    print(Hive.box("myModulesBox").getAt(i));
  }
  print("END OF HIVE TEST PRINT");
 print("START OF myModules TEST PRINT");
  for(int i=0; i<myModules.length; i++){
    print(myModules[i]);
  }
  print("END OF myModules TEST PRINT");
   
}