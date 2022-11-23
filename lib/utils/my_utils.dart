import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:patient/configs/my_print.dart';
import 'package:uuid/uuid.dart';

import '../configs/constants.dart';


class MyUtils {
  static Future<void> copyToClipboard(BuildContext? context, String string) async {
    if(string.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: string));
      if(context != null) {
        // Snakbar().show_info_snakbar(context, "Copied");
      }
    }
  }

  String getSecureUrl(String url) {
    if(url.startsWith("http:")) {
      url = url.replaceFirst("http:", "https:");
    }
    return url;
  }

  static String getUniqueIdFromUuid() {
    return const Uuid().v1().replaceAll("-", "");
  }

  String getCurrentDoseTime() {
     DateTime currentTime = DateTime.now();
     MyPrint.printOnConsole("Current time is hour: ${currentTime.hour} && minute: ${currentTime.minute}");

    if((currentTime.hour >= 0 && currentTime.minute > 0) && (currentTime.hour < 11)){
      return PrescriptionMedicineDoseTime.morning;
    }else if((currentTime.hour >= 11 && currentTime.minute > 0) && (currentTime.hour < 17)){
      return PrescriptionMedicineDoseTime.afternoon;
     }else if(currentTime.hour >= 17 && currentTime.minute > 0 && currentTime.hour < 22){
       return PrescriptionMedicineDoseTime.evening;
     }else if(currentTime.hour >= 22 && currentTime.minute > 0 && currentTime.hour < 23 && currentTime.minute < 59){
       return PrescriptionMedicineDoseTime.night;
     }else{
      MyPrint.printOnConsole("Time data is empty");
      return '';
     }

  }


}













