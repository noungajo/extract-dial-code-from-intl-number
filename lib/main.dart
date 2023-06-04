import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'country_and_country_code.dart';
import 'drop_down_selection.dart';

seperatePhoneAndDialCode(String phoneWithDialCode) {
  if (phoneWithDialCode.contains("+") == false) {
    phoneWithDialCode = "+$phoneWithDialCode";
  }
  Map<String, String> foundedCountry = {};
  for (var country in Countries.allCountries) {
    String dialCode = country["dial_code"].toString();
    if (phoneWithDialCode.contains(dialCode)) {
      foundedCountry = country;
    }
  }

  if (foundedCountry.isNotEmpty) {
    var dialCode = phoneWithDialCode.substring(
      0,
      foundedCountry["dial_code"]!.length,
    );
    var newPhoneNumber = phoneWithDialCode.substring(
      foundedCountry["dial_code"]!.length,
    );
    // ignore: avoid_print
    print({dialCode, newPhoneNumber});
  }
}

dynamic selectedVille = {
  "@id": "/api/v2/shop/zones/dla",
  "@type": "Zone",
  "name": "Douala",
  "members": ["/api/v2/admin/zone-members/CM-LT"]
};
dynamic selectedQuartier = {
  "@id": "/api/v2/shop/zones/dla-bonapriso",
  "@type": "Zone",
  "name": "Bonapriso",
  "members": ["/api/v2/admin/zone-members/dla"]
};
extractData(List listOfData, String code) {
  List returnData = [];

  for (var zone in listOfData) {
    if (zone["members"][0].split("/").last == code) {
      returnData.add(zone);
    }
  }
  return returnData;
}

void main() {
  Get.put(LivraisonController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MultipleDropDownSelection(),
    );
  }
}
// je suis une région et je voudraiss avoir toutes mes villes
/*
toutes mes villes se reconnaisses par mon code présent dans leur hydramember
*/

// je suis une ville et je voudrais tous mes quartiers
/*
tous mes quartiers se recconnaisse car leur id contient mon code
*/