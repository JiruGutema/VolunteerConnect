import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class User {
  final String name;
  final String role;
  final String email;
  final String phone;
  final String city;
  final String bio;
  final String attendedEvents;
  final String hoursVolunteered;
  final List<String> skills;
  final List<String> interests;

  User({
    required this.name,
    required this.role,
    required this.email,
    required this.city,
    required this.phone,
    required this.bio,
    required this.attendedEvents,
    required this.hoursVolunteered,
    required this.skills,
    required this.interests,
  });
}

final user = User(
  name: 'Jiru Gutema',
  city: 'New York NY',
  role: 'Volunter',
  email: 'Jethior1@gmail.com',
  phone: '+251978556748',
  bio: 'Lorem ipsum dolor sit amet , consectectur adipiscing sed do elit',
  attendedEvents: '12',
  hoursVolunteered: '48',
  skills: ['Teaching', 'First Aid', 'Gardening'],
  interests: ['Enviroment', 'Elderly Care'],
);

class _ProfilePageState extends State<ProfilePage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, size: 70, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(user.name,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    Text(
                      user.role,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Personal Information',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            print("edited successfully");
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.all(0)),
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            print("deleted successfully");
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 24,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: Color.fromARGB(255, 123, 123, 123),
                      ),
                      SizedBox(width: 8),
                      Text(user.email),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Color.fromARGB(255, 123, 123, 123),
                      ),
                      SizedBox(width: 8),
                      Text(user.city),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(
                        Icons.phone,
                        size: 20,
                        color: Color.fromARGB(255, 123, 123, 123),
                      ),
                      SizedBox(width: 8),
                      Text(user.phone),
                    ]),
                    const SizedBox(height: 16),
                    Text(
                      "Bio",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 90, 90, 90)),
                    ),
                    const SizedBox(height: 4),
                    Text(user.bio)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Volunteer Stats Card
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Volunteer Stats',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Column(children: [
                          Text(user.attendedEvents,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Text(
                            'Events Attended',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ]),
                        SizedBox(width: 24),
                        Icon(Icons.access_time, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Column(children: [
                          Text(user.hoursVolunteered,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Text(
                            'Hours Volunteered',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ])
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Skills',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 122, 121, 121))),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: user.skills
                          .map((skill) => Chip(
                                label: Text(skill),
                                labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: Colors.blue[100],
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Interests',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: user.interests
                          .map((interest) => Chip(
                                label: Text(interest),
                                labelStyle: TextStyle(color: Colors.blue),
                                backgroundColor: Colors.blue[100],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
