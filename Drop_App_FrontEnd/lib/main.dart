import 'package:flutter/material.dart';
import 'package:drop_app/tabs/donate.dart';
import 'package:drop_app/tabs/share.dart';
import 'package:drop_app/tabs/chat.dart';
import 'package:drop_app/tabs/profile.dart';


void main() {
  runApp(const MyApp());
}

ShareQuest example = ShareQuest(userName: 'Conan Gray', itemName: 'Multipot', itemDescription: 'Electric multi-pot for cooking pasta', coins: 1, timeRemaining: '30 Min', date: '17 Oct');

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  
  late TabController navbarcontroller;
  
  @override
  void initState() {
    super.initState();
    navbarcontroller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    navbarcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: TabBarView(
        controller: navbarcontroller,
        children:  <Widget> [Donate(),  ShareQuestList(shareQuests: [example,example,example,example,example, example, example, example, example, example
        ],), Profile() ],
      ),

  bottomNavigationBar: Material(
  elevation: 3,
  child: Container(
    height: 70, 
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 249, 249, 249),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, -3), // Shadow position (to add shadow above)
        ),
      ],
    ),
    child: TabBar(
      tabs: <Tab>[
        makeTab('assets/images/donate.png', 'Donate'),
        makeTab('assets/images/share.png', 'Share'),
        makeTab('assets/images/chat.png', 'Chat'),
        makeTab('assets/images/profile.png', 'Profile')
      ],
      controller: navbarcontroller,
    ),
  ),
),
    );
  }
}

Tab makeTab( String location, String tabName){
  return Tab(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 28, 
                height: 28,
                child: Image.asset(location),
              ),
               Text(
                tabName,
                style: const TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto', 
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
}


