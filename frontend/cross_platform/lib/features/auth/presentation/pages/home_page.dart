import 'package:cross_platform/features/auth/presentation/pages/explore_page.dart';
import 'package:cross_platform/features/auth/presentation/pages/my_application_page.dart';
import 'package:flutter/material.dart';
import 'package:cross_platform/features/auth/presentation/pages/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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

  List<Widget> get _pages => [
        _buildHomeContent(),
        ExplorePage(),
        MyApplicationsBody(),
        const ProfilePage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Volunter Connect',
            style: TextStyle(
                color: Color.fromARGB(255, 74, 74, 74),
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 22,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/vc_logo.png'),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          )
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'My Application'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            "Search for events here!",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Upcoming events",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          title: Text("Explore"),
                          titleTextStyle:
                              TextStyle(color: Colors.black, fontSize: 24),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        body: ExplorePage(),
                      ),
                    ),
                  );
                },
                style: ButtonStyle(),
                child: Text("View all", style: TextStyle(color: Colors.blue)),
              )
            ],
          ),
          const SizedBox(height: 10),
          ...upcomingEvents.map((event) {
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
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(event['organization']!),
                        const SizedBox(height: 4),
                       const Row(
                          children: [
                          const Icon(Icons.calendar_today, size: 14),
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
          }).toList(),
        ],
      ),
    );
  }
}
