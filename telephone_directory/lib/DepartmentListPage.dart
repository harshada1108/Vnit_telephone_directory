import 'package:flutter/material.dart';

import 'ContactPage.dart';
class DepartmentListPage extends StatelessWidget {
  final List<String> department;

  DepartmentListPage({required this.department});

  // Method to convert string to camel case

  // Method to remove "DEPARTMENT / SECTION / BRANCH" prefix

  // Function to format the text into camel case or readable format
  String formatDepartmentName(String rawText) {
    // Remove the leading part before the colon and trim the result
    String formatted = rawText.split(':').last.trim();
    // Capitalize each word
    return formatted.split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Departments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10.0, // Horizontal space between cards
            mainAxisSpacing: 10.0, // Vertical space between cards
            childAspectRatio: width / (height * 0.5), // Adjust the height ratio as needed
          ),
          itemCount: department.length,
          itemBuilder: (context, index) {
            // Strip prefix and convert to camel case for display


            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(

                    builder: (context) => ContactPage(sectionTitle: department[index].toString(), title: formatDepartmentName(department[index].toString()), ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFE1C4), // Background color similar to crème
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    formatDepartmentName(department[index].toString()),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


