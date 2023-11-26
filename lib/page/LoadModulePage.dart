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

  final _loadModuleFormKey = GlobalKey<FormState>();

  String selectedUniversity = "null";

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

  List<Widget> getModulesToShow(){
    List<Widget> widgets = [];
    for(int i=0; i<templateModules.length; i++){
      if(templateModules[i].university == selectedUniversity){
        // only render template module if it belongs to current university
        widgets.add(ListTile(
          title: Text(templateModules[i].moduleName!),
          subtitle: Text(templateModules[i].moduleCode!),
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
      widgets.add(const ListTile(
        title: Text("Use the Universities box above to select a University to continue"),
        tileColor: Colors.red,
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
            Form(
              key: _loadModuleFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    return DropdownMenu<String>(
                      controller: universitiesDropdownController,
                      leadingIcon: const Icon(Icons.search),
                      label: const Text('University'),
                      dropdownMenuEntries: buildListModulesUniversityFilterItems(),
                      width: constraints.maxWidth,
                      requestFocusOnTap: false,
                      enableFilter: false,
                      onSelected: (value){
                        selectedUniversity = value!;
                        setState(() { });
                      }
                    );
                  }
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: getModulesToShow()
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