import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadImageToFirestore(File imageFile) async {
  try {
    if (!await imageFile.exists()) {
      print('Image file does not exist');
      return;
    }

    // Create a unique filename for the image
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Create a reference to the Firebase Storage location
    final Reference storageReference =
    FirebaseStorage.instance.ref().child('images/profilePic/$fileName');

    // Upload the file to Firebase Storage
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask;

    // Get the download URL of the uploaded image
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    // Save the download URL in Cloud Firestore
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'url': downloadUrl});

    print('Image uploaded to Firestore: $downloadUrl');
  } catch (e) {
    // Handle any errors that occur during the upload process
    print('Error uploading image to Firestore: $e');
  }
}