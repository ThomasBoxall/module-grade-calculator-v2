import '../main.dart';
import 'package:flutter/material.dart';
import '../cls/Module.dart';

class MyModules extends StatefulWidget {
  const MyModules({super.key});

  @override
  State<MyModules> createState() => _MyModulesState();
}

class _MyModulesState extends State<MyModules> {

  void refreshRoute(){
    setState(() {});
    dbFlush();
    dbAdd();
  }

  /// Return list of widgets to be inserted into ListView
  List<Widget> getModulesToDisplay(){
    List<Widget> modulesToDisplay = [];
    for(int i=0; i<myModules.length; i++){
      if(myModules[i].isListedToUser){
        //add to the array
        modulesToDisplay.add(ListTile(
          title: Text(myModules[i].moduleName!),
          subtitle: Text("(${myModules[i].moduleCode!})"),
          leading: const Icon(Icons.view_module_outlined),
          onTap: (){
            // eventually do something more here,
            currentModule = i;
            currentPageIndex = 2;
            Navigator.pushReplacementNamed(context, "/");
          },
          trailing: PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text("Edit"),
                  ]
                )
              ),
              const PopupMenuItem(
                value: 2,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete),
                    SizedBox(width: 10),
                    Text("Delete"),
                  ]
                )
              )
            ],
            onSelected:(value){
              if(value == 1){
                // edit
                // print("$index - 1");
                currentModule = i;
                currentPageIndex = 2;
                refreshRoute();
                Navigator.pushReplacementNamed(context, "/");
              } else if (value == 2){
                //delete
                myModules.removeAt(i);
                refreshRoute();
              }
            },
          ),
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
        actions: [
          IconButton(
            onPressed: (){
              print("MYMOD LENGTH BEFORE: ${myModules.length}");
              myModules.clear();
              print("MYMOD LENGTH AFTER: ${myModules.length}");

              // now it is empty, we need to add one and set the currentModule to prevent the app *completely* imploding
              myModules.add(Module(true, false, "quick"));
              currentModule = 0;
              refreshRoute();
            },
            icon: const Icon(Icons.abc)
          )
        ],
      ),
      body:
        ListView(
          children: getModulesToDisplay()
        ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'New Module',
        label: const Text("Add"),
        icon: const Icon(Icons.add),
        onPressed: (){
          myModules.add(Module(true, false, "quick"));
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