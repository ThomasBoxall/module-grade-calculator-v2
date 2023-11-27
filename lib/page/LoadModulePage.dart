import 'package:module_grade_calculator_pappl/cls/Module.dart';

import '../main.dart';
import 'package:flutter/material.dart';

class LoadModulePage extends StatefulWidget {
  const LoadModulePage({super.key});


  @override
  State<LoadModulePage> createState() => _LoadModulePageState();
}

class _LoadModulePageState extends State<LoadModulePage> {

  late TextEditingController universitiesDropdownController = TextEditingController();
  late TextEditingController levelDropdownController = TextEditingController();

  final _loadModuleFormKey = GlobalKey<FormState>();

  String selectedUniversity = "null";
  String selectedLevel = "null";

  String searchTerm = "";

  List<DropdownMenuEntry<String>> buildListModulesUniversityFilterItems(){
    List<DropdownMenuEntry<String>> universityFilterItems = [];
    universities.forEach((key, value){
      universityFilterItems.add(DropdownMenuEntry<String>(
        value: key,
        label: value
        )
      );
    });
    return universityFilterItems;
  }

  List<DropdownMenuEntry<String>> buildModuleLevelFilterItems(){
    List<DropdownMenuEntry<String>> moduleFilterItems = [];

    moduleLevels.forEach((element) {
      moduleFilterItems.add(DropdownMenuEntry<String>(
        label: element,
        value: element
      )
      );
    });

    return moduleFilterItems;
  }

  List<Widget> getModulesToShow(String searchParam){
    List<Widget> widgets = [];
    for(int i=0; i<templateModules.length; i++){
      if(templateModules[i].university == selectedUniversity && ((templateModules[i].moduleName!.toLowerCase().contains(searchParam) || templateModules[i].moduleCode!.toLowerCase().contains(searchParam)) && (selectedLevel == "null" || selectedLevel == templateModules[i].level))){
        // only render template module if it belongs to current university
        widgets.add(ListTile(
          title: Text(templateModules[i].moduleName!),
          subtitle: Text("${templateModules[i].moduleCode!} (${templateModules[i].level!})"),
          leading: const Icon(Icons.view_module_outlined),
          trailing: const Icon(Icons.arrow_right),
          onTap: () {
            myModules.add(templateModules[i]);
            currentModule = myModules.length - 1; // the last one added will always be the one we've just added
            dbFlush();
            dbAdd();
            currentPageIndex = 2;
            Navigator.pushReplacementNamed(context, "/");
          },
        ));
      }
    }
    if(widgets.isEmpty){
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: const ListTile(
            title: Text("Use the Universities box above to select a University to continue"),
            // tileColor: Colors.red, 
          ),
        )
      )); 
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Load Module"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SearchBar(
                leading: const Icon(Icons.search),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)
                ),
                onChanged: (value){
                  setState(() {
                    searchTerm = value.toLowerCase();
                  });
                }
              )
            ),
            Form(
              key: _loadModuleFormKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: DropdownMenu<String>(
                      controller: universitiesDropdownController,
                      leadingIcon: const Icon(Icons.search),
                      label: const Text('University'),
                      dropdownMenuEntries: buildListModulesUniversityFilterItems(),
                      requestFocusOnTap: false,
                      enableFilter: false,
                      onSelected: (value){
                        selectedUniversity = value!;
                        setState(() { });
                      }
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: DropdownMenu<String>(
                      controller: levelDropdownController,
                      leadingIcon: const Icon(Icons.search),
                      label: const Text('Level'),
                      dropdownMenuEntries: buildModuleLevelFilterItems(),
                      requestFocusOnTap: false,
                      enableFilter: false,
                      onSelected: (value){
                        selectedLevel = value!;
                        print(value);
                        setState(() { });
                      }
                    )
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: getModulesToShow(searchTerm)
              )
            )
          ]
        )     
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