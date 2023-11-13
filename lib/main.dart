import 'package:flutter/material.dart';

import 'Assessment.dart';


int currentPageIndex = 1;

const navigationDestinations = [
    NavigationDestination(icon: Icon(Icons.folder_open_outlined), selectedIcon: Icon(Icons.folder_open), label: 'Load Module'),
    NavigationDestination(icon: Icon(Icons.calculate_outlined), selectedIcon: Icon(Icons.calculate), label: 'Quick Calculator'),
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


void main() {
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
      home: const QuickCalculator(title: 'Quick Calculator'),
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

  @override
  Widget build(BuildContext context) {

    // build the list used to populate 
    final List<DropdownMenuEntry<AssessmentTypes>> assessmentTypes = <DropdownMenuEntry<AssessmentTypes>>[];
    for(final AssessmentTypes assessmentType in AssessmentTypes.values){
      assessmentTypes.add(DropdownMenuEntry<AssessmentTypes>(value:assessmentType, label: assessmentType.label, leadingIcon: Icon(assessmentType.icon)));
    }
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Add Edit Thing DO SOMEBETTERTITLINGHERE SOMETIME"),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){
                  return DropdownMenu<AssessmentTypes>(
                    controller: assessmentIconController,
                    enableFilter: true,
                    leadingIcon: const Icon(Icons.search),
                    label: const Text('Assessment Type'),
                    dropdownMenuEntries: assessmentTypes,
                    width: constraints.maxWidth
                  );
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: TextFormField(
                controller: assessmentNameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Assessment Name')
                ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: TextFormField(
                controller: assessmentPercentageOfModuleController,
                decoration: const InputDecoration(border: OutlineInputBorder(), suffix: Text("%"), labelText: 'Assessment Percentage')
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: TextFormField(
                controller: markPercentageOfAssessmentController,
                decoration: const InputDecoration(border: OutlineInputBorder(), suffix: Text("%"), labelText: 'Your Mark')
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
                    onPressed: () {  },
                    child: const Text("Save")
                  ),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}

class QuickCalculator extends StatefulWidget {
  const QuickCalculator({super.key, required this.title});

  final String title;

  @override
  State<QuickCalculator> createState() => _QuickCalculatorState();
}

class _QuickCalculatorState extends State<QuickCalculator> {


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
              'push the button... go on, i dare you',
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditPage()));},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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