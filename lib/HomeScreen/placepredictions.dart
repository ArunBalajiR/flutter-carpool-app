import 'dart:convert';

class PlacePredictions{
  String name;
  String label;
  PlacePredictions({this.name,this.label});
  PlacePredictions.fromJson(Map<String,dynamic> json){
    name = json["name"];
    label = json["label"];
  }
}