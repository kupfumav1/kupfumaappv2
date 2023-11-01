import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kupfuma/auth.dart';
import 'package:kupfuma/widget_tree.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:angles/angles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

List<String> africanCountries = [
  'Country','Algeria', 'Angola', 'Benin', 'Botswana', 'Burkina Faso', 'Burundi',
  'Cabo Verde', 'Cameroon', 'Central African Republic', 'Chad', 'Comoros',
  'Congo', 'Cote d\'Ivoire', 'Djibouti', 'Egypt', 'Equatorial Guinea',
  'Eritrea', 'Eswatini', 'Ethiopia', 'Gabon', 'Gambia', 'Ghana', 'Guinea',
  'Guinea-Bissau', 'Kenya', 'Lesotho', 'Liberia', 'Libya', 'Madagascar',
  'Malawi', 'Mali', 'Mauritania', 'Mauritius', 'Morocco', 'Mozambique',
  'Namibia', 'Niger', 'Nigeria', 'Rwanda', 'Sao Tome and Principe',
  'Senegal', 'Seychelles', 'Sierra Leone', 'Somalia', 'South Africa',
  'South Sudan', 'Sudan', 'Tanzania', 'Togo', 'Tunisia', 'Uganda',
  'Zambia', 'Zimbabwe',
];


PlatformFile? pickedFileReport;
UploadTask? uploadTaskReport;
Future selectFileReport() async {
  final result = await FilePicker.platform.pickFiles();
  if (result == null) return;

  pickedFileReport = result.files.first;
}

String range="0,100",selectedCountry="ALL",selectedSecta="ALL";
String range1="0,100",selectedCountry1="ALL",selectedSecta1="ALL";
String uid=" ",role="Owner",smeRob="";

final threeQuarterTurn = Angle.halfTurn() + Angle.degrees(180.0);

String theDate = DateFormat.d().format(DateTime.now());
String month = DateFormat.MMMM().format(DateTime.now());
String the_year = DateFormat('yyyy').format(DateTime.now());

String getMonth(int currentMonthIndex) {
  return DateFormat('MMM').format(DateTime(0, currentMonthIndex)).toString();
}

String the_month = month;
String actualDate = theDate + "-" + month + "-" + the_year;
String actualMonthRef = month + "-" + the_year;

String getMonthRef(String s) {
  final DateFormat format = DateFormat('dd-MMMM-yyyy');
  final DateTime date = format.parse(s);
  final String month = date.month.toString().padLeft(2, '0');
  final String year = date.year.toString();
  return '$month-$year';
}

Future<void> signOut() async {
  await Auth().signOut();
}

class GuideRoute extends StatelessWidget {
  const GuideRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kupfuma: User Guide'),
      ),
      body: SfPdfViewer.asset('assets/guide.pdf'),
    );
  }
}

class AboutRoute extends StatelessWidget {
  const AboutRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kupfuma: About'),
      ),
      body: SfPdfViewer.asset('assets/about.pdf'),
    );
  }
}

class HomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomePage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;
  @override
  HomePageState createState() => HomePageState();

}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [
  otherUser,
    reviseBudget,
    home,
    guide,

    about
  ];
  static const List<MenuItem> secondItems = [settings, delete, logout];

  static const myAdvisor = MenuItem(text: 'My Advisor', icon: Icons.album);
  static const otherUser =
      MenuItem(text: 'Team Members', icon: Icons.people_outline);
  static const home =
      MenuItem(text: 'Profile', icon: Icons.supervised_user_circle_outlined);
  static const guide =
      MenuItem(text: 'User Guide', icon: Icons.verified_user_rounded);
  static const about = MenuItem(text: 'About Us', icon: Icons.comment);
  static const delete = MenuItem(text: 'Delete', icon: Icons.delete_forever);
  static const settings = MenuItem(text: 'Reset', icon: Icons.delete);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);
  static const reviseBudget =
      MenuItem(text: 'Reset Budgets', icon: Icons.money_off);
  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    final User? user = Auth().currentUser;
    
    String email = user?.email ?? 'email';
    TextEditingController smeNameController = new TextEditingController();
    TextEditingController userNameController = new TextEditingController();
    TextEditingController mainNumberController = new TextEditingController();
    TextEditingController smeNameController1 = new TextEditingController();
    TextEditingController userNameController1 = new TextEditingController();
    TextEditingController mainNumberController1 = new TextEditingController();
    TextEditingController descController = new TextEditingController();
    String advisorDesc = "",
        advisorName = "",
        advisorNumber = "",
        advisorEmail = "",
        advisorCountry = "",
        advisorCity = "",
        advisorQ1 = "",
        advisorQ2 = "",
        advisorEx1 = "",
        advisorEx2 = "",
        advisorEx3 = "",
        advisorEx4 = "",
        advisorEx5 = "";

    final _formKey = GlobalKey<FormState>();
    String mainSme = "", number = "", key = "";
    late DatabaseReference reference;
    update2() async {
      reference = FirebaseDatabase.instance.ref('User' + '/' + key);
      Map<String, String> revenue1 = {
        'secondaryEmail': smeNameController1.text,
        'secondaryPassword': mainNumberController1.text,
        'secondaryUser': userNameController1.text,
      };
      await reference.update(revenue1);
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: smeNameController.text,
              password: mainNumberController.text);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    }

    bool obscureText = true;

    update() async {
      reference = FirebaseDatabase.instance.ref('User' + '/' + key);
      Map<String, String> revenue1 = {
        'sme': smeNameController.text,
        'number': mainNumberController.text,
        'fname': userNameController.text,
        'desc': descController.text
      };
      await reference.update(revenue1);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    }

    @override
    startState() async {
      // TODO: implement initState
      await FirebaseDatabase.instance
          .ref()
          .child('User/')
          .onChildAdded
          .listen((event) {
        Map revenue = event.snapshot.value as Map;
        revenue['key'] = event.snapshot.key;
        if (email == revenue['email']) {
          key = revenue['key'];
          reference = FirebaseDatabase.instance.ref('Users' + '/' + key);
          //number =revenue['number'];
          mainSme = revenue['sme'];
          advisorEmail = revenue['advisorEmail'];
          smeNameController.text = mainSme;
          userNameController.text = revenue['fname'];
          // Step 2 <- SEE HERE
          if (revenue.containsKey('secondaryEmail')) {
            smeNameController1.text = revenue['secondaryEmail'];
            userNameController1.text = revenue['secondaryUser'];
            mainNumberController1.text =
                revenue['secondaryPassword'].toString();
          }
          mainNumberController.text = revenue['number'].toString();
          descController.text = revenue['desc'];
        }
      });

      await Future.delayed(Duration(seconds: 1));

      FirebaseDatabase.instance
          .ref()
          .child('advisor/')
          .onChildAdded
          .listen((event) {
        Map revenue = event.snapshot.value as Map;
        revenue['key'] = event.snapshot.key;
        if (advisorEmail == revenue['email']) {
          print("napinda baba");
          advisorName = revenue['name'];
          advisorCountry = revenue['country'];
          advisorCity = revenue['city'];
          advisorEx1 = revenue['exp1'];
          advisorEx2 = revenue['exp2'];
          advisorEx3 = revenue['exp3'];
          advisorEx4 = revenue['exp4'];
          advisorEx5 = revenue['exp5'];
          advisorQ1 = revenue['q1'];
          advisorQ2 = revenue['q2'];
          advisorDesc = revenue['desc'];
        }
      });
    }

    startState();
    switch (item) {
      case MenuItems.otherUser:
        if(role=="Owner")
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RetrieveUsersPage()),
        );
        break;
      case MenuItems.myAdvisor:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'My Advisor Profile\n' + advisorName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '\n\nNumber: ' + advisorNumber,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Email: ' + advisorEmail,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Description: ' + advisorDesc,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        '\nQualifcations',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        advisorQ1,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        advisorQ2,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        '\nExperience',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        advisorEx1,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        advisorEx2,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        advisorEx3,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        advisorEx4,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        advisorEx5,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                              style: TextButton.styleFrom(
                                onSurface: Colors.white,
                                backgroundColor: Colors.orange,
                                minimumSize: const Size.fromHeight(50),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        //Do something
        break;
      case MenuItems.home:
        if(role=="Owner")
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Missing Required Field';
                          }
                          return null;
                        },
                        controller: userNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                          hintText: 'Enter User Name',
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Missing Required Field';
                          }
                          return null;
                        },
                        controller: smeNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'SME Name',
                          hintText: 'Enter SME Name',
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Missing Required Field';
                          }
                          return null;
                        },
                        controller: mainNumberController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone Number',
                          hintText: 'Enter Phone Number',
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Missing Required Field';
                          }
                          return null;
                        },
                        controller: descController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Business Description',
                          hintText: 'Enter Business Description',
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MaterialButton(
                            // style: TextButton.styleFrom(
                            //   onSurface: Colors.white,
                            //   backgroundColor:Colors.blue,
                            //     minimumSize: const Size.fromHeight(50),
                            //
                            // ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                update();
                                // reference.push().set(revenue);

                                SignIn;
                              }
                            },
                            child: const Text('Update'),
                            color: Colors.blue,
                            textColor: Colors.white,
                            minWidth: 300,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                              style: TextButton.styleFrom(
                                onSurface: Colors.white,
                                backgroundColor: Colors.orange,
                                minimumSize: const Size.fromHeight(50),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        //Do something
        break;
      case MenuItems.about:

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutRoute()),
        );

        break;
      case MenuItems.guide:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GuideRoute()),
        );

        break;
      case MenuItems.reviseBudget:
        final salesTargetController = TextEditingController();
        final actionPlanController = TextEditingController();
        final revenueBudgetController = TextEditingController();
        final fixedCostsController = TextEditingController();
        final revenueTargetController = TextEditingController();
        final expensesTargetController = TextEditingController();
        if(role=="Owner")
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Revise Budgets',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: revenueBudgetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Revenue Budget ',
                        hintText: 'Enter Revenue Budget',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: fixedCostsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Fixed Costs Budget',
                        hintText: 'Enter Fixed Costs Budget',
                      ),
                    ),
                    // const SizedBox(height: 15),
                    // TextField(
                    //   controller: revenueTargetController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'Revenue Target ',
                    //     hintText: 'Enter Revenue Target',
                    //   ),
                    // ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: expensesTargetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Daily Expenses Budget',
                        hintText: 'Enter Daily Expenses Budget',
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Map<String, String> revenue = {
                      'salesTarget': '',
                      'actionPlan': '',
                      'revenueBudget': revenueBudgetController.text,
                      'fixedCosts': fixedCostsController.text,
                      'revenueTarget': '',
                      'expensesTarget': expensesTargetController.text
                    };

                    FirebaseDatabase.instance
                        .ref()
                        .child(actualMonthRef + '/budgets/' + uid)
                        .push()
                        .set(revenue);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                    style: TextButton.styleFrom(
                      onSurface: Colors.white,
                      backgroundColor: Colors.orange,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close')),
              ],
            );
          },
        );

        break;
      case MenuItems.settings:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Erase Company Data'),
            content: const Text(
                'Are you sure you want to erase all your Company Data?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => {Navigator.pop(context, 'No')},
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => {
                  FirebaseDatabase.instance.ref("Revenue/" + uid).remove(),
                  FirebaseDatabase.instance.ref("Expenses/" + uid).remove(),
                  FirebaseDatabase.instance.ref("budgets/" + uid).remove(),
                  FirebaseDatabase.instance
                      .ref("trackExpensesCartegory/" + uid)
                      .remove(),
                  FirebaseDatabase.instance
                      .ref("trackMorningMessage/" + uid)
                      .remove(),
                  FirebaseDatabase.instance.ref("trackRevenue/" + uid).remove(),
                  FirebaseDatabase.instance
                      .ref("trackExpenses/" + uid)
                      .remove(),
                  FirebaseDatabase.instance.ref("balanceSheet/" + uid).remove(),
                  FirebaseDatabase.instance.ref("FixedCosts/" + uid).remove(),
                  FirebaseDatabase.instance.ref("net_position/" + uid).remove(),
                  FirebaseDatabase.instance
                      .ref("trackFixedCosts/" + uid)
                      .remove(),
                  FirebaseDatabase.instance
                      .ref("trackFixedCostsCartegory/" + uid)
                      .remove(),
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  ),
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        break;

      case MenuItems.logout:
        //Do something
        Auth().signOut();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
        break;
      case MenuItems.delete:
        final TextEditingController _controllerPassword =
            TextEditingController();
        final _formKey = GlobalKey<FormState>();
        
        String email = user?.email ?? 'email';
        authority(password) async {
          AuthCredential credential =
              EmailAuthProvider.credential(email: email, password: password);

// Reauthenticate
          await FirebaseAuth.instance.currentUser!
              .reauthenticateWithCredential(credential);
          try {
            await FirebaseAuth.instance.currentUser!.delete();
          } on FirebaseAuthException catch (e) {
            if (e.code == 'requires-recent-login') {
              print(
                  'The user must reauthenticate before this operation can be executed.');
            }
          }
          print("napinda");
          FirebaseAuth.instance.currentUser!.delete();
          FirebaseDatabase.instance.ref("Revenue/" + uid).remove();
          FirebaseDatabase.instance.ref("Expenses/" + uid).remove();
          FirebaseDatabase.instance.ref("budgets/" + uid).remove();
          FirebaseDatabase.instance
              .ref("trackExpensesCartegory/" + uid)
              .remove();
          FirebaseDatabase.instance.ref("trackMorningMessage/" + uid).remove();
          FirebaseDatabase.instance.ref("trackRevenue/" + uid).remove();
          FirebaseDatabase.instance.ref("trackExpenses/" + uid).remove();
          FirebaseDatabase.instance.ref("balanceSheet/" + uid).remove();
          FirebaseDatabase.instance.ref("FixedCosts/" + uid).remove();
          FirebaseDatabase.instance.ref("net_position/" + uid).remove();
          FirebaseDatabase.instance.ref("trackFixedCosts/" + uid).remove();
          FirebaseDatabase.instance
              .ref("trackFixedCostsCartegory/" + uid)
              .remove();
        }
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Erase Account'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Password';
                  }
                  return null;
                },
                controller: _controllerPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true, //<-- SEE HERE
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black),
                obscureText: true,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => {Navigator.pop(context, 'Cancel')},
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {
                      authority(_controllerPassword.text),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      ),
                    }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
        break;
    }
  }
}






class HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  int _selectedIndex = 0;

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  // Check if the user is signed in
  Column _buildInsightColumn(
      Color color, Color color2, String amount, String desc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10, // <-- SEE HERE
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color2,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color2,
            ),
          ),
        ),
        SizedBox(
          height: 10, // <-- SEE HERE
        ),
      ],
    );
  }

  Column _buildInsight2Column(
      Color color, Color color2, String desc2, String amount, String desc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10, // <-- SEE HERE
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(desc2),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color2,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color2,
            ),
          ),
        ),
        SizedBox(
          height: 10, // <-- SEE HERE
        ),
      ],
    );
  }

  List<_SalesData2> data = [];
  List<_SalesData2> data2 = [];
  List<_SalesData2> data3 = [];
  Color insightColor1 = Colors.blue;
  Color insightColor2 = Colors.blue;
  Color insightColor3 = Colors.grey;
  Color insightColor4 = Colors.white;
  Color insightColor5 = Colors.white;
  Color insightColor6 = Colors.white;
  Color? npColor;
  double totalRevenue = 0;
  double totalExpenses = 0;
  double averageRevenue = 0;
  double percentageRevenue = 0;
  int countRevenue = 0;
  double total = 0;
  double rp = 0;
  double cp = 0;
  double np = 0, projected = 0;
////calculate profit start

  double profit2 = 0;

//// calculate profit end
  late DatabaseReference dbRef;
  late DatabaseReference reference;
  late DatabaseReference budget_reference;
  late Query machinesRef;
  String sme = '', currency = '';
  String UserName = "";
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final salesTargetController = TextEditingController();
  final actionPlanController = TextEditingController();
  final revenueBudgetController = TextEditingController();
  final fixedCostsController = TextEditingController();
  final revenueTargetController = TextEditingController();
  final expensesTargetController = TextEditingController();
  double fixedCosts = 0.0;
  double fr = 0.0;
  double dailyExp = 0, dailyRev = 0, dailyCosts = 0;
  String? selectedValue;
  String _valueChanged = '', _valueChanged0 = '';
  String _valueToValidate = '', _valueToValidate0 = '';
  String _valueSaved = '', _valueSaved0 = '';
  final List<Map<String, dynamic>> _items0 = [
    {
      'value': the_year,
      'label': the_year,
      'icon': null,
    },
  ];
  final List<Map<String, dynamic>> _items = [
    {
      'value': "January",
      'label': "January",
      'icon': null,
    },
    {
      'value': "February",
      'label': "February",
      'icon': null,
    },
    {
      'value': "March",
      'label': "March",
      'icon': null,
    },
    {
      'value': "April",
      'label': "April",
      'icon': null,
    },
    {
      'value': "May",
      'label': "May",
      'icon': null,
    },
    {
      'value': "June",
      'label': "June",
      'icon': null,
    },
    {
      'value': "July",
      'label': "July",
      'icon': null,
    },
    {
      'value': "August",
      'label': "August",
      'icon': null,
    },
    {
      'value': "September",
      'label': "September",
      'icon': null,
    },
    {
      'value': "October",
      'label': "October",
      'icon': null,
    },
    {
      'value': "November",
      'label': "November",
      'icon': null,
    },
    {
      'value': "December",
      'label': "December",
      'icon': null,
    },
  ];

  double revs = 0, exps = 0, budgetExpenses = 0, budgetRevenue = 0, temp = 0;

String machineImage="",machineName="",machinePrice="";
  

  bigState() async{
    String mail = user?.email ?? 'email';
    await FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user1 = event.snapshot.value as Map;
      if (user1['email'] == mail) {
        setState(() {
          sme = user1['sme'];
          currency = user1['currency'];
          UserName = user1['fname'];
          if (user1.containsKey('primaryUid')) {

            uid = user1['primaryUid'];
            print("iripo baba"+uid);
            role=user1['role'];
            smeRob=user1['sme'];
          }
          else
          {

            uid= user?.uid ?? 'uid';
            smeRob=user1['sme'];
          }
        });
      }

    });
    await Future.delayed(Duration(seconds: 1));
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        fixedCosts = double.parse(revenue['fixedCosts']);

        for (int i = 0; i < 31; i++) {
          if (i < 10) {
            data3.add(_SalesData2("0" + i.toString(), fixedCosts));
          } else {
            data3.add(_SalesData2(i.toString(), fixedCosts));
          }
        }
      });
    });

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      {
        countRevenue++;
        setState(() {
          if (revenue['date'] == actualDate) {
            dailyRev += double.parse(revenue['amount']);
          }
          totalRevenue += double.parse(revenue['amount']);
          averageRevenue = totalRevenue / countRevenue;
          percentageRevenue = (averageRevenue / totalRevenue) * 100;

          total = totalRevenue + totalExpenses;

          cp = (totalExpenses / total) * 100;

          np = totalRevenue - totalExpenses;
          rp = totalRevenue / total;
          fr = (fixedCosts / totalRevenue) * 100;
        });
      }
    });

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Expenses/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      {
        setState(() {
          totalExpenses += double.parse(revenue['amount']) + fixedCosts;
          total = totalRevenue + totalExpenses;

          rp = totalRevenue / (totalRevenue + totalExpenses);

          cp = (totalExpenses / total) * 100;
          np = totalRevenue - totalExpenses;
          if (revenue['date'] == actualDate) {
            dailyExp += double.parse(revenue['amount']);
            dailyCosts = (dailyExp / dailyRev) * 100;
          }

          fr = (fixedCosts / totalRevenue) * 100;
          if (projected > 0) {
            npColor = Colors.green;
          } else {
            npColor = Colors.red;
          }
        });
      }
    });

    dbRef = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);

  }
  void calculateProfit() async {


    double totalRevenue = 0, cogs = 0, gp = 0;

    double totalExpense = 0, fixedCosts = 0;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/net_position/' + uid + '/')
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        profit2 += double.parse(rev['amount']);
      });
      projected += double.parse(rev['amount']);
    });
    await Future.delayed(Duration(seconds: 1));
    String a = '0',
        a1 = '0',
        a2 = '0',
        a3 = '0',
        a4 = '0',
        a5 = '0',
        a6 = '0',
        a7 = '0',
        a8 = '0',
        a9 = '0',
        a10 = '0',
        a11 = '0',
        a12 = '0';
    FirebaseDatabase.instance
        .ref()
        .child(
        actualMonthRef + '/trackFixedCosts/' + uid + '/' + actualMonthRef)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        fixedCosts += double.parse(revenue['amount']);
      });
      projected += double.parse(revenue['amount']);
    });
    await Future.delayed(Duration(seconds: 1));

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/trackExpensesCartegory/' + uid)
        .onChildAdded
        .listen((event) {
      Map exp = event.snapshot.value as Map;

      setState(() {
        a = exp['Advertising'];
        a1 = exp['Business Vehicle(s) Repairs'];
        a2 = exp['Employee Commissions'];
        a3 = exp['Variable Employee Benefits'];
        a4 = exp['Meals & Entertainment'];
        a5 = exp['Office'];
        a6 = exp['Professional Services'];
        a7 = exp['Phone'];
        a8 = exp['Travel'];
        a9 = exp['Training and Education'];
        a10 = exp['Deliveries'];
        a11 = exp['Loan & Interest Payments'];
        a12 = exp['Other'];
        totalExpense = fixedCosts +
            double.parse(a) +
            double.parse(a1) +
            double.parse(a2) +
            double.parse(a3) +
            double.parse(a4) +
            double.parse(a5) +
            double.parse(a6) +
            double.parse(a7) +
            double.parse(a8) +
            double.parse(a9) +
            double.parse(a10) +
            double.parse(a11) +
            double.parse(a12);

        // profit2 = totalRevenue - totalExpense - cogs;
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      setState(() {
        cogs += (double.parse(revenue['amount']) *
            (100 - double.parse(revenue['margin']))) /
            100;
        totalRevenue += double.parse(revenue['amount']);

        // profit2 = totalRevenue - totalExpense - cogs;
        gp = totalRevenue - cogs;
      });
    });
    await Future.delayed(Duration(seconds: 1));

    // profit2 = totalRevenue - totalExpense - cogs;
  }
  void plotGraph() async {
    // <-- Their email
    String mail = user?.email ?? 'email';
    int k = 0, z = 0;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        budgetRevenue = double.parse(revenue['revenueBudget']);
        budgetExpenses = double.parse(revenue['fixedCosts']);
        projected -= budgetExpenses;
        // data.add(_SalesData2("0", budgetExpenses));
        //data2.add(_SalesData2("0", budgetRevenue));
      });
    });
    await Future.delayed(Duration(seconds: 1));

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Expenses/' + uid + '/')
        .orderByChild('date')
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        exps += double.parse(rev['amount']);
        if (k < 1) {
          k++;
          for (int i = 0; i < int.parse(rev['date'].substring(0, 2)); i++) {
            if (i < 10) {
              data.add(_SalesData2("0" + i.toString(), budgetExpenses));
            } else {
              data.add(_SalesData2(i.toString(), budgetExpenses));
            }
          }
        }
        data.add(
            _SalesData2(rev['date'].substring(0, 2), exps + budgetExpenses));
      });
    });

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
        '/trackRevenue/' +
        uid +
        '/' +
        actualMonthRef +
        "/")
        .orderByChild('date')
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        revs += double.parse(rev['amount']);
        //data2.add(_SalesData(
        //    rev['date'].substring(0, 2), double.parse(rev['amount'])));
        if (z < 1) {
          z++;
          for (int i = 0; i < int.parse(rev['date'].substring(0, 2)); i++) {
            if (i < 10) {
              data2.add(_SalesData2("0" + i.toString(), 0));
            } else {
              data2.add(_SalesData2(i.toString(), 0));
            }
          }
        }
        data2.add(_SalesData2(rev['date'].substring(0, 2), revs));
      });
    });
  }
  @override
  void initState() {
    super.initState();
    calculateProfit();

     // <-- Their email
    String mail = user?.email ?? 'email';
   bigState();
    dbRef = FirebaseDatabase.instance.ref().child(actualMonthRef + '/budgets/');
    budget_reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid);
    plotGraph();
    //getStudentData();
    FirebaseDatabase.instance.ref().child('machines/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;

        setState(() {
          machineImage = user['imageUrls'];
          machineName = user['machineName'];
          machinePrice = user['price'];
        });

    });


  }

  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          //test dropdown
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,

              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
          //test dropdown
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(children: [
                  SelectFormField(
                    type: SelectFormFieldType.dialog,
                    controller: null,
                    //initialValue: _initialValue,
                    icon: null,
                    labelText: the_year,
                    changeIcon: false,
                    dialogTitle: '',
                    dialogCancelBtn: 'Close',
                    enableSearch: false,
                    dialogSearchHint: 'Search',
                    items: _items0,
                    onChanged: (val) => setState(() => _valueChanged0 = val),
                    validator: (val) {
                      setState(() => _valueToValidate0 = val ?? '');
                      return null;
                    },
                    onSaved: (val) => setState(() => _valueSaved0 = val ?? ''),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(children: [
                  SelectFormField(
                    type: SelectFormFieldType.dialog,
                    controller: null,
                    //initialValue: _initialValue,
                    icon: null,
                    labelText: the_month,
                    changeIcon: true,
                    dialogTitle: '',
                    dialogCancelBtn: 'Close',
                    enableSearch: false,
                    dialogSearchHint: 'Search',
                    items: _items,
                    onChanged: (val) {
                      setState(() {
                        _valueChanged = val;
                        month = val;
                        the_month = val;
                        actualMonthRef = month + "-" + the_year;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                    validator: (val) {
                      setState(() {
                        _valueToValidate = val ?? '';
                        month = val ?? '';
                        the_month = val ?? '';
                        actualMonthRef = month + "-" + the_year;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        _valueSaved = val ?? '';
                        month = val ?? '';
                        the_month = val ?? '';
                        actualMonthRef = month + "-" + the_year;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                  ),
                ]),
              ),
            ),
          ]),
          // const Text(" "),
          // const Text(" "),
          // const Text(" "),
          // const Text(" "),
          // SelectFormField(
          //   type: SelectFormFieldType.dialog,
          //   controller: null,
          //   //initialValue: _initialValue,
          //   icon: null,
          //   labelText: the_month,
          //   changeIcon: true,
          //   dialogTitle: '',
          //   dialogCancelBtn: 'Close',
          //   enableSearch: false,
          //   dialogSearchHint: 'Search',
          //   items: _items,
          //   onChanged: (val) => setState(() => _valueChanged = val),
          //   validator: (val) {
          //     setState(() => _valueToValidate = val ?? '');
          //     return null;
          //   },
          //   onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          // ),

          Container(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                  //  border: Border.all(width: 2.0, color: insightColor2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              alignment: Alignment.center,
              child: SemicircularIndicator(
                radius: 140,
                color: Colors.green,
                backgroundColor: Colors.red,
                strokeWidth: 20,
                strokeCap: StrokeCap.square,
                progress: rp,
                bottomPadding: 5,
                contain: true,
                child: Column(
                  children: [
                    Text(
                      '\n\n$sme',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Month To Date\n$date\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue),
                    ),
                    Text(
                      '\nProjected Net Position',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: npColor),
                    ),
                    Text(
                      '' + projected.toStringAsFixed(0) + ' \n',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: npColor),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Revenue'),
                          Icon(Icons.square, color: Colors.green),
                          Text('Costs'),
                          Icon(Icons.square, color: Colors.red),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding:
                const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
            child: const Text(
              'Insights',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: insightColor1,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: _buildInsightColumn(insightColor1, insightColor4,
                    dailyRev.toStringAsFixed(0), 'Daily Revenue\n'),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    color: insightColor2,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: _buildInsightColumn(insightColor2, insightColor5,
                    dailyExp.toStringAsFixed(0), 'Daily Expenses\n'),
              ),
              Container(
                decoration: BoxDecoration(
                    color: insightColor3,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: _buildInsightColumn(
                    insightColor3,
                    insightColor6,
                    dailyCosts.toStringAsFixed(2) + '%',
                    'Daily Costs/\n   Revenue'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: _buildInsight2Column(Colors.green, Colors.black,
                    '       MTD       ', revs.toStringAsFixed(0), 'Revenue\n'),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: _buildInsight2Column(
                  Colors.red,
                  Colors.black,
                  '       MTD       ',
                  exps.toStringAsFixed(0),
                  'Expenses\n',
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: _buildInsight2Column(
                    Colors.orange,
                    Colors.black,
                    '       MTD       ',
                    fixedCosts.toStringAsFixed(0),
                    '  Fixed Costs    \n'),
              ),
            ],
          ),
          const Text(
            '    Breakeven',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          //Initialize the chart widget
          Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //   border: Border.all(width: 2.0, color: insightColor2),
              // ),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  palette: <Color>[Colors.green, Colors.red, Colors.blue],
                  // Chart title
                  title: null,
                  // Enable legend
                  legend: Legend(isVisible: false),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_SalesData2, String>>[
                    LineSeries<_SalesData2, String>(
                        dataSource: data2,
                        xValueMapper: (_SalesData2 sales, _) => sales.year,
                        yValueMapper: (_SalesData2 sales, _) => sales.sales,
                        name: 'Revenue',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: false)),
                    LineSeries<_SalesData2, String>(
                        dataSource: data,
                        xValueMapper: (_SalesData2 sales, _) => sales.year,
                        yValueMapper: (_SalesData2 sales, _) => sales.sales,
                        name: 'Expenses',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: false)),
                    LineSeries<_SalesData2, String>(
                        dataSource: data3,
                        xValueMapper: (_SalesData2 sales, _) => sales.year,
                        yValueMapper: (_SalesData2 sales, _) => sales.sales,
                        name: 'Budgeted Fixed Costs',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: false))
                  ]),
            ),
          ),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Revenue'),
                Icon(Icons.square, color: Colors.green),
                Text('Expenses'),
                Icon(Icons.square, color: Colors.red),
                Text('Fixed Budget'),
                Icon(Icons.square, color: Colors.blue),
              ],
            ),
          ),
		  const SizedBox(height: 5),
    Container(
    color: Colors.black,
    child:Center(child:      Text('     \nMachine Exchange\n   ',
    style:TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.bold,)
    ),)),
		  Container(
  color: Colors.black,
  child: Row(

    children: [
      Expanded(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RetrieveMachinePage()),
      );
            },
            child: Text('Visit'),
          ),
          const SizedBox(width: 8),
          const Text(
            "Machine of the day",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 8),
          Text(
            '\$'+machinePrice,
            style: const TextStyle(color: Colors.white,
            fontSize:16,
              fontWeight:FontWeight.bold
            ),
          ),
          SizedBox(width: 8),
          Text(
            machineName,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),),
      Container(
        width:200,
        height:200,
        child: Image.network(
          machineImage,
          fit: BoxFit.cover,
        ),
      ),

    ],
  ),
),
          Container(
            color: Colors.black,
            child:Center(
              child: Text(
                '\n\nBuy affordable used machines for your small business directly from other small near you \n\n',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 15),
          
          ////curved graph

          ////curved graph
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _SalesData2 {
  _SalesData2(this.year, this.sales);

  final String year;
  final double sales;
}

class Invoice {
  final String customer;
  final String address;
  final List<LineItem> items;
  Invoice(this.customer, this.address, this.items);
  double totalCost() {
    return items.fold(
        0, (previousValue, element) => previousValue + element.cost);
  }
}

class LineItem {
  final String description;
  final double cost;

  LineItem(this.description, this.cost);
}

class SecondRoute extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  //SecondRoute({Key? key}) : super(key: key);

  SecondRoute(
      {super.key,
      required this.ky,
      required this.amount,
      required this.plan,
      required this.comment,
      required this.date,
      required this.margin});
  final String amount;
  final String plan;
  final String comment;
  final String date;
  final String margin;
  final String ky;
  final User? user = Auth().currentUser;
  @override
  //SecondRouteState createState() => SecondRouteState();
  State<SecondRoute> createState() => SecondRouteState();
}

class SecondRouteState extends State<SecondRoute> {
  int _selectedIndex = 1;

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {

      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  final User? user = Auth().currentUser;

  late DatabaseReference reference;
  String sme = '', currency = '';
  

  // <-- Their email

  //const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue'),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  widget.date,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Daily Sales',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  widget.comment,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ]),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '' + widget.amount,
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                    ]),
              ),
            ]),
            SizedBox(height: 50),
            Text(
              'Margin',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.margin + "%"),
            SizedBox(height: 50),
            Text(
              'Daily Comment',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.comment),
            SizedBox(height: 50),
            Text(
              'Key Action Plan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.plan),
            SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                
                reference = FirebaseDatabase.instance
                    .ref("Revenue/" + uid + "/" + widget.ky);

                reference.remove();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Background color
              ),
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ThirdRoute extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  //SecondRoute({Key? key}) : super(key: key);

  ThirdRoute(
      {super.key,
      required this.ky,
      required this.amount,
      required this.plan,
      required this.comment,
      required this.date,
      required this.margin});
  final String amount;
  final String plan;
  final String comment;
  final String date;
  final String margin;
  final String ky;
  final User? user = Auth().currentUser;
  @override
  //SecondRouteState createState() => SecondRouteState();
  State<ThirdRoute> createState() => ThirdRouteState();
}

class ThirdRouteState extends State<ThirdRoute> {
  int _selectedIndex = 3;

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  final User? user = Auth().currentUser;
  
  late DatabaseReference reference;
  //const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense'),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  widget.date,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  widget.plan,
                  style: TextStyle(),
                ),
                Text(
                  widget.comment,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ]),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '' + widget.amount,
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                    ]),
              ),
            ]),
            SizedBox(height: 50),
            Text(
              'Expense Title',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.margin),
            SizedBox(height: 50),
            Text(
              'Expense Description',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.comment),
            SizedBox(height: 50),
            Text(
              'Cartegory',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.plan),
            SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                
                reference = FirebaseDatabase.instance
                    .ref("Expenses/" + uid + "/" + widget.ky);

                reference.remove();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Background color
              ),
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back!'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: 3,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class RevenuePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  RevenuePage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  RevenuePageState createState() => RevenuePageState();
}

class RevenuePageState extends State<RevenuePage> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 1;

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  List<_SalesData> data = [];
  List<_SalesData> data2 = [];

  double totalRevenue = 0;
  double averageRevenue = 0;
  double percentageRevenue = 0, cash = 0;
  int countRevenue = 0;
  double budget = 0, dailyRev = 0;

  final amountController = TextEditingController();
  final marginController = TextEditingController();
  final dateController = TextEditingController();
  final commentController = TextEditingController();
  final planController = TextEditingController();
  final Color unselectedItemColor = Colors.blue;
  late Query dbRef, dbRef20;
  late DatabaseReference reference, reference1;
  String currentValue = '0';
  String sme = '', currency = '';

  getDateValue(date) {
    
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      currentValue = rev['amount'];
      // rev['key'] = event.snapshot.key;
    });
  }

  Future<void> updateMonthlyRevenue(amount, date, cogs) async {
    double currentValue = 0, newValue = 0;
    double currentCOGS = 0, newCOGS = 0;
    DatabaseReference refe, refe2, refe3;
    

    refe3 = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Expenses/' + uid + '/' + date);
    refe2 = FirebaseDatabase.instance.ref().child(actualMonthRef +
        '/trackExpenses/' +
        uid +
        '/' +
        actualMonthRef +
        "/" +
        date);
    refe = FirebaseDatabase.instance.ref().child(actualMonthRef +
        '/trackRevenue' +
        '/' +
        uid +
        '/' +
        actualMonthRef +
        "/" +
        date);

    DatabaseReference np_refe;
    double net_position = 0;
    np_refe = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/net_position/' + uid + '/' + actualMonthRef);
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/net_position/' + uid + '/')
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        if (rev['month'] == actualMonthRef) {
          net_position = double.parse(rev['amount']);
        }
      });
    });

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        if (rev['date'] == date) {
          currentValue = double.parse(rev['amount']);
          currentCOGS = double.parse(rev['cogs']);
        }
      });
    });

    await Future.delayed(Duration(seconds: 1));

    newValue = currentValue + double.parse(amount);
    newCOGS = currentCOGS + cogs;
    net_position += double.parse(amount) - cogs;
    Map<String, String> trackNP = {
      'amount': net_position.toString(),
      'month': actualMonthRef,
    };
    np_refe.set(trackNP);

    Map<String, String> trackRevenue = {
      'amount': newValue.toString(),
      'date': date,
      'cogs': newCOGS.toString(),
    };
    Map<String, String> trackExp = {
      'cogs': newCOGS.toString(),
    };
    Map<String, String> addToExpense = {
      'amount': newCOGS.toString(),
      'margin': 'COGS',
      'date': date,
      'comment': 'COGS',
      'plan': 'COGS',
    };
    refe.set(trackRevenue);
    refe2.update(trackExp);
    refe3.update(addToExpense);
  }



  @override
  void initState() {
    super.initState();
 // <-- Their email
    String mail = user?.email ?? 'email';
    int k = 0;
    String tt = "";
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/balanceSheet/' + uid + "/currentAssets")
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      if (revenue['cartegory'] == "Cash_In_Hand") {
        setState(() {
          cash += double.parse(revenue['amount']);
        });
      }
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        budget = double.parse(revenue['revenueBudget']) / 30;
        for (var i = 0; i < 31; i++) {
          if (i < 10) {
            tt = "0" + i.toString();
            data.add(_SalesData(tt, budget));
          } else {
            data.add(_SalesData(i.toString(), budget));
          }
        }
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .orderByChild('date')
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        if (rev['date'] == actualDate) {
          dailyRev += double.parse(rev['amount']);
        }
        if (k < 1) {
          k++;
          for (int i = 0; i < int.parse(rev['date'].substring(0, 2)); i++) {
            if (i < 10) {
              data2.add(_SalesData("0" + i.toString(), 0));
            } else {
              data2.add(_SalesData(i.toString(), 0));
            }
          }
        }
        data2.add(_SalesData(
            rev['date'].substring(0, 2), double.parse(rev['amount'])));
        //data.add(_SalesData(rev['date'].substring(0, 2),double.parse(budget.toStringAsFixed(0))));
      });
    });

    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });
    Map? revenueTrack;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      revenueTrack = event.snapshot.value as Map;
    });

    String getDate = "";
    double dateAmount = 0.0;

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue/' + uid)
        .orderByChild("date")
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      countRevenue++;

      setState(() {
        totalRevenue += double.parse(revenue['amount']);
        averageRevenue = totalRevenue / countRevenue;
        percentageRevenue = (averageRevenue / totalRevenue) * 100;

        if (getDate == revenue['date'].substring(0, 2)) {
          getDate = "";
          dateAmount += double.parse(revenue['amount']);
        } else {
          getDate = revenue['date'].substring(0, 2);
          dateAmount += double.parse(revenue['amount']);
        }
      });
      if (getDate != "") {
        // data2.add(_SalesData(getDate, dateAmount));
        // data.add(_SalesData(getDate, budget));
        dateAmount = 0;
      }
    });
    dbRef = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    dbRef20 = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/balanceSheet/' + uid + "/currentAssets");
    reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    reference1 = FirebaseDatabase.instance.ref().child(
        actualMonthRef + '/trackRevenue/' + uid + '/' + actualMonthRef + "/");
  }

  Widget listRevenue({required Map revenue}) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondRoute(
                    ky: revenue['key'],
                    amount: revenue['amount'],
                    plan: revenue['plan'],
                    comment: revenue['comment'],
                    margin: revenue['margin'],
                    date: revenue['date'])),
          );
          // Add what you want to do on tap
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  revenue['date'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Daily Sales',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  revenue['comment'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ]),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '' + revenue['amount'],
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                    ]),
              ),
            ])));

    return Text('');
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          //Initialize the chart widget
          Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  //border: Border.all(width: 2.0, color: insightColor2),
                  ),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  palette: <Color>[Colors.green, Colors.blue],
                  // Chart title
                  title:
                      ChartTitle(text: 'Month Revenue - $the_month $the_year'),
                  // Enable legend
                  legend: Legend(isVisible: false),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_SalesData, String>>[
                    LineSeries<_SalesData, String>(
                        dataSource: data2,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: 'Revenue',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: false)),
                    LineSeries<_SalesData, String>(
                        dataSource: data,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: 'Budget',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: false))
                  ]),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Revenue'),
                Icon(Icons.square, color: Colors.green),
                Text('Budget'),
                Icon(Icons.square, color: Colors.blue),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        Text("" + dailyRev.toStringAsFixed(0)),
                        const Text(''),
                        const Text('Daily Revenue'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blueGrey,
                    child: Column(
                      children: [
                        const Text('Average'),
                        Text("" + averageRevenue.toStringAsFixed(0)),
                        const Text('Daily Revenue'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        const Text('MTD'),
                        Text("" + totalRevenue.toStringAsFixed(0)),
                        const Text('Revenue'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if(role=="Owner" || role=="Accounts/ Admin")
          ElevatedButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Daily Revenue',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Missing Required Field';
                              }
                              return null;
                            },
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Amount ',
                              hintText: 'Enter Amount',
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Missing Required Field';
                              }
                              return null;
                            },
                            controller: marginController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Margin',
                              hintText: 'Enter Gross Margin %',
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextfieldDatePicker(
                            cupertinoDatePickerBackgroundColor: Colors.white,
                            cupertinoDatePickerMaximumDate: DateTime.now(),
                            cupertinoDatePickerMaximumYear: 2023,
                            cupertinoDatePickerMinimumYear: 1990,
                            cupertinoDatePickerMinimumDate: DateTime(1990),
                            cupertinoDateInitialDateTime: DateTime.now(),
                            materialDatePickerFirstDate: DateTime(2021),
                            materialDatePickerInitialDate: DateTime.now(),
                            materialDatePickerLastDate: DateTime.now(),
                            preferredDateFormat: DateFormat('dd-MMMM-' 'yyyy'),
                            onSaved: getDateValue(dateController.text),
                            textfieldDatePickerController: dateController,
                            style: TextStyle(
                              fontSize: 1000 * 0.040,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              //errorText: errorTextValue,onSaved
                              helperStyle: TextStyle(
                                  fontSize: 1000 * 0.031,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    color: Colors.white,
                                  )),
                              hintText: 'Select Date Received',
                              hintStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Colors.blue,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Missing Required Field';
                              }
                              return null;
                            },
                            controller: commentController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Daily Comment',
                              hintText: 'Enter Daily Comment',
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Missing Required Field';
                              }
                              return null;
                            },
                            controller: planController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Key Action Plan',
                              hintText: 'Enter Key Action Plan',
                            ),
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MaterialButton(
                                // style: TextButton.styleFrom(
                                //   onSurface: Colors.white,
                                //   backgroundColor:Colors.blue,
                                //     minimumSize: const Size.fromHeight(50),
                                //
                                // ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (dateController.text == "") {
                                      dateController.text = actualDate;
                                    }
                                    Map<String, String> revenue = {
                                      'amount': amountController.text,
                                      'margin': marginController.text,
                                      'date': dateController.text,
                                      'comment': commentController.text,
                                      'plan': planController.text
                                    };

                                    Map<String, String> trackRevenue = {
                                      dateController.text:
                                          amountController.text,
                                    };
                                    double amo =
                                        double.parse(amountController.text);
                                    double margi = (100 -
                                            double.parse(
                                                marginController.text)) /
                                        100;
                                    double cogs = amo * margi;
                                    updateMonthlyRevenue(amountController.text,
                                        dateController.text, cogs);

                                    reference.push().set(revenue);
                                    //reference1.set(trackRevenue);
                                    cash += amo;
                                    Map<String, String> casset = {
                                      'amount': cash.toStringAsFixed(0),
                                      'description': "Cash In Hand",
                                      'cartegory': "Cash_In_Hand",
                                      'title': "Cash_In_Hand",
                                    };

                                    FirebaseDatabase.instance
                                        .ref()
                                        .child(actualMonthRef +
                                            '/balanceSheet/' +
                                            uid +
                                            "/currentAssets/CID")
                                        .update(casset);
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Save'),
                                color: Colors.blue,
                                textColor: Colors.white,
                                minWidth: 300,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  style: TextButton.styleFrom(
                                    onSurface: Colors.white,
                                    backgroundColor: Colors.orange,
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close')),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: const Text('Add Daily Revenue'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(50), // NEW
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map revenue = snapshot.value as Map;
                    revenue['key'] = snapshot.key;

                    return listRevenue(revenue: revenue);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30, // <-- SEE HERE
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class FundingPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  FundingPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  FundingPageState createState() => FundingPageState();
}

class FundingPageState extends State<FundingPage> {
  final User? user = Auth().currentUser;
  int _selectedIndex = 2;

  ////calculate profit start

  double profit2 = 0, wish = 0;
  void calculateProfit() async {
    
    double totalRevenue = 0, cogs = 0, gp = 0;

    double totalExpense = 0, fixedCosts = 0;

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/net_position/' + uid + '/')
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        profit2 += double.parse(rev['amount']);
      });
    });

    String a = '0',
        a1 = '0',
        a2 = '0',
        a3 = '0',
        a4 = '0',
        a5 = '0',
        a6 = '0',
        a7 = '0',
        a8 = '0',
        a9 = '0',
        a10 = '0',
        a11 = '0',
        a12 = '0';
    FirebaseDatabase.instance
        .ref()
        .child(
            actualMonthRef + '/trackFixedCosts/' + uid + '/' + actualMonthRef)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        fixedCosts += double.parse(revenue['amount']);
      });
    });

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/trackExpensesCartegory/' + uid)
        .onChildAdded
        .listen((event) {
      Map exp = event.snapshot.value as Map;

      setState(() {
        a = exp['Advertising'];
        a1 = exp['Business Vehicle(s) Repairs'];
        a2 = exp['Employee Commissions'];
        a3 = exp['Variable Employee Benefits'];
        a4 = exp['Meals & Entertainment'];
        a5 = exp['Office'];
        a6 = exp['Professional Services'];
        a7 = exp['Phone'];
        a8 = exp['Travel'];
        a9 = exp['Training and Education'];
        a10 = exp['Deliveries'];
        a11 = exp['Loan & Interest Payments'];
        a12 = exp['Other'];
        totalExpense = fixedCosts +
            double.parse(a) +
            double.parse(a1) +
            double.parse(a2) +
            double.parse(a3) +
            double.parse(a4) +
            double.parse(a5) +
            double.parse(a6) +
            double.parse(a7) +
            double.parse(a8) +
            double.parse(a9) +
            double.parse(a10) +
            double.parse(a11) +
            double.parse(a12);

        //profit2 = totalRevenue - totalExpense - cogs;
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      setState(() {
        cogs += (double.parse(revenue['amount']) *
                (100 - double.parse(revenue['margin']))) /
            100;
        totalRevenue += double.parse(revenue['amount']);
        //profit2 = totalRevenue - totalExpense - cogs;

        gp = totalRevenue - cogs;
      });
    });
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      // profit2 = totalRevenue - totalExpense - cogs;
      if (profit2 > 0) {
        minus = "";
        pos = profit2.toStringAsFixed(2);
        eq = " ";
      }
      if (profit2 == 0) {
        minus = " ";
        pos = " ";
        eq = profit2.toStringAsFixed(2);
      }
      if (profit2 > 0) {
        funding = profit2 * 2.5;
      } else {
        funding = 0;
      }
    });
  }

//// calculate profit end
  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  // Check if the user is signed in
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  final List<Map<String, dynamic>> _items = [
    {
      'value': '2.5',
      'label': 'Equipment',
      'icon': Icon(Icons.smart_toy_outlined),
    },
    {
      'value': '2',
      'label': 'Raw Materials',
      'icon': Icon(Icons.storefront),
    },
    {
      'value': '1',
      'label': 'Stock',
      'icon': Icon(Icons.people_rounded),
    },
    {
      'value': '5',
      'label':
          'Our support is highly prioritised towards value adding equipment in order to build manufacturing capacity for small businesses in Africa.',
      'icon': null,
    }
  ];
  PlatformFile? pickedFile;
  PlatformFile? pickedFile2;
  PlatformFile? pickedFile3;
  UploadTask? uploadTask;
  Future selectFile1() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future selectFile2() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile2 = result.files.first;
    });
  }

  Future selectFile3() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile3 = result.files.first;
    });
  }

  String uploaded = '';
  Future uploadFiles() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        alignment: Alignment.bottomCenter,
        backgroundColor: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "To start accessing our flexible, no collateral, data driven and low to no interest funding you need to have been on our platform for 3months minimum.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
    // Fluttertoast.showToast(
    //     msg: "To start accessing our flexible, no collateral, data driven and low to no interest funding you need to have been on our platform for 3months minimum.",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.orange,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
    // setState(() {
    //   uploaded = "Uploading Please Wait....";
    // });
    // 
    // final path = 'funding/' + uid + '/analysis.pdf';
    // final path2 = 'funding/' + uid + '/istatement.pdf';
    // final path3 = 'funding/' + uid + '/bsheet.pdf';
    //
    // final file = File(pickedFile!.path!);
    // final file2 = File(pickedFile2!.path!);
    // final file3 = File(pickedFile3!.path!);
    //
    // final ref = FirebaseStorage.instance.ref().child(path);
    // uploadTask = ref.putFile(file);
    //
    // final snapshot = await uploadTask!.whenComplete(() => {});
    // final urlDownload = await snapshot.ref.getDownloadURL();

    //
    // final ref2 = FirebaseStorage.instance.ref().child(path2);
    // uploadTask = ref2.putFile(file2);
    //
    // final ref3 = FirebaseStorage.instance.ref().child(path3);
    // uploadTask = ref3.putFile(file3);
    // setState(() {
    //   uploaded = "Funding Request Sent Thank You";
    // });
  }

  double totalRevenue = 0;
  double averageRevenue = 0;
  double percentageRevenue = 0;
  int countRevenue = 0;
  double funding = 0.0;
  double fundingp = 0.0;
  double pol = 0.0;
  String minus = " ";
  String pos = " ";
  String eq = " ";

  double totalExpenses = 0.0;

  final amountController = TextEditingController();
  final marginController = TextEditingController();
  final dateController = TextEditingController();
  final commentController = TextEditingController();
  final planController = TextEditingController();

  late Query dbRef;
  late DatabaseReference reference;
  String sme = "", currency = "";
  @override
  void initState() {
    super.initState();
    calculateProfit();
     // <-- Their email
    String mail = user?.email ?? 'email';
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
          if (user.containsKey('wishedCapital')) {
            wish = double.parse(user['wishedCapital']);
          }
        });
      }
    });

    dbRef = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      setState(() {
        totalRevenue += double.parse(revenue['amount']);

        fundingp = funding / 100000;
        pol = totalRevenue - totalExpenses;

        if (profit2 < 0) {
          minus = profit2.toStringAsFixed(2);
          pos = " ";
          eq = " ";
        }
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Expenses/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      setState(() {
        totalExpenses += double.parse(revenue['amount']);
        pol = totalRevenue - totalExpenses;

        if (profit2 < 0) {
          minus = profit2.toStringAsFixed(2);
          pos = " ";
          eq = " ";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          //Initialize the chart widget

          Column(
            children: <Widget>[
              Text(
                '$uploaded',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const Text(
                'Average Profit 3 Months',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Text(""),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        "$minus",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        "$eq",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        "$pos",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      Text(""),
                    ],
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: LinearPercentIndicator(
                  width: 180.0,
                  lineHeight: 23.0,
                  percent: 0.5,
                  center: Text(
                    " ",
                    style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.white, 
                    ),
                  ),
                  leading: const Text(
                    "      -",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.red),
                  ),
                  trailing: const Text(
                    "+",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.green),
                  ),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  backgroundColor: Colors.green,
                  progressColor: Colors.red,
                ),
              ),
              const Text('Your Business Capacity'),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 6.0, color: insightColor2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Text("" + funding.toStringAsFixed(2)),
              ),
              Container(
                padding: const EdgeInsets.all(17),
                child: SelectFormField(
                  type: SelectFormFieldType.dialog,
                  controller: planController,
                  //initialValue: _initialValue,
                  icon: Icon(Icons.format_shapes),
                  labelText: 'What does your business need?',
                  changeIcon: true,
                  dialogTitle: '',
                  dialogCancelBtn: 'Close',
                  enableSearch: false,
                  dialogSearchHint: 'Search',
                  items: _items,
                  onChanged: (val) {
                    setState(() {
                      _valueChanged = val;

                      if (profit2 > 0) {
                        funding = profit2 * double.parse(val);
                      } else {
                        funding = 0;
                      }
                    });
                  },
                  validator: (val) {
                    setState(() => _valueToValidate = val ?? '');
                    return null;
                  },
                  onSaved: (val) => setState(() => _valueSaved = val ?? ''),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(17),
                child: Column(
                  children: [
                    ElevatedButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          onSurface: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: selectFile1,
                        child: const Text('[Attach] Best Supplier Quotation')),
                    SizedBox(height: 6),
                    ElevatedButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          onSurface: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: selectFile1,
                        child: const Text('[Attach] Cost Benefit Analysis')),
                    SizedBox(height: 6),
                    ElevatedButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          onSurface: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: selectFile2,
                        child: const Text('[Attach] Income Statement')),
                    SizedBox(height: 6),
                    ElevatedButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          onSurface: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: selectFile3,
                        child: const Text('[Attach] Balance Sheet')),
                    const SizedBox(height: 18),
                    ElevatedButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          onSurface: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: uploadFiles,
                        child: const Text('Submit')),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 5.0, color: Colors.blue),
                  ),
                ),
                padding: const EdgeInsets.only(top: 17, left: 17, right: 17),
                child: Column(
                  children: [
                    const Text(
                      'Our analytics help small businesses become profitable whilst our flexible funding rewards profitability by giving you more capital.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(top: 17, left: 17, right: 17),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Wishlist: How much capital do you wish to raise to take your business to the next level',
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Text(
                      wish.toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ExpensesPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ExpensesPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;
  @override
  ExpensesPageState createState() => ExpensesPageState();
}

class ExpensesPageState extends State<ExpensesPage> {
  final User? user = Auth().currentUser;
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController? _controller;

  //String _initialValue;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  int _selectedIndex = 3;
  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Advertising',
      'label': 'Advertising',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Business Vehicle(s) Repairs',
      'label': 'Business Vehicle(s) Repairs',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Employee Commissions',
      'label': 'Employee Commissions',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Variable Employee Benefits',
      'label': 'Variable Employee Benefits',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Meals & Entertainment',
      'label': 'Meals & Entertainment',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Office',
      'label': 'Office',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Professional Services',
      'label': 'Proffesional Services',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Phone',
      'label': 'Phone',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Travel',
      'label': 'Travel',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Training and Education',
      'label': 'Training and Education',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Deliveries',
      'label': 'Deliveries',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Loan & Interest Payments',
      'label': 'Loan & Interest Payments',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Other',
      'label': 'Other',
      'icon': Icon(Icons.monetization_on_outlined),
    },
  ];
  List<_SalesData> data = [];
  List<String> strings = [];

  List<_SalesData> data2 = [];
  late Query dbRef;
  late DatabaseReference reference;
  final amountController = TextEditingController();
  final marginController = TextEditingController();
  final dateController = TextEditingController();
  final commentController = TextEditingController();
  final planController = TextEditingController();
  double totalExpenses = 0;
  double averageExpenses = 0;
  double percentageExpenses = 0;
  double fixedCosts = 0, dailyExp = 0, wish = 0, cash = 0;
  int countExpenses = 0;
  String sme = '', currency = '';

  Future<void> updateMonthlyExpenses(amount, date, cart) async {
    double currentValue = 0, newValue = 0, cartValue = 0, cartNewValue = 0;

    String? cartKey;
    DatabaseReference refe;
    DatabaseReference np_refe;
    double net_position = 0;
    np_refe = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/net_position/' + uid + '/' + actualMonthRef);
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/net_position/' + uid + '/')
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        if (rev['month'] == actualMonthRef) {
          net_position = double.parse(rev['amount']);
        }
      });
    });

    refe = FirebaseDatabase.instance.ref().child(actualMonthRef +
        '/trackExpenses/' +
        uid +
        '/' +
        actualMonthRef +
        "/" +
        date);
    DatabaseReference dbRefe = FirebaseDatabase.instance.ref().child(
        actualMonthRef +
            '/trackExpensesCartegory/' +
            uid +
            '/' +
            actualMonthRef);
    DataSnapshot snapshot = await dbRefe.get();
    if (snapshot.value == null) {
      Map<String, String> cartegories = {
        'Advertising': '0',
        'Business Vehicle(s) Repairs': '0',
        'Employee Commissions': '0',
        'Variable Employee Benefits': '0',
        'Meals & Entertainment': '0',
        'Office': '0',
        'Professional Services': '0',
        'Phone': '0',
        'Travel': '0',
        'Training and Education': '0',
        'Deliveries': '0',
        'Loan & Interest Payments': '0',
        'Other': '0',
        'month': actualMonthRef,
      };

      dbRefe.set(cartegories);
    } else {}
    await Future.delayed(Duration(seconds: 1));
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/trackExpensesCartegory/' + uid)
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        cartValue = double.parse(rev[cart]);
      });
    });

    await Future.delayed(Duration(seconds: 1));
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackExpenses/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        if (rev['date'] == date) {
          currentValue = double.parse(rev['amount']);

          // rev['key'] = event.snapshot.key;
        }
      });
    });

    await Future.delayed(Duration(seconds: 1));
    newValue = currentValue + double.parse(amount);
    cartNewValue = cartValue + double.parse(amount);
    net_position -= double.parse(amount);
    Map<String, String> trackNP = {
      'amount': net_position.toString(),
      'month': actualMonthRef,
    };
    np_refe.set(trackNP);

    Map<String, String> trackExpenses = {
      'amount': newValue.toString(),
      'date': date,
      "cogs": "0",
      cart: cartNewValue.toString(),
    };

    refe.update(trackExpenses);
    Map<String, String> trackCart = {
      cart: cartNewValue.toString(),
      'month': actualMonthRef,
      "cogs": "0",
    };

    dbRefe.update(trackCart);
  }



  @override
  void initState() {
    super.initState();
    
    String mail = user?.email ?? 'email';
    int k = 0;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/balanceSheet/' + uid + "/currentAssets")
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      if (revenue['cartegory'] == "Cash_In_Hand") {
        setState(() {
          cash += double.parse(revenue['amount']);
        });
      }
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      String tt = "";
      setState(() {
        fixedCosts = double.parse(revenue['expensesTarget']) / 30;
        for (var i = 0; i < 31; i++) {
          if (i < 10) {
            tt = "0" + i.toString();
            data.add(_SalesData(tt, fixedCosts));
          } else {
            data.add(_SalesData(i.toString(), fixedCosts));
          }
        }
      });
    });
    double tempAmount = 0, tempCOGS = 0;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackExpenses/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .orderByChild('date')
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        tempAmount = rev['amount'] != null ? double.parse(rev['amount']) : 0.0;

        tempCOGS = double.parse(rev['cogs']);

        if (rev['date'] == actualDate) {
          dailyExp += tempAmount + tempCOGS;
        }
        if (k < 1) {
          k++;
          if(rev['date']!=null){
            int dateLength = rev['date'].length;
            int endIndex = dateLength >= 2 ? 2 : dateLength;
            int dateSubstring = int.parse(rev['date'].substring(0, endIndex));
          for (int i = 0; i < dateSubstring; i++) {
            if (i < 10) {
              data2.add(_SalesData("0" + i.toString(), 0));
            } else {
              data2.add(_SalesData(i.toString(), 0));
            }
          }
        }
        }
        if(rev['date']!=null) {
          data2.add(_SalesData(rev['date'].substring(0, 2),
              double.parse(rev['amount']) + double.parse(rev['cogs'])));
        }
        // data.add(_SalesData(rev['date'].substring(0, 2), double.parse(fixedCosts.toStringAsFixed(0))));
      });
    });
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
          if (user.containsKey('wishedCapital')) {
            wish = double.parse(user['wishedCapital']);
          }
        });
      }
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Expenses/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      countExpenses++;
      setState(() {
        totalExpenses += double.parse(revenue['amount']);
        averageExpenses = totalExpenses / countExpenses;
        percentageExpenses = (averageExpenses / totalExpenses) * 100;
      });
    });
    strings.add("Nepal");
    // <-- Their email

    dbRef = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Expenses' + '/' + uid);
    reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Expenses' + '/' + uid);
    _controller = TextEditingController(text: '2');

    _getValue();
  }

  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        //_initialValue = 'circleValue';
        _controller?.text = 'circleValue';
      });
    });
  }

  Widget listExpenses({required Map revenue}) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ThirdRoute(
                    ky: revenue['key'],
                    amount: revenue['amount'],
                    plan: revenue['plan'],
                    comment: revenue['comment'],
                    margin: revenue['margin'],
                    date: revenue['date'])),
          );
          // Add what you want to do on tap
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  revenue['date'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  revenue['plan'],
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  revenue['comment'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ]),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '' + revenue['amount'],
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                    ]),
              ),
            ])));

    return Text('');
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          //Initialize the chart widget
          Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExpensesPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white, // Background Color
                        ),
                        child: const Text(
                          'Variable Costs',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FixedCostsPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red, // Background Color
                        ),
                        child: const Text(
                          'Fixed Costs',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ]),
                  ),
                ],
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  // border: Border.all(width: 2.0, color: insightColor2),
                  ),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  palette: <Color>[Colors.red, Colors.blue],
                  // Chart title
                  title:
                      ChartTitle(text: 'Month Expenses - $the_month $the_year'),
                  // Enable legend
                  legend: Legend(isVisible: false),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_SalesData, String>>[
                    LineSeries<_SalesData, String>(
                        dataSource: data2,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: 'Expenses',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: false)),
                    LineSeries<_SalesData, String>(
                        dataSource: data,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: 'Budget',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: false))
                  ]),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Expenses'),
                Icon(Icons.square, color: Colors.red),
                Text('Budget'),
                Icon(Icons.square, color: Colors.blue),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        Text("" + dailyExp.toStringAsFixed(0)),
                        const Text(''),
                        const Text('Daily Expenses'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blueGrey,
                    child: Column(
                      children: [
                        const Text('Average'),
                        Text("" + percentageExpenses.toStringAsFixed(0)),
                        const Text('Daily Expenses'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        const Text('MTD'),
                        Text("" + totalExpenses.toStringAsFixed(0)),
                        const Text('Expenses'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if(role=="Owner" || role=="Accounts/ Admin")
          ElevatedButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Daily Expenses',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          SelectFormField(
                            type: SelectFormFieldType.dialog,
                            controller: planController,
                            //initialValue: _initialValue,
                            icon: Icon(Icons.format_shapes),
                            labelText: 'Category',
                            changeIcon: true,
                            dialogTitle: 'Expense Category',
                            dialogCancelBtn: 'CANCEL',
                            enableSearch: true,
                            dialogSearchHint: 'Search',
                            items: _items,
                            onChanged: (val) =>
                                setState(() => _valueChanged = val),
                            validator: (val) {
                              setState(() => _valueToValidate = val ?? '');
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _valueSaved = val ?? ''),
                          ),

                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Amount ',
                              hintText: 'Enter Amount',
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: marginController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Expense Title',
                              hintText: 'Enter Expense Title',
                            ),
                          ),
                          const SizedBox(height: 15),
                          // TextField(
                          //   controller: dateController,
                          //   keyboardType: TextInputType.datetime,
                          //   decoration: const InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     labelText: 'Date Paid dd-mm-yyyy',
                          //     hintText: 'Select Date Paid dd-mm-yyyy',
                          //   ),),
                          TextfieldDatePicker(
                            cupertinoDatePickerBackgroundColor: Colors.white,
                            cupertinoDatePickerMaximumDate: DateTime(2099),
                            cupertinoDatePickerMaximumYear: 2099,
                            cupertinoDatePickerMinimumYear: 1990,
                            cupertinoDatePickerMinimumDate: DateTime(1990),
                            cupertinoDateInitialDateTime: DateTime.now(),
                            materialDatePickerFirstDate: DateTime(2022),
                            materialDatePickerInitialDate: DateTime.now(),
                            materialDatePickerLastDate: DateTime.now(),
                            preferredDateFormat: DateFormat('dd-MMMM-' 'yyyy'),
                            textfieldDatePickerController: dateController,
                            style: TextStyle(
                              fontSize: 1000 * 0.040,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              //errorText: errorTextValue,
                              helperStyle: TextStyle(
                                  fontSize: 1000 * 0.031,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    color: Colors.white,
                                  )),
                              hintText: 'Select Paid Date',
                              hintStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: commentController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Expense Description',
                              hintText: 'Enter Expense Description',
                            ),
                          ),
                          const SizedBox(height: 15),

                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MaterialButton(
                                // style: TextButton.styleFrom(
                                //   onSurface: Colors.white,
                                //   backgroundColor:Colors.blue,
                                //     minimumSize: const Size.fromHeight(50),
                                //
                                // ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (dateController.text == "") {
                                      dateController.text = actualDate;
                                    }
                                    Map<String, String> revenue = {
                                      'amount': amountController.text,
                                      'margin': marginController.text,
                                      'date': dateController.text,
                                      'comment': commentController.text,
                                      'plan': planController.text
                                    };

                                    updateMonthlyExpenses(
                                        amountController.text,
                                        dateController.text,
                                        planController.text);
                                    reference.push().set(revenue);
                                    cash -= double.parse(amountController.text);
                                    Map<String, String> casset = {
                                      'amount': cash.toStringAsFixed(0),
                                      'description': "Cash In Hand",
                                      'cartegory': "Cash_In_Hand",
                                      'title': "Cash_In_Hand",
                                    };

                                    FirebaseDatabase.instance
                                        .ref()
                                        .child(actualMonthRef +
                                            '/balanceSheet/' +
                                            uid +
                                            "/currentAssets/CID")
                                        .update(casset);
                                    Navigator.pop(context);
                                  }
                                  ;
                                },
                                child: const Text('Save'),
                                color: Colors.blue,
                                textColor: Colors.white,
                                minWidth: 300,
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  style: TextButton.styleFrom(
                                    onSurface: Colors.white,
                                    backgroundColor: Colors.orange,
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close')),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: const Text('Add Daily Expenses'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(50), // NEW
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map revenue = snapshot.value as Map;
                    revenue['key'] = snapshot.key;

                    return listExpenses(revenue: revenue);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 110, // <-- SEE HERE
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

class ISPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ISPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;
  @override
  ISPageState createState() => ISPageState();
}

class ISPageState extends State<ISPage> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 2;
  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;
  double totalRevenue = 0;
  double averageRevenue = 0;
  double percentageRevenue = 0;
  int countRevenue = 0;

  double totalExpense = 0;
  double averageExpense = 0;
  double percentageExpense = 0;
  int countExpense = 0;
  double profit = 0;
  late Query dbRefRevenue;
  late Query dbRefExpense;
  late DatabaseReference reference;
  double cogs = 0, gp = 0, fixedCosts = 0;
  String a = '0',
      a1 = '0',
      a2 = '0',
      a3 = '0',
      a4 = '0',
      a5 = '0',
      a6 = '0',
      a7 = '0',
      a8 = '0',
      a9 = '0',
      a10 = '0',
      a11 = '0',
      a12 = '0';

  String sme = '', currency = '';

  String UserName = "";
  final List<String> incomeStatementHeaders = [
    'Revenue',
    'Less: Cost of Goods Sold',
    'Gross Profit',
    'Less: Total Expenses',
    'Net Income',
  ];

  List<double>? incomeStatementValues;
  generatePdf() async {
    
    final url = 'https://kupfuma.com/advisor/pl.php?uid=' + uid;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bigState() async{

  }

  @override
  void initState() {
    super.initState();
    

    // <-- Their email
    String mail = user?.email ?? 'email';
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });
    FirebaseDatabase.instance
        .ref()
        .child(
            actualMonthRef + '/trackFixedCosts/' + uid + '/' + actualMonthRef)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        fixedCosts += double.parse(revenue['amount']);
        totalExpense += double.parse(revenue['amount']);
      });
    });

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/trackExpensesCartegory/' + uid)
        .onChildAdded
        .listen((event) {
      Map exp = event.snapshot.value as Map;
      if (month == actualMonthRef) {
        setState(() {
          a = exp['Advertising'];
          a1 = exp['Business Vehicle(s) Repairs'];
          a2 = exp['Employee Commissions'];
          a3 = exp['Variable Employee Benefits'];
          a4 = exp['Meals & Entertainment'];
          a5 = exp['Office'];
          a6 = exp['Professional Services'];
          a7 = exp['Phone'];
          a8 = exp['Travel'];
          a9 = exp['Training and Education'];
          a10 = exp['Deliveries'];
          a11 = exp['Loan & Interest Payments'];
          a12 = exp['Other'];
          totalExpense = fixedCosts +
              double.parse(a) +
              double.parse(a1) +
              double.parse(a2) +
              double.parse(a3) +
              double.parse(a4) +
              double.parse(a5) +
              double.parse(a6) +
              double.parse(a7) +
              double.parse(a8) +
              double.parse(a9) +
              double.parse(a10) +
              double.parse(a11) +
              double.parse(a12);

          profit = totalRevenue - totalExpense - cogs;
        });
      }
    });

    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map revenue = event.snapshot.value as Map;
      setState(() {
        countExpense++;

        // totalExpense += double.parse(revenue['amount']);
        averageExpense = totalRevenue / countRevenue;
        percentageExpense = (averageRevenue / totalRevenue) * 100;
      });
    });
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map revenue = event.snapshot.value as Map;
      setState(() {
        countExpense++;
        averageExpense = totalRevenue / countRevenue;
        percentageExpense = (averageRevenue / totalRevenue) * 100;
      });
    });
    dbRefRevenue = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    dbRefRevenue.onChildAdded.listen((event) {
      Map revenue = event.snapshot.value as Map;
      setState(() {
        cogs += (double.parse(revenue['amount']) *
                (100 - double.parse(revenue['margin']))) /
            100;
        totalRevenue += double.parse(revenue['amount']);

        profit = totalRevenue - totalExpense - cogs;
        gp = totalRevenue - cogs;
      });
    });

    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(employeeData: employees);
    incomeStatementValues = [
      totalRevenue,
      cogs,
      gp,
      totalExpense,
      profit,
    ];
  }

  Widget listExpenses({required Map revenue}) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Text(
                  revenue['comment'],
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                Text(
                  revenue['amount'],
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                const Text(''),
              ],
            ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        const Text("Total Revenue"),
                        Text('' + totalRevenue.toString()),
                        const Text(''),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blueGrey,
                    child: Column(
                      children: [
                        const Text(
                          'Total Expenses',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        Text("" + totalExpense.toString()),
                        const Text(''),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        const Text('Net Position'),
                        Text("" + profit.toStringAsFixed(2)),
                        const Text(''),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            color: Colors.blue,
            child: Column(
              children: [
                Text(""),
                Text('$sme: Income Statement - $the_month $the_year'),
                Text(""),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Column(
                children: [
                  const Text(
                    'Revenue',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '    Less: COGS',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '    Gross Profit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(''),
                    const SizedBox(height: 5),
                    const Text(''),
                    const SizedBox(height: 5),
                    const Text(''),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    totalRevenue.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "( " + cogs.toStringAsFixed(2) + " )",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    gp.toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '    Expenses:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          if (a != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Advertising",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a1 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Business Vehicle(s) Repairs",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a1",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a2 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Employee Commissions",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a2",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a3 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Variable Employee Benefits",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a3",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a4 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Meals & Entertainment",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a4",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a5 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Office",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a5",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a6 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Professional Services",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a6",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a7 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a7",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a8 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Travel",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a8",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a9 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Training and Education",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a9",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a10 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Deliveries",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a10",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a11 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Loan & Interest Payments",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a11",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          if (a12 != '0')
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Other",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$a12",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        const Text(''),
                      ],
                    ))
                  ],
                )),
          Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Fixed Costs",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$fixedCosts",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      const Text(''),
                    ],
                  ))
                ],
              )),
          Row(children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '  Total Expenses',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                const Text(''),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                Text(
                  '( ' + totalExpense.toStringAsFixed(2) + ' )',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            )),
          ]),
          Row(children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '  Net Profit / Loss',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(''),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                Text(
                  '' + profit.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
          ]),
          FloatingActionButton(
            child: Icon(Icons.print),
            onPressed: () async {
              await generatePdf();
            },
          ),
          SizedBox(
            height: 85,
          ),

          //Initialize the chart widget
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  List<Employee> getEmployeeData() {
    return [
      Employee('Revenue', '', '0.00'),
      Employee('Less: COGS', '', '0.00'),
      Employee('Gross Profit', '', '0.00'),
      Employee('', '', ''),
      Employee('Expenses', '', ''),
      Employee('Advertising', '0.00', ''),
      Employee('Rent', '0.00', '0.00'),
      Employee('Less:Tax', '', '0.00'),
      Employee('Net Profit or Loss', '', '0.00'),
    ];
  }
}

// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation);

  /// Id of an employee.
  final String id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.designation),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

class BSPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  BSPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;
  @override
  BSPageState createState() => BSPageState();
}

class BSPageState extends State<BSPage> {
  final User? user = Auth().currentUser;
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;
  late DatabaseReference dbRef;

  GlobalKey<FormState> _oFormKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> _oFormKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> _oFormKey3 = GlobalKey<FormState>();

  String sme = '', currency = '';
  String UserName = "";
  //String _initialValue;
  String _valueChangedfixedAssets = '',
      _valueChangedcurrentAssets = '',
      _valueChangedlongTermLiabilities = '',
      _valueChangedcurrentLiabilities = '';
  String _valueToValidatefixedAssets = '',
      _valueToValidatecurrentAssets = '',
      _valueToValidatelongTermLiabilities = '',
      _valueToValidatecurrentLiabilities = '';
  String _valueSavedfixedAssets = '',
      _valueSavedcurrentAssets = '',
      _valueSavedlongTermLiabilities = '',
      _valueSavedcurrentLiabilities = '';
  int _selectedIndexfixedAssets = 3,
      _selectedIndexcurrentAssets = 3,
      _selectedIndexlongTermLiabilities = 3,
      _selectedIndexcurrentLiabilities = 3;
  final List<Map<String, dynamic>> _currentAssets = [
    {
      'value': 'Cash',
      'label': 'Cash',
      'icon': Icon(Icons.money),
    },
    {
      'value': 'Cash equivalents',
      'label': 'Cash equivalents',
      'icon': Icon(Icons.attach_money_sharp),
    },
    {
      'value': 'Short-term deposits',
      'label': 'Short-term deposits',
      'icon': Icon(Icons.comment_bank_rounded),
    },
    {
      'value': 'Accounts receivables',
      'label': 'Accounts receivables',
      'icon': Icon(Icons.account_balance),
    },
    {
      'value': 'Inventory',
      'label': 'Inventory',
      'icon': Icon(Icons.inventory_2_outlined),
    },
    {
      'value': 'Marketable securities',
      'label': 'Marketable securities',
      'icon': Icon(Icons.security),
    },
    {
      'value': 'Office supplies',
      'label': 'Office supplies',
      'icon': Icon(Icons.local_post_office),
    },
    {
      'value': 'Kupfuma Raw Materials',
      'label': 'Kupfuma Raw Materials',
      'icon': Icon(Icons.money),
    },
    {
      'value': 'Kupfuma Stock',
      'label': 'Kupfuma Stock',
      'icon': Icon(Icons.money),
    },
  ];
  final List<Map<String, dynamic>> _longTermLiabilities = [
    {
      'value': 'GetFunds Revenue Funding',
      'label': 'GetFunds Revenue Funding',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Bank loan',
      'label': 'Bank loan',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Bank Overdraft',
      'label': 'Bank Overdraft',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Notes Payable',
      'label': 'Notes Payable',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Bond Payable',
      'label': 'Bond Payable',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Deferred Income Taxes',
      'label': 'Deferred Income Taxes',
      'icon': Icon(Icons.monetization_on_outlined),
    },
  ];
  final List<Map<String, dynamic>> _fixedAssets = [
    {
      'value': 'Land',
      'label': 'Land',
      'icon': Icon(Icons.landscape),
    },
    {
      'value': 'Building',
      'label': 'Building',
      'icon': Icon(Icons.house),
    },
    {
      'value': 'Equipment',
      'label': 'Equipment ie Computer',
      'icon': Icon(Icons.computer),
    },
    {
      'value': 'Patents',
      'label': 'Patents',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Trademarks',
      'label': 'Trademarks',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Investments',
      'label': 'Investments',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Kupfuma Equipment',
      'label': 'Kupfuma Equipment',
      'icon': Icon(Icons.landscape),
    },
  ];
  final List<Map<String, dynamic>> _currentLiabilities = [
    {
      'value': 'Accounts payable',
      'label': 'Accounts payable',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Accrued liabilities',
      'label': 'Accrued liabilities',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Accrued wages',
      'label': 'Accrued wages',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Customer deposits',
      'label': 'Customer deposits',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Current portion of debt payable',
      'label': 'Current portion of debt payable',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Deferred revenue',
      'label': 'Deferred revenue',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Income taxes payable',
      'label': 'Income taxes payable',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Interest payable',
      'label': 'Interest payable',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Payroll taxes payable',
      'label': 'Payroll taxes payable',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Salaries payable',
      'label': 'Salaries payable',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Sales taxes payable',
      'label': 'Sales taxes payable',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Use taxes payable',
      'label': 'Use taxes payable',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Warranty liability',
      'label': 'Warranty liability',
      'icon': Icon(Icons.monetization_on_outlined),
    },
  ];
  final amountFixedAssetController = TextEditingController(),
      titleFixedAssetController = TextEditingController(),
      descFixedAssetController = TextEditingController(),
      cartFixedAssetController = TextEditingController();

  final amountCurrentAssetController = TextEditingController(),
      titleCurrentAssetController = TextEditingController(),
      descCurrentAssetController = TextEditingController(),
      cartCurrentAssetController = TextEditingController();

  final amountLongtermLiabilityController = TextEditingController(),
      titleLongtermLiabilityController = TextEditingController(),
      descLongtermLiabilityController = TextEditingController(),
      cartLongtermLiabilityController = TextEditingController();

  final amountCurrentLiabilityController = TextEditingController(),
      titleCurrentLiabilityController = TextEditingController(),
      descCurrentLiabilityController = TextEditingController(),
      cartCurrentLiabilityController = TextEditingController();
  final marginController = TextEditingController();
  final dateController = TextEditingController();
  final commentController = TextEditingController();
  final planController = TextEditingController();
  double cogs = 0, gp = 0, fixedCosts = 0;
  double profit = 0, equity = 0, tot = 0;
  double totalRevenue = 0;

  double totalExpense = 0;
  void calculateProfit() async {
    

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/net_position/' + uid + '/')
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        profit += double.parse(rev['amount']);
      });
    });
    String a = '0',
        a1 = '0',
        a2 = '0',
        a3 = '0',
        a4 = '0',
        a5 = '0',
        a6 = '0',
        a7 = '0',
        a8 = '0',
        a9 = '0',
        a10 = '0',
        a11 = '0',
        a12 = '0';
    FirebaseDatabase.instance
        .ref()
        .child(
            actualMonthRef + '/trackFixedCosts/' + uid + '/' + actualMonthRef)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        fixedCosts += double.parse(revenue['amount']);
      });
    });
    await Future.delayed(Duration(seconds: 1));
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/trackExpensesCartegory/' + uid)
        .onChildAdded
        .listen((event) {
      Map exp = event.snapshot.value as Map;

      setState(() {
        a = exp['Advertising'];
        a1 = exp['Business Vehicle(s) Repairs'];
        a2 = exp['Employee Commissions'];
        a3 = exp['Variable Employee Benefits'];
        a4 = exp['Meals & Entertainment'];
        a5 = exp['Office'];
        a6 = exp['Professional Services'];
        a7 = exp['Phone'];
        a8 = exp['Travel'];
        a9 = exp['Training and Education'];
        a10 = exp['Deliveries'];
        a11 = exp['Loan & Interest Payments'];
        a12 = exp['Other'];
        totalExpense = fixedCosts +
            double.parse(a) +
            double.parse(a1) +
            double.parse(a2) +
            double.parse(a3) +
            double.parse(a4) +
            double.parse(a5) +
            double.parse(a6) +
            double.parse(a7) +
            double.parse(a8) +
            double.parse(a9) +
            double.parse(a10) +
            double.parse(a11) +
            double.parse(a12);

        profit = totalRevenue - totalExpense - cogs;
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      setState(() {
        cogs += (double.parse(revenue['amount']) *
                (100 - double.parse(revenue['margin']))) /
            100;
        totalRevenue += double.parse(revenue['amount']);
        gp = totalRevenue - cogs;
        profit = totalRevenue - totalExpense - cogs;
      });
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      profit = totalRevenue - totalExpense - cogs;
    });
  }

  Future<void> drawBalanceSheet() async {
    
    calculateProfit();
    await Future.delayed(Duration(seconds: 1));
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/balanceSheet/' + uid + "/fixedAssets")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        fixedAssets += (double.parse(rev['priceController']) -
            double.parse(rev['accDepController']));
        totalAssets = fixedAssets + currentAssets;
        totalLiabilities = longTermLiabilities + currentLiabilities;
        tot = totalAssets - totalLiabilities;
        equity = totalAssets - totalLiabilities - profit;
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/balanceSheet/' + uid + "/currentLiability")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        currentLiabilities += double.parse(rev['amount']);
        totalAssets = fixedAssets + currentAssets;
        totalLiabilities = longTermLiabilities + currentLiabilities;
        tot = totalAssets - totalLiabilities;
        equity = totalAssets - totalLiabilities - profit;
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/balanceSheet/' + uid + "/currentAssets")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        currentAssets += double.parse(rev['amount']);
        totalAssets = fixedAssets + currentAssets;
        totalLiabilities = longTermLiabilities + currentLiabilities;
        tot = totalAssets - totalLiabilities;
        equity = totalAssets - totalLiabilities - profit;
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/balanceSheet/' + uid + "/longtermLiability")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        longTermLiabilities += double.parse(rev['amount']);
        totalAssets = fixedAssets + currentAssets;
        totalLiabilities = longTermLiabilities + currentLiabilities;
        tot = totalAssets - totalLiabilities;
        equity = totalAssets - totalLiabilities - profit;
      });
    });

    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    drawBalanceSheet();
     // <-- Their email
    dbRef = FirebaseDatabase.instance.ref().child('balanceSheet' + '/' + uid);

    String mail = user?.email ?? 'email';
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
          UserName = user['fname'];
        });
      }
    });
    employees = getEmployeeData2();
    employeeDataSource = EmployeeDataSource(employeeData: employees);
  }

  int _selectedIndex = 2;
  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  double fixedAssets = 0,
      currentAssets = 0,
      currentLiabilities = 0,
      longTermLiabilities = 0,
      totalAssets = 0,
      totalLiabilities = 0;

  void getFixedAssetsData() async {
    

    Future<void> _showMyDialog() async {
      GlobalKey<FormState> _oFormKey0 = GlobalKey<FormState>();
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Add Fixed Asset',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _oFormKey0,
                child: ListBody(
                  children: <Widget>[
                    SelectFormField(
                      type: SelectFormFieldType.dialog,
                      controller: cartFixedAssetController,
                      //initialValue: _initialValue,
                      icon: Icon(Icons.format_shapes),
                      labelText: 'Select Category',
                      changeIcon: true,
                      dialogTitle: 'Fixed Asset Category',
                      dialogCancelBtn: 'CANCEL',
                      enableSearch: true,
                      dialogSearchHint: 'Search',
                      items: _fixedAssets,
                      onChanged: (val) =>
                          setState(() => _valueChangedfixedAssets = val),
                      validator: (val) {
                        setState(() => _valueToValidatefixedAssets = val ?? '');
                        return null;
                      },
                      onSaved: (val) =>
                          setState(() => _valueSavedfixedAssets = val ?? ''),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: titleFixedAssetController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        hintText: 'Enter Title',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: descFixedAssetController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        hintText: 'Enter Description',
                      ),
                    ),
                    // const SizedBox(height: 15),
                    // TextField(
                    //   controller: revenueTargetController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'Revenue Target ',
                    //     hintText: 'Enter Revenue Target',
                    //   ),
                    // ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: amountFixedAssetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Value',
                        hintText: 'Enter Value',
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_oFormKey0.currentState!.validate()) {
                    Map<String, String> revenue = {
                      'amount': amountFixedAssetController.text,
                      'description': descFixedAssetController.text,
                      'cartegory': cartFixedAssetController.text,
                      'title': titleFixedAssetController.text
                    };

                    dbRef
                        .child(actualMonthRef + '/fixedAssets')
                        .push()
                        .set(revenue);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }

    _showMyDialog();
  }

  void getCurrentAssetsData() async {
    

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Add Current Asset',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _oFormKey1,
                child: ListBody(
                  children: <Widget>[
                    SelectFormField(
                      type: SelectFormFieldType.dialog,
                      controller: cartCurrentAssetController,
                      //initialValue: _initialValue,
                      icon: Icon(Icons.format_shapes),
                      labelText: 'Select Category',
                      changeIcon: true,
                      dialogTitle: 'Current Asset Category',
                      dialogCancelBtn: 'CANCEL',
                      enableSearch: true,
                      dialogSearchHint: 'Search',
                      items: _currentAssets,
                      onChanged: (val) =>
                          setState(() => _valueChangedcurrentAssets = val),
                      validator: (val) {
                        setState(
                            () => _valueToValidatecurrentAssets = val ?? '');
                        return null;
                      },
                      onSaved: (val) =>
                          setState(() => _valueSavedcurrentAssets = val ?? ''),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: titleCurrentAssetController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        hintText: 'Enter Title',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: descCurrentAssetController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        hintText: 'Enter Description',
                      ),
                    ),
                    // const SizedBox(height: 15),
                    // TextField(
                    //   controller: revenueTargetController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'Revenue Target ',
                    //     hintText: 'Enter Revenue Target',
                    //   ),
                    // ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: amountCurrentAssetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Value',
                        hintText: 'Enter Value',
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_oFormKey1.currentState!.validate()) {
                    Map<String, String> revenue = {
                      'amount': amountCurrentAssetController.text,
                      'description': descCurrentAssetController.text,
                      'cartegory': cartCurrentAssetController.text,
                      'title': titleCurrentAssetController.text
                    };

                    dbRef
                        .child(actualMonthRef + '/currentAssets')
                        .push()
                        .set(revenue);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }

    _showMyDialog();
  }

  void getCurrentLiabilitiesData() async {
    

    Future<void> _showMyDialog() async {
      //  await Future.delayed(Duration(seconds: 2));
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Add Current Liability',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _oFormKey2,
                child: ListBody(
                  children: <Widget>[
                    SelectFormField(
                      type: SelectFormFieldType.dialog,
                      controller: cartCurrentLiabilityController,
                      //initialValue: _initialValue,
                      icon: Icon(Icons.format_shapes),
                      labelText: 'Select Category',
                      changeIcon: true,
                      dialogTitle: 'Current Liability Category',
                      dialogCancelBtn: 'CANCEL',
                      enableSearch: true,
                      dialogSearchHint: 'Search',
                      items: _currentLiabilities,
                      onChanged: (val) =>
                          setState(() => _valueChangedcurrentLiabilities = val),
                      validator: (val) {
                        setState(() =>
                            _valueToValidatecurrentLiabilities = val ?? '');
                        return null;
                      },
                      onSaved: (val) => setState(
                          () => _valueSavedcurrentLiabilities = val ?? ''),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: titleCurrentLiabilityController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        hintText: 'Enter Title',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: descCurrentLiabilityController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        hintText: 'Enter Description',
                      ),
                    ),
                    // const SizedBox(height: 15),
                    // TextField(
                    //   controller: revenueTargetController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'Revenue Target ',
                    //     hintText: 'Enter Revenue Target',
                    //   ),
                    // ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: amountCurrentLiabilityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Value',
                        hintText: 'Enter Value',
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_oFormKey2.currentState!.validate()) {
                    Map<String, String> revenue = {
                      'amount': amountCurrentLiabilityController.text,
                      'description': descCurrentLiabilityController.text,
                      'cartegory': cartCurrentLiabilityController.text,
                      'title': titleCurrentLiabilityController.text
                    };

                    dbRef
                        .child(actualMonthRef + '/currentLiability')
                        .push()
                        .set(revenue);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }

    _showMyDialog();
  }

  void getLongtermLiabilitiesData() async {
    

    Future<void> _showMyDialog() async {
      // await Future.delayed(Duration(seconds: 2));
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Add Longterm Liability',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _oFormKey3,
                child: ListBody(
                  children: <Widget>[
                    SelectFormField(
                      type: SelectFormFieldType.dialog,
                      controller: cartLongtermLiabilityController,
                      //initialValue: _initialValue,
                      icon: Icon(Icons.format_shapes),
                      labelText: 'Select Category',
                      changeIcon: true,
                      dialogTitle: 'Longterm Liability Category',
                      dialogCancelBtn: 'CANCEL',
                      enableSearch: true,
                      dialogSearchHint: 'Search',
                      items: _longTermLiabilities,
                      onChanged: (val) => setState(
                          () => _valueChangedlongTermLiabilities = val),
                      validator: (val) {
                        setState(() =>
                            _valueToValidatelongTermLiabilities = val ?? '');
                        return null;
                      },
                      onSaved: (val) => setState(
                          () => _valueSavedlongTermLiabilities = val ?? ''),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: titleLongtermLiabilityController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        hintText: 'Enter Title',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: descLongtermLiabilityController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        hintText: 'Enter Description',
                      ),
                    ),
                    // const SizedBox(height: 15),
                    // TextField(
                    //   controller: revenueTargetController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'Revenue Target ',
                    //     hintText: 'Enter Revenue Target',
                    //   ),
                    // ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: amountLongtermLiabilityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Value',
                        hintText: 'Enter Value',
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_oFormKey3.currentState!.validate()) {
                    Map<String, String> revenue = {
                      'amount': amountLongtermLiabilityController.text,
                      'description': descLongtermLiabilityController.text,
                      'cartegory': cartLongtermLiabilityController.text,
                      'title': titleLongtermLiabilityController.text
                    };

                    dbRef
                        .child(actualMonthRef + '/longtermLiability')
                        .push()
                        .set(revenue);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }

    _showMyDialog();
  }

  Widget balanceSheetRow(desc, desc2, value3, font1, font2, bcl) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.white), color: bcl),
      child: Row(
        children: [
          Expanded(
              child: Text(desc,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: font1,
                  ))),
          Text(desc2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              )),
          Expanded(
            child: Text(value3,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: font2,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        const Text('\nTotal Assets'),
                        Text("$totalAssets"),
                        const Text('\n  '),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blueGrey,
                    child: Column(
                      children: [
                        const Text('\nTotal Liabilities'),
                        Text("$totalLiabilities"),
                        const Text('\n  '),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        const Text('\n Equity'),
                        Text("" + equity.toStringAsFixed(2)),
                        const Text('\n '),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        onSurface: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AssetsPage()),
                        );
                        // getFixedAssetsData(); // Navigate back to first route when tapped.
                      },
                      child: const Text(
                        '\n+\n\nFixed Asset\n',
                        textAlign: TextAlign.center,
                      )),
                ),
                Expanded(
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        onSurface: Colors.white,
                        backgroundColor: Colors.lightBlue,
                      ),
                      onPressed: () {
                        getCurrentAssetsData(); // Navigate back to first route when tapped.
                      },
                      child: const Text(
                        '\n+\n\nCurrent Asset\n',
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        onSurface: Colors.white,
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        getLongtermLiabilitiesData(); // Navigate back to first route when tapped.
                      },
                      child: const Text(
                        '\n+\n\nLong Term Liability\n',
                        textAlign: TextAlign.center,
                      )),
                ),
                Expanded(
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        onSurface: Colors.white,
                        backgroundColor: Colors.orangeAccent,
                      ),
                      onPressed: () {
                        getCurrentLiabilitiesData(); // Navigate back to first route when tapped.
                      },
                      child: const Text(
                        '\n+\n\nCurrent Liability\n',
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            color: Colors.blue,
            child: Column(
              children: [
                Text(""),
                Text('$sme: Balance Sheet - $the_month $the_year'),
                Text(""),
              ],
            ),
          ),
          const SizedBox(height: 10),
          //balancesheet rows start
          balanceSheetRow(
              "Assets", "", "", FontWeight.bold, FontWeight.bold, Colors.grey),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssetsRoute(
                      ky: "1",
                      comment: "Fixed Assets",
                    ),
                  ));
              // Add what you want to do on tap
            },
            child: balanceSheetRow(
                "Fixed Assets",
                "",
                fixedAssets.toStringAsFixed(2),
                FontWeight.normal,
                FontWeight.normal,
                Colors.lightBlueAccent),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssetsRoute(
                      ky: "2",
                      comment: "Current Assets",
                    ),
                  ));
              // Add what you want to do on tap
            },
            child: balanceSheetRow(
                "Current Assets",
                "",
                currentAssets.toStringAsFixed(2),
                FontWeight.normal,
                FontWeight.normal,
                Colors.grey),
          ),
          balanceSheetRow("Total Assets", "", totalAssets.toStringAsFixed(2),
              FontWeight.bold, FontWeight.bold, Colors.lightBlueAccent),
          balanceSheetRow(
              "", "", "", FontWeight.normal, FontWeight.normal, Colors.grey),
          balanceSheetRow("Liabilities", "", "", FontWeight.bold,
              FontWeight.bold, Colors.lightBlueAccent),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssetsRoute(
                      ky: "3",
                      comment: "Current Liabilities",
                    ),
                  ));
              // Add what you want to do on tap
            },
            child: balanceSheetRow(
                "Current Liabilities",
                "",
                currentLiabilities.toStringAsFixed(2),
                FontWeight.normal,
                FontWeight.normal,
                Colors.grey),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssetsRoute(
                      ky: "4",
                      comment: "Long Term Liabilities",
                    ),
                  ));
              // Add what you want to do on tap
            },
            child: balanceSheetRow(
                "Long Term Liabilities",
                "",
                longTermLiabilities.toStringAsFixed(2),
                FontWeight.normal,
                FontWeight.normal,
                Colors.lightBlueAccent),
          ),
          balanceSheetRow(
              "Total Liabilities",
              "",
              totalLiabilities.toStringAsFixed(2),
              FontWeight.bold,
              FontWeight.bold,
              Colors.grey),
          balanceSheetRow("", "", "", FontWeight.normal, FontWeight.normal,
              Colors.lightBlueAccent),
          balanceSheetRow("Owners Equity", "", "", FontWeight.bold,
              FontWeight.normal, Colors.grey),
          balanceSheetRow("Contributed Capital", "", equity.toStringAsFixed(2),
              FontWeight.normal, FontWeight.normal, Colors.lightBlueAccent),
          balanceSheetRow(
              "Retained Profits - YTD",
              "",
              profit.toStringAsFixed(2),
              FontWeight.normal,
              FontWeight.normal,
              Colors.grey),
          //balanceSheetRow("Retained Profits - MTD","","0.00",FontWeight.normal,FontWeight.normal,Colors.lightBlueAccent),
          balanceSheetRow("Shareholder Equity", "", tot.toStringAsFixed(2),
              FontWeight.bold, FontWeight.bold, Colors.grey),
          balanceSheetRow("", "", "", FontWeight.normal, FontWeight.normal,
              Colors.lightBlueAccent),

          ///balncesheet rows end

          // Container(
          //     child: SfDataGrid(
          //       source: employeeDataSource,
          //       columnWidthMode: ColumnWidthMode.fill,
          //       columns: <GridColumn>[
          //         GridColumn(
          //             columnName: 'id',
          //             label: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   '',
          //                 )
          //               ],
          //             )),
          //         GridColumn(
          //             columnName: 'name',
          //             label: Container(
          //                 padding: EdgeInsets.all(8.0),
          //                 alignment: Alignment.center,
          //                 child: Text(''))),
          //         GridColumn(
          //             columnName: 'designation',
          //             label: Container(
          //                 padding: EdgeInsets.all(8.0),
          //                 alignment: Alignment.center,
          //                 child: Text(
          //                   '',
          //                   overflow: TextOverflow.ellipsis,
          //                 ))),
          //       ],
          //     ),
          //   ),

          //Initialize the chart widget
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  List<Employee> getEmployeeData2() {
    return [
      Employee('Assets', '', ''),
      Employee('Fixed Assets', '', '0.00'),
      Employee('Current Assets', '', '0.00'),
      Employee('', '', ''),
      Employee('Liabilities', '', ''),
      Employee('Current Liabilities', '', '0.00'),
      Employee('Long Term Liabilities', '', '0.00'),
      Employee('', '', ''),
      Employee('Owners Equity', '', '0.00'),
      Employee('Total Liabilities and Equity', '', '0.00'),
    ];
  }
}

class CFPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CFPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;
  @override
  CFPageState createState() => CFPageState();
}

class CFPageState extends State<CFPage> {
  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: null,
      body: FooterView(
          children: [
            //Initialize the chart widget
          ],
          footer: Footer(
            //this takes the Footer Component which has 4 arguments with one being mandatory ie the child
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Icon(Icons.home)),
                      const Text('Home')
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RevenuePage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Icon(Icons.wallet)),
                      const Text('Revenue')
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  alignment: Alignment.bottomCenter,
                                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  onSurface: Colors.white,
                                                  backgroundColor: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ISPage()),
                                                  ); // Navigate back to first route when tapped.
                                                },
                                                child: const Text(
                                                    'Income Statement')),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  onSurface: Colors.white,
                                                  backgroundColor: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BSPage()),
                                                  ); // Navigate back to first route when tapped.
                                                },
                                                child: const Text(
                                                    'Balance Sheet')),
                                          ],
                                        ),
                                        // Column(
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     ElevatedButton(
                                        //         style: TextButton.styleFrom(
                                        //           onSurface: Colors.white,
                                        //           backgroundColor:Colors.blue,
                                        //
                                        //         ),
                                        //         onPressed:() {
                                        //           Navigator.push(
                                        //             context,
                                        //             MaterialPageRoute(builder: (context) => CFPage()),
                                        //           );// Navigate back to first route when tapped.
                                        //         }, child:const Text('Cash Flow')),
                                        //   ],
                                        // ),
                                        const SizedBox(height: 15),
                                        // TextButton(
                                        // onPressed: () {
                                        // Navigator.pop(context);
                                        // },
                                        // child: const Text('Close'),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          child: const Icon(Icons.add_circle)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExpensesPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Icon(Icons.pie_chart)),
                      const Text('Expenses')
                    ],
                  ),
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FundingPage()),
                          ); // Navigate back to first route when tapped.
                        },
                        child: const Icon(Icons.attach_money_sharp)),
                    const Text('Funding')
                  ],
                ),
              ],
            ), //See Description Below for the other arguments of the Footer Component
          ),
          flex: 8),
    );
  }
}

class AdvisoryPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AdvisoryPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  AdvisoryPageState createState() => AdvisoryPageState();
}

class AdvisoryPageState extends State<AdvisoryPage> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 2;
  String? selectedValue;
  String _valueChanged = '', _valueChanged0 = '';
  String _valueToValidate = '', _valueToValidate0 = '';
  String _valueSaved = '', _valueSaved0 = '';
  TextEditingController areaController = new TextEditingController();
  TextEditingController agendaController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  TextEditingController attendingController = new TextEditingController();

  final List<Map<String, dynamic>> _items = [
    {
      'value': "Strategy",
      'label': "Strategy",
      'icon': null,
    },
    {
      'value': "Sales and Marketing",
      'label': "Sales and Marketing",
      'icon': null,
    },
    {
      'value': "Finance",
      'label': "Finance",
      'icon': null,
    },
    {
      'value': "Human Resources",
      'label': "Human Resources",
      'icon': null,
    },
    {
      'value': "Operations",
      'label': "Operations",
      'icon': null,
    },
    {
      'value': "Information Technology",
      'label': "Information Technology",
      'icon': null,
    },
    {
      'value': "Legal",
      'label': "Legal",
      'icon': null,
    },
    {
      'value': "Research and Development",
      'label': "Research and Development",
      'icon': null,
    },
  ];

  late DatabaseReference advisory_reference;
  Future<void> _showMyDialog() async {
    
    advisory_reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/advisory/' + uid);
    //await Future.delayed(Duration(seconds: 2));
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Talk To My Advisor',
            textAlign: TextAlign.center,
            style: TextStyle(
              backgroundColor: Colors.white,
              color: Colors.blue,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SelectFormField(
                  type: SelectFormFieldType.dialog,
                  controller: areaController,
                  //initialValue: _initialValue,
                  icon: null,
                  labelText: "Select key area you need help",
                  changeIcon: true,
                  dialogTitle: '',
                  dialogCancelBtn: 'Close',
                  enableSearch: false,
                  dialogSearchHint: 'Search',
                  items: _items,
                  onChanged: (val) => setState(() => _valueChanged = val),
                  validator: (val) {
                    setState(() {
                      _valueToValidate = val ?? '';
                      month = val ?? '';
                      the_month = val ?? '';
                    });
                    return null;
                  },
                  onSaved: (val) => setState(() => _valueSaved = val ?? ''),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: agendaController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'What is the Agenda',
                    hintText: 'What is the Agenda',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: descController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Briefly describe the Agenda.. ',
                    hintText: 'Agenda Description',
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Submit & Connect'),
              onPressed: () {
                Map<String, String> revenue = {
                  'attending': attendingController.text,
                  'description': descController.text,
                  'agenda': agendaController.text,
                  'area': areaController.text
                };

                advisory_reference.push().set(revenue);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
                style: TextButton.styleFrom(
                  onSurface: Colors.white,
                  backgroundColor: Colors.orange,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close')),
          ],
        );
      },
    );
  }

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  List<_SalesData> data = [];
  List<_SalesData> data2 = [];

  double totalRevenue = 0;
  double averageRevenue = 0;
  double percentageRevenue = 0;
  int countRevenue = 0;
  double budget = 0, dailyRev = 0;

  final amountController = TextEditingController();
  final marginController = TextEditingController();
  final dateController = TextEditingController();
  final commentController = TextEditingController();
  final planController = TextEditingController();
  final Color unselectedItemColor = Colors.blue;
  late Query dbRef;
  late DatabaseReference reference, reference1;
  String currentValue = '0';
  String sme = '', currency = '';

  getDateValue(date) {
    
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      currentValue = rev['amount'];
    });
  }

  Future<void> morningMessage() async {
    
    double budget = 0;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        budget = double.parse(revenue['revenueBudget']) / 30;
      });
    });
    await Future.delayed(Duration(seconds: 1));
    DatabaseReference dbRefe = FirebaseDatabase.instance.ref().child(
        'trackMorningMessage/' + uid + '/' + actualMonthRef + '/' + actualDate);
    DataSnapshot snapshot = await dbRefe.get();

    if (snapshot.value == null) {
      Map<String, String> cartegories = {
        'Advertising': '0',
      };

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Rise and shine.'),
          content: Text(
              'New day! New opportunities! Your revenue target for today is ' +
                  budget.toStringAsFixed(2)),
          actions: <Widget>[
            // TextButton(
            //   onPressed: () =>{ Navigator.pop(context, 'No')},
            //   child: const Text('No'),
            // ),
            TextButton(
              onPressed: () => {
                dbRefe.set(cartegories),
                Navigator.pop(context, 'No'),
              },
              child: const Text('Noted. Thank You.'),
            ),
          ],
        ),
      );
    } else {}

    Timer mytimer = Timer.periodic(Duration(seconds: 1800), (timer) {
      if (snapshot.value == null) {
        Map<String, String> cartegories = {
          'Advertising': '0',
        };

        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Rise and shine.'),
            content: Text(
                'New day! New opportunities! Your revenue target for today is ' +
                    budget.toStringAsFixed(2)),
            actions: <Widget>[
              // TextButton(
              //   onPressed: () =>{ Navigator.pop(context, 'No')},
              //   child: const Text('No'),
              // ),
              TextButton(
                onPressed: () => {
                  dbRefe.set(cartegories),
                  Navigator.pop(context, 'No'),
                },
                child: const Text('Noted. Thank You.'),
              ),
            ],
          ),
        );
      } else {}
    });
  }

  @override
  void initState() {
    super.initState();

     // <-- Their email
    String mail = user?.email ?? 'email';

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        budget = double.parse(revenue['revenueBudget']);
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .orderByChild('date')
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        if (rev['date'] == actualDate) {
          dailyRev += double.parse(rev['amount']);
        }

        data2.add(_SalesData(
            rev['date'].substring(0, 2), double.parse(rev['amount'])));
        data.add(_SalesData(rev['date'].substring(0, 2), budget));
      });
    });

    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });
    Map? revenueTrack;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      revenueTrack = event.snapshot.value as Map;
    });

    String getDate = "";
    double dateAmount = 0.0;

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue/' + uid)
        .orderByChild("date")
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      countRevenue++;

      setState(() {
        totalRevenue += double.parse(revenue['amount']);
        averageRevenue = totalRevenue / countRevenue;
        percentageRevenue = (averageRevenue / totalRevenue) * 100;

        if (getDate == revenue['date'].substring(0, 2)) {
          getDate = "";
          dateAmount += double.parse(revenue['amount']);
        } else {
          getDate = revenue['date'].substring(0, 2);
          dateAmount += double.parse(revenue['amount']);
        }
      });
      if (getDate != "") {
        // data2.add(_SalesData(getDate, dateAmount));
        // data.add(_SalesData(getDate, budget));
        dateAmount = 0;
      }
    });
    dbRef = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);

    reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    reference1 = FirebaseDatabase.instance.ref().child(
        actualMonthRef + '/trackRevenue/' + uid + '/' + actualMonthRef + "/");
  }

  Widget listRevenue({required Map revenue}) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondRoute(
                    ky: revenue['key'],
                    amount: revenue['amount'],
                    plan: revenue['plan'],
                    comment: revenue['comment'],
                    margin: revenue['margin'],
                    date: revenue['date'])),
          );
          // Add what you want to do on tap
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  revenue['date'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Daily Sales',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  revenue['comment'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ]),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '' + revenue['amount'],
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                    ]),
              ),
            ])));

    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          //Initialize the chart widget
          Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  //border: Border.all(width: 2.0, color: insightColor2),
                  ),
              child: Text(
                "Sometimes it’s exhausting growing your small business to become a big business of tomorrow, you need to bounce of key strategic with sharp minds, our pool of small business experts will be there for you to bounce off ideas through our 360° Advisory.\n\n Simply Talk To My Advisor, to get an independent opinion on a strategic action plan for your business, we will assign our best advisor with deep expertise in the area to assist you.",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                      onSurface: Colors.black,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      // _showMyDialog(); // Navigate back to first route when tapped.

                      final phone =
                          '00447826819272'; // Replace with the phone number you want to send a message to
                      final message =
                          'Hello, Advisor'; // Replace with the message you want to send

                      final url =
                          'https://wa.me/$phone?text=${Uri.encodeFull(message)}';

                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Row(children: [
                      Icon(Icons.arrow_circle_right_outlined),
                      Text('Talk To My Advisor')
                    ])),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      onSurface: Colors.black,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyadvisorPage())); // Navigate back to first route when tapped.
                    },
                    child: Row(children: [
                      Icon(Icons.arrow_circle_right_outlined),
                      Text(
                        'My Advisor Profile',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ])),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 8.0, color: Colors.blue),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'My Meetings\n\n\nAgenda',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '\n\n\nDate',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '\n\n\n   Documents',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 8.0, color: Colors.blue),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'My Documents\n\n\nName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '\n\n\Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '\n\n\n   Feedback',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/model.png',
            width: 230,
            height: 430,
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AssetsRoute extends StatefulWidget {
  AssetsRoute({super.key, required this.ky, required this.comment});

  final String comment;

  final String ky;
  final User? user = Auth().currentUser;
  @override
  //SecondRouteState createState() => SecondRouteState();
  State<AssetsRoute> createState() => AssetsRouteState();
}

class AssetsRouteState extends State<AssetsRoute> {
  int _selectedIndex = 2;

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  final User? user = Auth().currentUser;
  
  late DatabaseReference reference, dbRef;
  void initState() {
    String key = widget.ky;
    
    setState(() {
      if (key == "1") {
        dbRef = FirebaseDatabase.instance
            .ref()
            .child('balanceSheet' + '/' + uid + '/fixedAssets');
      }
      if (key == "2") {
        dbRef = FirebaseDatabase.instance
            .ref()
            .child('balanceSheet' + '/' + uid + '/currentAssets');
      }
      if (key == "3") {
        dbRef = FirebaseDatabase.instance
            .ref()
            .child('balanceSheet' + '/' + uid + '/currentLiability');
      }
      if (key == "4") {
        dbRef = FirebaseDatabase.instance.ref().child(actualMonthRef +
            '/balanceSheet' +
            '/' +
            uid +
            '/longtermLiability');
      }
    });
  }

  Widget listRevenue({required Map revenue}) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  revenue['cartegory'] +
                      " - " +
                      revenue['title'] +
                      "\n" +
                      revenue['description'],
                ),
              ],
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "" + revenue['amount'],
                ),
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.comment),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map revenue = snapshot.value as Map;
                    revenue['key'] = snapshot.key;

                    return listRevenue(revenue: revenue);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}


class FixedCostsPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  FixedCostsPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;
  @override
  FixedCostsPageState createState() => FixedCostsPageState();
}

class FixedCostsPageState extends State<FixedCostsPage> {
  final User? user = Auth().currentUser;
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController? _controller;

  //String _initialValue;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  int _selectedIndex = 3;
  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Fixed Employee Benefits',
      'label': 'Fixed Employee Benefits',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Internet',
      'label': 'Internet',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Electricity',
      'label': 'Electricity',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Water',
      'label': 'Water',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Software subscriptions',
      'label': 'Software subscriptions',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Entertainment Subscriptions',
      'label': 'Entertainment Subscriptions',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Business Insurance',
      'label': 'Business Insurance',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Depreciation',
      'label': 'Depreciation',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Rentals',
      'label': 'Rentals',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Base Salaries',
      'label': 'Base Salaries',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Other',
      'label': 'Other',
      'icon': Icon(Icons.monetization_on_outlined),
    },
  ];
  List<_SalesData> data = [];
  List<String> strings = [];

  List<_SalesData> data2 = [];
  late Query dbRef;
  late DatabaseReference reference;
  final amountController = TextEditingController();
  final marginController = TextEditingController();
  final dateController = TextEditingController();
  final commentController = TextEditingController();
  final planController = TextEditingController();
  double totalExpenses = 0;
  double averageExpenses = 0;
  double percentageExpenses = 0;
  double fixedCosts = 0, dailyExp = 0, cash = 0;
  int countExpenses = 0;
  String sme = '', currency = '';

  Future<void> updateMonthlyExpenses(amount, date, cart) async {
    double currentValue = 0, newValue = 0, cartValue = 0, cartNewValue = 0;
    
    String? cartKey;
    DatabaseReference refe;

    DatabaseReference np_refe;
    double net_position = 0;
    np_refe = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/net_position/' + uid + '/' + actualMonthRef);
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/net_position/' + uid + '/')
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        if (rev['month'] == actualMonthRef) {
          net_position = double.parse(rev['amount']);
        }
      });
    });

    refe = FirebaseDatabase.instance.ref().child(actualMonthRef +
        '/trackFixedCosts/' +
        uid +
        '/' +
        actualMonthRef +
        "/" +
        date);
    DatabaseReference dbRefe = FirebaseDatabase.instance.ref().child(
        actualMonthRef +
            '/trackFixedCostsCartegory/' +
            uid +
            '/' +
            actualMonthRef);
    DataSnapshot snapshot = await dbRefe.get();
    if (snapshot.value == null) {
      Map<String, String> cartegories = {
        'Rent': '0',
        'Wages & Salaries': '0',
        'Other': '0',
        'month': actualMonthRef,
      };

      dbRefe.set(cartegories);
    }
    await Future.delayed(Duration(seconds: 1));
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/trackFixedCostsCartegory/' + uid)
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        cartValue = double.parse(rev[cart]);
      });
    });

    await Future.delayed(Duration(seconds: 1));
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackFixedCosts/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        if (rev['date'] == date) {
          currentValue = double.parse(rev['amount']);

          // rev['key'] = event.snapshot.key;
        }
      });
    });

    await Future.delayed(Duration(seconds: 1));
    newValue = currentValue + double.parse(amount);
    cartNewValue = cartValue + double.parse(amount);
    net_position -= double.parse(amount);
    Map<String, String> trackNP = {
      'amount': net_position.toString(),
      'month': actualMonthRef,
    };
    np_refe.set(trackNP);

    Map<String, String> trackExpenses = {
      'amount': newValue.toString(),
      'date': date,
      "cogs": "0",
      cart: cartNewValue.toString(),
    };

    refe.update(trackExpenses);
    Map<String, String> trackCart = {
      "cogs": "0",
      cart: cartNewValue.toString(),
      'month': actualMonthRef,
    };

    dbRefe.update(trackCart);
  }

  
  @override
  void initState() {
    super.initState();
    
    String mail = user?.email ?? 'email';
    int k = 0;
    double temp = 0;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/balanceSheet/' + uid + "/currentAssets")
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      if (revenue['cartegory'] == "Cash_In_Hand") {
        setState(() {
          cash += double.parse(revenue['amount']);
        });
      }
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        fixedCosts = double.parse(revenue['fixedCosts']);
        temp = double.parse(revenue['fixedCosts']) / 30;
        for (int i = 0; i < 31; i++) {
          if (i < 10) {
            data.add(_SalesData(
                "0" + i.toString(), double.parse(temp.toStringAsFixed(0))));
          } else {
            data.add(_SalesData(
                i.toString(), double.parse(temp.toStringAsFixed(0))));
          }
        }
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackFixedCosts/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .orderByChild('date')
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        if (rev['date'] == actualDate) {
          dailyExp += double.parse(rev['amount']) + double.parse(rev['cogs']);
        }

        if (k < 1) {
          k++;
          for (int i = 0; i < int.parse(rev['date'].substring(0, 2)); i++) {
            if (i < 10) {
              data2.add(_SalesData("0" + i.toString(), 0));
            } else {
              data2.add(_SalesData(i.toString(), 0));
            }
          }
        }
        data2.add(_SalesData(rev['date'].substring(0, 2),
            double.parse(rev['amount']) + double.parse(rev['cogs'])));
        // data.add(_SalesData(rev['date'].substring(0, 2), fixedCosts/30));
      });
    });
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/FixedCosts/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      countExpenses++;
      setState(() {
        totalExpenses += double.parse(revenue['amount']);
        averageExpenses = totalExpenses / countExpenses;
        percentageExpenses = (averageExpenses / totalExpenses) * 100;
      });
    });
    strings.add("Nepal");
    // <-- Their email

    dbRef = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/FixedCosts' + '/' + uid);
    reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/FixedCosts' + '/' + uid);
    _controller = TextEditingController(text: '2');

    _getValue();
  }

  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        //_initialValue = 'circleValue';
        _controller?.text = 'circleValue';
      });
    });
  }

  Widget listExpenses({required Map revenue}) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ThirdRoute(
                    ky: revenue['key'],
                    amount: revenue['amount'],
                    plan: revenue['plan'],
                    comment: revenue['comment'],
                    margin: revenue['margin'],
                    date: revenue['date'])),
          );
          // Add what you want to do on tap
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  revenue['date'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  revenue['plan'],
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  revenue['comment'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ]),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '' + revenue['amount'],
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                    ]),
              ),
            ])));

    return Text('');
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          //Initialize the chart widget
          Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExpensesPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red, // Background Color
                        ),
                        child: const Text(
                          'Variable Costs',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FixedCostsPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white, // Background Color
                        ),
                        child: const Text(
                          'Fixed Costs',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ]),
                  ),
                ],
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  // border: Border.all(width: 2.0, color: insightColor2),
                  ),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  palette: <Color>[Colors.red, Colors.blue],
                  // Chart title
                  title: ChartTitle(
                      text: 'Month Fixed Costs - $the_month $the_year'),
                  // Enable legend
                  legend: Legend(isVisible: false),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_SalesData, String>>[
                    LineSeries<_SalesData, String>(
                        dataSource: data2,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: 'Fixed Costs',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: false)),
                    LineSeries<_SalesData, String>(
                        dataSource: data,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: 'Budget',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: false))
                  ]),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Fixed Costs'),
                Icon(Icons.square, color: Colors.red),
                Text('Budget'),
                Icon(Icons.square, color: Colors.blue),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        Text("" + dailyExp.toStringAsFixed(0)),
                        const Text(''),
                        const Text('Daily FCosts'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blueGrey,
                    child: Column(
                      children: [
                        const Text('Average'),
                        Text("" + percentageExpenses.toStringAsFixed(0)),
                        const Text('Daily FCosts'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        const Text('MTD'),
                        Text("" + totalExpenses.toStringAsFixed(0)),
                        const Text('FCosts'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if(role=="Owner" || role=="Accounts/ Admin")
          ElevatedButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Daily Fixed Costs',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          SelectFormField(
                            type: SelectFormFieldType.dialog,
                            controller: planController,
                            //initialValue: _initialValue,
                            icon: Icon(Icons.format_shapes),
                            labelText: 'Category',
                            changeIcon: true,
                            dialogTitle: 'Fixed Cost Category',
                            dialogCancelBtn: 'CANCEL',
                            enableSearch: true,
                            dialogSearchHint: 'Search',
                            items: _items,
                            onChanged: (val) =>
                                setState(() => _valueChanged = val),
                            validator: (val) {
                              setState(() => _valueToValidate = val ?? '');
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _valueSaved = val ?? ''),
                          ),

                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Amount ',
                              hintText: 'Enter Amount',
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: marginController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Fixed Cost Title',
                              hintText: 'Enter Fixed Cost Title',
                            ),
                          ),
                          const SizedBox(height: 15),
                          // TextField(
                          //   controller: dateController,
                          //   keyboardType: TextInputType.datetime,
                          //   decoration: const InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     labelText: 'Date Paid dd-mm-yyyy',
                          //     hintText: 'Select Date Paid dd-mm-yyyy',
                          //   ),),
                          TextfieldDatePicker(
                            cupertinoDatePickerBackgroundColor: Colors.white,
                            cupertinoDatePickerMaximumDate: DateTime(2099),
                            cupertinoDatePickerMaximumYear: 2099,
                            cupertinoDatePickerMinimumYear: 1990,
                            cupertinoDatePickerMinimumDate: DateTime(1990),
                            cupertinoDateInitialDateTime: DateTime.now(),
                            materialDatePickerFirstDate: DateTime(2022),
                            materialDatePickerInitialDate: DateTime.now(),
                            materialDatePickerLastDate: DateTime.now(),
                            preferredDateFormat: DateFormat('dd-MMMM-' 'yyyy'),
                            textfieldDatePickerController: dateController,
                            style: TextStyle(
                              fontSize: 1000 * 0.040,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              //errorText: errorTextValue,
                              helperStyle: TextStyle(
                                  fontSize: 1000 * 0.031,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    color: Colors.white,
                                  )),
                              hintText: 'Select Paid Date',
                              hintStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: commentController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Fixed Cost Description',
                              hintText: 'Enter Fixed Cost Description',
                            ),
                          ),
                          const SizedBox(height: 15),

                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MaterialButton(
                                // style: TextButton.styleFrom(
                                //   onSurface: Colors.white,
                                //   backgroundColor:Colors.blue,
                                //     minimumSize: const Size.fromHeight(50),
                                //
                                // ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (dateController.text == "") {
                                      dateController.text = actualDate;
                                    }
                                    Map<String, String> revenue = {
                                      'amount': amountController.text,
                                      'margin': marginController.text,
                                      'date': dateController.text,
                                      'comment': commentController.text,
                                      'plan': planController.text
                                    };

                                    updateMonthlyExpenses(
                                        amountController.text,
                                        dateController.text,
                                        planController.text);
                                    reference.push().set(revenue);
                                    cash -= double.parse(amountController.text);
                                    Map<String, String> casset = {
                                      'amount': cash.toStringAsFixed(0),
                                      'description': "Cash In Hand",
                                      'cartegory': "Cash_In_Hand",
                                      'title': "Cash_In_Hand",
                                    };

                                    FirebaseDatabase.instance
                                        .ref()
                                        .child(actualMonthRef +
                                            '/balanceSheet/' +
                                            uid +
                                            "/currentAssets/CID")
                                        .update(casset);

                                    Navigator.pop(context);
                                  }
                                  ;
                                },
                                child: const Text('Save'),
                                color: Colors.blue,
                                textColor: Colors.white,
                                minWidth: 300,
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  style: TextButton.styleFrom(
                                    onSurface: Colors.white,
                                    backgroundColor: Colors.orange,
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close')),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: const Text('Add Fixed Cost'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(50), // NEW
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map revenue = snapshot.value as Map;
                    revenue['key'] = snapshot.key;

                    return listExpenses(revenue: revenue);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 110, // <-- SEE HERE
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
class ValuationPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ValuationPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  ValuationPageState createState() => ValuationPageState();
}

class ValuationPageState extends State<ValuationPage> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 2;
  TextEditingController areaController = new TextEditingController();
  TextEditingController agendaController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  TextEditingController attendingController = new TextEditingController();
  TextEditingController dateController2 = new TextEditingController();

  TextEditingController amortisationController = new TextEditingController();

  TextEditingController ebitaController = new TextEditingController();
  TextEditingController depreciationController = new TextEditingController();
  TextEditingController interestPaidController = new TextEditingController();
  TextEditingController interestReceivedController =
      new TextEditingController();
  TextEditingController taxController = new TextEditingController();
  TextEditingController profitController = new TextEditingController();
  double calcEbita = 0;
  String valuation = "NO VALUATION";

  Widget listExpenses({required Map revenue}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              revenue['amount'] ?? "0",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              revenue['date'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              revenue['status'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    return Text('');
  }

  late DatabaseReference advisory_reference;
  String _valueChanged3 = '';
  String _valueToValidate3 = '';
  String _valueSaved3 = '';
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';
  final List<Map<String, dynamic>> _ebitaItems = [];
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Yes',
      'label': 'Yes',
      'icon': Icon(Icons.check),
    },
    {
      'value': 'No',
      'label': 'No',
      'icon': Icon(Icons.info),
    }
  ];
  final List<Map<String, dynamic>> _items2 = [
    {
      'value': 'Sell',
      'label': 'Transaction ie to Sell',
      'icon': null,
    },
    {
      'value': 'Strategising',
      'label': 'Value Creation ie Strategising',
      'icon': null,
    }
  ];
  GlobalKey<FormState> _oFormKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  _showEbita() async {
    
    advisory_reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Valuation/' + uid);
    //await Future.delayed(Duration(seconds: 2));
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '$sme: Guesstimate Valuation',
            textAlign: TextAlign.center,
            style: TextStyle(
              backgroundColor: Colors.white,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _oFormKey2,
              child: ListBody(
                children: <Widget>[
                  SelectFormField(
                    type: SelectFormFieldType.dialog,
                    controller: ebitaController,
                    //initialValue: _initialValue,
                    icon: Icon(Icons.circle),
                    labelText: 'Whats My Sector',
                    changeIcon: true,
                    dialogTitle: 'Sector',
                    dialogCancelBtn: 'Close',
                    enableSearch: false,
                    dialogSearchHint: 'Whats My Sector',
                    items: _ebitaItems,
                    onChanged: (val3) {
                      setState(() {
                        _valueChanged3 = val3;
                      });
                    },
                    validator: (val3) {
                      setState(() => _valueToValidate3 = val3 ?? '');
                      if (val3 == null || val3.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    onSaved: (val3) =>
                        setState(() => _valueSaved3 = val3 ?? ''),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'What was your profit after tax last year?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    controller: profitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Profit',
                      hintText: 'Profit',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                  Text(
                    'How much company tax did you pay last year?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required. Default Enter 0';
                      }
                      return null;
                    },
                    controller: taxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tax',
                      hintText: 'Tax',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'How much interest did you receive last year?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required. Default Enter 0';
                      }
                      return null;
                    },
                    controller: interestReceivedController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Interest Received',
                      hintText: 'Interest Received',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'How much interest did you pay last year?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required. Default Enter 0';
                      }
                      return null;
                    },
                    controller: interestPaidController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Interest Paid',
                      hintText: 'Interest Paid',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'What was your depreciation last year?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required. Default Enter 0';
                      }
                      return null;
                    },
                    controller: depreciationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Depreciation',
                      hintText: 'Depreciation',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'What was your amortisation last year?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required. Default Enter 0';
                      }
                      return null;
                    },
                    controller: amortisationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'amortisation',
                      hintText: 'amortisation',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Note the Guess Value provided is a bit of a wild guess, for a proper valuation we need more realistic data points and research to compute the value. For a proper valuation click Yes below and redirect to our proper valuation page.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                onSurface: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Guess The Value?'),
              onPressed: () {
                // _showEbitaValue();
                Map<String, String> casset = {
                  'ebitaController': ebitaController.text,
                  'profitController': profitController.text,
                  'interestReceivedController': interestReceivedController.text,
                  'taxController': taxController.text,
                  'interestPaidController': interestPaidController.text,
                  'depreciationController': depreciationController.text,
                  'amortisationController': amortisationController.text,
                };

                FirebaseDatabase.instance
                    .ref()
                    .child('/guessestimate/' + uid + "/ebita/")
                    .update(casset);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ValuationPage()),
                );
                // setState(() {
                //   calcEbita = double.parse(ebitaController.text) *
                //       (double.parse(profitController.text) +
                //           double.parse(taxController.text) -
                //           double.parse(interestReceivedController.text) +
                //           double.parse(interestPaidController.text) +
                //           double.parse(depreciationController.text) +
                //           double.parse(amortisationController.text));
                // });

                // if (_oFormKey2.currentState!.validate()) {

                // }
                // ;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Instead, I need a proper valuation.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        onSurface: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        _showMyDialog(); // Navigate back to first route when tapped.
                      },
                      child: Row(children: [Text('Yes')])),
                ),
              ],
            ),
            ElevatedButton(
                style: TextButton.styleFrom(
                  onSurface: Colors.white,
                  backgroundColor: Colors.orange,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close')),
          ],
        );
      },
    );
  }

  _showEbitaValue() {
    //

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            ' ',
            textAlign: TextAlign.center,
            style: TextStyle(
              backgroundColor: Colors.white,
              color: Colors.blue,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ElevatedButton(
                    style: TextButton.styleFrom(
                      onSurface: Colors.black,
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: null,
                    child: Text(
                        '$sme: Guess Value - ' + calcEbita.toStringAsFixed(2))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Instead, i need a proper valuation.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                        style: TextButton.styleFrom(
                          onSurface: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          _showMyDialog(); // Navigate back to first route when tapped.
                        },
                        child: Row(children: [Text('Yes')])),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                style: TextButton.styleFrom(
                  onSurface: Colors.white,
                  backgroundColor: Colors.orange,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close')),
          ],
        );
      },
    );
  }

  ///// actual valuation start
  Future<void> _showMyDialog() async {
    
    advisory_reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Valuation/' + uid);
    //await Future.delayed(Duration(seconds: 2));
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '  Business Valuation     ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _oFormKey,
              child: ListBody(
                children: <Widget>[
                  SelectFormField(
                    type: SelectFormFieldType.dialog,
                    controller: areaController,
                    //initialValue: _initialValue,
                    icon: null,
                    labelText: 'Reason for Business Valuation',
                    changeIcon: true,
                    dialogTitle: 'Valuation Reason',
                    dialogCancelBtn: 'Close',
                    enableSearch: false,
                    dialogSearchHint: 'Reason for Business Valuation',
                    items: _items2,
                    onChanged: (val2) {
                      setState(() {
                        _valueChanged2 = val2;
                      });
                    },
                    validator: (val2) {
                      setState(() => _valueToValidate2 = val2 ?? '');
                      if (val2 == null || val2.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    onSaved: (val2) =>
                        setState(() => _valueSaved2 = val2 ?? ''),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(17),
                    child: SelectFormField(
                      type: SelectFormFieldType.dialog,
                      controller: agendaController,
                      //initialValue: _initialValue,
                      icon: null,
                      labelText: 'Do you want us to help you?',
                      changeIcon: true,
                      dialogTitle: 'Need Assistance?',
                      dialogCancelBtn: 'Close',
                      enableSearch: false,
                      dialogSearchHint: 'Do yo want us to help you?',
                      items: _items,
                      onChanged: (val) {
                        setState(() {
                          _valueChanged = val;
                        });
                      },
                      validator: (val) {
                        setState(() => _valueToValidate = val ?? '');
                        if (val == null || val.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      onSaved: (val) => setState(() => _valueSaved = val ?? ''),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    controller: descController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Other Information ',
                      hintText: 'Please enter other relevant information',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    controller: attendingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Business Value Estimate',
                      hintText: 'Estimate Business Value',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    controller: dateController2,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'When do you expect your report?',
                      hintText: 'When do you expect your report?',
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                if (_oFormKey.currentState!.validate()) {
                  Map<String, String> revenue = {
                    'value': attendingController.text,
                    'description': descController.text,
                    'help': agendaController.text,
                    'reason': areaController.text,
                    'date': dateController2.text,
                    'status': 'pending'
                  };

                  advisory_reference.push().set(revenue);

                  // Replace with the message you want to send

                  final url = 'https://buy.stripe.com/cN2bJH2kC4ZWeZ26oo';

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                  // final paymentMethod = await Stripe.instance.paymentRequestWithCardForm(
                  // amount:'100',
                  // currency:'USD',
                  // );

                  Navigator.of(context).pop();
                }
                ;
              },
            ),
            ElevatedButton(
                style: TextButton.styleFrom(
                  onSurface: Colors.white,
                  backgroundColor: Colors.orange,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close')),
          ],
        );
      },
    );
  }

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  List<_SalesData> data = [];
  List<_SalesData> data2 = [];

  double totalRevenue = 0;
  double averageRevenue = 0;
  double percentageRevenue = 0;
  int countRevenue = 0;
  double budget = 0, dailyRev = 0;

  final amountController = TextEditingController();
  final marginController = TextEditingController();
  final dateController = TextEditingController();
  final commentController = TextEditingController();
  final planController = TextEditingController();
  final Color unselectedItemColor = Colors.blue;
  late Query dbRef, dbRef2;
  late DatabaseReference reference, reference1;
  String currentValue = '0';
  String sme = '', currency = '';

  getDateValue(date) {
    
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      currentValue = rev['amount'];
    });
  }

  @override
  void initState() {
    super.initState();

     // <-- Their email
    String mail = user?.email ?? 'email';
// Stripe.publishableKey='pk_live_51N85NcGg8GWdATteQ5h08RLz2EwsFs4mHlVQKzRHJljhYbDfjYWWlV3JQdgZJot0Cd2qew4FiFLj7u96g9XkBvA000qGx4Lx21';
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/latestValuation/')
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      if (revenue['user'] == uid) {
        setState(() {
          valuation = revenue['amount'];
        });
      }
    });
    FirebaseDatabase.instance
        .ref()
        .child( '/guessestimate/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        calcEbita = double.parse(revenue['ebitaController']) *
            (double.parse(revenue['profitController']) +
                double.parse(revenue['taxController']) -
                double.parse(revenue['interestReceivedController']) +
                double.parse(revenue['interestPaidController']) +
                double.parse(revenue['depreciationController']) +
                double.parse(revenue['amortisationController']));
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child('/ebita/')
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        _ebitaItems.add({
          'value': revenue['EV'],
          'label': revenue['Name'],
          'icon': null,
        });
      });
    });

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        budget = double.parse(revenue['revenueBudget']);
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .orderByChild('date')
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        if (rev['date'] == actualDate) {
          dailyRev += double.parse(rev['amount']);
        }

        data2.add(_SalesData(
            rev['date'].substring(0, 2), double.parse(rev['amount'])));
        data.add(_SalesData(rev['date'].substring(0, 2), budget));
      });
    });

    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });
    Map? revenueTrack;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      revenueTrack = event.snapshot.value as Map;
    });

    String getDate = "";
    double dateAmount = 0.0;

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue/' + uid)
        .orderByChild("date")
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      countRevenue++;

      setState(() {
        totalRevenue += double.parse(revenue['amount']);
        averageRevenue = totalRevenue / countRevenue;
        percentageRevenue = (averageRevenue / totalRevenue) * 100;

        if (getDate == revenue['date'].substring(0, 2)) {
          getDate = "";
          dateAmount += double.parse(revenue['amount']);
        } else {
          getDate = revenue['date'].substring(0, 2);
          dateAmount += double.parse(revenue['amount']);
        }
      });
      if (getDate != "") {
        // data2.add(_SalesData(getDate, dateAmount));
        // data.add(_SalesData(getDate, budget));
        dateAmount = 0;
      }
    });
    dbRef = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    dbRef2 = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Valuation' + '/' + uid);
    reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    reference1 = FirebaseDatabase.instance.ref().child(
        actualMonthRef + '/trackRevenue/' + uid + '/' + actualMonthRef + "/");
  }

  Widget listRevenue({required Map revenue}) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondRoute(
                    ky: revenue['key'],
                    amount: revenue['amount'],
                    plan: revenue['plan'],
                    comment: revenue['comment'],
                    margin: revenue['margin'],
                    date: revenue['date'])),
          );
          // Add what you want to do on tap
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  revenue['date'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Daily Sales',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  revenue['comment'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ]),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '' + revenue['amount'],
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                    ]),
              ),
            ])));

    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          //Initialize the chart widget
          Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  //border: Border.all(width: 2.0, color: insightColor2),
                  ),
              child: Text(
                "Do you know the true value of your business?\n\nOur Business Valuation combined with out artificial intelligence will help you understand the true value of your business for various use cases. Our main valuation method is Discounted Free Cash Flow with guidance form Asset and Market Valuation. Once we have done a business valuation for your business, the value will be displayed below. Our main areas of business valuation include selling your business ‘as a whole or part, or going into a partnership where you have to exchange stake to explore positive synergies.",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                      onSurface: Colors.black,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: null,
                    child: Row(children: [
                      Icon(Icons.arrow_circle_right_outlined),
                      Text('$sme: Guess Value - ' +
                          calcEbita.toStringAsFixed(2)),
                    ])),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                      onSurface: Colors.black,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      _showEbita(); // Navigate back to first route when tapped.
                    },
                    child: Row(children: [
                      Icon(Icons.arrow_circle_right_outlined),
                      Text('Value My Business')
                    ])),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              'My Valuation Reports\n',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 8.0, color: Colors.blue),
              ),
            ),
            child: Row(
              children: [
                // Expanded(
                //   child: Text(
                //     'Valuation',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: Text(
                //     'Valuation Date',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: Text(
                //     'Download',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                const Text("No Valuation Yet"),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: dbRef2,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map revenue = snapshot.value as Map;
                    revenue['key'] = snapshot.key;

                    return listExpenses(revenue: revenue);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MyadvisorPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyadvisorPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  MyadvisorPageState createState() => MyadvisorPageState();
}

class MyadvisorPageState extends State<MyadvisorPage> {
  final User? user = Auth().currentUser;
//
  String email = "";
  int _selectedIndex = 2;
  TextEditingController areaController = new TextEditingController();
  TextEditingController agendaController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  TextEditingController attendingController = new TextEditingController();
  TextEditingController dateController2 = new TextEditingController();
  String advisorNum = "",
      advisorDesc = "",
      advisorName = "",
      advisorNumber = "",
      advisorEmail = "",
      advisorCountry = "",
      advisorCity = "",
      advisorQ1 = "",
      advisorQ2 = "",
      advisorEx1 = "",
      advisorEx2 = "",
      advisorEx3 = "",
      advisorEx4 = "",
      advisorEx5 = "",
      advisorURL = "";
  startState() async {
    // TODO: implement initState
    email = user?.email ?? 'email';
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map revenue = event.snapshot.value as Map;
      revenue['key'] = event.snapshot.key;
      if (email == revenue['email']) {
        advisorEmail = revenue['advisorEmail'];
        //smeNameController.text = mainSme;
        //userNameController.text= revenue['fname'];
        // Step 2 <- SEE HERE
        //mainNumberController.text = revenue['number'].toString();
        //descController.text = revenue['desc'];
      }
    });

    await Future.delayed(Duration(seconds: 1));

    FirebaseDatabase.instance
        .ref()
        .child('advisor/')
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      revenue['key'] = event.snapshot.key;
      if (advisorEmail == revenue['email']) {
        print("napinda baba");
        setState(() {
          advisorNumber = revenue['number'];
          advisorName = revenue['name'];
          advisorCountry = revenue['country'];
          advisorCity = revenue['city'];
          advisorEx1 = revenue['exp1'];
          advisorEx2 = revenue['exp2'];
          advisorEx3 = revenue['exp3'];
          advisorEx4 = revenue['exp4'];
          advisorEx5 = revenue['exp5'];
          advisorQ1 = revenue['q1'];
          advisorQ2 = revenue['q2'];
          advisorDesc = revenue['desc'];
          advisorNum = revenue['num'];
          if (revenue.containsKey('picture')) {
            advisorURL = revenue['picture'];
          }
        });
      }
    });
  }

  Widget listExpenses({required Map revenue}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              revenue['reason'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              revenue['date'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              revenue['status'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    return Text('');
  }

  late DatabaseReference advisory_reference;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Yes',
      'label': 'Yes',
      'icon': Icon(Icons.check),
    },
    {
      'value': 'No',
      'label': 'No',
      'icon': Icon(Icons.info),
    }
  ];
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  Future<void> _showMyDialog() async {
    
    advisory_reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Valuation/' + uid);
    //await Future.delayed(Duration(seconds: 2));
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '  Proper Business Valuation     ',
            textAlign: TextAlign.center,
            style: TextStyle(
              backgroundColor: Colors.white,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _oFormKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    controller: areaController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'What s the reason for Business Valuation',
                      hintText: 'Valuation Reason',
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(17),
                    child: SelectFormField(
                      type: SelectFormFieldType.dialog,
                      controller: agendaController,
                      //initialValue: _initialValue,
                      icon: Icon(Icons.format_shapes),
                      labelText: 'Do yo want us to help you?',
                      changeIcon: true,
                      dialogTitle: 'Need Assistance?',
                      dialogCancelBtn: 'Close',
                      enableSearch: false,
                      dialogSearchHint: 'Do yo want us to help you?',
                      items: _items,
                      onChanged: (val) {
                        setState(() {
                          _valueChanged = val;
                        });
                      },
                      validator: (val) {
                        setState(() => _valueToValidate = val ?? '');
                        if (val == null || val.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      onSaved: (val) => setState(() => _valueSaved = val ?? ''),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    controller: descController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Other Information ',
                      hintText: 'Please enter other relevant information',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    controller: attendingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Business Value Estimate',
                      hintText: 'Estimate Business Value',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    controller: dateController2,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'When do you expect your report?',
                      hintText: 'When do you expect your report?',
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                onSurface: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Submit'),
              onPressed: () async {
                Map<String, String> revenue = {
                  'value': attendingController.text,
                  'description': descController.text,
                  'help': agendaController.text,
                  'reason': areaController.text,
                  'date': dateController2.text,
                  'status': 'pending'
                };
                final url = 'https://buy.stripe.com/cN2bJH2kC4ZWeZ26oo';

                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
                advisory_reference.push().set(revenue);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  List<_SalesData> data = [];
  List<_SalesData> data2 = [];

  double totalRevenue = 0;
  double averageRevenue = 0;
  double percentageRevenue = 0;
  int countRevenue = 0;
  double budget = 0, dailyRev = 0;

  final amountController = TextEditingController();
  final marginController = TextEditingController();
  final dateController = TextEditingController();
  final commentController = TextEditingController();
  final planController = TextEditingController();
  final Color unselectedItemColor = Colors.blue;
  late Query dbRef, dbRef2;
  late DatabaseReference reference, reference1;
  String currentValue = '0';
  String sme = '', currency = '';

  getDateValue(date) {
    
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      currentValue = rev['amount'];
    });
  }

  @override
  void initState() {
    super.initState();

     // <-- Their email
    String mail = user?.email ?? 'email';
    startState();
    //
    FirebaseDatabase.instance
        .ref()
        .child('advisor/')
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      revenue['key'] = event.snapshot.key;
      if (advisorEmail == revenue['email']) {
        print("napinda baba");
        setState(() {
          advisorNumber = revenue['number'];
          advisorName = revenue['name'];
          advisorCountry = revenue['country'];
          advisorCity = revenue['city'];
          advisorEx1 = revenue['exp1'];
          advisorEx2 = revenue['exp2'];
          advisorEx3 = revenue['exp3'];
          advisorEx4 = revenue['exp4'];
          advisorEx5 = revenue['exp5'];
          advisorQ1 = revenue['q1'];
          advisorQ2 = revenue['q2'];
          advisorDesc = revenue['desc'];
          advisorNum = revenue['num'];
          if (revenue.containsKey('picture')) {
            advisorURL = revenue['picture'];
          }
        });
      }
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        budget = double.parse(revenue['revenueBudget']);
        startState();
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .orderByChild('date')
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map rev = event.snapshot.value as Map;
      setState(() {
        startState();
        if (rev['date'] == actualDate) {
          dailyRev += double.parse(rev['amount']);
        }

        data2.add(_SalesData(
            rev['date'].substring(0, 2), double.parse(rev['amount'])));
        data.add(_SalesData(rev['date'].substring(0, 2), budget));
      });
    });

    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });
    Map? revenueTrack;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef +
            '/trackRevenue/' +
            uid +
            '/' +
            actualMonthRef +
            "/")
        .onChildAdded
        .listen((event) {
      revenueTrack = event.snapshot.value as Map;
    });

    String getDate = "";
    double dateAmount = 0.0;

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue/' + uid)
        .orderByChild("date")
        .limitToLast(30)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      countRevenue++;

      setState(() {
        totalRevenue += double.parse(revenue['amount']);
        averageRevenue = totalRevenue / countRevenue;
        percentageRevenue = (averageRevenue / totalRevenue) * 100;

        if (getDate == revenue['date'].substring(0, 2)) {
          getDate = "";
          dateAmount += double.parse(revenue['amount']);
        } else {
          getDate = revenue['date'].substring(0, 2);
          dateAmount += double.parse(revenue['amount']);
        }
      });
      if (getDate != "") {
        // data2.add(_SalesData(getDate, dateAmount));
        // data.add(_SalesData(getDate, budget));
        dateAmount = 0;
      }
    });
    dbRef = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    dbRef2 = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Valuation' + '/' + uid);
    reference = FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/Revenue' + '/' + uid);
    reference1 = FirebaseDatabase.instance.ref().child(
        actualMonthRef + '/trackRevenue/' + uid + '/' + actualMonthRef + "/");
  }

  Widget listRevenue({required Map revenue}) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondRoute(
                    ky: revenue['key'],
                    amount: revenue['amount'],
                    plan: revenue['plan'],
                    comment: revenue['comment'],
                    margin: revenue['margin'],
                    date: revenue['date'])),
          );
          // Add what you want to do on tap
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  revenue['date'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Daily Sales',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  revenue['comment'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ]),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '' + revenue['amount'],
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                    ]),
              ),
            ])));

    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          //Initialize the chart widget

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                      onSurface: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: null,
                    child: Row(children: [
                      Icon(Icons.arrow_circle_right_outlined),
                      Text(
                        'My Advisor Profile',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ])),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                advisorURL != null
                    ? Image.network(advisorURL)
                    : Text('No Picture Yet'),
                Text(
                  '$advisorName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  ' $advisorCity, $advisorCountry',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Email: $advisorEmail',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Text(
                //   'Number: $advisorNumber',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 10),
                Text(
                  'Qualifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$advisorQ1 \n $advisorQ2',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Experience',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'I. $advisorEx1\nII. $advisorEx2\nIII. $advisorEx3\nIV. $advisorEx4\nV. $advisorEx5\n\n',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$advisorDesc',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AssetsPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AssetsPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;
  @override
  AssetsPageState createState() => AssetsPageState();
}

class AssetsPageState extends State<AssetsPage> {
  final User? user = Auth().currentUser;
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController? _controller;

  //String _initialValue;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  int _selectedIndex = 2;
  double assetNumber = 0;
  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Land',
      'label': 'Land',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Building',
      'label': 'Building',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Machinery',
      'label': 'Machinery',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Equipment',
      'label': 'Equipment',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Computers',
      'label': 'Computers',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Furniture',
      'label': 'Furniture',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Fixtures',
      'label': 'Fixtures',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Patents',
      'label': 'Patents',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Trademarks',
      'label': 'Trademarks',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Tools',
      'label': 'Tools',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Motor Vehicles',
      'label': 'Motor Vehicles',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Investments',
      'label': 'Investments',
      'icon': Icon(Icons.monetization_on_outlined),
    },
    {
      'value': 'Other',
      'label': 'Other',
      'icon': Icon(Icons.monetization_on_outlined),
    },
  ];
  List<_SalesData> data = [];
  List<String> strings = [];

  List<_SalesData> data2 = [];
  late Query dbRef;
  late DatabaseReference reference, referenceAsset;
  final assetNumberController = TextEditingController();
  final assetClassController = TextEditingController();
  final serialController = TextEditingController();
  final supplierController = TextEditingController();
  final priceController = TextEditingController();
  final depMonthsController = TextEditingController();
  final monthlyDepController = TextEditingController();
  final monthsInUseController = TextEditingController();
  final accDepController = TextEditingController();
  final marketValueController = TextEditingController();
  final netValueController = TextEditingController();
  final descController = TextEditingController();
  final purchaseDateController = TextEditingController();

  final auditCommentController = TextEditingController();

  double totalExpenses = 0;
  double averageExpenses = 0;
  double percentageExpenses = 0;
  double fixedCosts = 0, dailyExp = 0, temp=0;
  int countExpenses = 0,main=0;
  String sme = '', currency = '',assetNumba='0';

  @override
  void initState() {
    super.initState();
    
    String mail = user?.email ?? 'email';
    int k = 0;

    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/budgets/' + uid)
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      String tt = "";
      setState(() {
        fixedCosts = double.parse(revenue['expensesTarget']) / 30;
        for (var i = 0; i < 31; i++) {
          if (i < 10) {
            tt = "0" + i.toString();
            data.add(_SalesData(tt, fixedCosts));
          } else {
            data.add(_SalesData(i.toString(), fixedCosts));
          }
        }
      });
    });
    double tempAmount = 0, tempCOGS = 0;
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/assetNumber/' + uid)
        .onChildAdded
        .listen((event) {
      Map user = event.snapshot.value as Map;
      assetNumber = double.parse(user['assetNumber']) + 1;
      setState(() {
        assetNumber = double.parse(user['assetNumber']) + 1;
      });
    });
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
          if (user.containsKey('assetNumber')) {
            assetNumba = user['assetNumber'];
          }
          else
            {
              assetNumba='0';
            }
           temp=double.parse(assetNumba) +1;
        });
      }
    });
    FirebaseDatabase.instance
        .ref()
        .child('balanceSheet' + '/' + uid + '/' + 'fixedAssets/')
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;

      var key=event.snapshot.key;
print("key");

      ///// get carts
      FirebaseDatabase.instance
          .ref()
          .child('balanceSheet' + '/' + uid + '/' + 'fixedAssets/'+key!)
          .onChildAdded
          .listen((event) {
        Map asset = event.snapshot.value as Map;

        DateTime purchaseDate1 = DateFormat('dd-MMMM-yyyy').parse(asset['purchaseDateController']);

// Format the DateTime object to the desired format
        String formattedDate = DateFormat('yyyy-MM-dd').format(purchaseDate1);

// Print the formatted date
        print('The formatted date is $formattedDate');

        // Get the current date
        DateTime currentDate = DateTime.now();
        DateTime purchaseDate = DateTime.parse(formattedDate);
// Calculate the difference in months between the two dates
        var differenceInMonths = (currentDate.year - purchaseDate.year) * 12 + currentDate.month - purchaseDate.month;
        print('The months is $differenceInMonths');
        double acc=double.parse(asset['monthlyDepController'])*differenceInMonths;
        double netValue=double.parse(asset['priceController'])-acc;
        setState(() {
          totalExpenses += double.parse(asset['priceController']);
          averageExpenses += netValue;
          if(asset['status'] == "Available")
            {
              countExpenses++;
              main++;
            }
          else
            {
              main++;
            }

        });
      });
    });
    strings.add("Nepal");
    // <-- Their email
    assetNumberController.text = assetNumber.toString();
    dbRef = FirebaseDatabase.instance
        .ref()
        .child('balanceSheet' + '/' + uid + '/' + 'fixedAssets/');
    referenceAsset = FirebaseDatabase.instance.ref().child('/User' + '/' + uid + '/');
    reference = FirebaseDatabase.instance
        .ref()
        .child('balanceSheet' + '/' + uid + '/' + 'fixedAssets/');
    _controller = TextEditingController(text: '2');

    _getValue();
  }

  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        //_initialValue = 'circleValue';
        _controller?.text = 'circleValue';
      });
    });
  }

  String _valueChanged00 = '', _valueChanged0 = '';
  String _valueToValidate00 = '', _valueToValidate0 = '';
  String _valueSaved00 = '', _valueSaved0 = '';
  final List<Map<String, dynamic>> _items0 = [
    {
      'value': the_year,
      'label': the_year,
      'icon': null,
    },
  ];
  final List<Map<String, dynamic>> _items00 = [
    {
      'value': "January",
      'label': "January",
      'icon': null,
    },
    {
      'value': "February",
      'label': "February",
      'icon': null,
    },
    {
      'value': "March",
      'label': "March",
      'icon': null,
    },
    {
      'value': "April",
      'label': "April",
      'icon': null,
    },
    {
      'value': "May",
      'label': "May",
      'icon': null,
    },
    {
      'value': "June",
      'label': "June",
      'icon': null,
    },
    {
      'value': "July",
      'label': "July",
      'icon': null,
    },
    {
      'value': "August",
      'label': "August",
      'icon': null,
    },
    {
      'value': "September",
      'label': "September",
      'icon': null,
    },
    {
      'value': "October",
      'label': "October",
      'icon': null,
    },
    {
      'value': "November",
      'label': "November",
      'icon': null,
    },
    {
      'value': "December",
      'label': "December",
      'icon': null,
    },
  ];
  //// Get Asset Cartegory Start
  Widget listCartegory({required Map revenue}) {
    
    String cart=revenue['key'];
    final scrollController=ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(revenue['key'],
      style:const TextStyle(
        fontSize:20,
        fontWeight: FontWeight.bold),
      ),

      Container(
        height:200,
        child: FirebaseAnimatedList(
        shrinkWrap: true,
        controller:scrollController,
        query: FirebaseDatabase.instance.ref().child('balanceSheet' + '/' + uid + '/' + 'fixedAssets/'+revenue['key']),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map revenue = snapshot.value as Map;
          revenue['key'] = snapshot.key;
          revenue['cart']=cart;
          return listExpenses(revenue: revenue);
        },
      ),),
        Divider(
          thickness: 3.0,
        ),
    ],);
  }
  ///// Get asset cartegory end
  Widget listExpenses({required Map revenue}) {
  String status=revenue['status'];
  TextEditingController commentController = new TextEditingController();

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Assets1Route(
                    ky: revenue['key'],
                    priceController1: revenue['priceController'],
                    assetNumberController1: revenue['assetNumberController'],
                    descController1: revenue['descController'],
                    serialController1: revenue['serialController'],
                    auditCommentController1: revenue['auditCommentController'],
                    supplierController1: revenue['assetName'],
                    depMonthsController1: revenue['depMonthsController'],
                    monthlyDepController1: revenue['monthlyDepController'],
                    monthsInUseController1: revenue['purchaseDateController'],
                      assetClassController1: revenue['cart'],
                    marketValueController1: revenue['marketValueController'])),
          );
          // Add what you want to do on tap
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Asset "+revenue['assetNumberController'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  revenue['assetName'],
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  revenue['descController'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  "\$"+revenue['priceController'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ]),
            Text(" "),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,


                    children: [
                      Text(actualDate),
                      DropdownButtonFormField<String>(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            border: InputBorder.none,
                          ),
                          value:status,
                          items:[
                            DropdownMenuItem(child:Text('Available',style: TextStyle(color: Colors.green, ),textAlign: TextAlign.center),value:'Available'),
                            DropdownMenuItem(child:Text('Not Available',style: TextStyle(color: Colors.red, ),textAlign: TextAlign.center),value:'Not Available'),
                            DropdownMenuItem(child:Text('Written Off',style: TextStyle(color: Colors.orange, ),textAlign: TextAlign.center),value:'Written Off'),

                          ],
                          onChanged:(value){
                            setState((){
                              range=value ?? '';
                            });

                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                child: Form(
                                  key: _formKey,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                   height:420,
                                    child:
                                      Column(

                                        children: <Widget>[
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Describe the status',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Missing Required Field';
                                              }
                                              return null;
                                            },
                                            controller: commentController,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 4,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Enter Audit Comment',
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                            ),
                                          ),

                                          const SizedBox(height: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              MaterialButton(
                                                // style: TextButton.styleFrom(
                                                //   onSurface: Colors.white,
                                                //   backgroundColor:Colors.blue,
                                                //     minimumSize: const Size.fromHeight(50),
                                                //
                                                // ),
                                                onPressed: () async{
                                                  
                                                  if (_formKey.currentState!.validate()) {
                                                    Navigator.pop(context);

                                                    Map<String, String> revenue1 = {
                                                      'auditCommentController': commentController.text,
                                                      'status': value.toString(),
                                                    };
                                                    await FirebaseDatabase.instance.ref('/balanceSheet/' + uid + "/fixedAssets/"+revenue['cart']+"/"+revenue['key']).update(revenue1);
                                                    // reference.push().set(revenue);

                                                   // SignIn;
                                                  }
                                                },
                                                child: const Text('Update'),
                                                color: Colors.blue,
                                                textColor: Colors.white,
                                                minWidth: 300,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          const SizedBox(height: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ElevatedButton(
                                                  style: TextButton.styleFrom(
                                                    onSurface: Colors.white,
                                                    backgroundColor: Colors.orange,
                                                    minimumSize: const Size.fromHeight(50),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Close')),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ),
                                ),
                              ),
                            );



                          }
                      ),

                    ]),
              ),
            ])));
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
   bool isChecked=true;
    final scrollController=ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(children: [
                  SelectFormField(
                    type: SelectFormFieldType.dialog,
                    controller: null,
                    //initialValue: _initialValue,
                    icon: null,
                    labelText: the_year,
                    changeIcon: false,
                    dialogTitle: '',
                    dialogCancelBtn: 'Close',
                    enableSearch: false,
                    dialogSearchHint: 'Search',
                    items: _items0,
                    onChanged: (val) => setState(() => _valueChanged0 = val),
                    validator: (val) {
                      setState(() => _valueToValidate0 = val ?? '');
                      return null;
                    },
                    onSaved: (val) => setState(() => _valueSaved0 = val ?? ''),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(children: [
                  SelectFormField(
                    type: SelectFormFieldType.dialog,
                    controller: null,
                    //initialValue: _initialValue,
                    icon: null,
                    labelText: the_month,
                    changeIcon: true,
                    dialogTitle: '',
                    dialogCancelBtn: 'Close',
                    enableSearch: false,
                    dialogSearchHint: 'Search',
                    items: _items00,
                    onChanged: (val) => setState(() => _valueChanged00 = val),
                    validator: (val) {
                      setState(() {
                        _valueToValidate00 = val ?? '';
                        month = val ?? '';
                        the_month = val ?? '';
                      });
                      return null;
                    },
                    onSaved: (val) => setState(() => _valueSaved00 = val ?? ''),
                  ),
                ]),
              ),
            ),
          ]),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\n\nAsset Register\n',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A comprehensive list of productive\n assets for your business \n providing a basis for your monthly asset register.',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        const Text('  '),
                        Text("" + totalExpenses.toStringAsFixed(0)),
                        const Text('Purchase Value'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blueGrey,
                    child: Column(
                      children: [
                        const Text(' '),
                        Text("" + averageExpenses.toStringAsFixed(0)),
                        const Text('Total Asset Value'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        const Text(''),
                        Text(main.toStringAsFixed(0)+"/" + countExpenses.toStringAsFixed(0)),
                        const Text('Number of Items'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    if(role=="Owner" || role=="Accounts/ Admin")
          ElevatedButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'New Asset Details',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),

                          Text(
                            "Asset Number : " + assetNumba.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SelectFormField(
                            type: SelectFormFieldType.dialog,
                            controller: assetClassController,
                            //initialValue: _initialValue,
                            icon: Icon(Icons.format_shapes),
                            labelText: 'Asset Class',
                            changeIcon: true,
                            dialogTitle: 'Asset Class',
                            dialogCancelBtn: 'CANCEL',
                            enableSearch: true,
                            dialogSearchHint: 'Search',
                            items: _items,
                            onChanged: (val) =>
                                setState(() => _valueChanged = val),
                            validator: (val) {
                              setState(() => _valueToValidate = val ?? '');
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _valueSaved = val ?? ''),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: serialController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Serial Number ',
                              hintText: 'Enter Serial Number',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextfieldDatePicker(
                            cupertinoDatePickerBackgroundColor: Colors.white,
                            cupertinoDatePickerMaximumDate: DateTime(2099),
                            cupertinoDatePickerMaximumYear: 2099,
                            cupertinoDatePickerMinimumYear: 1990,
                            cupertinoDatePickerMinimumDate: DateTime(1990),
                            cupertinoDateInitialDateTime: DateTime.now(),
                            materialDatePickerFirstDate: DateTime(2022),
                            materialDatePickerInitialDate: DateTime.now(),
                            materialDatePickerLastDate: DateTime.now(),
                            preferredDateFormat: DateFormat('dd-MMMM-' 'yyyy'),
                            textfieldDatePickerController:
                                purchaseDateController,
                            style: TextStyle(
                              fontSize: 1000 * 0.040,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              //errorText: errorTextValue,
                              helperStyle: TextStyle(
                                  fontSize: 1000 * 0.031,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    color: Colors.white,
                                  )),
                              hintText: 'Select Purchase Date',
                              hintStyle: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.normal),
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: supplierController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Asset Name',
                              hintText: 'Enter Asset Name',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: priceController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Current Value',
                              hintText: 'Enter Current Value',
                            ),
                            onChanged: (value) {
    // handle the text input here
    double a=double.parse(value);
    double b=double.parse(depMonthsController.text);
    double result=a/b;
    monthlyDepController.text=result.toString();
    //print('The text input has changed to: $value');
  },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: depMonthsController,
                            onChanged: (value) {
    // handle the text input here
    double a=double.parse(priceController.text);
    double b=double.parse(value);
    double result=a/b;
    monthlyDepController.text=result.toString();
    //print('The text input has changed to: $value');
  },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Depreciation Months',
                              hintText: 'Enter Depreciation Months',
                            ),
                          ),




                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: marketValueController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Market Value',
                              hintText: 'Enter Market Value',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: descController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Asset Description',
                              hintText: 'Enter Asset Description',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            controller: auditCommentController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Monthly Audit Comment',
                              hintText: 'Monthly Audit Comment',
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MaterialButton(
                                // style: TextButton.styleFrom(
                                //   onSurface: Colors.white,
                                //   backgroundColor:Colors.blue,
                                //     minimumSize: const Size.fromHeight(50),
                                //
                                // ),
                                onPressed: () {
double a=double.parse(priceController.text);
    double b=double.parse(depMonthsController.text);
    double result=a/b;
    monthlyDepController.text=result.toString();
                                  Map<String, String> revenue = {
                                    'assetNumberController':
                                    temp.toString(),
                                    'assetClassController':
                                        assetClassController.text,
                                    'serialController': serialController.text,
                                    'assetName':
                                        supplierController.text,
                                    'priceController': priceController.text,
                                    'depMonthsController':
                                        depMonthsController.text,
                                    'monthlyDepController':
                                        monthlyDepController.text,
                                    'accDepController': '0',
                                    'marketValueController':
                                        marketValueController.text,
                                    'netValueController':
                                    priceController.text,
                                    'descController': descController.text,
                                    'auditCommentController':
                                        auditCommentController.text,
                                    'purchaseDateController':
                                        purchaseDateController.text,
                                    'creation_date': actualDate,
                                    'monthYearRef':actualMonthRef,
                                    'status':"Available"
                                  };

                                  Map<String, String> assetNum = {
                                    'assetNumber': temp.toString(),
                                  };
                                  setState(() {
                                    temp++;
                                    assetNumba =temp.toString();
                                  });
                                  Map<String, String> cart = {
                                    'cartegory': assetClassController.text,
                                  };
                                  
                                  String cartegorize=assetClassController.text;
                                  referenceAsset.update(assetNum);
                                  FirebaseDatabase.instance
                                      .ref()
                                      .child('balanceSheet' + '/' + uid + '/' + 'fixedAssets/'+cartegorize).push().set(revenue);
                                  // FirebaseDatabase.instance
                                  //     .ref()
                                  //     .child('balanceSheet' + '/' + uid + '/' + 'fixedAssets/'+cartegorize).update(cart);

                                  Navigator.pop(context);
                                },
                                child: const Text('Save'),
                                color: Colors.blue,
                                textColor: Colors.white,
                                minWidth: 300,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  style: TextButton.styleFrom(
                                    onSurface: Colors.white,
                                    backgroundColor: Colors.orange,
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Go Back')),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: const Text('Add New Asset'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(50), // NEW
            ),
          ),
          const SizedBox(height:20),

          SingleChildScrollView(
            child: Container(
              height:350,
              padding: const EdgeInsets.all(20),
              child:
              FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: dbRef,
                controller:scrollController,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map revenue = snapshot.value as Map;
                    revenue['key'] = snapshot.key;
                    return listCartegory(revenue: revenue);
                  },
                ),

            ),
          ),

          SizedBox(
            height: 110, // <-- SEE HERE
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Assets1Route extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  //SecondRoute({Key? key}) : super(key: key);

  Assets1Route({
    super.key,
    required this.ky,
    required this.priceController1,
    required this.assetNumberController1,
    required this.serialController1,
    required this.auditCommentController1,
    required this.descController1,
    required this.supplierController1,
    required this.depMonthsController1,
    required this.monthlyDepController1,
    required this.monthsInUseController1,
    required this.marketValueController1,
    required this.assetClassController1,
  });
  final String priceController1;
  final String assetNumberController1;
  final String serialController1;
  final String auditCommentController1;
  final String descController1;
  final String supplierController1;
  final String depMonthsController1;
  final String monthlyDepController1;
  final String monthsInUseController1;
  final String marketValueController1;
  final String assetClassController1;
  final String ky;
  final User? user = Auth().currentUser;
  @override
  //SecondRouteState createState() => SecondRouteState();
  State<Assets1Route> createState() => Assets1RouteState();
}

class Assets1RouteState extends State<Assets1Route> {
  int _selectedIndex = 2;

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = 2;
    });

    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  final User? user = Auth().currentUser;
  
  late DatabaseReference reference;
  final assetNumberController = TextEditingController();
  final assetClassController = TextEditingController();
  final serialController = TextEditingController();
  final supplierController = TextEditingController();
  final priceController = TextEditingController();
  final depMonthsController = TextEditingController();
  final monthlyDepController = TextEditingController();
  final monthsInUseController = TextEditingController();
  final accDepController = TextEditingController();
  final marketValueController = TextEditingController();
  final netValueController = TextEditingController();
  final descController = TextEditingController();
  final purchaseDateController = TextEditingController();

  final auditCommentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
 generatePdf() async {
    
    final url = 'https://kupfuma.com/advisor/printAssets.php?uid=' + uid;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    assetNumberController.text=widget.assetNumberController1;
    assetClassController.text=widget.assetClassController1;
    serialController.text=widget.serialController1;
    supplierController.text=widget.supplierController1;
    priceController.text=widget.priceController1;
    depMonthsController.text=widget.depMonthsController1;
    monthlyDepController.text=widget.monthlyDepController1;
   // accDepController.text=widget.accDepController1;
    marketValueController.text=widget.marketValueController1;
   // netValueController.text=widget.netValueController1;
    descController.text=widget.descController1;
    purchaseDateController.text=widget.monthsInUseController1;
    auditCommentController.text=widget.auditCommentController1;
String updateKey=widget.ky;
double temp=0, monthlyDep=0, accDep=0,netValue=0;

    monthlyDep=double.parse(priceController.text)/double.parse(depMonthsController.text);
    monthlyDepController.text=monthlyDep.toString();
print(purchaseDateController.text);


// Create a DateTime object from the purchase date string
    DateTime purchaseDate1 = DateFormat('dd-MMMM-yyyy').parse(purchaseDateController.text);

// Format the DateTime object to the desired format
    String formattedDate = DateFormat('yyyy-MM-dd').format(purchaseDate1);

// Print the formatted date
    print('The formatted date is $formattedDate');

    // Get the current date
    DateTime currentDate = DateTime.now();
    DateTime purchaseDate = DateTime.parse(formattedDate);
// Calculate the difference in months between the two dates
    var differenceInMonths = (currentDate.year - purchaseDate.year) * 12 + currentDate.month - purchaseDate.month;
    accDep=monthlyDep*differenceInMonths;
    netValue=double.parse(priceController.text)-accDep;
// Print the difference in months
    print('The difference in months is $differenceInMonths');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Asset'),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child:

        SingleChildScrollView(child:
          Form(
            key: _formKey,
            child:
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.supplierController1,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    Text(
                      "Asset Number : " + assetNumberController.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Purchase Date : " + purchaseDateController.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Monthly Depriciation : \$" + monthlyDep.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Accumulated Depriciation: \$" + accDep.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Net Value : \$" + netValue.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: serialController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Serial Number ',
                        hintText: 'Enter Serial Number',
                      ),
                    ),

                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: supplierController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Asset Name',
                        hintText: 'Enter Asset Name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: priceController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Current Value',
                        hintText: 'Enter Current Value',
                      ),
                      onChanged: (value) {
                        // handle the text input here
                        double a=double.parse(value);
                        double b=double.parse(depMonthsController.text);
                        double result=a/b;
                        monthlyDepController.text=result.toString();
                        //print('The text input has changed to: $value');
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: depMonthsController,
                      onChanged: (value) {
                        // handle the text input here
                        double a=double.parse(priceController.text);
                        double b=double.parse(value);
                        double result=a/b;
                        monthlyDepController.text=result.toString();
                        //print('The text input has changed to: $value');
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Depreciation Months',
                        hintText: 'Enter Depreciation Months',
                      ),
                    ),




                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: marketValueController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Market Value',
                        hintText: 'Enter Market Value',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: descController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Asset Description',
                        hintText: 'Enter Asset Description',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Required';
                        }
                        return null;
                      },
                      controller: auditCommentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Monthly Audit Comment',
                        hintText: 'Monthly Audit Comment',
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          // style: TextButton.styleFrom(
                          //   onSurface: Colors.white,
                          //   backgroundColor:Colors.blue,
                          //     minimumSize: const Size.fromHeight(50),
                          //
                          // ),
                          onPressed: () {
                            double a=double.parse(priceController.text);
                            double b=double.parse(depMonthsController.text);
                            double result=a/b;
                            monthlyDepController.text=result.toString();
                            Map<String, String> revenue = {

                              'serialController': serialController.text,
                              'assetName':
                              supplierController.text,
                              'priceController': priceController.text,
                              'depMonthsController':
                              depMonthsController.text,
                              'monthlyDepController':
                              monthlyDepController.text,
                              'accDepController': accDep.toString(),
                              'marketValueController':
                              marketValueController.text,
                              'netValueController':
                              netValue.toString(),
                              'descController': descController.text,
                              'auditCommentController':
                              auditCommentController.text,
                              'lastUpdated': actualDate,
                            };


                           
                            
                            String cartegorize=assetClassController.text;
                            //referenceAsset.update(assetNum);
                            FirebaseDatabase.instance
                                .ref()
                                .child('balanceSheet' + '/' + uid + '/' + 'fixedAssets/'+cartegorize+'/'+updateKey).update(revenue);
                            // FirebaseDatabase.instance
                            //     .ref()
                            //     .child('balanceSheet' + '/' + uid + '/' + 'fixedAssets/'+cartegorize).update(cart);

                            Navigator.pop(context);
                          },
                          child: const Text('Update'),
                          color: Colors.blue,
                          textColor: Colors.white,
                          minWidth: 300,
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              onSurface: Colors.white,
                              backgroundColor: Colors.orange,

                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Go Back')),),
                        Expanded(
                          child:const Text("        ")
                        ),
                        Expanded(
                         child:ElevatedButton(
                          onPressed: () {
                            
                            String cartegorize=assetClassController.text;
                            FirebaseDatabase.instance
                                .ref('balanceSheet' + '/' + uid + '/' + 'fixedAssets/'+cartegorize+'/'+updateKey)
                                .remove();

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Background color
                          ),
                          child: const Text('Delete'),
                        ),),
                      ],
                    ),
 FloatingActionButton(
            child: Icon(Icons.print),
            onPressed: () async {
              await generatePdf();
            },
          ),


                  ],
                ),

          ),


        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: 3,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class DealRoom extends StatefulWidget {
  @override
  DealRoomState createState() => DealRoomState();
}

class DealRoomState extends State<DealRoom> {
  final User? user = Auth().currentUser;
  GlobalKey<FormState> _oFormKey2 = GlobalKey<FormState>();

  int _selectedIndex = 4;
  TextEditingController valueController = new TextEditingController();
  TextEditingController whenController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  TextEditingController reportController = new TextEditingController();
  TextEditingController websiteController = new TextEditingController();
  TextEditingController cvController = new TextEditingController();
  String valuation = "NO VALUATION";
  // Check if the user is signed in
  File? _image;
  void _uploadCV() async {

    final image=await FilePicker.platform.pickFiles();

    if (image != null) {
      final path = image.files.single.path;
      setState((){
        _image=File(path!);
      });
      // Do something with the picked PDF file
    }

    Random random = Random();
    int randomNumber = random.nextInt(1000000) + 1;
    final Reference storageReference = FirebaseStorage.instance.ref().child(randomNumber.toString());

    final UploadTask uploadTask = storageReference.putFile(_image!);
    await uploadTask.whenComplete(() async {
      final String downloadUrl = await storageReference.getDownloadURL();
      setState(() {
        cvController.text=downloadUrl;
      });
    });
  }
  void _uploadProfile() async {

    final image=await FilePicker.platform.pickFiles();

    if (image != null) {
      final path = image.files.single.path;
      setState((){
        _image=File(path!);
      });
      // Do something with the picked PDF file
    }

    Random random = Random();
    int randomNumber = random.nextInt(1000000) + 1;
    final Reference storageReference = FirebaseStorage.instance.ref().child(randomNumber.toString());

    final UploadTask uploadTask = storageReference.putFile(_image!);
    await uploadTask.whenComplete(() async {
      final String downloadUrl = await storageReference.getDownloadURL();
      setState(() {
        reportController.text=downloadUrl;
      });
    });
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }

  final Map<String, bool> _containerVisibilities = {};
  List<dynamic> data = []; // store data fetched from Firebase
  String sme = '', currency = '', UserName = '';
  
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child( '/Selling');
void toggleContainerVisibility(String id){

  String m=id+"m";
  String s=id+"s";
  setState(() {
    if(_containerVisibilities[m]==true)
      {
        _containerVisibilities[m] = false;
        _containerVisibilities[s] = true;
      }
    else
      {
        _containerVisibilities[s] = false;
        _containerVisibilities[m] = true;
      }


  });

}
  registerInvestor() async {
    
    final url = 'https://kupfuma.com/invest/investor/login';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
int check=1;
  returnDialog() async{
    String mail = user?.email ?? 'email';
    String sme="";
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;

      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];

        });
      }
    });
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        alignment: Alignment.bottomCenter,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        onSurface: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Fund My Business'),
                              content: SingleChildScrollView(child:Form(
                                key: _oFormKey2,
                                child: Column(
                                  children: <Widget>[

                                    TextFormField(
                                      controller: valueController,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue,
                                              width: 2.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue,
                                              width: 2.0),
                                        ),
                                        labelText:
                                        'Enter Funding Required',
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                      ),
                                    ),
                                    const SizedBox(height:10),
                                    ElevatedButton(
                                        style: TextButton.styleFrom(
                                          minimumSize:
                                          const Size.fromHeight(50),
                                          onSurface: Colors.white,
                                          backgroundColor: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          // TODO: Implement image selection and upload
                                          // List<String> imagePaths = ['path1', 'path2']; // Example image paths
                                          // await _uploadImages(imagePaths);

                                          _uploadCV();

                                        },
                                        child: const Text(
                                            '-[Attach] CEO\'s CV-')),
                                    const SizedBox(height:10),
                                    TextField(
                                      controller: descController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 10,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue,
                                              width: 2.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue,
                                              width: 2.0),
                                        ),
                                        labelText:
                                        'Why do you need equity funding',
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                      ),
                                    ),
                                    const SizedBox(height:10),
                                    ElevatedButton(
                                        style: TextButton.styleFrom(
                                          minimumSize:
                                          const Size.fromHeight(50),
                                          onSurface: Colors.white,
                                          backgroundColor: Colors.blue,
                                        ), onPressed: () async {
                              // TODO: Implement image selection and upload
                              // List<String> imagePaths = ['path1', 'path2']; // Example image paths
                              // await _uploadImages(imagePaths);

                              _uploadProfile();

                              },
                                        child: const Text(
                                            '-[Attach] Company Profile-')),

                                    const SizedBox(height:10),
                                    Center(child:Text("-OR-",style:TextStyle(fontWeight: FontWeight.bold))),
                                    const SizedBox(height:10),
                                    TextFormField(
                                      controller: websiteController,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue,
                                              width: 2.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue,
                                              width: 2.0),
                                        ),
                                        labelText:
                                        'Enter Company Website',
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                      ),
                                    ),

                                  ],
                                ),
                              ),),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Submit'),
                                  onPressed: () {
// push the form data to Firebase Realtime Database
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('/Selling2/')
                                        .push().set({
                                      'whenDoYouWantToSell':
                                      whenController.text,
                                      'howMuchAreYouSellingFor':
                                      valueController.text,
                                      'brieflyDescribeYourMotivationToSellTheBusiness':
                                      descController.text,
                                      'uid': uid,
                                      'website':websiteController.text,
                                      'owner_cv':cvController.text,
                                      'company_profile':reportController.text,
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Fund My Business')),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        onSurface: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ValuationPage()),
                        ); // Navigate back to first route when tapped.
                      },
                      child: const Text('Value My Business')),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        onSurface: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DealRoom()),
                        ); // Navigate back to first route when tapped.
                      },
                      child: Text('$smeRob Fair Value [$valuation]', style:TextStyle(fontSize:12))),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
  Widget listExpenses({required Map revenue}) {
    //print( _containerVisibilities[revenue['key']+"m"]);
    final country=selectedCountry1.split(" ");
    final rang=range1.split(",");
    final sector=selectedSecta1.toUpperCase();
    double lower=double.parse(rang[0])*1000;
    double upper=double.parse(rang[1])*1000;
    double actual=double.parse(revenue['askingPrice']);

    // print("i found "+machine['country']+" compared to "+country[0]);
    if(((actual>lower && actual<upper) || range1=="0,100")&&(revenue['country']==country[0] || selectedCountry1=="ALL") && (revenue['industry'].toUpperCase()==sector.toUpperCase() || sector.toUpperCase()=="ALL"))
    {
    return
      Column(children: [
        Visibility(
          visible: _containerVisibilities[revenue['key'] + "m"] ?? false,
          child: Container(

            padding: const EdgeInsets.all(20),

            child:Container(

              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      revenue['image1'],),
                    fit: BoxFit.cover),
              ),
              child:Container(

                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                  ),child: Column(
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(

                    children: [
                      Expanded(child: Text('')),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              toggleContainerVisibility(revenue['key']);
                            },
                            child: Text("Click For Terms",
                              textAlign: TextAlign.right,
                              style: TextStyle(

                                color: Colors.white,
                                background: Paint()
                                  ..color = Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],),
                    ],),
                  SizedBox(height: 55),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(revenue['smeName'] + "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          background: Paint()
                            ..color = Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],),
                  Divider(
                    color: Colors.white,
                    thickness: 3,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(revenue['buy'] + "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          background: Paint()
                            ..color = Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],),
                  SizedBox(height: 55),
                  Row(

                    children: [
                      Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Required Funding",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                background: Paint()
                                  ..color = Colors.black.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text("      \$" + revenue['askingPrice'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                background: Paint()
                                  ..color = Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ])),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Fair Value",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              background: Paint()
                                ..color = Colors.black.withOpacity(0.5),
                            ),
                          ),
                          ElevatedButton(onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DealRoom()),
                            ); // Navigate back to first route when tapped.
                          }, child: Text("\$" + revenue['fairValue'])),
                        ],),
                    ],),

                ],
              )
            ),
            )
            ,),
        ),
        Visibility(
            visible: _containerVisibilities[revenue['key'] + "s"] ?? false,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                Row(

                  children: [
                    Expanded(child: Text('')),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            toggleContainerVisibility(revenue['key']);
                          },
                          child: Text("Return",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,

                            ),
                          ),
                        ),

                      ],),
                  ],),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(revenue['smeName'] + "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(revenue['motive'] + "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],),
                Divider(
                  color: Colors.black,
                  thickness: 3,
                ),
                Center(
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(children: [
                          Text("Total Funding"),
                          Text("Minimum Funding"),
                        ]),
                        TableRow(children: [
                          Container(
                            color: Colors.black,
                            child: (Text(
                              "\$" + revenue['askingPrice'], style: TextStyle(
                              color: Colors.white,
                            ),)),
                          ),
                          Container(
                            color: Colors.black,
                            child: (Text(
                              "\$" + revenue['minFund'], style: TextStyle(
                              color: Colors.white,
                            ),)),
                          ),
                        ]),
                        TableRow(children: [
                          Text("Revenue/ Year"),
                          Text("Profit/ Year"),
                        ]),
                        TableRow(children: [
                          Container(
                            color: Colors.black,
                            child: (Text(
                              "\$" + revenue['revenueYear'], style: TextStyle(
                              color: Colors.white,
                            ),)),
                          ),
                          Container(
                            color: Colors.black,
                            child: (Text(
                              "\$" + revenue['profitYear'], style: TextStyle(
                              color: Colors.white,
                            ),)),
                          ),
                        ]),
                        TableRow(children: [
                          Text("Gross Margin"),
                          Text("Profit Margin"),
                        ]),
                        TableRow(children: [
                          Container(
                            color: Colors.black,
                            child: (Text(
                              revenue['grossMargin'] + "%", style: TextStyle(
                              color: Colors.white,
                            ),)),
                          ),
                          Container(
                            color: Colors.black,
                            child: (Text(
                              revenue['profitMargin'] + "%", style: TextStyle(
                              color: Colors.white,
                            ),)),
                          ),
                        ]),
                        TableRow(children: [
                          Text("Revenue Multiple"),
                          Text("Profit Multiple"),
                        ]),
                        TableRow(children: [
                          Container(
                            color: Colors.black,
                            child: (Text(revenue['revenueMultiple'] + "X",
                              style: TextStyle(
                                color: Colors.white,
                              ),)),
                          ),
                          Container(
                            color: Colors.black,
                            child: (Text(
                              revenue['profitMultiple'] + "X", style: TextStyle(
                              color: Colors.white,
                            ),)),
                          ),
                        ]),
                        TableRow(children: [
                          Text("Operating Years"),
                          Text("Industry"),
                        ]),
                        TableRow(children: [
                          Container(
                            color: Colors.black,
                            child: (Text(
                              revenue['operatingYears'], style: TextStyle(
                              color: Colors.white,
                            ),)),
                          ),
                          Container(
                            color: Colors.black,
                            child: (Text(revenue['industry'].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                              ),)),
                          ),
                        ]),
                        TableRow(children: [
                          Text("City/ Town"),
                          Text("Country"),
                        ]),
                        TableRow(children: [
                          Container(
                            color: Colors.black,
                            child: (Text(revenue['city'], style: TextStyle(
                              color: Colors.white,
                            ),)),
                          ),
                          Container(
                            color: Colors.black,
                            child: (Text(revenue['country'], style: TextStyle(
                              color: Colors.white,
                            ),)),
                          ),
                        ]),


                      ],
                    )
                ),
                ElevatedButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      onSurface: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      registerInvestor(); // Navigate back to first route when tapped.
                    },
                    child: const Text('View More Details')),

              ]),
            ))
      ],);
  }
  else{
    return const Text("No Deals Found");
  }


  }

  @override
  void initState() {
    super.initState();
    String mail = user?.email ?? 'email';
    String ey="";
    setState(() {
      
    });

    FirebaseDatabase.instance
        .ref()
        .child('/Selling')
        .onChildAdded
        .listen((event)
    {
      Map revenue = event.snapshot.value as Map;

      setState(() {
        ey = event.snapshot.key ?? "";
        _containerVisibilities[ey+"m"]=true;
        _containerVisibilities[ey+"s"]=false;
      });
    });
    FirebaseDatabase.instance
        .ref()
        .child(actualMonthRef + '/latestValuation/')
        .onChildAdded
        .listen((event) {
      Map revenue = event.snapshot.value as Map;
      if (revenue['user'] == uid) {
        setState(() {
          valuation = revenue['amount'];
        });
      }
    });
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
          UserName = user['fname'];
        });
      }
    });

    //returnDialog();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      returnDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          //test dropdown
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
          //test dropdown
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body:
          SingleChildScrollView(child:Column(
            children: [

          Container(
          padding: EdgeInsets.all(16),
            child: Row(children:[
              Expanded(child:
              Container(


                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),

                ),
                child:
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: InputBorder.none,
                    labelText:"Country"
                  ),
                  items: africanCountries.map((country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (selectedCountry20) {
                   setState(() {
                        selectedCountry1=selectedCountry20 ?? "";

                      });
                  },
                ),),
              ),
            ])),
              Container(
            padding: EdgeInsets.all(16),
            child: Row(children:[
              Expanded(child:
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child:
                DropdownButtonFormField<String>(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: InputBorder.none,
                    ),
                    value:"0,100",
                    items:[
                      DropdownMenuItem(child:Text('-Deal Size[USD]-',textAlign: TextAlign.center),value:'0,100'),

                      DropdownMenuItem(child:Text('10 to 20K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'10,20'),
                      DropdownMenuItem(child:Text('20 to 30K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'20,30'),
                      DropdownMenuItem(child:Text('30 to 40K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'30,40'),
                      DropdownMenuItem(child:Text('40 to 50K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'40,50'),
                      DropdownMenuItem(child:Text('50 to 60K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'50,60'),
                      DropdownMenuItem(child:Text('60 to 70K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'60,70'),
                      DropdownMenuItem(child:Text('70 to 80K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'70,80'),
                      DropdownMenuItem(child:Text('80 to 90K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'80,90'),
                      DropdownMenuItem(child:Text('90 T0 100K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'90,100'),
                    ],
                    onChanged:(value){
                      setState((){
                        range1=value ?? '';
                      });
                    }
                ),),
              ),
              const Text("   "),
              Expanded(child:Container(

              decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(5.0),
    ),
    child: DropdownButtonFormField<String>(
                value: "-Sector-",
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: InputBorder.none,
      ),
                onChanged: (value) {
                  setState(() {
                    selectedSecta1 = value ?? "";
                  });
                },
                style: TextStyle(color: Colors.black),
                items: [
                  DropdownMenuItem(
                    value: '-Sector-',
                    child: Text('-Sector-'),
                  ),
                  DropdownMenuItem(
                    value: 'agriculture',
                    child: Text('Agriculture',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'automotive',
                    child: Text('Automotive',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'banking',
                    child: Text('Banking',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'construction',
                    child: Text('Construction',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'education',
                    child: Text('Education',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'energy',
                    child: Text('Energy',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'entertainment',
                    child: Text('Entertainment',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'finance',
                    child: Text('Finance',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'food and beverage',
                    child: Text('Food and Beverage',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'healthcare',
                    child: Text('Healthcare',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'hospitality',
                    child: Text('Hospitality',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'insurance',
                    child: Text('Insurance',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'manufacturing',
                    child: Text('Manufacturing',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'media',
                    child: Text('Media',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'real estate',
                    child: Text('Real Estate',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'retail',
                    child: Text('Retail',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'technology',
                    child: Text('Technology',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'telecommunications',
                    child: Text('Telecommunications',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'transportation',
                    child: Text('Transportation',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'utilities',
                    child: Text('Utilities',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                ],
              ),),
              ),

            ])
          ),
    Container(
    padding: EdgeInsets.all(16),
    child: Row(children:[

    Expanded(child:
    Container(
    decoration: BoxDecoration(
    color: Colors.orange,
    borderRadius: BorderRadius.circular(5.0),
    ),
    child:
    ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.orange, // Set the background color to orange
        ),
        onPressed: (){
              Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DealRoom()),);
    }, child: Text("Find Deal"))),
    )
    ]),),
              SingleChildScrollView(
                  child: Container(
                    height:500,
                    padding: const EdgeInsets.all(20),
                    child:
              FirebaseAnimatedList(
                shrinkWrap: true,
                query: dbRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map revenue = snapshot.value as Map;
                  revenue['key'] = snapshot.key;

                  return listExpenses(revenue: revenue);
                },
              ),)),

            ],
          ),),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}






















class AddMachinePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AddMachinePage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  AddMachinePageState createState() => AddMachinePageState();
}

class AddMachinePageState extends State<AddMachinePage> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 2;


int countImages=0;
  final _formKey = GlobalKey<FormState>();
  final _machineNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _sectorController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _historyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _spec1Controller = TextEditingController();
  final _spec2Controller = TextEditingController();
  final _spec3Controller = TextEditingController();
  final _spec4Controller = TextEditingController();
  final _contactController = TextEditingController();
  final _imageAccessTokenController=TextEditingController();
  final _imageAccessTokenController1=TextEditingController();
  final _imageAccessTokenController2=TextEditingController();
  final _imageAccessTokenController3=TextEditingController();
  final _imageAccessTokenController4=TextEditingController();
    final ownerController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  //List<String> _imageUrls = [];
  String _imageUrls = "";
 File? _image;
Future<String> uploadImageToFirebaseStorage(File image) async{
  final storageRef=FirebaseStorage.instance.ref().child("images/");
  final uploadTask=storageRef.putFile(image);
  await uploadTask.whenComplete(() => storageRef.putFile(image));
  final downloadUrl = await storageRef.getDownloadURL();

  return downloadUrl;
}
 void _uploadImage() async {

  final image=await ImagePicker().pickImage(source: ImageSource.gallery);
   setState((){
     _image=File(image!.path);
   });

  Random random = Random();
  int randomNumber = random.nextInt(1000000) + 1;
  final Reference storageReference = FirebaseStorage.instance.ref().child(randomNumber.toString());
  final UploadTask uploadTask = storageReference.putFile(File(image!.path));
  await uploadTask.whenComplete(() async {
    final String downloadUrl = await storageReference.getDownloadURL();
    setState(() {
      countImages++;
      if(countImages==1){
      _imageAccessTokenController1.text=downloadUrl;
      }
      if(countImages==2){
      _imageAccessTokenController2.text=downloadUrl;
      }
      if(countImages==3){
      _imageAccessTokenController3.text=downloadUrl;
      }
      if(countImages==4){
      _imageAccessTokenController4.text=downloadUrl;
      }
    });
  });
 }

  void _submitForm() {
      
    if (_formKey.currentState!.validate()) {
      // Save form data to Firebase Realtime Database
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('machines');
      DateTime now= DateTime.now();
      databaseReference.push().set({
        'machineName': _machineNameController.text,
        'price': _priceController.text,
        'condition': 'Used', // TODO: Implement condition selection
        'brand': _brandController.text,
        'model': _modelController.text,
        'year': _yearController.text,
        'sector': _sectorController.text,
        'city': _cityController.text,
        'country': _countryController.text,
        'history': _historyController.text,
        'description': _descriptionController.text,
        'spec1': _spec1Controller.text,
        'spec2': _spec2Controller.text,
        'spec3': _spec3Controller.text,
        'spec4': _spec4Controller.text,
        'contact': _contactController.text,
        'imageUrls': _imageAccessTokenController1.text,
        'imageUrls2': _imageAccessTokenController2.text,
        'imageUrls3': _imageAccessTokenController3.text,
        'imageUrls4': _imageAccessTokenController4.text,
        'creation_date':DateFormat('yyyy-MM-dd').format(now),
        'uid':uid,
        'owner':ownerController.text,
        'phone':phoneController.text,
        'email':emailController.text,
        'status':"Pending Approval"
      });

      // Clear form data
      setState(() {
        _imageAccessTokenController.clear();
        _machineNameController.clear();
        _priceController.clear();
        _brandController.clear();
        _modelController.clear();
        _yearController.clear();
        _sectorController.clear();
        _cityController.clear();
        _countryController.clear();
        _historyController.clear();
        _descriptionController.clear();
        _spec1Controller.clear();
        _spec2Controller.clear();
        _spec3Controller.clear();
        _contactController.clear();
        ownerController.clear();
        phoneController.clear();
        emailController.clear();

      });
      Fluttertoast.showToast(
        msg: 'Thank you. One of our Advisors will contact you',
        toastLength: Toast.LENGTH_LONG, // or Toast.LENGTH_LONG
        gravity: ToastGravity.BOTTOM, // or other positions like TOP, CENTER
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RetrieveMachinePage()),);
    }
  }

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }
String sme='',currency='';

  @override
  void initState() {
    super.initState();

     // <-- Their email
    String mail = user?.email ?? 'email';

    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });



  }


  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          //Initialize the chart widget
          Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          onSurface: Colors.white,
                          backgroundColor: Colors.blue,
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RetrieveMachinePage()),); // Navigate back to first route when tapped.
                        },
                        child: const Text('     Machine Exchange   ')),
              Row(
              children: [
              Expanded(
              child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RetrieveMyMachinePage()),);},
              icon: Icon(Icons.list_alt),
              label: Text('My Listings'),
            ),
          ),
          Expanded(
            child: Text('Quickly sell the machine to other small businesses'),
          ),
        ],
      ),
      SizedBox(height: 16.0),

      TextFormField(
        controller: _machineNameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 3.0),
          ),
          labelText: 'Type Machine Name',
        ),
        style: TextStyle(fontSize: 18.0),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16.0),
      Container(
          padding: EdgeInsets.all(16),
        child:const Text("Overview",
        style:TextStyle(
            fontSize: 20,
            fontWeight:FontWeight.bold,

        ),
        ),
      ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // Set the border color to black
                          width: 1.0, // Set the border width
                        ),
                      ),
                      child:
                      Container(
                        padding: EdgeInsets.all(16),
                      child:Column(
                        children: [
                          TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.blue, width: 3.0),
                              ),
                              labelText: 'Enter Price',
                            ),
                            keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                          ),
                          SizedBox(height: 8.0),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.blue, width: 3.0),
                              ),
                              labelText: 'Select Condition',
                            ),
                            value: 'Used',
                            items: ['Used', 'Not Used']
                                .map((String value) =>
                                DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                                .toList(),
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _brandController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.blue, width: 3.0),
                              ),
                              labelText: 'Brand',
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _modelController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.blue, width: 3.0),
                              ),
                              labelText: 'Model',
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _yearController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.blue, width: 3.0),
                              ),
                              labelText: 'Year',
                            ),
                            keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                          ),
                          SizedBox(height: 8.0),
                          DropdownButtonFormField<String>(
                            value: "-Sector-",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _sectorController.text = value ?? "";
                              });
                            },
                            style: TextStyle(color: Colors.black),
                            items: [
                              DropdownMenuItem(
                                value: '-Sector-',
                                child: Text('-Sector-'),
                              ),
                              DropdownMenuItem(
                                value: 'agriculture',
                                child: Text('Agriculture',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'automotive',
                                child: Text('Automotive',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'banking',
                                child: Text('Banking',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'construction',
                                child: Text('Construction',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'education',
                                child: Text('Education',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'energy',
                                child: Text('Energy',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'entertainment',
                                child: Text('Entertainment',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'finance',
                                child: Text('Finance',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'food and beverage',
                                child: Text('Food and Beverage',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'healthcare',
                                child: Text('Healthcare',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'hospitality',
                                child: Text('Hospitality',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'insurance',
                                child: Text('Insurance',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'manufacturing',
                                child: Text('Manufacturing',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'media',
                                child: Text('Media',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'real estate',
                                child: Text('Real Estate',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'retail',
                                child: Text('Retail',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'technology',
                                child: Text('Technology',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'telecommunications',
                                child: Text('Telecommunications',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'transportation',
                                child: Text('Transportation',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                              DropdownMenuItem(
                                value: 'utilities',
                                child: Text('Utilities',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.blue, width: 3.0),
                              ),
                              labelText: 'City',
                            ),
                          ),
                          SizedBox(height: 8.0),

                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(labelText: 'Select Country'),
                            items: africanCountries.map((country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Text(country),
                              );
                            }).toList(),
                            onChanged: (selectedCountry20) {

                              setState(() {
                                _countryController.text=selectedCountry20 ?? "";

                              });
                            },
                          ),
                        ],
                      ),
                    ),),
                    const SizedBox(height:16),
                    SizedBox(height: 16.0),
                    Text('Images',style:
                    TextStyle(fontWeight:
                    FontWeight.bold,fontSize:
                    20),),
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, // Set the border color to black
            width: 1.0, // Set the border width
          ),
        ),
        child:Center( child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload up to four pictures'),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () async {
                // TODO: Implement image selection and upload
                // List<String> imagePaths = ['path1', 'path2']; // Example image paths
                // await _uploadImages(imagePaths);

                _uploadImage();

              },
              child: Text('Upload Images'),
            ),
          ],
        ),
        )
      ),
                    SizedBox(height: 16.0),
                    Text('History',style:
                    TextStyle(fontWeight:
                    FontWeight.bold,fontSize:
                    20),),
                    SizedBox(height: 8.0),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      controller: _historyController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blue, width: 3.0),
                        ),
                        hintText:
                        'Enter the history of the machine (optional)',
                      ),

                    ),
                    SizedBox(height: 16.0),
                    Text('Description',style:
                    TextStyle(fontWeight:
                    FontWeight.bold,fontSize:
                    20),),
                    SizedBox(height: 8.0),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      controller: _descriptionController,
                      decoration:
                      InputDecoration(
                          border:
                          OutlineInputBorder(borderSide:
                          BorderSide(color:
                          Colors.blue,width:
                          3.0)),hintText:
                      "Enter the description of the machine (optional)",labelStyle:
                      TextStyle(fontWeight:
                      FontWeight.bold),labelText:
                      "Description",alignLabelWithHint:true),

                    ),
                    SizedBox(height:
                    16.0,),
      Container(
        padding: EdgeInsets.all(16),child:
      const Text("Specifications",style:TextStyle(
          fontSize:20,
          fontWeight:
      FontWeight.bold))),
                    Row(children:
                    [Expanded(child:
                    Column(children:
                    [TextFormField(controller:_spec1Controller,decoration:
                    InputDecoration(
                        border:
                        OutlineInputBorder(borderSide:
                        BorderSide(color:
                        Colors.blue,width:
                        3.0)),hintText:
                    "Enter Specification 1",labelStyle:
                    TextStyle(fontWeight:
                    FontWeight.bold),labelText:"Enter Specification 1",alignLabelWithHint:true),),
                      SizedBox(height: 8.0,),
                      TextFormField(controller:_spec2Controller,decoration:
                      InputDecoration(border:
                      OutlineInputBorder(borderSide:
                      BorderSide(color:
                      Colors.blue,width:
                      3.0)),hintText:"Enter Specification 2",labelStyle:
                      TextStyle(fontWeight:
                      FontWeight.bold),labelText:"Enter Specification 2",alignLabelWithHint:true),),SizedBox(height:
                    8.0,),TextFormField(controller:_spec3Controller,decoration:
                    InputDecoration(border:
                    OutlineInputBorder(borderSide:
                    BorderSide(color:
                    Colors.blue,width:
                    3.0)),hintText:"Enter Specification 3",labelStyle:
                    TextStyle(fontWeight:
                    FontWeight.bold),labelText:"Enter Specification 3",alignLabelWithHint:true),),SizedBox(height:
                    8.0,),TextFormField(controller:_spec4Controller,decoration:
                    InputDecoration(border:
                    OutlineInputBorder(borderSide:
                    BorderSide(color:
                    Colors.blue,width:
                    3.0)),hintText:"Enter Specification 4",labelStyle:
                    TextStyle(fontWeight:
                    FontWeight.bold),labelText:"Enter Specification 4",alignLabelWithHint:true),),],),),
                    ],

                    ),
                    const SizedBox(height:16),
                    Container(
                        padding: EdgeInsets.all(16),child:
                    const Text("Contact Details",style:TextStyle(
                        fontSize:20,
                        fontWeight:
                        FontWeight.bold))),
                    Column(children:[

                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller:_contactController,decoration:

                      InputDecoration(border:

                      OutlineInputBorder(borderSide:

                      BorderSide(color:

                      Colors.blue,width:

                      3.0)),hintText:

                      "Enter your address details",labelStyle:

                      TextStyle(fontWeight:

                      FontWeight.bold),labelText:

                      "Address Details",alignLabelWithHint:true),),
                      TextFormField(
                          controller:ownerController,
                          decoration:InputDecoration(
                            hintText:"Enter Owner Full Name",
                            labelText:"Enter Owner Full Name",
                          )
                      ),
                      TextFormField(
                          controller:emailController,
                          decoration:InputDecoration(
                            hintText:"Enter Email",
                            labelText:"Enter Email",
                          )
                      ),
                      TextFormField(
                          controller:phoneController,
                          decoration:InputDecoration(
                            hintText:"Enter Phone Number",
                            labelText:"Enter Phone Number",
                          )
                      ),
                      SizedBox(height:

                      16.0,),


                    ],),
                    const SizedBox(height:16),
                    ElevatedButton(onPressed:_submitForm,

                      child:

                      Text('List Machine'),

                      style:

                      ElevatedButton.styleFrom(

                        primary:

                        Colors.blue,

                        onPrimary:

                        Colors.white,

                        padding:

                        EdgeInsets.symmetric(

                          vertical:

                          16.0,

                          horizontal:

                          32.0,

                        ),

                        textStyle:

                        TextStyle(

                          fontSize:

                          20,

                          fontWeight:

                          FontWeight.bold,

                        ),

                      ),

                    ),








      ],),
            ),),],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}


class RetrieveMachinePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  RetrieveMachinePage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  RetrieveMachinePageState createState() => RetrieveMachinePageState();
}

class RetrieveMachinePageState extends State<RetrieveMachinePage> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 2;


final Map<String, bool> _containerVisibilities = {};
void toggleContainerVisibility(String id){

  String m=id;

  setState(() {

        _containerVisibilities["main"] = false;
        _containerVisibilities[m] = true;
  });

}

 String _selectedSector="";



  Widget listMachines({required Map machine}) {
if(machine['status'] == "Approved"){
    return Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width:100,
                  height:100,
                  padding: EdgeInsets.all(20),
                  child:
                 machine['imageUrls'] != null && machine['imageUrls'].isNotEmpty ?
                  Image.network(
                        machine['imageUrls'],
                        fit: BoxFit.cover,
                      ) : Container(),
                )


              ]),
              Expanded(
                child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(
                                         machine['machineName'],
                                         style: TextStyle(
                                           fontSize: 15,
                                           fontWeight: FontWeight.bold,
                                         ),
                                       ),
                                       SizedBox(height: 12),
                                       Center(child:Table(
                                         children:[
                                           TableRow(
                                             children: [
                                               const Text('Price:',
                                                 style: TextStyle(

                                                     fontSize: 12,

                                                   fontWeight: FontWeight.bold,
                                                 ),
                                               ),
                                               Text('${machine['price']}',
                                                 style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                             ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Brand:',
                                                   style: TextStyle(

                                                       fontSize: 12,

                                                     fontWeight: FontWeight.bold,
                                                   ),
                                                 ),
                                                 Text('${machine['brand']}',
                                                   style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Model:',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 12,
                                                   ),
                                                 ),
                                                 Text('${machine['model']}',
                                                   style: TextStyle(
                                                     fontSize: 12,
                                                   ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Year:',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 12
                                                   ),
                                                 ),
                                                 Text('${machine['year']}',style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Sector:',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 12,
                                                   ),
                                                 ),
                                                 Text('${machine['sector']}',style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('City:',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 12,
                                                   ),
                                                 ),
                                                 Text('${machine['city']}',style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Country:',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 12,
                                                   ),
                                                 ),
                                                 Text('${machine['country']}',style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('',

                                                 ),
                                                 ElevatedButton(onPressed: (){
                                                   toggleContainerVisibility(machine['key']);
                                                 }, child:
                                                 Text('View Details')
                                                 ),
                                               ]
                                           ),
                                         ]
                                       )),

                                     ],
                                   ),

              ),
            ]);
  }
    else {
  return Center(
  child: Text("No Machine Found")
  );
  }

  }


    Widget listMachineDetails({required Map machine}) {


    return
Column(children: [
Visibility(
visible: _containerVisibilities[machine['key']] ?? false,
child:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:[
  Center(child:
   Text(
                                         machine['machineName'],
                                         style: TextStyle(
                                           fontSize: 20,
                                           fontWeight: FontWeight.bold,
                                         ),
                                       ),
                                      ),
  Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width:100,
                  height:100,
                  padding: EdgeInsets.all(20),
                  child:
                 machine['imageUrls'] != null && machine['imageUrls'].isNotEmpty ?
                  Image.network(
                        machine['imageUrls'],
                        fit: BoxFit.cover,
                      ) : Container(),
                )


              ]),
              Expanded(
                child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [

                                       Center(child:Table(
                                         children:[
                                           TableRow(
                                             children: [
                                               const Text('Price:',
                                                 style: TextStyle(

                                                     fontSize: 12,

                                                   fontWeight: FontWeight.bold,
                                                 ),
                                               ),
                                               Text('${machine['price']}',
                                                 style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                             ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Brand:',
                                                   style: TextStyle(

                                                       fontSize: 12,

                                                     fontWeight: FontWeight.bold,
                                                   ),
                                                 ),
                                                 Text('${machine['brand']}',
                                                   style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Model:',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 12,
                                                   ),
                                                 ),
                                                 Text('${machine['model']}',
                                                   style: TextStyle(
                                                     fontSize: 12,
                                                   ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Year:',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 12
                                                   ),
                                                 ),
                                                 Text('${machine['year']}',style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Sector:',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 12,
                                                   ),
                                                 ),
                                                 Text('${machine['sector']}',style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('City:',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 12,
                                                   ),
                                                 ),
                                                 Text('${machine['city']}',style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Country:',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 12,
                                                   ),
                                                 ),
                                                 Text('${machine['country']}',style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),

                                         ]
                                       )),

                                     ],
                                   ),

              ),
            ]),
            Container(
            padding: EdgeInsets.all(16),
            child:
  const Text(
    " History",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),),
  Container(
            padding: EdgeInsets.all(16),
            child:
  Text(
    "  "+machine['history'],
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
  ),),
  const SizedBox(height:5),
  Container(
            padding: EdgeInsets.all(16),
            child:
  const Text(
    " Description",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),),
Container(
            padding: EdgeInsets.all(16),
            child:
  Text(
    "  "+machine['description'],
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
  ),
),
  const SizedBox(height:5),
  Container(
            padding: EdgeInsets.all(16),
            child:
  const Text(
    " Specifications",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),),
  Container(
            padding: EdgeInsets.all(16),
            child:
  Text(
    "  -"+machine['spec1']+"\n  -"+machine['spec2']+"\n  -"+machine['spec3'],
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
  ),),
  const SizedBox(height:5),
  Container(
            padding: EdgeInsets.all(16),
            child:
      const Text(
        " Contact Details",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),),
      Container(
            padding: EdgeInsets.only(left:16),
            child:
      Row(children:[
        Text("  Name: "+machine['owner']),

      ]),),
      Container(
            padding: EdgeInsets.only(left:16),child:
      Row(children:[
        Text("  Email: "+machine['email']+"    "),
      InkWell(
      child: Icon(Icons.email),
      onTap: () async {

    final url = 'mailto://' + machine['email'];

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },
      )
      ]),),
      Container(
            padding: EdgeInsets.only(left:16), child:
         Row(children:[
        Text("  Phone: "+machine['phone']+"    "),
      InkWell(
      child: const Icon(FontAwesomeIcons.whatsapp),
        highlightColor: Colors.green,
        splashColor: Colors.green,
      onTap: () async {
    String phone=machine["phone"];
    String message="hi";
    final url ='https://wa.me/$phone?text=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },
      ),Expanded(
             child:Text("       ")
           ),
            ElevatedButton(
             onPressed: () {

                FirebaseDatabase.instance.ref("machines/" + machine['key']).remove();


               Navigator.pop(context);
             },
             style: ElevatedButton.styleFrom(
               primary: Colors.red, // Background color
             ),
             child: const Text('Delete'),
           ),
      ]),),
      const SizedBox(height:5),
      Row(children:[
        Expanded(child:
        ElevatedButton(onPressed:() async {
          final String text = 'Hello, there is a '+machine['machineName']+' machine up for grabs visit kupfuma.com!';
          final String url = 'whatsapp://send?text=${Uri.encodeFull(text)}';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child:
        Row(children:[Text("Share - "),Icon(FontAwesomeIcons.whatsapp)
      ])

        )
          ,
        ),
        Expanded(child:
        ElevatedButton(onPressed:() async {
          final String subject = 'Kupfuma Machine For Sale';
          final String body = 'Hello, there is a '+machine['machineName']+' machine up for grabs visit kupfuma.com!';
          final String url = 'mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
            child:
            Row(children:[const Text("Share - "),const Icon(Icons.email),
            ])

        )
          ,
        ),
      ]),
])),
],);



  }


  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }
  String sme='',currency='';
  late DatabaseReference _databaseReference;
  List<Machine> _machineList = [];
  late Query dbRef;
  int listCount=0;
  @override
  void initState() {
    super.initState();
_containerVisibilities["main"]=true;
     // <-- Their email
    String mail = user?.email ?? 'email';
dbRef = FirebaseDatabase.instance
        .ref()
        .child('machines/');
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });

 FirebaseDatabase.instance.ref().child('machines/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;

        setState(() {
          listCount++;
        });

    });

 _databaseReference =
        FirebaseDatabase.instance.reference().child('machines');
    _databaseReference.onChildAdded.listen((event) {
      setState(() {
        _machineList.add(Machine.fromSnapshot(event.snapshot));
      });
    });


  }

String selectedSector="";
  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    final scrollController=ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color:Colors.black,
            child:
             ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                            primary: Colors.black, 
                          ),
                          onPressed: () {
                               Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RetrieveMachinePage()),); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Machine Exchange   ')),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddMachinePage()),
      );
            },
            child: Text('List Machine'),
          ),
             Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Buy affordable used machines for your small business directly from other small near you ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            child: Row(children:[
              Expanded(child:
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child:
                DropdownButtonFormField<String>(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: InputBorder.none,
                    ),
                    value:"0,100",
                    items:[
                      DropdownMenuItem(child:Text('-Price[USD]-',textAlign: TextAlign.center),value:'0,100'),
                      DropdownMenuItem(child:Text('0 to 0.5K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'0,0.5'),
                      DropdownMenuItem(child:Text('0.5 to 1K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'0.5,1'),
                      DropdownMenuItem(child:Text('1 to 2K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'1,2'),
                      DropdownMenuItem(child:Text('2 to 5K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'2,5'),
                      DropdownMenuItem(child:Text('5 to 10K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'5,10'),
                      DropdownMenuItem(child:Text('10K+',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'10,1000')
                    ],
                    onChanged:(value){
                      setState((){
                        range=value ?? '';
                      });
                    }
                ),),
              ),
              const Text("   "),
              Expanded(child:Container(

              decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(5.0),
    ),
    child: DropdownButtonFormField<String>(
                value: "-Sector-",
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: InputBorder.none,
      ),
                onChanged: (value) {
                  setState(() {
                    selectedSecta = value ?? "";
                  });
                },
                style: TextStyle(color: Colors.black),
                items: [
                  DropdownMenuItem(
                    value: '-Sector-',
                    child: Text('-Sector-'),
                  ),
                  DropdownMenuItem(
                    value: 'agriculture',
                    child: Text('Agriculture',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'automotive',
                    child: Text('Automotive',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'banking',
                    child: Text('Banking',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'construction',
                    child: Text('Construction',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'education',
                    child: Text('Education',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'energy',
                    child: Text('Energy',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'entertainment',
                    child: Text('Entertainment',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'finance',
                    child: Text('Finance',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'food and beverage',
                    child: Text('Food and Beverage',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'healthcare',
                    child: Text('Healthcare',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'hospitality',
                    child: Text('Hospitality',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'insurance',
                    child: Text('Insurance',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'manufacturing',
                    child: Text('Manufacturing',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'media',
                    child: Text('Media',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'real estate',
                    child: Text('Real Estate',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'retail',
                    child: Text('Retail',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'technology',
                    child: Text('Technology',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'telecommunications',
                    child: Text('Telecommunications',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'transportation',
                    child: Text('Transportation',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                  DropdownMenuItem(
                    value: 'utilities',
                    child: Text('Utilities',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                  ),
                ],
              ),),
              ),

            ])
          ),
    Container(
    padding: EdgeInsets.all(16),
    child: Row(children:[
      Expanded(child:Container(

        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DropdownButtonFormField<String>(
          value: "Country",
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              selectedCountry = value ?? "";
            });
          },
          style: TextStyle(color: Colors.black),
          items: africanCountries.map((country) {
            return DropdownMenuItem<String>(
              value: country,
              child: Text(country),
            );
          }).toList(),
        ),),
      ),

const Text("     "),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.orange, // Set the background color to orange
        ),
      onPressed: (){
       
              Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchMachinePage()),);
    }, child: Text("Search"))
    ]),),
Visibility(


visible: _containerVisibilities["main"] ?? true,
  child:
          SingleChildScrollView(
  child: Container(
    height:200,
    child: 
      FirebaseAnimatedList(
        shrinkWrap: true,
        query: dbRef,
        controller:scrollController,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map machine = snapshot.value as Map;
          machine['key'] = snapshot.key;

          return listMachines(machine: machine);
        },
      ),
    
  ),
),

      ),
      SingleChildScrollView(
            child: Container(
              height:300,
              child:
              FirebaseAnimatedList(
                shrinkWrap: true,
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map machine = snapshot.value as Map;
                    machine['key'] = snapshot.key;

                    return listMachineDetails(machine: machine);
                  },
                ),
              
            ),
          ),
          
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class SearchMachinePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  SearchMachinePage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  SearchMachinePageState createState() => SearchMachinePageState();
}

class SearchMachinePageState extends State<SearchMachinePage> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 2;


  final Map<String, bool> _containerVisibilities = {};
  void toggleContainerVisibility(String id){

    String m=id;

    setState(() {

      _containerVisibilities["main"] = false;
      _containerVisibilities[m] = true;
    });

  }

  String _selectedSector="";



  Widget listMachines({required Map machine}) {
    final country = selectedCountry.split(" ");
    final rang = range.split(",");
    final sector = selectedSecta.toUpperCase();
    double lower = double.parse(rang[0]) * 1000;
    double upper = double.parse(rang[1]) * 1000;
    double actual = double.parse(machine['price']);

    print("i found " + machine['country'] + " compared to " + country[0]);
if(machine['status'] == "Approved"){
    if (((actual > lower && actual < upper) || range == "0,100") &&
        (machine['country'] == country[0] || selectedCountry == "ALL") &&
        (machine['sector'].toUpperCase() == sector.toUpperCase() ||
            sector.toUpperCase() == "ALL")) {
      return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 100,
                height: 100,
                padding: EdgeInsets.all(20),
                child:
                machine['imageUrls'] != null && machine['imageUrls'].isNotEmpty
                    ?
                Image.network(
                  machine['imageUrls'],
                  fit: BoxFit.cover,
                )
                    : Container(),
              )


            ]),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    machine['machineName'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Center(child: Table(
                      children: [
                        TableRow(
                            children: [
                              const Text('Price:',
                                style: TextStyle(

                                  fontSize: 12,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('${machine['price']}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),),
                            ]
                        ),
                        TableRow(
                            children: [
                              const Text('Brand:',
                                style: TextStyle(

                                  fontSize: 12,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('${machine['brand']}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),),
                            ]
                        ),
                        TableRow(
                            children: [
                              const Text('Model:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text('${machine['model']}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),),
                            ]
                        ),
                        TableRow(
                            children: [
                              const Text('Year:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                              Text('${machine['year']}', style: TextStyle(
                                fontSize: 12,
                              ),),
                            ]
                        ),
                        TableRow(
                            children: [
                              const Text('Sector:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text('${machine['sector']}', style: TextStyle(
                                fontSize: 12,
                              ),),
                            ]
                        ),
                        TableRow(
                            children: [
                              const Text('City:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text('${machine['city']}', style: TextStyle(
                                fontSize: 12,
                              ),),
                            ]
                        ),
                        TableRow(
                            children: [
                              const Text('Country:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text('${machine['country']}', style: TextStyle(
                                fontSize: 12,
                              ),),
                            ]
                        ),
                        TableRow(
                            children: [
                              const Text('',

                              ),
                              ElevatedButton(onPressed: () {
                                toggleContainerVisibility(machine['key']);
                              }, child:
                              Text('View Details')
                              ),
                            ]
                        ),
                      ]
                  )),

                ],
              ),

            ),
          ]));
    }
    else {
      return Center(
          child: Text("No Machine Found")
      );
    }
  }
  else {
  return Center(
  child: Text("No Machine Found")
  );
  }
  }


  Widget listMachineDetails({required Map machine}) {


    return
      Column(children: [
        Visibility(
            visible: _containerVisibilities[machine['key']] ?? false,
            child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Center(child:
                  Text(
                    machine['machineName'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                  Row(children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width:100,
                        height:100,
                        padding: EdgeInsets.all(20),
                        child:
                        machine['imageUrls'] != null && machine['imageUrls'].isNotEmpty ?
                        Image.network(
                          machine['imageUrls'],
                          fit: BoxFit.cover,
                        ) : Container(),
                      )


                    ]),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Center(child:Table(
                              children:[
                                TableRow(
                                    children: [
                                      const Text('Price:',
                                        style: TextStyle(

                                          fontSize: 12,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('${machine['price']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Brand:',
                                        style: TextStyle(

                                          fontSize: 12,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('${machine['brand']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Model:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text('${machine['model']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Year:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12
                                        ),
                                      ),
                                      Text('${machine['year']}',style: TextStyle(
                                        fontSize: 12,
                                      ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Sector:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text('${machine['sector']}',style: TextStyle(
                                        fontSize: 12,
                                      ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('City:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text('${machine['city']}',style: TextStyle(
                                        fontSize: 12,
                                      ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Country:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text('${machine['country']}',style: TextStyle(
                                        fontSize: 12,
                                      ),),
                                    ]
                                ),

                              ]
                          )),

                        ],
                      ),

                    ),
                  ]),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    const Text(
                      " History",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    Text(
                      "  "+machine['history'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),),
                  const SizedBox(height:5),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    const Text(
                      " Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    Text(
                      "  "+machine['description'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height:5),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    const Text(
                      " Specifications",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    Text(
                      "  -"+machine['spec1']+"\n  -"+machine['spec2']+"\n  -"+machine['spec3'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),),
                  const SizedBox(height:5),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    const Text(
                      " Contact Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                  Container(
                    padding: EdgeInsets.only(left:16),
                    child:
                    Row(children:[
                      Text("  Name: "+machine['owner']),

                    ]),),
                  Container(
                    padding: EdgeInsets.only(left:16),child:
                  Row(children:[
                    Text("  Email: "+machine['email']+"    "),
                    InkWell(
                      child: Icon(Icons.email),
                      onTap: () async {

                        final url = 'mailto://' + machine['email'];

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    )
                  ]),),
                  Container(
                    padding: EdgeInsets.only(left:16), child:
                  Row(children:[
                    Text("  Phone: "+machine['phone']+"    "),
                    InkWell(
                      child: const Icon(FontAwesomeIcons.whatsapp),
                      highlightColor: Colors.green,
                      splashColor: Colors.green,
                      onTap: () async {
                        String phone=machine["phone"];
                        String message="hi";
                        final url ='https://wa.me/$phone?text=${Uri.encodeFull(message)}';

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),Expanded(
                        child:Text("       ")
                    ),
                    ElevatedButton(
                      onPressed: () {

                        FirebaseDatabase.instance.ref("machines/" + machine['key']).remove();


                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Background color
                      ),
                      child: const Text('Delete'),
                    ),
                  ]),),
                  const SizedBox(height:5),

                ])),
      ],);



  }


  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }
  String sme='',currency='';
  late DatabaseReference _databaseReference;
  List<Machine> _machineList = [];
  late Query dbRef;
  @override
  void initState() {
    super.initState();
    _containerVisibilities["main"]=true;
     // <-- Their email
    String mail = user?.email ?? 'email';
    dbRef = FirebaseDatabase.instance
        .ref()
        .child('machines/');
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });
    _databaseReference =
        FirebaseDatabase.instance.reference().child('machines');
    _databaseReference.onChildAdded.listen((event) {
      setState(() {
        _machineList.add(Machine.fromSnapshot(event.snapshot));
      });
    });


  }

  String selectedSector="";
  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color:Colors.black,
            child:
            Text('Machine Exchange',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMachinePage()),
              );
            },
            child: Text('List Machine'),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Buy affordable used machines for your small business directly from other small near you ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(16),
              child: Row(children:[
                Expanded(child:
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child:
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Select Country'),
                    items: africanCountries.map((country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (selectedCountry20) {
                      setState(() {
                        selectedCountry=selectedCountry20 ?? "";

                      });


                    },
                  ),),
                ),
              ])),
          Container(
              padding: EdgeInsets.all(16),
              child: Row(children:[
                Expanded(child:
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child:
                  DropdownButtonFormField<String>(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: InputBorder.none,
                      ),
                      value:"0,100",
                      items:[
                        DropdownMenuItem(child:Text('-Price[USD]-',textAlign: TextAlign.center),value:'0,100'),
                        DropdownMenuItem(child:Text('0 to 0.5K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'0,0.5'),
                        DropdownMenuItem(child:Text('0.5 to 1K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'0.5,1'),
                        DropdownMenuItem(child:Text('1 to 2K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'1,2'),
                        DropdownMenuItem(child:Text('2 to 5K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'2,5'),
                        DropdownMenuItem(child:Text('5 to 10K',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'5,10'),
                        DropdownMenuItem(child:Text('10K+',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'10,1000')
                      ],
                      onChanged:(value){
                        setState((){
                          range=value ?? '';
                        });
                      }
                  ),),
                ),
                const Text("   "),
                Expanded(child:Container(

                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: "-Sector-",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedSecta = value ?? "";
                      });
                    },
                    style: TextStyle(color: Colors.white),
                    items: [
                      DropdownMenuItem(
                        value: '-Sector-',
                        child: Text('-Sector-'),
                      ),
                      DropdownMenuItem(
                        value: 'agriculture',
                        child: Text('Agriculture',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'automotive',
                        child: Text('Automotive',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'banking',
                        child: Text('Banking',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'construction',
                        child: Text('Construction',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'education',
                        child: Text('Education',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'energy',
                        child: Text('Energy',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'entertainment',
                        child: Text('Entertainment',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'finance',
                        child: Text('Finance',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'food and beverage',
                        child: Text('Food and Beverage',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'healthcare',
                        child: Text('Healthcare',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'hospitality',
                        child: Text('Hospitality',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'insurance',
                        child: Text('Insurance',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'manufacturing',
                        child: Text('Manufacturing',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'media',
                        child: Text('Media',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'real estate',
                        child: Text('Real Estate',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'retail',
                        child: Text('Retail',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'technology',
                        child: Text('Technology',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'telecommunications',
                        child: Text('Telecommunications',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'transportation',
                        child: Text('Transportation',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                      DropdownMenuItem(
                        value: 'utilities',
                        child: Text('Utilities',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),
                      ),
                    ],
                  ),),
                ),

              ])
          ),

          Container(
            padding: EdgeInsets.all(16),
            child: Row(children:[


              Expanded(child:
              Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child:
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange, // Set the background color to orange
                      ),
                      onPressed: (){

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchMachinePage()),);
                      }, child: Text("Find Machine"))),
              )
            ]),),
          Visibility(

            visible: _containerVisibilities["main"] ?? true,
            child:
            SingleChildScrollView(
              child: Column(
                children: [
                  FirebaseAnimatedList(
                    shrinkWrap: true,
                    query: dbRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map machine = snapshot.value as Map;
                      machine['key'] = snapshot.key;

                      return listMachines(machine: machine);
                    },
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height:400,
              child:
              FirebaseAnimatedList(
                shrinkWrap: true,
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map machine = snapshot.value as Map;
                    machine['key'] = snapshot.key;

                    return listMachineDetails(machine: machine);
                  },
                ),

            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Machine {
  final String machineName;
  final List<String> imageUrls;
  final String price;
  final String brand;
  final String model;
  final String year;
  final String sector;
  final String city;
  final String country;

  Machine({
    required this.machineName,
    required this.imageUrls,
    required this.price,
    required this.brand,
    required this.model,
    required this.year,
    required this.sector,
    required this.city,
    required this.country,
  });

factory Machine.fromSnapshot(DataSnapshot snapshot) {
  Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?;
  return Machine(
    machineName: data?['machineName'] ?? '',
    imageUrls: List<String>.from(data?['imageUrls'] ?? []),
    price: data?['price'] ?? '',
    brand: data?['brand'] ?? '',
    model: data?['model'] ?? '',
    year: data?['year'] ?? '',
    sector: data?['sector'] ?? '',
    city: data?['city'] ?? '',
    country: data?['country'] ?? '',
  );
}

}




//otherusers class start

class usersPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  usersPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  usersPageState createState() => usersPageState();
}

class usersPageState extends State<usersPage> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 2;



  final _formKey = GlobalKey<FormState>();
  final _machineNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _sectorController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _historyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _spec1Controller = TextEditingController();
  final _spec2Controller = TextEditingController();
  final _spec3Controller = TextEditingController();
  final _spec4Controller = TextEditingController();
  final _contactController = TextEditingController();
  final _imageAccessTokenController=TextEditingController();
  final ownerController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  //List<String> _imageUrls = [];
  String _imageUrls = "";
  File? _image;
  Future<String> uploadImageToFirebaseStorage(File image) async{
    final storageRef=FirebaseStorage.instance.ref().child("images/");
    final uploadTask=storageRef.putFile(image);
    await uploadTask.whenComplete(() => storageRef.putFile(image));
    final downloadUrl = await storageRef.getDownloadURL();

    return downloadUrl;
  }

  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }
  String sme='',currency='',a='',b='',c='',d='',e='',f='';

  TextEditingController smeNameController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController mainNumberController = new TextEditingController();
  TextEditingController smeNameController1 = new TextEditingController();
  TextEditingController userNameController1 = new TextEditingController();
  TextEditingController userName2Controller1 = new TextEditingController();
  TextEditingController mainNumberController1 = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  TextEditingController roleController = new TextEditingController();

  bool obscureText = true;

  @override
  void initState() {
    super.initState();

     // <-- Their email
    String mail = user?.email ?? 'email';

    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
          a= user['number'];
          b= user['desc'];
          c= user['sector'];
          d= user['assetNumber'];
        });
      }
    });



  }


  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),

      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),

            child:
          //Initialize the chart widget
          Container(
            padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set the border color to black
          width: 1.0, // Set the border width
        ),),
            child: Form(
              key: _formKey,
              child:
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Add User +',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      DropdownButtonFormField<String>(
                          style: TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            border: InputBorder.none,
                          ),
                          value:"Owner",
                          items:const [
                            DropdownMenuItem(child:Text('-Role-',textAlign: TextAlign.center),value:'Owner'),
                            DropdownMenuItem(child:Text('Accounts/ Admin',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'Accounts/ Admin'),
                            DropdownMenuItem(child:Text('Management',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'Management'),
                            DropdownMenuItem(child:Text('Investor',style: TextStyle(color: Colors.black, ),textAlign: TextAlign.center),value:'Investor'),
                            ],
                          onChanged:(value){
                            setState((){
                              roleController.text=value ?? '';
                            });
                          }
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Missing Required Field';
                          }
                          return null;
                        },
                        controller: userNameController1,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter First Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Missing Required Field';
                          }
                          return null;
                        },
                        controller: userName2Controller1,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Surname',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Missing Required Field';
                          }
                          return null;
                        },
                        controller: smeNameController1,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Email',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Missing Required Field';
                          }
                          return null;
                        },
                        controller: mainNumberController1,
                        keyboardType: TextInputType.text,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Password',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            icon: (Icon(Icons.lock)),
                            suffixIcon: IconButton(
                              icon: obscureText
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                obscureText = !obscureText;
                              },
                            )),
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MaterialButton(
                            // style: TextButton.styleFrom(
                            //   onSurface: Colors.white,
                            //   backgroundColor:Colors.blue,
                            //     minimumSize: const Size.fromHeight(50),
                            //
                            // ),
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                User? temp = Auth().currentUser;
                                String key = temp?.uid ?? 'uid';


                                  FirebaseDatabase.instance.ref('User' + '/' + key);
                                  Map<String, String> revenue1 = {
                                    'secondaryEmail': smeNameController1.text,
                                    'secondaryPassword': mainNumberController1.text,
                                    'secondaryUser': userNameController1.text,
                                    'role':roleController.text
                                  };
                                await FirebaseDatabase.instance.ref('User' + '/' + key+'/team/').push().set(revenue1);

                                  UserCredential userCredential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                      email: smeNameController1.text,
                                      password: mainNumberController1.text);
                                User? user = Auth().currentUser;

                                Map<String, String> user1 = {
                                  'sme': sme,
                                  'number': a,
                                  'fname': userNameController1.text,
                                  'sname': userName2Controller1.text,
                                  'email': smeNameController1.text,
                                  'desc':b,
                                  'currency':currency,
                                  'sector':c,
                                  'assetNumber':d,
                                  'type':'Secondary',
                                  'role':roleController.text,
                                  'password': mainNumberController1.text,
                                  'primaryUid':key

                                };
                                User? temp1 = Auth().currentUser;
                                String u = temp1?.uid ?? 'uid';
                                await FirebaseDatabase.instance.ref().child('User'+'/'+u).set(user1);


                                  //Send mail
                                final url = Uri.parse('https://kupfuma.com/testMail.php');
                                final headers = <String, String>{
                                  'Content-Type': 'application/json',
                                };
                                final body = <String, dynamic>{
                                  'role': roleController.text,
                                  'sme': sme,
                                  'name':userNameController1.text,
                                  'email':smeNameController1.text,
                                  'password':mainNumberController1.text
                                };

                                final response = await http.post(url, headers: headers, body: jsonEncode(body));

                                if (response.statusCode == 200) {
                                  print('Data posted successfully');
                                } else {
                                  print('Error posting data: ${response.statusCode}');
                                }


                                Auth().signOut();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignIn()),
                                  );

                                // reference.push().set(revenue);

                                SignIn;
                              }
                            },
                            child: const Text('Add User'),
                            color: Colors.blue,
                            textColor: Colors.white,
                            minWidth: 300,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                              style: TextButton.styleFrom(
                                onSurface: Colors.white,
                                backgroundColor: Colors.orange,
                                minimumSize: const Size.fromHeight(50),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Users List')),
                        ],
                      ),
                    ],
                  ),

            ),),)],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}


// otherusers class end

class RetrieveUsersPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  RetrieveUsersPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  RetrieveUsersPageState createState() => RetrieveUsersPageState();
}

class RetrieveUsersPageState extends State<RetrieveUsersPage> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 2;


final Map<String, bool> _containerVisibilities = {};
void toggleContainerVisibility(String id){

  String m=id;

  setState(() {

        _containerVisibilities["main"] = false;
        _containerVisibilities[m] = true;
  });

}

 String _selectedSector="";



  Widget listMachines({required Map machine}) {

    return Row(children: [

              Expanded(
                child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(
                                         machine['secondaryUser'],
                                         style: TextStyle(
                                           fontSize: 15,
                                           fontWeight: FontWeight.bold,
                                         ),
                                       ),
                                       SizedBox(height: 12),
                                       Center(child:Table(
                                         children:[
                                           TableRow(
                                             children: [
                                               const Text('Role:',
                                                 style: TextStyle(

                                                     fontSize: 12,

                                                   fontWeight: FontWeight.bold,
                                                 ),
                                               ),
                                               Text('${machine['role']}',
                                                 style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                             ]
                                           ),
                                           TableRow(
                                               children: [
                                                 const Text('Email:',
                                                   style: TextStyle(

                                                       fontSize: 12,

                                                     fontWeight: FontWeight.bold,
                                                   ),
                                                 ),
                                                 Text('${machine['secondaryEmail']}',
                                                   style: TextStyle(
                                                   fontSize: 12,
                                                 ),),
                                               ]
                                           ),

                                           TableRow(
                                               children: [
                                                 const Text('',

                                                 ),
                                                 ElevatedButton(onPressed: (){
                                                   String ki=machine['key'];
                                                   
                                                   FirebaseDatabase.instance.ref("User/" + uid+"/team/"+ki).remove();

                                                 }, child:
                                                 Text('Delete')
                                                 ),
                                               ]
                                           ),
                                         ]
                                       )),

                                     ],
                                   ),

              ),
            ]);


  }




  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }
  String sme='',currency='';
  late DatabaseReference _databaseReference;
  List<Machine> _machineList = [];
  late Query dbRef;
  int listCount=0;
  @override
  void initState() {
    super.initState();
    _containerVisibilities["main"]=true;
     // <-- Their email
    String mail = user?.email ?? 'email';
dbRef = FirebaseDatabase.instance
        .ref()
        .child('User/'+uid+'/team');
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });

 FirebaseDatabase.instance.ref().child('machines/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;

        setState(() {
          listCount++;
        });

    });

 _databaseReference =
        FirebaseDatabase.instance.reference().child('machines');
    _databaseReference.onChildAdded.listen((event) {
      setState(() {
        _machineList.add(Machine.fromSnapshot(event.snapshot));
      });
    });


  }

String selectedSector="";
  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    final scrollController=ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => usersPage()),
      );
            },
            child: Text('Add User'),
          ),
             Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Manage users here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
  Visibility(


visible: _containerVisibilities["main"] ?? true,
  child:
          SingleChildScrollView(
  child: Container(
    height:200,
    padding: const EdgeInsets.all(20),
    child: 
      FirebaseAnimatedList(
        shrinkWrap: true,
        query: dbRef,
        controller:scrollController,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map machine = snapshot.value as Map;
          machine['key'] = snapshot.key;
          return listMachines(machine: machine);
        },
      ),
  ),
),

      ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}


////// my listings
class RetrieveMyMachinePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  RetrieveMyMachinePage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  RetrieveMyMachinePageState createState() => RetrieveMyMachinePageState();
}

class RetrieveMyMachinePageState extends State<RetrieveMyMachinePage> {
  final User? user = Auth().currentUser;

  int _selectedIndex = 2;


  final Map<String, bool> _containerVisibilities = {};
  void toggleContainerVisibility(String id){

    String m=id;

    setState(() {

      _containerVisibilities["main"] = false;
      _containerVisibilities[m] = true;
    });

  }

  String _selectedSector="";



  Widget listMachines({required Map machine}) {
    if(machine['status'] == "Approved"){
      if(machine['uid'] == uid) {
        return Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 100,
              height: 100,
              padding: EdgeInsets.all(20),
              child:
              machine['imageUrls'] != null && machine['imageUrls'].isNotEmpty ?
              Image.network(
                machine['imageUrls'],
                fit: BoxFit.cover,
              ) : Container(),
            )


          ]),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  machine['machineName'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Center(child: Table(
                    children: [
                      TableRow(
                          children: [
                            const Text('Price:',
                              style: TextStyle(

                                fontSize: 12,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${machine['price']}',
                              style: TextStyle(
                                fontSize: 12,
                              ),),
                          ]
                      ),
                      TableRow(
                          children: [
                            const Text('Brand:',
                              style: TextStyle(

                                fontSize: 12,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${machine['brand']}',
                              style: TextStyle(
                                fontSize: 12,
                              ),),
                          ]
                      ),
                      TableRow(
                          children: [
                            const Text('Model:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text('${machine['model']}',
                              style: TextStyle(
                                fontSize: 12,
                              ),),
                          ]
                      ),
                      TableRow(
                          children: [
                            const Text('Year:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),
                            ),
                            Text('${machine['year']}', style: TextStyle(
                              fontSize: 12,
                            ),),
                          ]
                      ),
                      TableRow(
                          children: [
                            const Text('Sector:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text('${machine['sector']}', style: TextStyle(
                              fontSize: 12,
                            ),),
                          ]
                      ),
                      TableRow(
                          children: [
                            const Text('City:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text('${machine['city']}', style: TextStyle(
                              fontSize: 12,
                            ),),
                          ]
                      ),
                      TableRow(
                          children: [
                            const Text('Country:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text('${machine['country']}', style: TextStyle(
                              fontSize: 12,
                            ),),
                          ]
                      ),
                      TableRow(
                          children: [
                            const Text('',

                            ),
                            ElevatedButton(onPressed: () {
                              toggleContainerVisibility(machine['key']);
                            }, child:
                            Text('View Details')
                            ),
                          ]
                      ),
                    ]
                )),

              ],
            ),

          ),
        ]);
      }
      else {
        return Center(
            child: Text("No Machine Found")
        );
      }
    }
    else {
      return Center(
          child: Text("No Machine Found")
      );
    }

  }


  Widget listMachineDetails({required Map machine}) {


    return

        Visibility(
            visible: _containerVisibilities[machine['key']] ?? false,
            child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Center(child:
                  Text(
                    machine['machineName'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                  Row(children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width:100,
                        height:100,
                        padding: EdgeInsets.all(20),
                        child:
                        machine['imageUrls'] != null && machine['imageUrls'].isNotEmpty ?
                        Image.network(
                          machine['imageUrls'],
                          fit: BoxFit.cover,
                        ) : Container(),
                      )


                    ]),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Center(child:Table(
                              children:[
                                TableRow(
                                    children: [
                                      const Text('Price:',
                                        style: TextStyle(

                                          fontSize: 12,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('${machine['price']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Brand:',
                                        style: TextStyle(

                                          fontSize: 12,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('${machine['brand']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Model:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text('${machine['model']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Year:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12
                                        ),
                                      ),
                                      Text('${machine['year']}',style: TextStyle(
                                        fontSize: 12,
                                      ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Sector:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text('${machine['sector']}',style: TextStyle(
                                        fontSize: 12,
                                      ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('City:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text('${machine['city']}',style: TextStyle(
                                        fontSize: 12,
                                      ),),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      const Text('Country:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text('${machine['country']}',style: TextStyle(
                                        fontSize: 12,
                                      ),),
                                    ]
                                ),

                              ]
                          )),

                        ],
                      ),

                    ),
                  ]),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    const Text(
                      " History",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    Text(
                      "  "+machine['history'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),),
                  const SizedBox(height:5),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    const Text(
                      " Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    Text(
                      "  "+machine['description'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height:5),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    const Text(
                      " Specifications",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    Text(
                      "  -"+machine['spec1']+"\n  -"+machine['spec2']+"\n  -"+machine['spec3'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),),
                  const SizedBox(height:5),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:
                    const Text(
                      " Contact Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                  Container(
                    padding: EdgeInsets.only(left:16),
                    child:
                    Row(children:[
                      Text("  Name: "+machine['owner']),

                    ]),),
                  Container(
                    padding: EdgeInsets.only(left:16),child:
                  Row(children:[
                    Text("  Email: "+machine['email']+"    "),
                    InkWell(
                      child: Icon(Icons.email),
                      onTap: () async {

                        final url = 'mailto://' + machine['email'];

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    )
                  ]),),
                  Container(
                    padding: EdgeInsets.only(left:16), child:
                  Row(children:[
                    Text("  Phone: "+machine['phone']+"    "),
                    InkWell(
                      child: const Icon(FontAwesomeIcons.whatsapp),
                      highlightColor: Colors.green,
                      splashColor: Colors.green,
                      onTap: () async {
                        String phone=machine["phone"];
                        String message="hi";
                        final url ='https://wa.me/$phone?text=${Uri.encodeFull(message)}';

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),Expanded(
                        child:Text("       ")
                    ),
                    ElevatedButton(
                      onPressed: () {

                        FirebaseDatabase.instance.ref("machines/" + machine['key']).remove();


                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Background color
                      ),
                      child: const Text('Delete'),
                    ),
                  ]),),
                  const SizedBox(height:5),
                  Row(children:[
                    Expanded(child:
                    ElevatedButton(onPressed:() async {
                      final String text = 'Hello, there is a '+machine['machineName']+' machine up for grabs visit kupfuma.com!';
                      final String url = 'whatsapp://send?text=${Uri.encodeFull(text)}';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                        child:
                        Row(children:[Text("Share - "),Icon(FontAwesomeIcons.whatsapp)
                        ])

                    )
                      ,
                    ),
                    Expanded(child:
                    ElevatedButton(onPressed:() async {
                      final String subject = 'Kupfuma Machine For Sale';
                      final String body = 'Hello, there is a '+machine['machineName']+' machine up for grabs visit kupfuma.com!';
                      final String url = 'mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                        child:
                        Row(children:[const Text("Share - "),const Icon(Icons.email),
                        ])

                    )
                      ,
                    ),
                  ]),
                ]));




  }


  // Check if the user is signed in
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // only scroll to top when current index is selected.
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RevenuePage()));
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssetsPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Assets Register')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ISPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('Income Statement')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BSPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: const Text('     Balance Sheet   ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvisoryPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text(
                              '     $threeQuarterTurn Business Advisory  ')),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            onSurface: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundingPage()),
                            ); // Navigate back to first route when tapped.
                          },
                          child: Text('     Micro Funding  ')),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DealRoom()));
        break;
    }
  }
  String sme='',currency='';
  late DatabaseReference _databaseReference;
  List<Machine> _machineList = [];
  late Query dbRef;
  int listCount=0;
  @override
  void initState() {
    super.initState();
    _containerVisibilities["main"]=true;
    // <-- Their email
    String mail = user?.email ?? 'email';
    dbRef = FirebaseDatabase.instance
        .ref()
        .child('machines/');
    FirebaseDatabase.instance.ref().child('User/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;
      if (user['email'] == mail) {
        setState(() {
          sme = user['sme'];
          currency = user['currency'];
        });
      }
    });

    FirebaseDatabase.instance.ref().child('machines/').onChildAdded.listen((event) {
      Map user = event.snapshot.value as Map;

      setState(() {
        listCount++;
      });

    });

    _databaseReference =
        FirebaseDatabase.instance.reference().child('machines');
    _databaseReference.onChildAdded.listen((event) {
      setState(() {
        _machineList.add(Machine.fromSnapshot(event.snapshot));
      });
    });


  }

  String selectedSector="";
  @override
  Widget build(BuildContext context) {
    Color insightColor2 = Colors.blue;
    final scrollController=ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                sme,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '$currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.menu_rounded,
                size: 46,
                color: Colors.white,
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                ...MenuItems.secondItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 340,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color:Colors.black,
            child:
            ElevatedButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  onSurface: Colors.white,
                  backgroundColor: Colors.blue,
                  primary: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RetrieveMachinePage()),); // Navigate back to first route when tapped.
                },
                child: const Text('     Machine Exchange   ')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMachinePage()),
              );
            },
            child: Text('List Machine'),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Buy affordable used machines for your small business directly from other small near you ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Visibility(


            visible: _containerVisibilities["main"] ?? true,
            child:
            SingleChildScrollView(
              child: Container(
                height:400,
                child:
                FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: dbRef,
                  controller:scrollController,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map machine = snapshot.value as Map;
                    machine['key'] = snapshot.key;

                    return listMachines(machine: machine);
                  },
                ),

              ),
            ),

          ),
          SingleChildScrollView(
            child: Container(
              height:400,
              child:
              FirebaseAnimatedList(
                shrinkWrap: true,
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map machine = snapshot.value as Map;
                    machine['key'] = snapshot.key;

                    return listMachineDetails(machine: machine);
                  },
                ),
              
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Dealroom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}