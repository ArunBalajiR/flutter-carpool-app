import 'package:flutter/material.dart';

class SetPrice extends StatefulWidget {
  @override
  _SetPriceState createState() => _SetPriceState();
}

class _SetPriceState extends State<SetPrice> {
  String price;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text("Enter Price"),
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              price = value;
            });
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Price",
            // icon: Icon(Icons.monetization_on),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(

          child: Text("Set Price"),
          onPressed: () {
            Navigator.of(context).pop(price.toString());
          },
        ),
        TextButton(
          child: Text("cancel"),
          onPressed: () {
            Navigator.of(context).pop("0.0");
          },
        )
      ],
    );
  }
}