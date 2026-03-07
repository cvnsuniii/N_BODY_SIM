import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
part 'bodyclass.g.dart';

@HiveType(typeId: 0)
class BodyDetails extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<double> lastValue;

  @HiveField(2)
  List<double> lastVelocities;

  @HiveField(3)
  List<double> lastAcceleration;

  @HiveField(4)
  double radius;

  @HiveField(5)
  int color;

  BodyDetails(
    this.name,
    this.lastValue,
    this.lastVelocities,
    this.lastAcceleration,
    this.radius,
    this.color
  );
}