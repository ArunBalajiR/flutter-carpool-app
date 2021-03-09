import 'dart:math';

class BackendService {
   static Future<List> getSuggestions(String query) async {
      await Future.delayed(Duration(seconds: 1));

      return List.generate(3, (index) {
         return {'name': query + index.toString(), 'price': Random().nextInt(100)};
      });
   }
}

class CitiesService {

   static final List<String> predictionList = [

      "80 Feet Road",
      "Alagappan Nagar",
      "Alagar Kovil Road",
      "Amman Sannathi Street",
      "Anaiyur",
      "Andalpuram",
      "Anna Nagar",
      "Anuppanadi",
      "Arappalayam",
      "Arasaradi",
      "Avaniyapuram",
      "Bibikulam",
      "Bypass Road",
      "Chinna Chokkikulam",
      "Chokikulam",
      "Dhanappa Mudali Street",
      "East Avani Moola Street",
      "East Marret Street",
      "East Masi Street",
      "East Veli Street",
      "Ellis Nagar",
      "Gandhi Nagar",
      "Gnanavolivupuram",
      "Goripalayam",
      "Jaihindpuram",
      "K.K. Nagar",
      "K.Pudur",
      "Kaka Thoppu Street",
      "Kalavasal",
      "Kamarajar Salai",
      "Kansamettu Street",
      "Kochadai",
      'Kodikulam',
      "Koodal Nagar",
      "Krishnapuram Colony",
      "Krishnarayar Tank Road",
      "Lakshmipuram",
      "Mahaboopalayam",
      "Manjanakara Street",
      "Mattuthavani",
      "Melakkal Road",
      "Melur Road",
      "Munichalai Road",
      "Naicker New Street",
      "Narayanapuram",
      "Narimedu",
      "Nethaji Road",
      "New Mahalipatti Road",
      "New Natham Road",
      "North Chitrai Street",
      "North Masi Street",
      "North Veli Street",
      "Othakadai",
      "Palace Road",
      "Palanganatham",
      "Pasumalai",
      "Ponmeni",
      "PT Rajan Road",
      "S S Colony",
      "Sathya Sai Nagar",
      "Sellur",
      "Sellur Road",
      "Shenoy Nagar",
      "Simmakkal",
      "South Avani Moola Street",
      "South Gate",
      "Therkuvasal",
      "Keezhaavasal",
      "Pottapalayam",
      "Ellis Nagar",
      "Munichalai",
      "South Marret Street",
      "South Masi Street",
      "South Veli Street",
      "SS Colony",
      "Subramaniapuram",
      "Surya Nagar",
      "Tallakulam",
      "Tamil Sangam Road",
      "Theni Main Road",
      "Town Hall Road",
      "TPK Road",
      "TVS Nagar",
      "Uthangudi",
      "Vakkil New Street",
      "Velmurugan Nagar",
      "Vengalakadai Street",
      "Vilangudi",
      "Villapuram",
      "Virattipathu",
      "Visalakshipuram Main Road",
      "Vishwanathapuram",
      "West Avani Moola Street",
      "West Masi Street",
      "West Perumal Maistry Street",
      "West Tower Street",
      "West Vadampokki Street",
      "West Veli Street",

   ];

   static List<String> getSuggestions(String query) {
      List<String> matches = [];
      matches.addAll(predictionList);

      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
      return matches;
   }
}






// TextField(
// onChanged: (val) {
// to = val;
//
// },
// autofocus: false,
//
// controller: _controller,
//
// cursorColor: Colors.black,
// // controller: appState.locationController,
// decoration: InputDecoration(
// filled: true,
// prefixIcon: Icon(
// Icons.location_on,
// color: clr,
// ),
// hintText: str,
// border: InputBorder.none,
// contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
// fillColor: Colors.white,
// ),
// ),