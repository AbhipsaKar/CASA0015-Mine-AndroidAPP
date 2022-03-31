import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:geolocator/geolocator.dart';
import 'login.dart';
import 'place.dart';


enum PlaceTrackerViewType {
  map,
  list,
}

class PlaceTrackerApp extends StatelessWidget {
  const PlaceTrackerApp( {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      home: _PlaceTrackerHomePage(),
    );
  }
}

class _PlaceTrackerHomePage extends StatelessWidget {
  const _PlaceTrackerHomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);

    @override
    void _onMapCreated(HereMapController hereMapController) {
      hereMapController.mapScene.loadSceneForMapScheme(
          MapScheme.normalDay, (MapError? error) async {
        if (error != null) {
          print('Map scene not loaded. MapError: ${error.toString()}');
          return;
        }

        const double distanceToEarthInMeters = 8000;
        hereMapController.camera.lookAtPointWithDistance(
            GeoCoordinates(52.530932, 13.384915), distanceToEarthInMeters);


        LocationPermission permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            print('Location permissions are denied');
          } else if (permission == LocationPermission.deniedForever) {
            print("'Location permissions are permanently denied");
          } else {
            print("GPS Location service is granted");
          }
        } else {
          print("GPS Location permission granted.");
        }


        Position position = await
        Geolocator.getCurrentPosition(forceAndroidLocationManager: false,
            desiredAccuracy: LocationAccuracy.bestForNavigation);

        print("Get GPS current Location ");

        final username = Provider
            .of<AppState>(context, listen: false)
            .id;
        print(username);

        Place place = Place(id: "yyy",
            latitude: position.latitude,
            longitude: position.longitude,
            name: "Home");
        Person person = Person(name: username);
        Markers marker = Markers(place, person);

        var trackers = <Markers>{};
        trackers.add(marker);
        Provider.of<AppState>(context, listen: false).setMarkers(
            trackers.toList());
        print("Update checkin");

        SharedPreferences? prefs;
        prefs = await SharedPreferences.getInstance();
        //prefs!.setStringList("trackers", trackers as List<String>);
        prefs!.setString("trackers" + username, jsonEncode(marker));

        final personList = List<String>.from(Provider
            .of<AppState>(context, listen: false)
            .persons);
        print(personList);
        if (personList.isEmpty || (!(personList.contains(username)))) {
          personList.add(username);
          prefs!.setStringList("persons", personList);
        }

        print("Length of list");
        print(personList.length);

        for (var item in personList) {
          print("For user");
          print(item);
          String jsonString = prefs!.getString("trackers" + item) as String;
          Map<String, dynamic> trackerMap = jsonDecode(jsonString);
          Markers trackerlist = Markers.fromJson(trackerMap);

          print("Location fetched");
          print(trackerlist!.nowPos.latitude);

          int index = personList.indexOf(item);
          GeoCoordinates geo = GeoCoordinates(
              trackerlist!.nowPos.latitude as double,
              trackerlist!.nowPos.longitude as double);
          hereMapController.camera.lookAtPointWithDistance(
              geo, distanceToEarthInMeters);
          MapImage? _photoMapImage;


          if (_photoMapImage == null) {
            String assetPath = 'assets/' + 'icon' + index.toString() +'.png';
            print(assetPath);

            _photoMapImage = MapImage.withFilePathAndWidthAndHeight(
                assetPath, 150,150);

            final marker = MapMarker(
                geo,
                _photoMapImage
            );
            print("Adding marker");
            hereMapController.mapScene.addMapMarker(marker);
          }
        }
        // Optionally enable textured 3D landmarks.
        //hereMapController.mapScene.setLayerVisibility(MapSceneLayers.landmarks, VisibilityState.visible);
      });
    }

    Widget _buildRow(String note) {

      return ListTile(
        title: Text(
          note,
          style: TextStyle(fontSize: 20),

        ),
        tileColor: Colors.grey,
        style: ListTileStyle.drawer,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),

        trailing: const Icon(
          Icons.gps_not_fixed,
          semanticLabel: 'Track',
        ),
        onTap: () {
          track() async {
            print("Trying to track");
            state.setViewType(
              state.viewType == PlaceTrackerViewType.map
                  ? PlaceTrackerViewType.list
                  : PlaceTrackerViewType.map,
            );

            HereMap(onMapCreated: _onMapCreated );
          }

          track();

        },
      );
    }

    Widget _buildSuggestions() {
      final persons = List<String>.from(Provider
          .of<AppState>(context, listen: false)
          .persons);

      print("Length of list");
      print(persons.length);

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: persons.length,
        itemBuilder: (context, i) {
          print("build row");
          print(i);
          return _buildRow(persons.elementAt(i));
        },
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text("MINE: Tracker"),
        backgroundColor: Colors.blueGrey,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
            child: IconButton(
              icon: Icon(
                //Toggle button
                state.viewType == PlaceTrackerViewType.map
                    ? Icons.list
                    : Icons.map,
                size: 32.0,
              ),
              onPressed: () {
                state.setViewType(
                  state.viewType == PlaceTrackerViewType.map
                      ? PlaceTrackerViewType.list
                      : PlaceTrackerViewType.map,
                );
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: state.viewType == PlaceTrackerViewType.map ? 0 : 1,
        children: [
          _buildSuggestions(),
          HereMap(onMapCreated: _onMapCreated),
        ],
      ),
    );
  }

}

class AppState extends ChangeNotifier {


  AppState({

    this.isLoggedIn = false,
    this.id = "Guest",
    this.viewType = PlaceTrackerViewType.map,
    required this.persons,
    required this.markers,  //To be able to initialise the list to Null on Application boot
    required this.notes
  });

  bool isLoggedIn;
  String id;
  List<Markers> markers;
  PlaceTrackerViewType viewType;
  List<String> notes;
  List<String> persons;

  void setViewType(PlaceTrackerViewType viewType) {
    print("Set view type:Abhi");
    print(viewType);
    this.viewType = viewType;
    notifyListeners();
  }

  void addPersons(List<String> person){
    persons = person;
    notifyListeners();
  }
  void setLoginState(bool state){
    isLoggedIn = state;
    notifyListeners();
  }

  void setMarkers(List<Markers> newPlaces) {
    markers = newPlaces;
    notifyListeners();
  }

  void setId(String newPerson) {
    id = newPerson;
    notifyListeners();
  }

  void setNotes(List<String> note) {
    notes = note;
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppState &&
        other.markers == markers &&
        other.viewType == viewType;
  }

  @override
  int get hashCode => hashValues(markers, viewType);
}


class Markers {
  late Place nowPos;
  late Person member;
  Markers(Place pos, Person person)
  {
    this.nowPos = pos;
    this.member = person;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.nowPos != null) {
      data['nowPos'] = this.nowPos.toJson();
    }
    if (this.member != null) {
      data['member'] = this.member.toJson();
    }
    return data;
  }

  Markers.fromJson(Map<String, dynamic> json) {
    nowPos = Place.fromJson(json['nowPos']);
    member = Person.fromJson(json['member']);
  }

}

