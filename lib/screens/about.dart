import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Define the function for building the glass container without shadow
Widget _buildGlassContainer({required Widget child, double width = 320}) {
  return Container(
    width: width,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.1),
          Color.fromRGBO(255, 255, 255, 1).withOpacity(0.05),
        ],
      ),
    ),
    child: Center(child: child), // Center the child vertically
  );
}

// Define the function for building glassy-styled buttons
Widget _buildGlassButton({
  required String label,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.3),
          Color.fromRGBO(255, 255, 255, 1).withOpacity(0.2),
        ],
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 8, horizontal: 16), // Adjust button padding
          child: Text(
            label,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14, // Adjust button font size
            ),
          ),
        ),
      ),
    ),
  );
}

// Widget to display profile details with large photo and fixed information
class ProfileDetails extends StatelessWidget {
  final String name;
  final String description;
  final String githubLink;
  final String linkedInLink;
  final String photoUrl;

  ProfileDetails({
    required this.name,
    required this.description,
    required this.githubLink,
    required this.linkedInLink,
    required this.photoUrl,
  });

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.8;

    return _buildGlassContainer(
      width: containerWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _launchUrl(githubLink),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                photoUrl,
                width: containerWidth * 0.4,
                height: containerWidth * 0.4,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          _buildGlassButton(
            label: 'GitHub',
            onPressed: () => _launchUrl(githubLink),
          ),
          SizedBox(height: 4), // Reduced SizedBox height between buttons
          _buildGlassButton(
            label: 'LinkedIn',
            onPressed: () => _launchUrl(linkedInLink),
          ),
        ],
      ),
    );
  }
}

// Widget to display static profiles with photos
class ProfilesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('The Creators')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileDetails(
                name: 'Gopal Singh S',
                description: 'Data Analyst/Flutter Developer',
                githubLink: 'https://github.com/GopalSinghRajput',
                linkedInLink:
                    'https://www.linkedin.com/in/gopal-singh-s-49b62a166/',
                photoUrl:
                    'https://media.licdn.com/dms/image/D5603AQHT_chPVnoRxQ/profile-displayphoto-shrink_800_800/0/1703058736614?e=1719446400&v=beta&t=GKCvjSeSo4FrN3tddqQFc6pbS2A__NmcinkID8U6k_E',
              ),
              SizedBox(height: 40),
              ProfileDetails(
                name: 'Fardeen Feroz Khan',
                description: 'Data Scientist/Machine Learning Engineer',
                githubLink: 'https://github.com/vinpatrol',
                linkedInLink:
                    'https://www.linkedin.com/in/fardeen-feroz-khan-98a866220/',
                photoUrl:
                    'https://instagram.fmaa1-3.fna.fbcdn.net/v/t51.2885-19/129722522_147491063382637_4447843167566056037_n.jpg?stp=dst-jpg_s320x320&_nc_ht=instagram.fmaa1-3.fna.fbcdn.net&_nc_cat=101&_nc_ohc=R55OEXTUzL0Ab4_dimv&edm=AOQ1c0wBAAAA&ccb=7-5&oh=00_AfBF6EoOHa9G4uhcLXj24ixNaXZeR_Rm9Ldbtqww9RRMaA&oe=662B3BAB&_nc_sid=8b3546',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
