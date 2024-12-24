import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kupfuma/api/firebase_api.dart';
import 'package:kupfuma/pages/home_page.dart';
import 'package:kupfuma/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';




import 'dart:math';

final navigatorKey=GlobalKey<NavigatorState>();
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
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);

}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications',
  importance: Importance.defaultImportance,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async {
   //Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();
  //pk_live_51N85NcGg8GWdATteQ5h08RLz2EwsFs4mHlVQKzRHJljhYbDfjYWWlV3JQdgZJot0Cd2qew4FiFLj7u96g9XkBvA000qGx4Lx21
  //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
  //pk_test_51N85NcGg8GWdATte5qleagkzNcAf8OE8yPWVWRTuMzgMnGPFm2t8bRVPL32RKJOjndlDO7Cx5c5Zwfl6vP6jBAtC007C8HvA3r
  //sk_test_51N85NcGg8GWdATtebhunIN7c1xq0wDojliMX1wDb9XSdMVCCCZUQp1ptFdSH5otgL2W7xqfgb3yD78kSaqq5bvFV00W3yKjsv2


  await Firebase.initializeApp();

  await FirebaseApi().initNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
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
      navigatorKey: navigatorKey,
      home: MyApp2(),
      routes: {
        NotificationScreen.route:(context) => NotificationScreen(),
      },
      //const WidgetTree()
    );
  }
}

const MaterialColor white = MaterialColor(
  0xFFFFFFFF, // Primary value for the white shade
  <int, Color>{
    50: Color(0xFFFFFFFF), // Lighter shades
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF), // Primary color
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF), // Darker shades
  },
);

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: white,
          primaryColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(color: Colors.white),
          )
        ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Colors.white),
              )
          )
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


class MyApp2 extends StatefulWidget {

  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  final DatabaseReference _database = FirebaseDatabase().reference();
  late FirebaseMessaging _fcm;
   String message="";
   String token="";

  @override
  void initState(){
    super.initState();
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {

      }
    });
    getToken();



  }
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
  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    setState(() {
      token = token;
    });
    final DatabaseReference _database = FirebaseDatabase().reference();
    _database.child('fcm-token/${token}').set({"token": token});
  }

}
