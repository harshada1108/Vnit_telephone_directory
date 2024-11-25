import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For making phone calls and sending emails
import 'package:flutter/services.dart'; // For loading assets

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredContacts = [];
  List<Map<String, String>> _allContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts(); // Load contacts from the JSON file
  }

  // Function to load contacts from the JSON file
  Future<void> _loadContacts() async {
    String data = await rootBundle.loadString('assets/output2.json');
    List<dynamic> jsonData = json.decode(data); // Decode the JSON string

    // Flatten the entries from each section into a list of contacts
    List<Map<String, String>> contacts = [];
    for (var section in jsonData) {
      if (section['entries'] != null) {
        for (var entry in section['entries']) {
          for (var contact in entry) {
            contacts.add({
              'NAME': (contact['NAME'] != null && contact['NAME'].isNotEmpty)
                  ? contact['NAME']
                  : (contact['LAB NAME'] != null &&
                          contact['LAB NAME'].isNotEmpty)
                      ? contact['LAB NAME']
                      : (contact['NAME OF FACULTY'] ?? ''),
              'EXTENSION NO.': contact['EXTENSION NO.'] ?? '',
              'EMAIL ID': contact['EMAIL ID'] ?? '',
            });
          }
        }
      }
    }

    setState(() {
      _allContacts = contacts; // Populate allContacts list
      _filteredContacts = _allContacts; // Initially, display all contacts
    });
  }

  void _filterContacts(String query) {
    setState(() {
      _filteredContacts = _allContacts
          .where((contact) =>
              contact['NAME']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _showPhoneDialog(
      List<String> phoneNumbers, String phoneKey, String key) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Phone Numbers"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...phoneNumbers.map((phone) {
              final displayPhone = phone.length == 4
                  ? "0712-280$phone" // Display mobile number as is
                  : phone;
              return ListTile(
                title: Text(displayPhone),
                leading: Icon(Icons.phone),
                onTap: () => _makePhoneCall(phone),
              );
            }).toList(),
            ListTile(
              title: Text("Add Phone Number"),
              leading: Icon(Icons.add),
              onTap: () => _addPhoneNumber(phoneKey, key),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phone) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: "0712-280$phone", // Use the formatted phone number
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Cannot launch tel url");
    }
  }

  Future<void> _showMailDialog(
      List<String> emails, String mailKey, String key) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Emails"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...emails.where((email) => email.isNotEmpty).map((email) {
              return ListTile(
                title: Text(email),
                leading: Icon(Icons.email_outlined),
                onTap: () async => await launch("mailto:$email"),
              );
            }).toList(),
            ListTile(
              title: Text("Add an Email"),
              leading: Icon(Icons.add),
              onTap: () => _addEmail(mailKey, key),
            ),
          ],
        ),
      ),
    );
  }

  void _addPhoneNumber(String phoneKey, String key) {
    // You can implement the function to add a phone number (e.g., open a dialog to input a new number)
    print('Add phone number: $phoneKey, $key');
  }

  void _addEmail(String mailKey, String key) {
    // You can implement the function to add an email (e.g., open a dialog to input a new email)
    print('Add email: $mailKey, $key');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Contacts"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterContacts,
              decoration: InputDecoration(
                hintText: "Search..",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Rounded rectangle for search tab
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xDDE9EEFF),
              ),
            ),
          ),
        ),
      ),
      body: _filteredContacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ..._filteredContacts.map((contact) {
                  final name = contact['NAME'] ?? '';
                  final emails = (contact['EMAIL ID'] ?? '')
                      .split(',')
                      .map((e) => e.trim())
                      .toList();
                  final phoneNumbers = (contact['EXTENSION NO.'] ?? '')
                      .split(',')
                      .map((e) => e.trim())
                      .toList();

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Color(
                          0xDDE9EEFF), // Background color similar to crème
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.phone),
                            onPressed: () {
                              if (phoneNumbers.isNotEmpty) {
                                _showPhoneDialog(
                                    phoneNumbers, 'phoneKey', 'key');
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.email),
                            onPressed: () {
                              _showMailDialog(emails, 'emailKey', 'key');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
    );
  }
}
