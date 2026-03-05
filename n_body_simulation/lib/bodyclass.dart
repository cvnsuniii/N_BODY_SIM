import 'package:hive/hive.dart';

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

  BodyDetails(
    this.name,
    this.lastValue,
    this.lastVelocities,
    this.lastAcceleration,
  );
}