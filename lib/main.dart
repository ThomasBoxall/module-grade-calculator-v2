import 'package:flutter/material.dart';


int currentPageIndex = 1;

const navigationDestinations = [
    NavigationDestination(icon: Icon(Icons.abc), label: 'Load Module'),
    NavigationDestination(icon: Icon(Icons.accessibility), label: 'Quick Calculator'),
    NavigationDestination(icon: Icon(Icons.info_outline), label: 'About'),
  ];

// function which detmines based on a number which page you want to be sent to (fn called when tap on icon on nav bar returns index from 0 to 2. we have to keep tabs on which page wants to be opened ourselves). return string, name of the page we are trying to go to (path to the file in the webserver)
// also need a var to store page which is open - f u says flutter we have to keep tabs on this

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuickCalculator(title: 'Flutter Demo Home Page'),
      routes: <String, WidgetBuilder> {
        "/load-module":(context) => const LoadModule(title: 'Load Module'),
        "/about":(context) => const About(title: 'About')
        }
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
              'Quick Calculator',
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