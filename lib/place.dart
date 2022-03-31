// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


class Place {
  String? id;
  double? latitude;
  double? longitude;
  String? name;


   Place({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
  }) ;



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['name'] = this.name;
    return data;
  }



  Place.fromJson(Map<String, dynamic> json) {
    id = json['id'] ;
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json['name'];

  }



}

class Person {
  String? name;


  Person({

    required this.name,
  }) ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }

  Person.fromJson(Map<String, dynamic> json) {

    name = json['name'];

  }

}
