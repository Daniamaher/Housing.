
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Housing/pages/HousesPage.dart';
import 'package:flutter_application_1/Housing/pages/widgets/customTextField.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditHousePage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> houseData;

  EditHousePage({required this.userId, required this.houseData});

  @override
  _EditHousePageState createState() => _EditHousePageState();
}

class _EditHousePageState extends State<EditHousePage> {
  final TextEditingController houseNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController numRoomsController = TextEditingController();
  final TextEditingController numBathroomsController = TextEditingController();
  final TextEditingController numOccupantsController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<String> imageUrls = [];
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    houseNameController.text = widget.houseData['houseName'];
    priceController.text = widget.houseData['price'].toString();
    numRoomsController.text = widget.houseData['numRooms'].toString();
    numBathroomsController.text = widget.houseData['numBathrooms'].toString();
    _selectedGender = widget.houseData['gender'];
    numOccupantsController.text = widget.houseData['numOccupants'].toString();
    emailController.text = widget.houseData['email'];
    imageUrls = List<String>.from(widget.houseData['imageUrls'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        title: Text('Edit House'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            SizedBox(height: 8),
            CustomTextField(
              label: 'House Name',
              hint: 'Enter House Name',
              controller: houseNameController,
            ),
            SizedBox(height: 20),
         
            SizedBox(height: 8),
            CustomTextField(
              label: 'Price',
              hint: 'Enter Price',
              controller: priceController,
            ),
            SizedBox(height: 20),
         
            SizedBox(height: 8),
            CustomTextField(
              label: 'Number of Rooms',
              hint: 'Enter Number of Rooms',
              controller: numRoomsController,
            ),
            SizedBox(height: 20),
           
            SizedBox(height: 8),
            CustomTextField(
              label: 'Number of Bathrooms',
              hint: 'Enter Number of Bathrooms',
              controller: numBathroomsController,
            ),
            SizedBox(height: 20),
           
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(color: kPrimaryColor),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 40,
                  elevation: 16,
                  hint: Text('Select Gender'),
                  value: _selectedGender ?? widget.houseData['gender'],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'female',
                      child: Text('Female', style: TextStyle(color: const Color.fromARGB(255, 98, 97, 97))),
                    ),
                    DropdownMenuItem(
                      value: 'male',
                      child: Text('Male', style: TextStyle(color: const Color.fromARGB(255, 98, 97, 97))),
                    ),
                    DropdownMenuItem(
                      value: 'male and female',
                      child: Text('Male and Female', style: TextStyle(color: const Color.fromARGB(255, 98, 97, 97))),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
           
            SizedBox(height: 8),
            CustomTextField(
              label: 'Number of Occupants',
              hint: 'Enter Number of Occupants',
              controller: numOccupantsController,
            ),
            SizedBox(height: 20),
          
            SizedBox(height: 8),
            CustomTextField(
              label: 'Contact Email',
              hint: 'Enter Contact Email',
              controller: emailController,
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: MaterialButton(
                onPressed: _pickImages,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_outlined),
                    SizedBox(width: 2),
                    Text('Upload Image'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (imageUrls.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            imageUrls[index],
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteImage(index);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      try {
        for (var image in images) {
          File imageFile = File(image.path);
          String uploadedImageUrl = await _uploadImage(imageFile);
          setState(() {
            imageUrls.add(uploadedImageUrl);
          });
        }
      } catch (error) {
        print('Error uploading image: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image. Please try again.'),
          ),
        );
      }
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
      await storageReference.putFile(imageFile);
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Error uploading image: $error');
      throw error;
    }
  }

  void _deleteImage(int index) {
    setState(() {
      imageUrls.removeAt(index);
    });
  }

  void _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final updatedHouseData = {
          'houseName': houseNameController.text,
          'price': double.tryParse(priceController.text) ?? 0.0,
          'numRooms': int.tryParse(numRoomsController.text) ?? 0,
          'numBathrooms': int.tryParse(numBathroomsController.text) ?? 0,
          'gender': _selectedGender ?? '',
          'numOccupants': int.tryParse(numOccupantsController.text) ?? 0,
          'email': emailController.text,
          'imageUrls': imageUrls,
        };

        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('houses')
            .where('houseName', isEqualTo: widget.houseData['houseName'])
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var docId = querySnapshot.docs.first.id;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .collection('houses')
              .doc(docId)
              .update(updatedHouseData);
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HousingPage()),
        );
      } catch (error) {
        print('Error updating house: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating house. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    houseNameController.dispose();
    priceController.dispose();
    numRoomsController.dispose();
    numBathroomsController.dispose();
    numOccupantsController.dispose();
    emailController.dispose();
    super.dispose();
  }
}








