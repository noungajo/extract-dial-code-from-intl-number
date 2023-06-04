import 'package:extract_code_from_phone_number/controller.dart';
import 'package:extract_code_from_phone_number/drop_ville.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'country_and_country_code.dart';

class MultipleDropDownSelection extends StatefulWidget {
  const MultipleDropDownSelection({super.key});

  @override
  State<MultipleDropDownSelection> createState() =>
      _MultipleDropDownSelectionState();
}

class _MultipleDropDownSelectionState extends State<MultipleDropDownSelection> {
  var listOfProvince = [], listOfCity = [].obs;
  var pays = [
    {
      "code": "CM",
      "name": "Cameroun",
    },
    {
      "code": "CI",
      "name": "Côte d'ivoire",
    },
    {
      "code": "FR",
      "name": "France",
    }
  ];
  TextEditingController controllerText = TextEditingController();
  LivraisonController livraisonController = Get.find<LivraisonController>();
  dynamic dropValueProvince, dropValue;
  @override
  void initState() {
    dropValue = pays.first;
    listOfProvince = provinceCode;
    livraisonController.sendData["country"] = dropValue["name"];
    if (listOfProvince.isNotEmpty) {
      dropValueProvince = provinceCode.first;
      livraisonController.sauvegardeRegionSelectionne = dropValueProvince;
      livraisonController.sendData["provinceCode"] = dropValueProvince["code"];
      livraisonController.sendData["provinceName"] = dropValueProvince["name"];
      livraisonController.listOfCity =
          extractData(Zones.zones, dropValueProvince["code"]);
    }
    if (livraisonController.sendData["Nom"] != null) {
      controllerText.text = livraisonController.sendData["Nom"];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.8,
                    // height: size.height * 0.08,
                    child: TextFormField(
                        cursorColor: Colors.black,
                        controller: controllerText,
                        //_contLivraison.addressFacture.billingAddress.firstName,
                        decoration: const InputDecoration(
                          label: Text("Ton nom"),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffC41028), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffC41028), width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffC41028), width: 1),
                          ),
                          disabledBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          return null;
                        }),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: dropDownCountry(),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: dropDownProvince(),
                  ),
                  boutonsuivant()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownCountry() {
    return DropdownButtonFormField<dynamic>(
      items: pays.map<DropdownMenuItem<dynamic>>((value) {
        return DropdownMenuItem<dynamic>(
          value: value,
          child: Text("${value['name']}"),
        );
      }).toList(),
      value: dropValue,
      onChanged: (dynamic value) {
        livraisonController.sendData["country"] = value["name"];
        setState(() {
          dropValue = pays.first;
          listOfProvince = provinceCode;
        });
      },
      decoration: const InputDecoration(
        label: Text("Pays"),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffC41028), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffC41028), width: 1),
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }

  Widget boutonsuivant() {
    return ElevatedButton(
      onPressed: () {
        livraisonController.sendData["Nom"] = controllerText.text;
        if (livraisonController.listOfCity.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DropVille()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Aucune ville pour cette région")),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 50),
        backgroundColor: const Color(0xffE2122E),
        maximumSize: const Size(130, 60),
        // onPrimary: Colors.black,
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Afficher",
            style: TextStyle(
                letterSpacing: 2,
                color: Colors.white,
                fontWeight: FontWeight.w700),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          )
        ],
      ),
      // )
    );
  }

  extractData(List listOfData, String code) {
    List returnData = [];
    for (var zone in listOfData) {
      if (zone["members"][0].split("/").last == code) {
        returnData.add(zone);
      }
    }
    return returnData;
  }

  DropdownButtonFormField dropDownProvince() {
    return DropdownButtonFormField<dynamic>(
      items: provinceCode.map<DropdownMenuItem<dynamic>>((value) {
        return DropdownMenuItem<dynamic>(
          value: value,
          child: Text("${value['name']}"),
        );
      }).toList(),
      value: dropValueProvince,
      onChanged: (value) {
        livraisonController.sauvegardeRegionSelectionne = value;
        livraisonController.sendData["provinceCode"] = value["code"];
        livraisonController.sendData["provinceName"] = value["name"];
        setState(() {
          livraisonController.listOfCity =
              extractData(Zones.zones, value["code"]);
          dropValueProvince = value;
        });
      },
      menuMaxHeight: 300,
      decoration: const InputDecoration(
        label: Text("Province"),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffC41028), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffC41028), width: 1),
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }
}
