import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: VolunteerProfileScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class VolunteerProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'My Application'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Profile",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
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
                  children: const [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, size: 70, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text('John Doe',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    Text(
                      'Volunteer',
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
                      children: const [
                        Expanded(
                          child: Text(
                            'Personal Information',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.delete, color: Colors.red),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(children: const [
                      Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: Color.fromARGB(255, 123, 123, 123),
                      ),
                      SizedBox(width: 8),
                      Text('johnDoe@gmail.com'),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: const [
                      Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Color.fromARGB(255, 123, 123, 123),
                      ),
                      SizedBox(width: 8),
                      Text('New York, NY'),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: const [
                      Icon(
                        Icons.phone,
                        size: 20,
                        color: Color.fromARGB(255, 123, 123, 123),
                      ),
                      SizedBox(width: 8),
                      Text('+251 91 234 5627'),
                    ]),
                    const SizedBox(height: 16),
                    const Text(
                      'Bio',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 90, 90, 90)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing sed do elit.'),
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
                      children: const [
                        Icon(Icons.calendar_today,
                            color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Column(children: [
                          Text('12',
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
                          Text('48',
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
                      children: ['Teaching', 'First Aid', 'Gardening']
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
                      children: ['Environment', 'Elderly Care']
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
