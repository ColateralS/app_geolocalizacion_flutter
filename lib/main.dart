import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(AppMap());

class AppMap extends StatefulWidget{
  AppMap() : super();
  final String title = "Geolocalización con Google Maps";
  @override
  AppMapState createState() => AppMapState();
}

class AppMapState extends State<AppMap>{

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(-0.1760876, -78.465119);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
    bearing: 180, //Posicion de la Camara
    target: LatLng(-0.1693637, -78.470718),
    //Angulo de la Posicion de la Camara
    zoom: 19.0,
  );

  Future<void> _goToPosition1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }

  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType = _currentMapType == MapType.normal 
      ? MapType.satellite 
      : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed(){
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'Marcador Agregado',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  Widget button(Function function, IconData icon){
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon, 
        size: 32.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 12.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    button(_onMapTypeButtonPressed, Icons.map),
                    SizedBox(
                      height: 16.0,
                    ),
                    button(_onAddMarkerButtonPressed, Icons.add_location_alt_outlined),
                    SizedBox(
                      height: 16.0,
                    ),
                    button(_goToPosition1, Icons.location_searching_sharp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}