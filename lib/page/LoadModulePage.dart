import '../main.dart';
import 'package:flutter/material.dart';

class LoadModulePage extends StatefulWidget {
  const LoadModulePage({super.key, required this.title});

  final String title;

  @override
  State<LoadModulePage> createState() => _LoadModulePageState();
}

class _LoadModulePageState extends State<LoadModulePage> {
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