class Office {
  String? name;
  String? roomNumber;
  String? buildingNumber;
  String? buildingName;
  String? compound;
  String? streetName;
  String? purok;
  String? barangay;
  String? district;
  String? municipality;
  String? city;

  Office(
      this.name,
      );

  // Constructor
  Office.withDetails({
    this.name,
    this.roomNumber,
    this.buildingNumber,
    this.buildingName,
    this.compound,
    this.streetName,
    this.purok,
    this.barangay,
    this.district,
    this.municipality,
    this.city,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'roomNumber': roomNumber,
      'buildingNumber': buildingNumber,
      'buildingName': buildingName,
      'compound': compound,
      'streetName': streetName,
      'purok': purok,
      'barangay': barangay,
      'district': district,
      'municipality': municipality,
      'city': city,
    };
  }

  // Factory method to create Office from a Map
  factory Office.fromMap(Map<String, dynamic> map) {
    return Office.withDetails(
      name: map['name'],
      roomNumber: map['roomNumber'],
      buildingNumber: map['buildingNumber'],
      buildingName: map['buildingName'],
      compound: map['compound'],
      streetName: map['streetName'],
      purok: map['purok'],
      barangay: map['barangay'],
      district: map['district'],
      municipality: map['municipality'],
      city: map['city'],
    );
  }
}