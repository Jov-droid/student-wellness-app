import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:student_wellness/models/contact.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  // Create contacts as a getter instead of final field
  List<Contact> get contacts => const [
    Contact('Campus Counseling', '123-456-7890'),
    Contact('Crisis Text Line', 'Text HOME to 741741'),
    Contact('National Suicide Prevention', '988'),
    Contact('Campus Security', '555-1234'),
  ];

  Future<void> _launchCall(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future<void> _launchSMS(String number) async {
    final uri = Uri.parse('sms:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(contact.name),
              subtitle: Text(contact.number),
              leading: const Icon(Icons.emergency),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (contact.number.contains('Text'))
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () => _launchSMS(contact.number.split(' ').last),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () => _launchCall(contact.number),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}