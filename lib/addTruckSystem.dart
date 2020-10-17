import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutterappgooglemap/Resources/colorPicker.dart';
import 'package:flutterappgooglemap/Resources/toast.dart';
import 'package:intl/intl.dart';
import 'LocalDatabase/addTruckDatabase.dart';

class AddNewFoodTrucksPage extends StatefulWidget {
  AddNewFoodTrucksPage({Key key, this.index}) : super(key: key);
  final String index;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddNewFoodTrucksPage>{
  TextEditingController foodTypeController = new TextEditingController();
  TextEditingController openingTimeController = new TextEditingController();
  TextEditingController closingTimeController = new TextEditingController();
  TextEditingController latitudeController = new TextEditingController();
  TextEditingController longitudeController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController foodDetailsController = new TextEditingController();
  bool _validateFoodType = false;
  bool _validateOpeningTime = false;
  bool _validateClosingTime = false;
  bool _validateLatitude = false;
  bool _validateLongitude = false;
  bool _validateAddress = false;
  bool _validateFoodDetails = false;
  var timeFormat = DateFormat("hh:mm a");
  DateTime openingTimeValue;
  DateTime closingTimeValue;
  FoodTruckDatabaseHelper foodTruckDatabaseHelper = FoodTruckDatabaseHelper.instance;


  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    var initialBlock = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        SizedBox(height: 10.0,),

        new TextField(
          controller: foodTypeController,
          style: TextStyle(color: appBarColor,fontSize: 14,fontFamily: "SFProDisplay-Medium",letterSpacing: .35),
          decoration: new InputDecoration(
              errorText: _validateFoodType ? 'Empty Field' : null,
              errorStyle: TextStyle(
                color: appBarColor,
                fontSize: 14,
                fontFamily: "SFProDisplay-Medium",
                letterSpacing: .35,
              ),
              labelText: 'Food Type', labelStyle: TextStyle(color: appBarColor,fontSize: 16,fontFamily: "SFProDisplay-Medium",letterSpacing: .35)),
        ),

        SizedBox(height: 12.0,),

        new TextField(
          controller: foodDetailsController,
          style: TextStyle(color: appBarColor,fontSize: 14,fontFamily: "SFProDisplay-Medium",letterSpacing: .35),
          decoration: new InputDecoration(
              errorText: _validateFoodDetails ? 'Empty Field' : null,
              errorStyle: TextStyle(
                color: appBarColor,
                fontSize: 14,
                fontFamily: "SFProDisplay-Medium",
                letterSpacing: .35,
              ),
              labelText: 'Food Details', labelStyle: TextStyle(color: appBarColor,fontSize: 16,fontFamily: "SFProDisplay-Medium",letterSpacing: .35)),
        ),

        SizedBox(height: 12.0,),

        new Row(
          children: <Widget>[
            new Flexible(
              child: DateTimeField(
                controller: openingTimeController,
                format: timeFormat,
                readOnly: true,
                style: TextStyle(color: appBarColor, fontSize: 14,fontFamily: "SFProDisplay-Medium",letterSpacing: 0.4),
                decoration: new InputDecoration(
                    errorText: _validateOpeningTime ? 'Empty Field' : null,
                    errorStyle: TextStyle(
                      color: appBarColor,
                      fontSize: 14,
                      fontFamily: "SFProDisplay-Medium",
                      letterSpacing: .35,
                    ),
                    labelText: 'Opening Time', labelStyle: TextStyle(color: appBarColor,fontSize: 16,fontFamily: "SFProDisplay-Medium",letterSpacing: .35)),
                onChanged: (dt) => setState(() {
                  openingTimeValue = dt;
                }),
                onShowPicker: (context, currentValue) async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    builder: (BuildContext context, Widget child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                        child: child,
                      );
                    },
                  );
                  return DateTimeField.convert(time);
                },
              ),
            ),
            new Icon(Icons.watch_later, color: appBarColor,),
            SizedBox(width: 20.0,),
            new Flexible(
              child: DateTimeField(
                controller: closingTimeController,
                format: timeFormat,
                readOnly: true,
                style: TextStyle(color: appBarColor, fontSize: 14,fontFamily: "SFProDisplay-Medium",letterSpacing: 0.4),
                decoration: new InputDecoration(
                    errorText: _validateClosingTime ? 'Empty Field' : null,
                    errorStyle: TextStyle(
                      color: appBarColor,
                      fontSize: 14,
                      fontFamily: "SFProDisplay-Medium",
                      letterSpacing: .35,
                    ),
                    labelText: 'Closing Time', labelStyle: TextStyle(color: appBarColor,fontSize: 16,fontFamily: "SFProDisplay-Medium",letterSpacing: .35)),
                onChanged: (dt) => setState(() {
                  closingTimeValue = dt;
                }),
                onShowPicker: (context, currentValue) async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    builder: (BuildContext context, Widget child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                        child: child,
                      );
                    },
                  );
                  return DateTimeField.convert(time);
                },
              ),
            ),
            new Icon(Icons.watch_later, color: appBarColor,),
          ],
        ),

        SizedBox(height: 12.0,),

        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: latitudeController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: appBarColor,fontSize: 14,fontFamily: "SFProDisplay-Medium",letterSpacing: .35),
                decoration: new InputDecoration(
                    errorText: _validateLatitude ? 'Empty Field' : null,
                    errorStyle: TextStyle(
                      color: appBarColor,
                      fontSize: 14,
                      fontFamily: "SFProDisplay-Medium",
                      letterSpacing: .35,
                    ),
                    labelText: "Latitude", labelStyle: TextStyle(color: appBarColor,fontSize: 16,fontFamily: "SFProDisplay-Medium",letterSpacing: .35)),
              ),
            ),
            SizedBox(width: deviceWidth*0.055,),
            new Flexible(
              child: new TextField(
                controller: longitudeController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: appBarColor,fontSize: 14,fontFamily: "SFProDisplay-Medium",letterSpacing: .35),
                decoration: new InputDecoration(
                    errorText: _validateLongitude ? 'Empty Field' : null,
                    errorStyle: TextStyle(
                      color: appBarColor,
                      fontSize: 14,
                      fontFamily: "SFProDisplay-Medium",
                      letterSpacing: .35,
                    ),
                    labelText: "Longitude", labelStyle: TextStyle(color: appBarColor,fontSize: 16,fontFamily: "SFProDisplay-Medium",letterSpacing: .35)),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.0,),

        new TextField(
          controller: addressController,
          style: TextStyle(color: appBarColor,fontSize: 14,fontFamily: "SFProDisplay-Medium",letterSpacing: .35),
          decoration: new InputDecoration(
              errorText: _validateAddress ? 'Empty Field' : null,
              errorStyle: TextStyle(
                color: appBarColor,
                fontSize: 14,
                fontFamily: "SFProDisplay-Medium",
                letterSpacing: .35,
              ),
              labelText: 'Address', labelStyle: TextStyle(color: appBarColor,fontSize: 16,fontFamily: "SFProDisplay-Medium",letterSpacing: .35)),
        ),
      ],
    );

    var btn = new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              border: Border.all(
                  color: greyShade,
                  width: 2.0
              ),
              color: whiteBack,
              borderRadius: new BorderRadius.circular(10),
            ),
            height: 50.0,
            child: new FlatButton(
              child: new Text(
                  "RESET",
                  style: TextStyle(color: greyShade,fontSize: 14,fontFamily: "SFProText-Semibold",letterSpacing: 0.0)
              ),
              onPressed: () {
                setState(() {
                  foodTypeController.text = '';
                  foodDetailsController.text = '';
                  openingTimeController.text = '';
                  closingTimeController.text = '';
                  latitudeController.text = '';
                  longitudeController.text = '';
                  addressController.text = '';
                });
              },
              padding: EdgeInsets.symmetric(horizontal: 42.0),
            ),
          ),
          Spacer(),
          new Container(
            decoration: new BoxDecoration(
              color: orangeColor,
              borderRadius: new BorderRadius.circular(10),
            ),
            height: 50.0,
            child: new FlatButton(
              child: new Text(
                  'ADD',
                  style: TextStyle(color: whiteBack,fontSize: 14,fontFamily: "SFProText-Semibold",letterSpacing: 0.0)
              ),
              onPressed: () async{
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  foodTypeController.text.trim().isEmpty
                      ? _validateFoodType = true
                      : _validateFoodType = false;
                  openingTimeController.text.trim().isEmpty
                      ? _validateOpeningTime = true
                      : _validateOpeningTime = false;
                  closingTimeController.text.trim().isEmpty
                      ? _validateClosingTime = true
                      : _validateClosingTime = false;
                  latitudeController.text.trim().isEmpty
                      ? _validateLatitude = true
                      : _validateLatitude = false;
                  addressController.text.trim().isEmpty
                      ? _validateAddress = true
                      : _validateAddress = false;
                  longitudeController.text.trim().isEmpty
                      ? _validateLongitude = true
                      : _validateLongitude = false;
                  foodDetailsController.text.trim().isEmpty
                      ? _validateFoodDetails = true
                      : _validateFoodDetails = false;
                });
                if(_validateLongitude == false && _validateFoodDetails == false && _validateLatitude == false && _validateFoodType == false && _validateOpeningTime == false && _validateClosingTime == false && _validateAddress == false){
                  insertFoodTruckData();
                }
              },
              padding: EdgeInsets.symmetric(horizontal: 52.0),
            ),
          ),
        ]
    );

    return Scaffold(
      appBar: AppBar(
        title: new Text('Add New Food Truck',style: TextStyle(color: whiteBack,fontFamily: "Roboto-Regular",fontSize: 18.0,letterSpacing: 0.0),),
        centerTitle: true,
        leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: new Icon(Icons.arrow_back_ios,color: whiteBack,),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            }
        ),
        backgroundColor: appBarColor,
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

                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0,bottom: 20.0),
                        child: new Container(
                          padding: EdgeInsets.only(bottom: 15.0,left: 10.0,right: 10.0),
                          child: initialBlock,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 50.0,bottom: 20.0),
                        child: new Container(
                          child: btn,
                        ),
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

  void insertFoodTruckData() async {
    var openTimeObj = new DateFormat("hh:mm a").parse(openingTimeController.text);
    var closeTimeObj = new DateFormat("hh:mm a").parse(closingTimeController.text);
    String openTiming = DateFormat('HH:mm:ss').format(openTimeObj);
    String closeTiming = DateFormat('HH:mm:ss').format(closeTimeObj);
    Map<String, dynamic> row = {
      FoodTruckDatabaseHelper.foodType : foodTypeController.text,
      FoodTruckDatabaseHelper.foodDetails : foodDetailsController.text,
      FoodTruckDatabaseHelper.openTime : openTiming,
      FoodTruckDatabaseHelper.closeTime : closeTiming,
      FoodTruckDatabaseHelper.latitude : latitudeController.text,
      FoodTruckDatabaseHelper.longitude : longitudeController.text,
      FoodTruckDatabaseHelper.address : addressController.text,
    };
    int id = await foodTruckDatabaseHelper.insertFoodTruck(row);
    print('inserted row id: $id');
    print(await foodTruckDatabaseHelper.queryAllRowsFoodTruck());
    SampleToast.newTruckAdded();
    Navigator.pop(context);
  }
}