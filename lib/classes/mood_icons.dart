import 'package:flutter/material.dart';

class MoodIcons{

  final String? title;
  final Color? color;
  final double? rotation;
  final IconData? icon;

  const MoodIcons({this.title, this.color, this.rotation, this.icon});


  IconData getMoodIcon(String mood){
    return _moodIconsList[_moodIconsList.indexWhere((icon) => icon.title == mood)].icon as IconData;
  }

  Color getMoodColor (String mood){
    return _moodIconsList[_moodIconsList.indexWhere((icon) => icon.title == mood)].color as Color;
  }

  double getMoodRotation(String mood){
    return _moodIconsList[_moodIconsList.indexWhere((icon) => icon.title == mood)].rotation as double;
  }

  List<MoodIcons> getMoodIconList(){
    return _moodIconsList;
  }
}


const List<MoodIcons> _moodIconsList =  <MoodIcons> [
 MoodIcons(title: 'Very Satisfied', color: Colors.amber, rotation: 0.2, icon: Icons.sentiment_very_satisfied),

  MoodIcons(title: 'Satisfied',color: Colors.green, rotation: 0.2, icon: Icons.sentiment_satisfied),
  MoodIcons(title: 'Neutral', color: Colors.grey, rotation: 0.0, icon: Icons.sentiment_neutral),
  MoodIcons(title: 'Dissatisfied', color: Colors.cyan, rotation: -0.2, icon: Icons.sentiment_dissatisfied),
  MoodIcons(title: 'Very Dissatisfied', color: Colors.red, rotation: -0.4, icon: Icons.sentiment_very_dissatisfied),

];