import 'package:cross_platform/features/auth/presentation/pages/even_detail_page.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _selectedCategory = 'All';
  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'title': 'Community Garden Cleanup',
      'subtitle': 'Green Earth Foundation',
      'category': 'Environment',
      'date': 'Saturday, April 12, 2025',
      'time': '9:00 AM – 1:00 PM',
      'location': 'Near Zawditi Memorial Hospital, Kazanolia',
      'spotsLeft': 15,
      'image': 'assets/images/community.jpg',
      'description':
          'A Community Garden Cleanup is a volunteer-driven event focused on maintaining and revitalizing a shared garden space used by a neighborhood, school, or organization. These events help promote environmental responsibility, community pride, and healthy living.',
      'requirements': [
        'Willingness to volunteer and work outdoors',
        'Basic physical ability (standing, lifting, bending, etc.)',
        'Punctuality – arrive on time and stay for the full shift if possible',
        'Respect for others and community property',
        'Often open to all ages'
      ],
      'additionalInfo': [
        'Light snacks and water will be provided',
        'You may earn volunteer hours (bring your time sheet if needed)',
        'Certification of participation available upon request'
      ],
      'contactInfo': {
        'phone': '09123456',
        'email': 'contact@volunteer.com',
        'telegram': '@volunteer'
      }
    },

    {
      'id': '1',
      'title': 'Addis Ababa Green Initiative',
      'subtitle': 'የአዲስ አበባ አረንጓዴ ተነሳሽነት (Yäaddis Abäba Arängwädä Tənəšašənät)',
      'category': 'Environment',
      'date': 'Saturday, April 12, 2025',
      'time': '9:00 AM – 1:00 PM',
      'location': 'Meskel Square, Addis Ababa',
      'spotsLeft': 25,
      'image': 'assets/images/community.jpg',
      'description':
          'Join us for a community cleanup in Meskel Square!  Let\'s work together to keep our city beautiful.  All are welcome!',
      'requirements': [
        'Willingness to volunteer and work outdoors',
        'Basic physical ability (standing, lifting, bending, etc.)',
        'Punctuality – arrive on time and stay for the full shift if possible',
        'Respect for others and community property',
        'All ages welcome'
      ],
      'additionalInfo': [
        'Refreshments will be provided (ቡና እና ሻይ)',
        'You may earn volunteer hours (bring your time sheet if needed)',
        'Certificate of participation available upon request'
      ],
      'contactInfo': {
        'phone': '+251 912 345 678',
        'email': 'addisgreen@example.com',
        'telegram': '@addisgreeninitiative'
      }
    },
    {
      'id': '2',
      'title': 'Gondar Lake Tana Cleanup',
      'subtitle': 'Lake Tana Conservation Project',
      'category': 'Environment',
      'date': 'Sunday, April 20, 2025',
      'time': '8:00 AM – 12:00 PM',
      'location': 'Lake Tana, Gondar',
      'spotsLeft': 10,
      'image': 'assets/images/community.jpg',
      'description':
          'Help us protect the beautiful Lake Tana! We\'ll be cleaning up the shoreline and planting trees.',
      'requirements': [
        'Love for nature',
        'Basic physical ability',
        'Punctuality',
        'Teamwork spirit',
        'Appropriate clothing and footwear'
      ],
      'additionalInfo': [
        'Transportation to and from the lake will be provided',
        'Lunch will be served',
        'A memorable experience awaits!'
      ],
      'contactInfo': {
        'phone': '+251 912 345 679',
        'email': 'laketana@conservation.com',
        'telegram': '@laketanaconservation'
      }
    }
    // Add more events here as needed
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _selectedCategory == 'All'
        ? _events
        : _events
            .where((event) => event['category'] == _selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          _buildCategoryFilter(),
          _buildSearchFilters(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return _buildEventCard(event, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    const categories = ['All', 'Environment', 'Education', 'Food'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
                foregroundColor: isSelected ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Text(category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchFilters() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextField(
            decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'sub-title',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            event['image'],
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  event['subtitle'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(event['date']),
                        const SizedBox(width: 16),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 4),
                        Text(event['time']),
                        const SizedBox(width: 16),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Text(event['location']),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Spots left: ${event['spotsLeft']}',
                  style: TextStyle(
                    color: event['spotsLeft'] > 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(event: event),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Detail',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
