import 'package:flutter/material.dart';

class Credits extends StatefulWidget {
  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'Absolute™',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0),
            Center(
              child: Column(
                children: <Widget>[
                  profile('Joyal A Johney', 'assets/joyal.jpg', 'Computer Science'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/50,
                  ),
                  profile('Steev James', 'assets/steeve.jpg', 'Computer Science'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/50,
                  ),
                  profile('Nikhil Babu', 'assets/nikhil.jpg', 'Computer Science'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget profile(name, image, dept) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(75.0)),
            // boxShadow: [BoxShadow(blurRadius: 9.0, color: Colors.black)]),
        ),
      ),
      Container(
        child: ListTile(
          title: Center(child: Text(name)),
          subtitle: Center(child: Text(dept)),
        ),
      )
    ],
  );
}