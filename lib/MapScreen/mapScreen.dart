import 'dart:async';
import 'dart:core' as prefix0;
import 'dart:core';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutterappgooglemap/LocalDatabase/addTruckDatabase.dart';
import 'package:flutterappgooglemap/MapScreen/Model/FoodTruckSet.dart';
import 'package:flutterappgooglemap/Resources/colorPicker.dart';
import 'package:flutterappgooglemap/Resources/toast.dart';
import 'package:flutterappgooglemap/addTruckSystem.dart';
import 'package:flutterappgooglemap/editTruckSystem.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

BitmapDescriptor myIcon;
BitmapDescriptor myIcon1;
int index = 0;
List<Marker> allMarkers = [];

class GoogleMapPage extends StatefulWidget {
  GoogleMapPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DriverFleetTrackingPageState createState() => _DriverFleetTrackingPageState();
}

class _DriverFleetTrackingPageState extends State<GoogleMapPage> {
  ProgressDialog pr = new ProgressDialog();
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMap googleMap;
  double zoomVal = 12.0;
  PinInformation sourcePinInfo;
  PinInformation currentlySelectedPin = PinInformation(foodType: '', foodDetails: '', location: '', openingTime: '', closingTime: '');
  double latitudePosition = -200;
  double longitudePosition = -100;
  List<FoodTruckSet> dbFoodTruck = new List<FoodTruckSet>();
  FoodTruckDatabaseHelper foodTruckDatabaseHelper = FoodTruckDatabaseHelper.instance;
  TextEditingController _typeAheadController = new TextEditingController();
  List<String> foodTypeArray = [];
  bool searchValue = false;


  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(200, 200)),
      'assets/fleet_pin.png',
    ).then((onValue) {
      setState(() {
        myIcon1 = onValue;
      });
    });
    super.initState();
    getAllVehicleListingCall();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getAllVehicleListingCall() async{
    pr.showProgressDialog(
      context,
      dismissAfter: Duration(seconds: 5),
      textToBeDisplayed:'Please Wait',
    );
    latitudePosition = -200;
    dbFoodTruck.clear();
    foodTypeArray.clear();
    index = 0;
    final allRows = await foodTruckDatabaseHelper.queryAllRowsFoodTruck();
    if(allRows.length > 0){
      allRows.forEach((row){
        setState(() {
          FoodTruckSet foodTruckSet = new FoodTruckSet();
          foodTruckSet.colId = row["colIndex"];
          foodTruckSet.foodType = row["foodType"];
          foodTruckSet.foodDetails = row["foodDetails"];
          foodTruckSet.openingTime = row["openTime"];
          foodTruckSet.closingTime = row["closeTime"];
          foodTruckSet.latitude = row["latitude"];
          foodTruckSet.longitude = row["longitude"];
          foodTruckSet.address = row["address"];
          dbFoodTruck.add(foodTruckSet);
        });
      });
    }
    if(dbFoodTruck.length == 0){
      SampleToast.noTruckFound();
      pr.dismissProgressDialog(context);
    }
    else{
      setState(() {
        allMarkers.clear();
        for(var i = 0 ; i < dbFoodTruck.length ; i++){
          print(dbFoodTruck[i].latitude);
          print(dbFoodTruck[i].longitude);
        }
        allMarkers = dbFoodTruck.map((element) {
          foodTypeArray.add(element.foodType);
          Marker marker = Marker(
            markerId: MarkerId(index.toString()),
            position: LatLng(double.parse(element.latitude), double.parse(element.longitude)),
            onTap: () {
              setState(() {
                var openTimeObj = new DateFormat("HH:mm:ss").parse(element.openingTime);
                String openTime = DateFormat('hh:mm a').format(openTimeObj);
                var closeTimeObj = new DateFormat("HH:mm:ss").parse(element.closingTime);
                String closeTime = DateFormat('hh:mm a').format(closeTimeObj);
                String currentTime = DateFormat('hh:mm a').format(DateTime.now());
                var currentTimeObj = new DateFormat("hh:mm a").parse(currentTime);
                bool openStore = false;
                if(currentTimeObj.isAfter(openTimeObj) && currentTimeObj.isBefore(closeTimeObj)){
                  openStore = true;
                }
                else{
                  openStore = false;
                }
                currentlySelectedPin = PinInformation(
                  foodType: element.foodType,
                  foodDetails: element.foodDetails,
                  location: element.address,
                  openingTime: openTime,
                  closingTime: closeTime,
                  openStore: openStore,
                  colId: element.colId,
                  latitude: element.latitude,
                  longitude: element.longitude
                );
                latitudePosition = 220;
                longitudePosition = 5;
              });
            },
            icon: myIcon1,
          );
          index++;
          return marker;
        }).toList();
      });
      pr.dismissProgressDialog(context);
    }
  }

  Future getSearchVehicleListingCall(String foodType) async{
    pr.showProgressDialog(
      context,
      dismissAfter: Duration(seconds: 5),
      textToBeDisplayed:'Please Wait',
    );
    latitudePosition = -200;
    dbFoodTruck.clear();
    index = 0;
    final allRows = await foodTruckDatabaseHelper.queryAllRowsFoodTruck();
    if(allRows.length > 0){
      allRows.forEach((row){
        setState(() {
          FoodTruckSet foodTruckSet = new FoodTruckSet();
          foodTruckSet.colId = row["colIndex"];
          foodTruckSet.foodType = row["foodType"];
          foodTruckSet.foodDetails = row["foodDetails"];
          foodTruckSet.openingTime = row["openTime"];
          foodTruckSet.closingTime = row["closeTime"];
          foodTruckSet.latitude = row["latitude"];
          foodTruckSet.longitude = row["longitude"];
          foodTruckSet.address = row["address"];
          if(foodTruckSet.foodType == foodType){
            dbFoodTruck.add(foodTruckSet);
          }
        });
      });
    }
    if(dbFoodTruck.length == 0){
      SampleToast.noTruckFound();
      pr.dismissProgressDialog(context);
    }
    else{
      setState(() {
        allMarkers.clear();
        for(var i = 0 ; i < dbFoodTruck.length ; i++){
          print(dbFoodTruck[i].latitude);
          print(dbFoodTruck[i].longitude);
        }
        allMarkers = dbFoodTruck.map((element) {
          Marker marker = Marker(
            markerId: MarkerId(index.toString()),
            position: LatLng(double.parse(element.latitude), double.parse(element.longitude)),
            onTap: () {
              setState(() {
                var openTimeObj = new DateFormat("HH:mm:ss").parse(element.openingTime);
                String openTime = DateFormat('hh:mm a').format(openTimeObj);
                var closeTimeObj = new DateFormat("HH:mm:ss").parse(element.closingTime);
                String closeTime = DateFormat('hh:mm a').format(closeTimeObj);
                String currentTime = DateFormat('hh:mm a').format(DateTime.now());
                var currentTimeObj = new DateFormat("hh:mm a").parse(currentTime);
                bool openStore = false;
                if(currentTimeObj.isAfter(openTimeObj) && currentTimeObj.isBefore(closeTimeObj)){
                  openStore = true;
                }
                else{
                  openStore = false;
                }
                currentlySelectedPin = PinInformation(
                    foodType: element.foodType,
                    foodDetails: element.foodDetails,
                    location: element.address,
                    openingTime: openTime,
                    closingTime: closeTime,
                    openStore: openStore,
                    colId: element.colId,
                    latitude: element.latitude,
                    longitude: element.longitude
                );
                latitudePosition = 220;
                longitudePosition = 5;
              });
            },
            icon: myIcon1,
          );
          index++;
          return marker;
        }).toList();
      });
      pr.dismissProgressDialog(context);
    }
  }

  List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(foodTypeArray);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Widget _googleMap(BuildContext context){
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    int index = 0;
    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          height: deviceHeight,
          width: deviceWidth,
          child: Stack(
            children: <Widget>[
              GoogleMap(
                mapToolbarEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(target: LatLng(28.6092966,77.2062674),zoom: zoomVal),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  controller.showMarkerInfoWindow(MarkerId(index.toString()));
                },
                onTap: (LatLng location) {
                  setState(() {
                    latitudePosition = -200;
                  });
                },
                markers: prefix0.Set.from(allMarkers),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                ].toSet(),
              ),
              MapPinPillComponent(
                  latitudePosition: latitudePosition,
                  longitudePosition: longitudePosition,
                  currentlySelectedPin: currentlySelectedPin
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    var headerBlock = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                width: deviceWidth*0.75,
                height: deviceHeight*0.04,
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    textAlign: TextAlign.center,
                    controller: this._typeAheadController,
                    decoration: new InputDecoration(contentPadding: EdgeInsets.only(bottom: 15.0),border: InputBorder.none,hintText: 'Search',hintStyle: TextStyle(color: whiteBack, fontSize: 14,fontFamily: "SFProDisplay-Medium")),
                    style: TextStyle(color: whiteBack, fontSize: 14,fontFamily: "SFProDisplay-Medium"),
                  ),
                  suggestionsCallback: (pattern) async {
                    return getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    this._typeAheadController.text = suggestion;

                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select';
                    }
                    return 'Text';
                  },
                ),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  color: appBarColor,
                ),
              ),
              Spacer(),
              searchValue == false
              ? GestureDetector(
                  onTap: (){
                    getSearchVehicleListingCall(_typeAheadController.text);
                    setState(() {
                      searchValue = true;
                    });
                  },
                  child: new Icon(Icons.search, color: appBarColor,),
              )
              : GestureDetector(
                onTap: (){
                  _typeAheadController.text = '';
                  getAllVehicleListingCall();
                  setState(() {
                    searchValue = false;
                  });
                },
                child: new Icon(Icons.cancel, color: appBarColor,),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: new Text('Food Trucks',style: TextStyle(color: whiteBack,fontFamily: "Roboto-Regular",fontSize: 18.0,letterSpacing: 0.0),),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewFoodTrucksPage())).then((value) {
            debugPrint(value);
            getAllVehicleListingCall();
          });
        },
        backgroundColor: appBarColor,
        child: new Icon(Icons.add,color: whiteBack,size: 35.0,)
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                new Container(
                  child:new Column(
                    children: <Widget>[
                      new Container(
                        height: 60.0,
                        child: headerBlock,
                        decoration: new BoxDecoration(
                            color: whiteBack,
                            boxShadow: [
                              BoxShadow(
                                  color: shadow,
                                  blurRadius: 20.0
                              )
                            ]
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height*0.9,
                        child: _googleMap(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PinInformation {
  String foodType;
  String foodDetails;
  String location;
  String openingTime;
  String closingTime;
  String latitude;
  String longitude;
  bool openStore;
  dynamic colId;

  PinInformation({this.foodType, this.foodDetails, this.location, this.openingTime, this.closingTime, this.openStore, this.colId, this.longitude, this.latitude});
}

class MapPinPillComponent extends StatefulWidget {
  final double latitudePosition;
  final double longitudePosition;
  final PinInformation currentlySelectedPin;

  MapPinPillComponent({ this.latitudePosition, this.longitudePosition, this.currentlySelectedPin});

  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}

class MapPinPillComponentState extends State<MapPinPillComponent> {
  FoodTruckDatabaseHelper foodTruckDatabaseHelper = FoodTruckDatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {

    return AnimatedPositioned(
      bottom: widget.latitudePosition,
      right: widget.longitudePosition,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(12.0),
          height: 115,
          width: 200,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: <BoxShadow>[
                BoxShadow(blurRadius: 20, offset: Offset.zero, color: Colors.grey.withOpacity(0.5))
              ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  widget.currentlySelectedPin.openStore == true
                      ? Text('Open',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontFamily: "SFProDisplay-Bold",fontSize: 14.0,letterSpacing: 0.0),)
                      : Text('Close',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontFamily: "SFProDisplay-Bold",fontSize: 14.0,letterSpacing: 0.0),),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      print('ankit');
                      print(widget.currentlySelectedPin.colId);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditFoodTrucksPage(colId: widget.currentlySelectedPin.colId,foodType: widget.currentlySelectedPin.foodType,foodDetails: widget.currentlySelectedPin.foodDetails,address: widget.currentlySelectedPin.location,openTime: widget.currentlySelectedPin.openingTime,closeTime: widget.currentlySelectedPin.closingTime,latitude: widget.currentlySelectedPin.latitude,longitude: widget.currentlySelectedPin.longitude,))).then((value) {
                        debugPrint(value);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GoogleMapPage()));
                      });
                    },
                    child: new Icon(Icons.edit, color: orangeColor,size: 15.0,)
                  ),
                  SizedBox(width: 5.0,),
                  GestureDetector(
                      onTap: (){
                        print('pandey');
                        print(widget.currentlySelectedPin.colId);
                        deleteFoodTruckData(widget.currentlySelectedPin.colId);
                      },
                      child: new Icon(Icons.delete_forever, color: orangeColor,size: 15.0,)
                  ),
                ],
              ),
              SizedBox(height: 3.0,),
              Text(widget.currentlySelectedPin.foodType,style: TextStyle(fontWeight: FontWeight.bold,color: blackBold,fontFamily: "SFProDisplay-Bold",fontSize: 14.0,letterSpacing: 0.0),),
              SizedBox(height: 3.0,),
              Text('Speciality'+' : '+widget.currentlySelectedPin.foodDetails,style: TextStyle(color: blackBold,fontFamily: "SFProDisplay-Bold",fontSize: 14.0,letterSpacing: 0.0),),
              SizedBox(height: 3.0,),
              Text('Timings'+' : '+widget.currentlySelectedPin.openingTime+' - '+widget.currentlySelectedPin.closingTime,style: TextStyle(color: blackBold,fontFamily: "SFProDisplay-Bold",fontSize: 14.0,letterSpacing: 0.0),),
              SizedBox(height: 3.0,),
              Text(widget.currentlySelectedPin.location,style: TextStyle(color: blackBold,fontFamily: "SFProDisplay-Bold",fontSize: 14.0,letterSpacing: 0.0),),
            ],
          ),
        ),
      ),
    );
  }

  void deleteFoodTruckData(dynamic dataId) async {
    await foodTruckDatabaseHelper.deleteRowFoodTruck(widget.currentlySelectedPin.colId);
    print(await foodTruckDatabaseHelper.queryAllRowsFoodTruck());
    SampleToast.truckDelete();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GoogleMapPage()));
  }
}