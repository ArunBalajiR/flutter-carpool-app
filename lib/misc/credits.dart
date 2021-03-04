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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 50.0),
            Center(
              child: Column(
                children: <Widget>[
                  profile('Arun Balaji R', 'assets/arun.jpg', 'Computer Science'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/50,
                  ),
                  profile('Dhaithiya Soodhan TS', 'assets/dhaithiya.jpg', 'Computer Science'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/50,
                  ),

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
        width: 200,
        height: 200,
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