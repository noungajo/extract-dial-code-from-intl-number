import 'package:get/get_state_manager/get_state_manager.dart';

class LivraisonController extends GetxController {
  var sendData = {};
  var listOfCity = [];
  var sauvegardeRegionSelectionne = {},
      sauvegardeVilleSelectionne = {},
      sauvegardeQuartierSelectionne = {};
  isTheElementInListOfObject(List laListe, String element) {
    if (element.isNotEmpty) {
      for (var item in laListe) {
        if (item["name"] == element) {
          return true;
        }
      }
    }
    return false;
  }
}
