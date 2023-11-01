import 'package:kupfuma/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'dart:math';


final List<List<String>> imgList = [
  ['assets/images/Tatenda.jpg','We enable small businesses\n to build their monthly\n financial statements, on the go.'],
  ['assets/images/p2.jpg','We are leveraging \nbig data to unlock potential\n in your small business,\n by giving you key insights daily.'],
  ['assets/images/p3.jpg','Our data analytics\n will help you sharpen your\n decision making for your small \nbusiness to grow your sales.'],
  ['assets/images/p4.jpg','We help transform small\n businesses to big businesses\n throughout big data analysis. '],
  ];
final int imgNum=Random().nextInt(4);
final int contentNum=Random().nextInt(4);

@override
void initState() {


}
Future<void> main() async {
   //Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();



  await Firebase.initializeApp();
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
      //const WidgetTree()
    );
  }
}
class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetTree(),
      //
    );
  }
}
class Expenses extends StatelessWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container()
      //
    );
  }
}
class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget hrLine = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Welcome',
        softWrap: true,
      ),
    );


    return Scaffold(
      body: Center(
        child:Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration:  BoxDecoration(
          image: DecorationImage(
              image: AssetImage(imgList[imgNum][0]),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 170, // <-- SEE HERE
            ),
            Text(
              imgList[imgNum][1],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Color.fromRGBO(0,0, 0, 0.5)
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );// Navigate back to first route when tapped.
              },
              child: Text('Welcome',
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),


            ),
            SizedBox(
              height: 150, // <-- SEE HERE
            ),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 70,
              endIndent: 70,
              color: Colors.white,

            ),
            const Text(
              'Africa',
              style: TextStyle(
                color: Colors.white,
                  fontWeight: FontWeight.bold,
                fontSize: 18,
                  backgroundColor: Color.fromRGBO(0,0, 0, 0.5)
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),

            ),
            Image.asset(
              'assets/images/lg.png',
              width: 150,
              height: 100,
              fit: BoxFit.cover,

            ),

          ],
      ),
      ),
    ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignIn()),
            );// Navigate back to first route when tapped.
          },
          child: const Text('Welcome'),
        ),
      ),
    );
  }
}