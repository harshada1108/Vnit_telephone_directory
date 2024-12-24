import 'package:flutter/material.dart';

class CouncilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Council',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'Developed by:'),
            ProfileCard(
                name: 'Harshada Polshetty',
                designation: 'BT22CSE016\nAPP HEAD, IDS.',
                image: "assets/harshatd.jpg"),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SectionHeader(title: 'Initiative by:'),
            ProfileCard(
                name: 'Ratnesh Kumar',
                designation: 'DEAN OF STUDENT WELFARE',
                image: "assets/img_1.png"),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ProfileCard(
                name: 'Shreshth Varma',
                designation: 'PRESIDENT, IDS',
                image: "assets/img_2.png"),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.04,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String designation;
  final String image;

  ProfileCard(
      {required this.name, required this.designation, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  image, // Replace with your image asset
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    designation,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: Colors.grey[700],
                    ),
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
