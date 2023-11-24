import 'dart:convert';

import '../main.dart';
import 'package:flutter/material.dart';
import '../cls/Module.dart';

class EditModuleInfoPage extends StatefulWidget {
  const EditModuleInfoPage({super.key});

  @override
  State<EditModuleInfoPage> createState() => _EditModuleInfoPageState();
}

class _EditModuleInfoPageState extends State<EditModuleInfoPage> {

  // TextEditingControllers for input fields
  late TextEditingController moduleNameController = TextEditingController();
  late TextEditingController moduleCodeController = TextEditingController();
  late TextEditingController moduleCreditController = TextEditingController();
  late TextEditingController moduleLevelController = TextEditingController();

  final _editModueFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    ///Build list of DropdownMenuEntry objects to select module level through
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

    // Define a variable to be used to warn users about the "save" state of the module. 
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
          child:ListView(
            
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
                          
                          dbFlush();
                          dbAdd();
                          dbTestPrint();
                          print(jsonEncode(myModules));
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