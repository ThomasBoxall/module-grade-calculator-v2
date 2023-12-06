import '../main.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key, required this.title});

  final String title;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  // double contextWidth = MediaQuery.of(context).size.width * 0.8;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
          
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      "assets/mgc-icon.png",
                      width: 100,
                      height: 100,
                    )
                  ),
                ),
                Card(
                  child: SizedBox(
                    height: 100,
                    child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                      "Module Grade Calculator", 
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                      )
                    )
                    ,
                    ),
                  ) 
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Text(
                            "Module Grade Calculator is a utility application which allows students to easily identify their overall grade in a module based off scores in individual assessments. This is v2 of Module Grade Calculator and it comes with many improvements and new features than v1 had. Module Grade Calculator is Open Source on GitHub.",
                            softWrap: true,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              style: TextButton.styleFrom(),
                              onPressed: () {},
                              child: const Text('GitHub'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Adding Your Modules as Templates",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Text(
                            "Ever wanted to add your modules as a template module, now you can! Maybe?",
                            softWrap: true,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              style: TextButton.styleFrom(),
                              onPressed: () {},
                              child: const Text('Email'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
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