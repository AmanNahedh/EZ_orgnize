import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:ez_orgnize/General/BirthdayInputWidget.dart';
import 'package:ez_orgnize/General/city_picker.dart';
import 'package:ez_orgnize/General/phone_number.dart';
import 'package:ez_orgnize/General/textFormField.dart';
import 'package:ez_orgnize/General/upload_image_to_firebase.dart';
import 'package:ez_orgnize/fire_base/Cheak.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class RegisterInfo extends StatefulWidget {
  final Function(String)? onNationalitySelected;

  const RegisterInfo({super.key, this.onNationalitySelected});

  @override
  State<RegisterInfo> createState() => _RegisterInfoState();
}

class _RegisterInfoState extends State<RegisterInfo> {
  var scafoldKey = GlobalKey<FormState>();

  bool editMode = false;

  void _valdiate() async {
    final isValid = scafoldKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "gender": 'selectedGender',
      "FirstName": firstNameCont.text,
      "LastName": lastNameCont.text,
      "PhoneNumber": phone.toString(),
      "City": city.toString(),
      "Nationality": selectedNationality,
      "TimeStamp": DateTime.now(),
      "Validity": "organizer",
      "tallCont": tallCont.text,
      "weightCont": weightCont.text,
      "id": FirebaseAuth.instance.currentUser!.uid,
      "work time": '',
      "rating": '',
    }).then((value) async {
      print('done');
    });
    await uploadImageToFirestore(selectedImage);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const cheak(),
      ),
    );
  }

  //Nationality
  String selectedNationality = 'Saudi Arabia';

  //to save birthday
  late DateTime selectedDate;

  var selectedImage;

  String editModeImageURL = '';

  void handleDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    // Do something with the selected date
    print('Selected date: $selectedDate');
  }

  var firstNameCont = TextEditingController();
  var lastNameCont = TextEditingController();
  var tallCont = TextEditingController();
  var weightCont = TextEditingController();
  String selectedGender = '';

  var phone = '';
  var city = 'Riyadh';

  @override
  void dispose() {
    firstNameCont.dispose();
    lastNameCont.dispose();
    tallCont.dispose();
    weightCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Register')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: scafoldKey,
            child: Column(
              children: [
                TextForm(
                  hint: 'first name',
                  controler: firstNameCont,
                  valid: (value) {
                    if (value.isEmpty) {
                      return 'pls enter your first name';
                    } else if (value.length == 1) {
                      return 'enter valid name';
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextForm(
                  hint: 'last name',
                  controler: lastNameCont,
                  valid: (value) {
                    if (value.isEmpty) {
                      return 'pls enter yur last name';
                    } else if (value.length == 1) {
                      return 'pls enter valid name';
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Male',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                              print(selectedGender);
                            });
                          },
                        ),
                        const Text('Male'),
                        const SizedBox(width: 16),
                        Radio<String>(
                          value: 'Female',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                              print(selectedGender);
                            });
                          },
                        ),
                        const Text('Female'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                BirthdayInputWidget(onDateSelected: handleDateSelected),
                const SizedBox(
                  height: 20,
                ),
                TextForm(
                  hint: 'Tall in CM',
                  controler: tallCont,
                  valid: (value) {
                    if (value.isEmpty) {
                      return 'pls enter valid tall in CM';
                    } else if (int.parse(value) < 140 ||
                        int.parse(value) > 220) {
                      return 'pls enter valid tall';
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextForm(
                  hint: 'weight in  KG',
                  controler: weightCont,
                  valid: (value) {
                    if (value.isEmpty) {
                      return 'pls enter weight in KG';
                    } else if (int.parse(value) < 35 ||
                        int.parse(value) > 170) {
                      return 'pls enter valid tall';
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                PhoneNumberInputWidget(onPhoneNumberChanged: (value) {
                  phone = value;
                }),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Nationality',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 8),
                CountryListPick(
                  theme: CountryTheme(
                    initialSelection: 'Saudi Arabia',
                    isShowCode: false,
                  ),
                  initialSelection: '966',
                  onChanged: (CountryCode? code) {
                    setState(
                      () {
                        selectedNationality = code!.name!;
                        print(selectedNationality);
                      },
                    );
                    widget.onNationalitySelected!(selectedNationality);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CityPickerWidget(onCitySelected: (value) {
                  city = value;
                }),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: editMode,
                  replacement: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                    },
                    child: selectedImage != null
                        ? SizedBox(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                selectedImage as File,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            // margin: EdgeInsets.symmetric(horizontal: 50),
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.teal,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6)),
                            width: MediaQuery.of(context).size.width,
                            child: const Column(
                              children: [
                                SizedBox(height: 30),
                                Icon(Icons.account_box, size: 50.0),
                                Text(
                                  'Upload your photo',
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ),
                  ),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                            image: NetworkImage(editModeImageURL))),
                  ),
                ),
                const Divider(),
                ElevatedButton(
                  onPressed: _valdiate,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    backgroundColor: Theme.of(context).colorScheme.background,

                    textStyle: const TextStyle(fontSize: 16),

                    padding: const EdgeInsets.all(12), // Set the button padding
                  ),
                  child: const Text('save iinfo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 95,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton.icon(
                  icon: Icon(Icons.camera,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  label: const Text(
                    "Camera",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: Icon(Icons.image,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  label: const Text(
                    "Gallery",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ])
        ],
      ),
    );
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.platform
        .getImageFromSource(source: source); //pickImage
    print('printing source of image $source');
    setState(() {
      selectedImage = File(image!.path);
    });
  }
}
