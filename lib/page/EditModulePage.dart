import 'dart:convert';

import '../main.dart';
import 'package:flutter/material.dart';
import 'EditModuleInfoPage.dart';
import 'AddEditPage.dart';

import 'package:url_launcher/url_launcher.dart';

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

Widget _totalMarkPercentCard(){
  return Card(
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
  );
}

Widget _assessmentsTakenCard(){
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
          children: [
            const Text(
              "Assessments Taken"
            ),
            Center(
              child: Text(
                "${myModules[currentModule].getAssessmentTakenAssValue().toString()}%", 
                style: Theme.of(context).textTheme.headlineMedium
              ),
            ),
          ],
        ),
    ),
  );
}

Widget _assessmentsAddedCard(){
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Text(
            "Assessments Added"
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
  );
}


  Widget _buildFullWidthHeadRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child:ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 75,
              minWidth: 150,
            ),
            child: _totalMarkPercentCard()
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child:ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 75,
              minWidth: 150,
            ),
            child: _assessmentsTakenCard()
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child:ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 75,
              minWidth: 150,
            ),
            child: _assessmentsAddedCard()
          ),
        ),
      ]      
      );
  }
  
  Widget _buildSmallWidthHeadRow(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child:ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 75,
                  minWidth: 330,
                ),
                child: _totalMarkPercentCard()
              ),
            ),
          ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child:ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 75,
                  minWidth: 150,
                ),
                child: _assessmentsTakenCard()
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child:ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 75,
                  minWidth: 150,
                ),
                child: _assessmentsAddedCard()
              ),
            ),
          ],
        )
      ]
    );
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
          ),
          IconButton(
            onPressed: () async{
              String email = Uri.encodeComponent("submissions@modulegradecalculator.com");  
              String subject = Uri.encodeComponent("Module Submission");
              String body = Uri.encodeComponent(jsonEncode(myModules[currentModule]));
              Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
              if (await launchUrl(mail)){
              } else{
                throw Exception("Unable to launch URL (email)");
              }
            },
            icon: const Icon(Icons.open_in_new)
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              if(constraints.maxWidth > 600){
                return _buildFullWidthHeadRow();
              } else{
                return _buildSmallWidthHeadRow();
              }
            }
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