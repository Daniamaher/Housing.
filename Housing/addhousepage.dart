
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Housing/pages/widgets/customTextField.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:image_picker/image_picker.dart';

class AddHousePage extends StatefulWidget {
  @override
  _AddHousePageState createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  final TextEditingController houseNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController numRoomsController = TextEditingController();
  final TextEditingController numBathroomsController = TextEditingController();
  final TextEditingController numOccupantsController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  List<String> imageUrls = [];
  String? _selectedGender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Add House',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'House Name',
                  controller: houseNameController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Field is required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Price',
                  controller: priceController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Field is required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Number of Rooms',
                  controller: numRoomsController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Field is required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Number of Bathrooms',
                  controller: numBathroomsController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Field is required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Number of Occupants',
                  controller: numOccupantsController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Field is required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Contact Email',
                  controller: emailController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Field is required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
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
                      value: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },

                       validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a gender';
                        } else {
                          return null;
                        }
                      },

                  




                      items: [
                        DropdownMenuItem(
                          value: 'female',
                          child: Text(
                            'Female',
                            style: TextStyle(color: const Color.fromARGB(255, 98, 97, 97)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'male',
                          child: Text(
                            'Male',
                            style: TextStyle(color: const Color.fromARGB(255, 98, 97, 97)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'male and female',
                          child: Text(
                            'Male and female',
                            style: TextStyle(color: const Color.fromARGB(255, 98, 97, 97)),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                if (imageUrls.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            File(imageUrls[index]),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(right: 60.0, left: 60),
                  child: ElevatedButton(
                    onPressed: _validateAndAddHouse,
                    child: Center(child: Text('Add House')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      for (var image in images) {
        setState(() {
          imageUrls.add(image.path);
        });
        print('Added image: ${image.path}');
      }
    }
  }

  void _validateAndAddHouse() {
    if (_formKey.currentState!.validate()) {
      _addHouse();
    }
  }

  void _addHouse() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<String> uploadedImageUrls = [];
      for (var imagePath in imageUrls) {
        File imageFile = File(imagePath);
        if (imageFile.existsSync()) {
          try {
            String uploadedImageUrl = await firestoreService.uploadImage(imageFile);
            uploadedImageUrls.add(uploadedImageUrl);
          } catch (error) {
            print('Error uploading image: $error');
          }
        } else {
          print('File does not exist: $imagePath');
        }
      }
   
      final houseData = {
  'userId': user.uid,
  'houseName': houseNameController.text,
  'price': double.parse(priceController.text),
  'numRooms': int.parse(numRoomsController.text),
  'numBathrooms': int.parse(numBathroomsController.text),
  'gender': _selectedGender,
  'numOccupants': int.parse(numOccupantsController.text),
  'email': emailController.text,
  'imageUrls': uploadedImageUrls,
};

      await firestoreService.addHouse(user.uid, houseData);
      Navigator.pop(context);
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

class FirestoreService {
  final storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(File file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference storageReference = storage.ref().child('images/$fileName');

      UploadTask uploadTask = storageReference.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      print('Error uploading image: $error');
      throw error; 
    }
  }



  Future<void> addHouse(String userId, Map<String, dynamic> houseData) async {
    try {
      CollectionReference housesCollection =
          firestore.collection('users').doc(userId).collection('houses');

      await housesCollection.add(houseData);

      print('House added successfully.');
    } catch (error) {
      print('Error adding house: $error');
      throw error;
    }
  }
}
























































