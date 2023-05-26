import 'country_and_country_code.dart';

seperatePhoneAndDialCode(String phoneWithDialCode) {
  if (phoneWithDialCode.contains("+") == false) {
    phoneWithDialCode = "+$phoneWithDialCode";
  }
  Map<String, String> foundedCountry = {};
  for (var country in Countries.allCountries) {
    String dialCode = country["dial_code"].toString();
    if (phoneWithDialCode.contains(dialCode)) {
      print(country);
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
    print({dialCode, newPhoneNumber});
  }
}

void main() {
  seperatePhoneAndDialCode("+33690291718");
}
