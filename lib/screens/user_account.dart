import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:glassmorphism/glassmorphism.dart';

class UserProfiles extends StatefulWidget {
  const UserProfiles({Key? key}) : super(key: key);

  @override
  State<UserProfiles> createState() => _UserProfilesState();
}

class _UserProfilesState extends State<UserProfiles> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late User _user;
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isEditing = false;
  late String _profileImageURL = '';

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .get();

      setState(() {
        _aboutMeController.text = userSnapshot.get('aboutMe') ?? '';
        _phoneNumberController.text = userSnapshot.get('phoneNumber') ?? '';
        _profileImageURL = userSnapshot.get('profileImageURL') ?? '';
      });
    } catch (e) {
      print('Error getting user info: $e');
    }
  }

  Future<void> _updateAboutMe() async {
    try {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(_user.uid);

      await userDoc.set({
        'displayName': _user.displayName,
        'email': _user.email,
        'aboutMe': _aboutMeController.text,
        'phoneNumber': _phoneNumberController.text,
        'profileImageURL': _profileImageURL,
      }, SetOptions(merge: true));

      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _profileImageURL = result.files.first.path ?? '';
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlassContainer({required Widget child, double blur = 15}) {
    return GlassmorphicContainer(
      width: MediaQuery.of(context).size.width,
      height: 110,
      borderRadius: 20,
      blur: blur,
      alignment: Alignment.topLeft,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.topRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.1),
          Color.fromRGBO(255, 255, 255, 1).withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.5),
          Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGlassDetailedContainer(
      {required Widget child, double blur = 15}) {
    return GlassmorphicContainer(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 700,
      borderRadius: 50,
      blur: blur,
      alignment: Alignment.center,
      border: 0,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.transparent, Colors.transparent],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.5),
          Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: child,
    );
  }

  Widget _buildProfileSection(
    String title,
    IconData icon,
    String content,
    bool isEditing,
    IconData editIcon,
    VoidCallback onPressed,
  ) {
    return Container(
      color: Color.fromRGBO(21, 39, 61, 1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (isEditing)
                IconButton(
                  icon: Icon(editIcon),
                  onPressed: onPressed,
                ),
            ],
          ),
          SizedBox(height: 8),
          isEditing
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    initialValue: content,
                    maxLines: title == 'About Me' ? 3 : 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: title == 'About Me'
                          ? 'Write something about yourself'
                          : 'Enter your phone number',
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
        ],
      ),
    );
  }

  void _showDetailedProfile() {
    bool isEditingAll = false;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                color: Color.fromRGBO(21, 39, 61, 1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppBar(
                        backgroundColor: Color.fromRGBO(18, 39, 62, 1),
                        elevation: 0,
                        actions: [
                          if (!isEditingAll)
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  isEditingAll = true;
                                });
                              },
                            ),
                        ],
                      ),
                      _buildGlassDetailedContainer(
                        child: Container(
                          color: Color.fromRGBO(21, 39, 61, 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 80,
                                    backgroundImage: _profileImageURL.isNotEmpty
                                        ? AssetImage(_profileImageURL)
                                        : NetworkImage(_user.photoURL!)
                                            as ImageProvider<Object>,
                                  ),
                                  if (isEditingAll)
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: _showImagePickerOptions,
                                        child: Icon(Icons.edit),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                _user.displayName ?? 'No Name',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _user.email ?? 'No Email',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 24),
                              _buildProfileSection(
                                'About Me',
                                Icons.info,
                                _aboutMeController.text.isNotEmpty
                                    ? _aboutMeController.text
                                    : 'No additional information available.',
                                isEditingAll,
                                Icons.edit,
                                () {
                                  setState(() {
                                    isEditingAll = true;
                                  });
                                },
                              ),
                              SizedBox(height: 24),
                              _buildProfileSection(
                                'Phone Number',
                                Icons.phone,
                                _phoneNumberController.text.isNotEmpty
                                    ? _phoneNumberController.text
                                    : 'No phone number available.',
                                isEditingAll,
                                Icons.edit,
                                () {
                                  setState(() {
                                    isEditingAll = true;
                                  });
                                },
                              ),
                              SizedBox(height: 24),
                              if (isEditingAll)
                                ElevatedButton(
                                  onPressed: () async {
                                    await _updateAboutMe();
                                    setState(() {
                                      isEditingAll = false;
                                    });
                                  },
                                  child: Text('Save'),
                                ),
                              SizedBox(height: 24),
                              GestureDetector(
                                onTap: () async {
                                  await _signOut();
                                },
                                child: Text(
                                  'Sign Out',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 28,
        backgroundColor: Color.fromRGBO(0, 34, 53, 1),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.exit_to_app),
        //     onPressed: _signOut,
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              if (!_isEditing) {
                _showDetailedProfile();
              }
            },
            child: _buildGlassContainer(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // First Column: Profile Picture
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        width: 58,
                        height: 58,
                        child: Image(
                          image: _profileImageURL.isNotEmpty
                              ? AssetImage(_profileImageURL)
                              : NetworkImage(_user.photoURL!)
                                  as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),

                    // Second Column: Name and Email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user.displayName ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _user.email ?? 'No Email',
                            style: const TextStyle(
                              fontSize: 14.5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Third Column: Arrow
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white, // Adjust the color as needed
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
