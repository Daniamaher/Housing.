
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Housing/myhouse.dart';
import 'package:flutter_application_1/Housing/pages/addhousepage.dart';
import 'package:flutter_application_1/Housing/pages/housedetailspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Housing/pages/houseownerloginpage.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HousingPage extends StatefulWidget {
  const HousingPage({Key? key}) : super(key: key);

  @override
  _HousingPageState createState() => _HousingPageState();
}

class _HousingPageState extends State<HousingPage> {
  double? _minPrice;
  double? _maxPrice;
  String? _selectedGender;
  int? _selectedBathroom;

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
backgroundColor:Color(0xff0f1035) ,
        title: Text('Houses',style: TextStyle(color: Colors.white),),
        actions: <Widget>[


            IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'My House ',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return MyHousingPage
                    ();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            tooltip: 'Filter',
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add House',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return AddHousePage();
                  },
                ),
              );
            },
          ),
           IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out ',
            onPressed: ()async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return HouseOwnerLoginPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collectionGroup('houses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final List<DocumentSnapshot> houseDocs = snapshot.data!.docs;
            final filteredHouseDocs = _filterHouses(houseDocs);

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredHouseDocs.length,
              itemBuilder: (context, index) {
                final houseData = filteredHouseDocs[index].data() as Map<String, dynamic>;
                final List<String> imageUrls = List<String>.from(houseData['imageUrls'] ?? []);
                return HouseItem(
                  houseName: houseData['houseName'] ?? '',
                  housePrice: houseData['price'] ?? 0.0,
                  occupants: houseData['numOccupants'] ?? 0,
                  rooms: houseData['numRooms'] ?? 0,
                  imageUrls: imageUrls,
                  userId: houseData['userId'],
                  gender: houseData['gender'] ?? '',
                  email: houseData['email'] ?? '',
                  bathrooms: houseData['numBathrooms'] ?? 0,   houseId: houseDocs[index].id,
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<DocumentSnapshot> _filterHouses(List<DocumentSnapshot> houseDocs) {
    return houseDocs.where((house) {
      final houseData = house.data() as Map<String, dynamic>;

      if (_minPrice != null &&
          houseData['price'] < _minPrice! ||
          _maxPrice != null &&
          houseData['price'] > _maxPrice!) {
        return false;
      }

      if (_selectedGender != null &&
          houseData['gender'] != _selectedGender) {
        return false;
      }

      if (_selectedBathroom != null &&
          houseData['numBathrooms'] != _selectedBathroom) {
        return false;
      }

      return true;
    }).toList();
  }

  void _showFilterDialog() {
    TextEditingController minPriceController = TextEditingController();
    TextEditingController maxPriceController = TextEditingController();

    ValueNotifier<String?> selectedGenderNotifier = ValueNotifier<String?>(_selectedGender);
    ValueNotifier<int?> selectedBathroomNotifier = ValueNotifier<int?>(_selectedBathroom);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filters'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price Range'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minPriceController,
                        decoration: InputDecoration(labelText: 'Min'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _minPrice = value.isNotEmpty ? double.parse(value) : null;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: maxPriceController,
                        decoration: InputDecoration(labelText: 'Max'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _maxPrice = value.isNotEmpty ? double.parse(value) : null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('Gender'),
                ValueListenableBuilder<String?>(
                  valueListenable: selectedGenderNotifier,
                  builder: (context, value, child) {
                    return DropdownButton<String>(
                      value: value,
                      onChanged: (newValue) {
                        selectedGenderNotifier.value = newValue;
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
                      items: <String>['', 'male', 'female', 'male and female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.isNotEmpty ? value : 'Any Gender'),
                        );
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text('Number of Bathrooms'),
                ValueListenableBuilder<int?>(
                  valueListenable: selectedBathroomNotifier,
                  builder: (context, value, child) {
                    return DropdownButton<int>(
                      value: value,
                      onChanged: (newValue) {
                        selectedBathroomNotifier.value = newValue;
                        setState(() {
                          _selectedBathroom = newValue;
                        });
                      },
                      items: <int>[0, 1, 2, 3, 4, 5]
                          .map<DropdownMenuItem<int>>((int? value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value != null ? value.toString() : 'Any'),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                minPriceController.clear();
                maxPriceController.clear();
                selectedGenderNotifier.value = null;
                selectedBathroomNotifier.value = null;
                setState(() {
                  _minPrice = null;
                  _maxPrice = null;
                  _selectedGender = null;
                  _selectedBathroom = null;
                });
                Navigator.of(context).pop();
              },
              child: Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Apply'),
            ),
          ],        );
      },
    );
  }
}

