import 'package:flutter/material.dart';
import "package:cross_platform/features/auth/presentation/pages/profile_page.dart";

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> upcomingEvents = [
    {
      'title': 'Community Garden Cleanup',
      'organization': 'Green Earth Foundation',
      'date': 'Thu, 15 Jun',
      'time': '09:00 - 13:00',
    },
    {
      'title': 'Food assistance program',
      'organization': 'Mekedonia',
      'date': 'Sat, 24 Jun',
      'time': '09:00 - 13:00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Home',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Text("VC",
                  style: TextStyle(color: Colors.blue, fontSize: 12)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))),
            ),
            const SizedBox(height: 20),
            const Text("Hello, John",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Ready to make a difference today?"),
            const SizedBox(height: 20),
            const Text("Ongoing",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/community.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.5),
                child: const Text(
                  "Join us at the Workforce Development Center for MJ Morgan Group Hiring Event.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Upcoming events",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("View all", style: TextStyle(color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: upcomingEvents.isNotEmpty
                  ? upcomingEvents.map((event) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/community.jpg',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event['title']!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(event['organization']!),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 14),
                                      const SizedBox(width: 4),
                                      Text(event['date']!),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.access_time, size: 14),
                                      const SizedBox(width: 4),
                                      Text(event['time']!),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()
                  : [
                      const Text(
                        "No upcoming events available.",
                        style: TextStyle(color: Colors.grey),
                      ),
                   
                    TextButton(onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>  VolunteerProfileScreen()),
                              );
          }, child: Text("Go to Profile"))
                    ],
            )
          ],
        ),
      ),
    );
  }
}
