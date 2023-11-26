import '../main.dart';
import 'package:flutter/material.dart';
import 'EditModuleInfoPage.dart';
import 'AddEditPage.dart';

class EditModulePage extends StatefulWidget {
  const EditModulePage({super.key});

  @override
  State<EditModulePage> createState() => _EditModulePageState();
}

class _EditModulePageState extends State<EditModulePage> {

  /// Refreshes all data on the route
  /// To be used whenever data value changes or page is returned to by Navigator.pop
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
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const EditModuleInfoPage())).then((value) => refreshRoute());},
            icon: const Icon(Icons.tune)
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditPage(isEdit: true))).then((value) => refreshRoute());},
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