import 'dart:ui';

class Trainee {
  String? nameFirst;
  String? nameMiddle;
  String? nameLast;
  String? position;
  DateTime? birthdate;
  String? contactNumber1;
  String? contactNumber2;
  String? emailPersonal;
  String? emailOfficial;
  String? profilePicture;
  dynamic trainings;

  Trainee(this.nameFirst, this.nameMiddle, this.nameLast, this.birthdate, this.contactNumber1, this.contactNumber2, this.emailPersonal, this.emailOfficial, this.profilePicture, this.trainings);
}