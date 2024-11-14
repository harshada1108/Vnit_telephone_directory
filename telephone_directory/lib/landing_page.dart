import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:telephone_directory/About.dart';
import 'package:telephone_directory/ContactsPage.dart';
import 'package:telephone_directory/main.dart';



class LandingPage extends StatelessWidget {
  final List<String> branches = [
    "DEPARTMENT / SECTION / BRANCH : APPLIED MECHANICS",
    "DEPARTMENT / SECTION/ BRANCH : ARCHITECTURE AND PLANNING",
    "DEPARTMENT / SECTION/BRANCH : CHEMICAL ENGINEERING",
    "DEPARTMENT / SECTION /BRANCH :CHEMISTRY",
    "DEPARTMENT / SECTION/ BRANCH : CIVIL ENGINEERING",
    "DEPARTMENT / SECTION/ BRANCH: COMPUTER SCIENCE & ENGINEERING",
    "DEPARTMENT / SECTION/BRANCH: ELECTRICAL ENGINEERING",
    "DEPARTMENT / SECTION /BRANCH: ELECTRONICS & COMMUNICATION ENGINEERING",
    "DEPARTMENT / SECTION/ BRANCH: CENTER FOR VLSI & NANO TECHNOLOGY",
    "DEPARTMENT / SECTION/BRANCH : HUMANITIES & SOCIAL SCIENCES",
    "DEPARTMENT / SECTION /BRANCH: MATHEMATICS",
    "DEPARTMENT / SECTION/BRANCH: MECHANICAL ENGINEERING",
    "DEPARTMENT / SECTION /BRANCH: METALLURGICAL & MATERIALS ENGINEERING",
    "DEPARTMENT / SECTION/BRANCH : MINING ENGINEERING",
    "DEPARTMENT / SECTION/BRANCH : PHYSICS",
  ];

  final List<String> departments = [
    "DEPARTMENT / SECTION : ADMINISTRATION",
    "DEPARTMENT / SECTION : DIRECTOR OFFICE",
    "DEPARTMENT / SECTION : REGISTRAR'S OFFICE",
    "DEPARTMENT / SECTION : DEAN'S OFFICE",
    "DEPARTMENT / SECTION : HEAD OF THE DEPARTMENTS",
  ];

  final List<String> services = [
    "DEPARTMENT / SECTION :ACADEMIC SECTION",
    "DEPARTMENT / SECTION :ACCOUNTS SECTION",
    "DEPARTMENT / SECTION : ELECTRICAL MAINTENANCE SECTION",
    "DEPARTMENT / SECTION : ESTABLISHMENT SECTION",
    "DEPARTMENT / SECTION : ESTATE MAINTENANCE SECTION",
    "DEPARTMENT / SECTION : EXAMINATION SECTION",
    "DEPARTMENT / SECTION : HOSTEL SECTION",
    "DEPARTMENT / SECTION : HOSTEL DEAN",
    "DEPARTMENT / SECTION : SECURITY SECTION",
    "DEPARTMENT / SECTION : STUDENT AND SPORTS ACTIVITY SECTION",
    "DEPARTMENT / SECTION : STORE SECTION",
    "DEPARTMENT / SECTION : TELEPHONE MAINTENANCE SECTION",
    "DEPARTMENT / SECTION : TRAINING & PLACEMENT SECTION",
    "DEPARTMENT / SECTION : COMPUTER CENTRE",
    "DEPARTMENT / SECTION : NETWORK CENTRE",
    "DEPARTMENT / SECTION : HEALTH CENTER",
    "DEPARTMENT / SECTION : LIBRARY & INFORMATION RESOURCE CENTRE",
    "DEPARTMENT / SECTION : GUEST HOUSE",
  ];




  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final cardHeight = height * 0.07;

    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding:  EdgeInsets.only(top: height*0.02),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo.png',
                    width: height * 0.16,
                    height: height * 0.16,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                'Visvesvaraya National Institute of\nTechnology, Nagpur',
                style: TextStyle(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                width: width * 0.8,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFD3E4EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Telephone Directory',
                    style: TextStyle(
                      fontSize: height * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  _buildCategoryCard(context, label: "Administration", cardHeight: cardHeight, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DepartmentListPage(department: departments)),
                    );
                  }),
                  _buildCategoryCard(context, label: "Departments", cardHeight: cardHeight, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DepartmentListPage(department: branches)),
                    );
                  }),
                  _buildCategoryCard(context, label: "Sections/Centers", cardHeight: cardHeight, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DepartmentListPage(department: services)),
                    );
                  }),
                  _buildCategoryCard(context, label: "VNIT Centralized Services", cardHeight: cardHeight, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactsPage(sectionTitle: 'CENTRALIZED SERVICES (VNIT CAMPUS)'),
                      ),
                    );
                  }),
                  _buildCategoryCard(context, label: "About App", cardHeight: cardHeight, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutPage(),
                      ),
                    );
                  }),
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Developed by " ,style: TextStyle(color :Colors.black38 ,fontSize: height*0.014),),

                    Image.asset(
                      'assets/ids333-removebg-preview.png', // Replace with your asset path
                      width: height * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, {required String label, required double cardHeight, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Color(0xFFFAE3D0),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: cardHeight * 0.30,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
