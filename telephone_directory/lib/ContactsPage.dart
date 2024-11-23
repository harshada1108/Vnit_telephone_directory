import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephone_directory/landing_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget {
  final String sectionTitle;
  ContactsPage({required this.sectionTitle});
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List contacts = [];
  List filteredContacts = [];
  TextEditingController searchController = TextEditingController();
  bool islabpresent = false;
  bool isworkshoppresent = false;
  List labContacts = [];
  List WorkshopContacts = [];

  @override
  void initState() {
    super.initState();
    _loadSectionData();
    searchController.addListener(_searchContacts);
  }

  // Load modified contacts from SharedPreferences
  Future<List> _loadModifiedContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? savedData =
        prefs.getStringList('${widget.sectionTitle}_modifiedContacts');
    print("saved data");
    print(savedData);
    return savedData != null
        ? savedData.map((contact) => json.decode(contact)).toList()
        : [];
  }

  // Save a modified contact with the new phone number
  Future<void> _saveModifiedContact(
      Map<String, dynamic> contact, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load the existing modified contacts list (if any)
    List<String>? modifiedContacts =
        prefs.getStringList('${widget.sectionTitle}_modifiedContacts');

    if (modifiedContacts == null) {
      modifiedContacts = [];
    }

    // Find the index of the existing contact with the same name
    int existingIndex =
        modifiedContacts.indexWhere((c) => json.decode(c)[key] == contact[key]);

    if (existingIndex != -1) {
      // If contact exists, replace it with the updated contact
      modifiedContacts[existingIndex] = json.encode(contact);
    } else {
      // If contact does not exist, add it as a new entry
      modifiedContacts.add(json.encode(contact));
    }

    // Save the updated list back to SharedPreferences
    await prefs.setStringList(
        '${widget.sectionTitle}_modifiedContacts', modifiedContacts);
  }

  Future<List> _loadSavedContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedData =
        prefs.getStringList('${widget.sectionTitle}_contacts');
    return savedData != null
        ? savedData.map((contact) => json.decode(contact)).toList()
        : [];
  }

  Future<void> _loadSectionData() async {
    final String response = await rootBundle.loadString('assets/output.json');
    final List data = json.decode(response) as List;

    final section = data.firstWhere(
        (section) => section['section'] == widget.sectionTitle,
        orElse: () => null);

    // Load contacts from SharedPreferences
    final savedContacts = await _loadSavedContacts();

    final modifiedContacts = await _loadModifiedContacts();

    for (var contact in savedContacts) {
      var isc = 0;
      var matchingContact = null;

      for (var modContact in modifiedContacts) {
        if (contact['NAME OF FACULTY / STAFF'] != null) {
          if (contact['NAME OF FACULTY / STAFF'] ==
              modContact['NAME OF FACULTY / STAFF']) {
            matchingContact = modContact;
            isc = 1;
            break; // Break the loop if a match is found
          }
        } else if (contact['NAME'] != null) {
          if (contact['NAME'] == modContact['NAME']) {
            matchingContact = modContact;
            isc = 2;
            break; // Break the loop if a match is found
          }
        } else if (contact['NAME '] != null) {
          if (contact['NAME '] == modContact['NAME ']) {
            matchingContact = modContact;
            isc = 3;
            break; // Break the loop if a match is found
          }
        }

        // If a matching contact is found, update the original contact with modified values
        if (isc == 1) {
          print(contact);
          print("updated contact");
          print(matchingContact);
          contact['NAME OF FACULTY / STAFF'] =
              matchingContact['NAME OF FACULTY / STAFF'];
          contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
          contact['EMAIL ID'] = matchingContact['EMAIL ID'];
        } else if (isc == 2) {
          print(contact);
          print("updated contact");
          print(matchingContact);
          contact['NAME'] = matchingContact['NAME'];
          contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
          contact['EMAIL ID'] = matchingContact['EMAIL ID'];
        } else if (isc == 3) {
          print(contact);
          print("updated contact");
          print(matchingContact);
          contact['NAME '] = matchingContact['NAME '];
          contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
          contact['EMAIL ID'] = matchingContact['EMAIL ID'];
        }

        // If no matching contact found, return the original contact
      }
    }
    print("Printing length ");
    print(section['entries'].length);
    if (section != null) {
      if (section['entries'].length == 2) {
        islabpresent = true;
        final facultycontacts = section['entries'][0];
        final labcontacts = section['entries'][1];
        labContacts = labcontacts;
        for (var contact in facultycontacts) {
          var isc = 0;
          var matchingContact = null;
          for (var modContact in modifiedContacts) {
            if (contact['NAME OF FACULTY / STAFF'] != null) {
              if (contact['NAME OF FACULTY / STAFF'] ==
                  modContact['NAME OF FACULTY / STAFF']) {
                matchingContact = modContact;
                isc = 1;
                break; // Break the loop if a match is found
              }
            } else if (contact['NAME'] != null) {
              if (contact['NAME'] == modContact['NAME']) {
                matchingContact = modContact;
                isc = 2;
                break; // Break the loop if a match is found
              }
            } else if (contact['NAME '] != null) {
              if (contact['NAME '] == modContact['NAME ']) {
                matchingContact = modContact;
                isc = 3;
                break; // Break the loop if a match is found
              }
            }
          }

          // If a matching contact is found, update the original contact with modified values
          if (isc == 1) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['NAME OF FACULTY / STAFF'] =
                matchingContact['NAME OF FACULTY / STAFF'];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          } else if (isc == 2) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['NAME'] = matchingContact['NAME'];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          } else if (isc == 3) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['NAME '] = matchingContact['NAME '];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          }

          // If no matching contact found, return the original contact
        }
        for (var contact in labcontacts) {
          var isc = false;
          var matchingContact = null;
          for (var modContact in modifiedContacts) {
            if (contact['LAB NAME'] != null) {
              if (contact['LAB NAME'] == modContact['LAB NAME']) {
                matchingContact = modContact;
                isc = true;
                break; // Break the loop if a match is found
              }
            }
          }

          // If a matching contact is found, update the original contact with modified values
          if (isc) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['LAB NAME'] = matchingContact['LAB NAME'];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          }

          // If no matching contact found, return the original contact
        }

        setState(() {
          contacts = [...facultycontacts, ...labcontacts, ...savedContacts];
          filteredContacts = contacts;
        });
      } else if (section['entries'].length == 3) {
        islabpresent = true;
        isworkshoppresent = true;
        final facultycontacts = section['entries'][0];
        final labcontacts = section['entries'][1];
        final workshopcontacts = section['entries'][2];
        WorkshopContacts = workshopcontacts;
        labContacts = labcontacts;

        for (var contact in facultycontacts) {
          var isc = 0;
          var matchingContact = null;
          for (var modContact in modifiedContacts) {
            if (contact['NAME OF FACULTY / STAFF'] != null) {
              if (contact['NAME OF FACULTY / STAFF'] ==
                  modContact['NAME OF FACULTY / STAFF']) {
                matchingContact = modContact;
                isc = 1;
                break; // Break the loop if a match is found
              }
            } else if (contact['NAME'] != null) {
              if (contact['NAME'] == modContact['NAME']) {
                matchingContact = modContact;
                isc = 2;
                break; // Break the loop if a match is found
              }
            } else if (contact['NAME '] != null) {
              if (contact['NAME '] == modContact['NAME ']) {
                matchingContact = modContact;
                isc = 3;
                break; // Break the loop if a match is found
              }
            }
          }

          // If a matching contact is found, update the original contact with modified values
          if (isc == 1) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['NAME OF FACULTY / STAFF'] =
                matchingContact['NAME OF FACULTY / STAFF'];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          } else if (isc == 2) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['NAME'] = matchingContact['NAME'];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          } else if (isc == 3) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['NAME '] = matchingContact['NAME '];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          }

          // If no matching contact found, return the original contact
        }
        for (var contact in labcontacts) {
          var isc = false;
          var matchingContact = null;
          for (var modContact in modifiedContacts) {
            if (contact['LAB NAME'] != null) {
              if (contact['LAB NAME'] == modContact['LAB NAME']) {
                matchingContact = modContact;
                isc = true;
                break; // Break the loop if a match is found
              }
            }
          }

          // If a matching contact is found, update the original contact with modified values
          if (isc) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['LAB NAME'] = matchingContact['LAB NAME'];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          }

          // If no matching contact found, return the original contact
        }
        for (var contact in workshopcontacts) {
          var isc = 0;
          var matchingContact = null;
          for (var modContact in modifiedContacts) {
            if (contact['NAME OF FACULTY'] != null) {
              if (contact['NAME OF FACULTY'] == modContact['NAME OF FACULTY']) {
                matchingContact = modContact;
                isc = 1;
                break; // Break the loop if a match is found
              }
            } else if (contact['NAME'] != null) {
              if (contact['NAME'] == modContact['NAME']) {
                matchingContact = modContact;
                isc = 2;
                break; // Break the loop if a match is found
              }
            } else if (contact['NAME '] != null) {
              if (contact['NAME '] == modContact['NAME ']) {
                matchingContact = modContact;
                isc = 3;
                break; // Break the loop if a match is found
              }
            }
          }

          // If a matching contact is found, update the original contact with modified values
          if (isc == 1) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['NAME OF FACULTY / STAFF'] =
                matchingContact['NAME OF FACULTY / STAFF'];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          }
          if (isc == 2) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['NAME'] = matchingContact['NAME'];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          }
          if (isc == 3) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['NAME '] = matchingContact['NAME '];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          }

          // If no matching contact found, return the original contact
        }
        setState(() {
          contacts = [
            ...facultycontacts,
            ...labcontacts,
            ...workshopcontacts,
            ...savedContacts
          ];
          filteredContacts = contacts;
        });
      } else {
        final facultycontacts = section['entries'];

        for (var contact in facultycontacts) {
          var isc = false;
          var matchingContact = null;
          for (var modContact in modifiedContacts) {
            if (contact['NAME OF FACULTY / STAFF'] != null) {
              if (contact['NAME OF FACULTY / STAFF'] ==
                  modContact['NAME OF FACULTY / STAFF']) {
                matchingContact = modContact;
                isc = true;
                break; // Break the loop if a match is found
              }
            } else if (contact['NAME'] != null) {
              if (contact['NAME'] == modContact['NAME']) {
                matchingContact = modContact;
                isc = true;
                break; // Break the loop if a match is found
              }
            } else if (contact['NAME '] != null) {
              if (contact['NAME '] == modContact['NAME ']) {
                matchingContact = modContact;
                isc = true;
                break; // Break the loop if a match is found
              }
            }
          }

          // If a matching contact is found, update the original contact with modified values
          if (isc) {
            print(contact);
            print("updated contact");
            print(matchingContact);
            contact['NAME OF FACULTY / STAFF'] =
                matchingContact['NAME OF FACULTY / STAFF'];
            contact['EXTENSION NO.'] = matchingContact['EXTENSION NO.'];
            contact['EMAIL ID'] = matchingContact['EMAIL ID'];
          }

          // If no matching contact found, return the original contact
        }
        setState(() {
          contacts = [...facultycontacts, ...savedContacts];
          filteredContacts = contacts;
        });
      }
    }
  }

  Future<void> _searchContacts() async {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredContacts = contacts.where((contact) {
        String name = contact['NAME '] ??
            contact['NAME'] ??
            contact['NAME OF FACULTY / STAFF'] ??
            contact['NAME OF DEPARTMENT'] ??
            contact['LAB NAME'] ??
            contact['MEETING ROOM'];
        return name.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _saveContactToPreferences(Map contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedContacts =
        prefs.getStringList('${widget.sectionTitle}_contacts');
    if (savedContacts == null) savedContacts = [];
    savedContacts.add(json.encode(contact));
    await prefs.setStringList('${widget.sectionTitle}_contacts', savedContacts);
  }

  Future<void> _addPhoneNumber(String phonekey, String key) async {
    Navigator.of(context).pop();
    TextEditingController phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Phone Number"),
        content: TextField(
          controller: phoneController,
          decoration: InputDecoration(hintText: "Enter phone number"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String newPhone = phoneController.text.trim();
              print("Okk uptill here");
              print(phonekey);
              if (newPhone.isNotEmpty) {
                // Find the contact that this number should be added to
                Map<String, dynamic>? contactToUpdate =
                    contacts.firstWhere((contact) {
                  return (contact[key] == phonekey);
                }, orElse: () => null);
                if (contactToUpdate != null) {
                  // Contact found, append the new phone number

                  List<String> phoneNumbers =
                      (contactToUpdate['EXTENSION NO.'] as String)
                          .split(',')
                          .map((e) => e.trim())
                          .toList();

                  // Avoid duplicate entries of the phone number
                  if (!phoneNumbers.contains(newPhone)) {
                    phoneNumbers.add(newPhone);
                  }

                  // Update contact with the new phone number list
                  contactToUpdate['EXTENSION NO.'] = phoneNumbers.join(', ');

                  // Save the modified contact to SharedPreferences
                  await _saveModifiedContact(contactToUpdate, key);

                  setState(() {
                    contacts = List.from(contacts); // Refresh the list
                    filteredContacts = contacts;
                  });
                } else {
                  // If no matching contact, create a new one
                  Map<String, dynamic> newContact = {
                    'NAME': "Added Contact",
                    'EXTENSION NO.': newPhone,
                  };
                  await _saveContactToPreferences(newContact);
                  setState(() {
                    contacts.add(newContact);
                    filteredContacts = contacts;
                  });
                }
                Navigator.of(context).pop();
              }
            },
            child: Text("Add"),
          ),
        ],
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

  Future<void> _showPhoneDialog(
      List<dynamic> phoneNumbers, String phonekey, String key) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Phone Numbers"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...phoneNumbers.map((phone) {
              return ListTile(
                title: Text(phone),
                leading: Icon(Icons.phone),
                onTap: () => _makePhoneCall(phone),
              );
            }).toList(),
            ListTile(
              title: Text("Add Phone Number"),
              leading: Icon(Icons.add),
              onTap: () => _addPhoneNumber(phonekey, key),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewContact() {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(hintText: "Phone Number"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String name = nameController.text.trim();
              String phone = phoneController.text.trim();
              String email = emailController.text.trim();

              if (name.isNotEmpty || phone.isNotEmpty || email.isNotEmpty) {
                Map<String, dynamic> newContact = {
                  'NAME': name,
                  'EXTENSION NO.': phone,
                  'EMAIL ID': email,
                };
                await _saveContactToPreferences(newContact);
                setState(() {
                  contacts.add(newContact);
                  filteredContacts = contacts;
                });
                Navigator.of(context).pop();
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> _addEmail(String phonekey, String key) async {
    Navigator.of(context).pop();
    TextEditingController phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add an Email"),
        content: TextField(
          controller: phoneController,
          decoration: InputDecoration(hintText: "Enter email address"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String newPhone = phoneController.text.trim();
              print("Okk uptill here");
              print(phonekey);
              if (newPhone.isNotEmpty) {
                // Find the contact that this number should be added to
                Map<String, dynamic>? contactToUpdate =
                    contacts.firstWhere((contact) {
                  return (contact[key] == phonekey);
                }, orElse: () => null);
                if (contactToUpdate != null) {
                  // Contact found, append the new phone number

                  List<String> phoneNumbers =
                      (contactToUpdate['EMAIL ID'] as String)
                          .split(',')
                          .map((e) => e.trim())
                          .toList();

                  // Avoid duplicate entries of the phone number
                  if (!phoneNumbers.contains(newPhone)) {
                    phoneNumbers.add(newPhone);
                  }

                  // Update contact with the new phone number list
                  contactToUpdate['EMAIL ID'] = phoneNumbers.join(', ');

                  // Save the modified contact to SharedPreferences
                  await _saveModifiedContact(contactToUpdate, key);

                  setState(() {
                    contacts = List.from(contacts); // Refresh the list
                    filteredContacts = contacts;
                  });
                } else {
                  // If no matching contact, create a new one
                  Map<String, dynamic> newContact = {
                    'NAME': "Added Contact",
                    'EXTENSION NO.': newPhone,
                  };
                  await _saveContactToPreferences(newContact);
                  setState(() {
                    contacts.add(newContact);
                    filteredContacts = contacts;
                  });
                }
                Navigator.of(context).pop();
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> _showMailDialog(
      List<dynamic> emails, String mailkey, String key) async {
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
              onTap: () => _addEmail(mailkey, key),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sectionTitle),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search..",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  // Rounded rectangle for search tab
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xDDE9EEFF),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          ...filteredContacts.map((contact) {
            final name = contact['NAME OF FACULTY / STAFF'] ??
                contact['NAME'] ??
                contact['NAME '] ??
                "";

            final emails = (contact['EMAIL ID'] ?? '')
                .split(',')
                .map((e) => e.trim())
                .toList();
            final phoneNumbers = (contact['EXTENSION NO.'] ?? '')
                .split(',')
                .map((e) => e.trim())
                .toList();

            var keyfound = '';

            contact.forEach((key, value) {
              if (key.contains('NAME')) {
                keyfound = key;
                return;
              }
            });

            if (contact.containsKey('LAB NAME') ||
                contact.containsKey('NAME OF FACULTY')) {
              return SizedBox.shrink();
            } else {
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Color(0xDDE9EEFF), // Background color similar to crème
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
                            _showPhoneDialog(phoneNumbers, name, keyfound);
                          } else {
                            _makePhoneCall(phoneNumbers[0]);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.email),
                        onPressed: () {
                          _showMailDialog(emails, name, keyfound);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          }).toList(),
          if (islabpresent)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                "Laboratories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          if (islabpresent)
            ...filteredContacts.map((lab) {
              final labName = lab['LAB NAME'] ?? lab['MEETING ROOM'] ?? "";
              final labExtension = lab['EXTENSION NO.'] ?? "";
              if (labName.isEmpty) {
                return SizedBox.shrink();
              }
              var key = 'LAB NAME';
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE1C4), // Background color similar to crème
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
                    labName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(labExtension),
                  trailing: IconButton(
                    icon: Icon(Icons.phone),
                    onPressed: () {
                      _showPhoneDialog([labExtension], labName, key);
                    },
                  ),
                  onTap: () {
                    _makePhoneCall(labExtension);
                  },
                ),
              );
            }).toList(),
          if (isworkshoppresent)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                "Workshop",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          if (isworkshoppresent)
            ...filteredContacts.map((contact) {
              final name = contact['NAME OF FACULTY'] ?? "";
              final emails = (contact['EMAIL ID'] ?? '')
                  .split(',')
                  .map((e) => e.trim())
                  .toList();
              final phoneNumbers = (contact['EXTENSION NO.'] ?? '')
                  .split(',')
                  .map((e) => e.trim())
                  .toList();

              var keyfound = '';
              contact.forEach((key, value) {
                if (key.contains('NAME')) {
                  keyfound = key;
                  return;
                }
              });

              if (contact.containsKey('LAB NAME') ||
                  contact.containsKey('NAME OF FACULTY/STAFF') ||
                  contact.containsKey('NAME ') ||
                  contact.containsKey('NAME')) {
                return SizedBox.shrink();
              } else {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE1C4),
                    // Background color similar to crème
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
                              _showPhoneDialog(phoneNumbers, name, keyfound);
                            } else {
                              _makePhoneCall(phoneNumbers[0]);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.email),
                          onPressed: () {
                            _showMailDialog(emails, name, keyfound);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewContact,
        child: Icon(Icons.add),
      ),
    );
  }
}
