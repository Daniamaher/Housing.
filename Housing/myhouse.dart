import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Housing/pages/addhousepage.dart';
import 'package:flutter_application_1/Housing/pages/housedetailspage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';

class MyHousingPage extends StatelessWidget {
  const MyHousingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
     final   FirebaseAuth auth=FirebaseAuth.instance;
     final  User? user =auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Houses'),
        actions: <Widget>[
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('users')
              .doc(user?.uid)
              .collection('houses')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final List<DocumentSnapshot> houseDocs = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              itemCount: houseDocs.length,
              itemBuilder: (context, index) {
                final houseData =
                    houseDocs[index].data() as Map<String, dynamic>;
                final List<String> imageUrls =
                    List<String>.from(houseData['imageUrls'] ?? []);
                return HouseItem(
                  houseName: houseData['houseName'] ?? '',
                  housePrice: houseData['price'] ?? '',
                  occupants:
                      int.tryParse(houseData['numOccupants'].toString()) ?? 0,
                  rooms: int.tryParse(houseData['numRooms'].toString()) ?? 0,
                  imageUrls: imageUrls,
                  userId: houseData['userId'],
                  gender: houseData['gender'],
                  email: houseData['email'],
                  bathrooms: houseData['numBathrooms'], 
                   houseId: houseDocs[index].id,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class HouseItem extends StatelessWidget {
  final String houseName;
  final double housePrice;
  final int occupants;
  final int rooms;
  final List<String> imageUrls;
  final String gender;
  final String email;
  final String userId;
  final int bathrooms;
      final String houseId;  

  const HouseItem({
    required this.houseName,
    required this.housePrice,
    required this.occupants,
    required this.rooms,
    required this.imageUrls,
    required this.gender,
    required this.email,
    required this.userId,
    required this.bathrooms, required this.houseId,
  });

  @override
  Widget build(BuildContext context) {
    String? firstImageUrl = imageUrls.isNotEmpty ? imageUrls.first : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayHouseDetailPage(
              houseDetails: HouseDetails(
                houseId: houseId,
                houseName: houseName,
                housePrice: housePrice,
                occupants: occupants,
                rooms: rooms,
                imageUrls: imageUrls,
                gender: gender,
                email: email,
                userId: userId,
                bathrooms: bathrooms,
              ),
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            firstImageUrl != null
                ? Image.network(
                    firstImageUrl,
                    width: double.infinity,
                    height: 190,
                    fit: BoxFit.cover,
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    houseName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Price: $housePrice',
                    style: TextStyle(color: Colors.yellow),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 4),
                      Text('Occupants: $occupants'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 4),
                      Text('Rooms: $rooms'),
                      SizedBox(width: 6),
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.toilet,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                      Text('bathroom $bathrooms'),
                    ],
                  ),

                 
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person_rounded),
                      SizedBox(width: 4),
                      Text('gender: $gender'),
                    ],
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}














