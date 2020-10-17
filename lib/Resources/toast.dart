import 'package:fluttertoast/fluttertoast.dart';
import 'colorPicker.dart';

class SampleToast {

  static void noTruckFound(){
    Fluttertoast.showToast(
      msg: "No Food Truck Found!",
      textColor: whiteBack,
      fontSize: 14.0,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: appBarColor,
    );
  }

  static void newTruckAdded(){
    Fluttertoast.showToast(
      msg: "New Food Truck Added!",
      textColor: whiteBack,
      fontSize: 14.0,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: appBarColor,
    );
  }

  static void truckDelete(){
    Fluttertoast.showToast(
      msg: "Food Truck Deleted Successfully!",
      textColor: whiteBack,
      fontSize: 14.0,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: appBarColor,
    );
  }

  static void updateTruck(){
    Fluttertoast.showToast(
      msg: "Food Truck Updated!",
      textColor: whiteBack,
      fontSize: 14.0,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: appBarColor,
    );
  }

}