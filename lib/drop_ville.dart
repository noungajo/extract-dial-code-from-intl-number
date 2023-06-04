import 'package:extract_code_from_phone_number/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'country_and_country_code.dart';

class DropVille extends StatefulWidget {
  const DropVille({super.key});
  @override
  State<DropVille> createState() {
    return _DropVilleState();
  }
}

class _DropVilleState extends State<DropVille> {
  var listOfQuartier = [].obs;

  TextEditingController controllerText = TextEditingController();
  LivraisonController livraisonController = Get.find<LivraisonController>();
  dynamic dropValuequartier, dropValueCity;
  @override
  void initState() {
    if (livraisonController.isTheElementInListOfObject(
        livraisonController.listOfCity,
        livraisonController.sendData["city"] ?? "")) {
      dropValueCity = livraisonController.sauvegardeVilleSelectionne;
      setState(() {
        dropValuequartier = livraisonController.sauvegardeQuartierSelectionne;
        listOfQuartier.value =
            extractData(Zones.zones, dropValueCity["@id"].split("/").last);
      });
    } else {
      dropValueCity = livraisonController.listOfCity.first;
      livraisonController.sauvegardeVilleSelectionne = dropValueCity;
      livraisonController.sendData["city"] = dropValueCity["name"];
      setState(() {
        listOfQuartier.value =
            extractData(Zones.zones, dropValueCity["@id"].split("/").last);
        if (listOfQuartier.isNotEmpty) {
          dropValuequartier = listOfQuartier.first;
          livraisonController.sauvegardeQuartierSelectionne = dropValuequartier;
          livraisonController.sendData["quartier"] = dropValuequartier["name"];
        }
      });
    }
    if (livraisonController.sendData["prenom"] != null) {
      controllerText.text = livraisonController.sendData["prenom"];
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
                          label: Text("Ton prenom"),
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
                    child: dropDownVille(),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: Obx(() => dropDownQuartier()),
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

  Widget boutonsuivant() {
    return ElevatedButton(
      onPressed: () {
        livraisonController.sendData["Prenom"] = controllerText.text;
        // ignore: avoid_print
        print(livraisonController.sendData);
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

  Widget dropDownVille() {
    return DropdownButtonFormField<dynamic>(
      items: livraisonController.listOfCity
          .map((item) =>
              DropdownMenuItem(value: item, child: Text(item["name"])))
          .toList(),
      value: dropValueCity,
      onChanged: (value) {
        setState(() {
          livraisonController.sendData["city"] = value["name"];
          dropValueCity = value;
          livraisonController.sauvegardeVilleSelectionne = value;
          listOfQuartier.value =
              extractData(Zones.zones, value["@id"].split("/").last);
          if (listOfQuartier.isNotEmpty) {
            dropValuequartier = listOfQuartier.first;
            livraisonController.sauvegardeQuartierSelectionne =
                dropValuequartier;
          }
        });
      },
      menuMaxHeight: 300,
      decoration: const InputDecoration(
        label: Text("Ville"),
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

  DropdownButtonFormField dropDownQuartier() {
    return DropdownButtonFormField<dynamic>(
      items: listOfQuartier
          .map((item) =>
              DropdownMenuItem(value: item, child: Text(item['name'])))
          .toList(),
      value: dropValuequartier,
      onChanged: (value) {
        livraisonController.sendData["quartier"] = value["name"];
        livraisonController.sauvegardeQuartierSelectionne = value;
        setState(() {
          dropValuequartier = value;
        });
      },
      menuMaxHeight: 300,
      decoration: const InputDecoration(
        label: Text("Quartier"),
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
