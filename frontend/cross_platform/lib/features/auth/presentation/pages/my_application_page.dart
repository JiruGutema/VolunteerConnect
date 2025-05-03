import 'package:flutter/material.dart';

class MyApplicationsBody extends StatefulWidget {
  const MyApplicationsBody({Key? key}) : super(key: key);

  @override
  _MyApplicationsBodyState createState() => _MyApplicationsBodyState();
}

class _MyApplicationsBodyState extends State<MyApplicationsBody> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> dummyApplications = [
    {
      'status': 'Approved',
      'appliedDate': 'Sat, 20 May',
      'title': 'Community Garden Cleanup',
      'organization': 'Green Earth Foundation',
      'date': 'Thu, 15 Jun',
      'time': '09:00 - 13:00',
    },
    {
      'status': 'Pending',
      'appliedDate': 'Mon, 22 May',
      'title': 'Beach Cleanup Day',
      'organization': 'Green Earth Foundation',
      'date': 'Sun, 25 Jun',
      'time': '08:00 - 11:00',
    },
    {
      'status': 'Canceled',
      'appliedDate': 'Fri, 12 May',
      'title': 'Senior Center Tech Help',
      'organization': 'Digital Bridge',
      'date': 'Sun, 25 Jun',
      'time': '08:00 - 11:00',
    },
    {
      'status': 'Pending',
      'appliedDate': 'Wed, 10 Feb',
      'title': '5K Road Cleanup',
      'organization': 'Addis Ababa Administration',
      'date': 'monday, 25 aug',
      'time': '08:00 - 11:00',
    },
    {
      'status': 'Canceled',
      'appliedDate': 'Thur, 12 Apr',
      'title': 'Shiromeda Safety Home',
      'organization': 'Holistic Team',
      'date': 'Wed, 25 Jan',
      'time': '08:00 - 11:00',
    },
    {
      'status': 'Approved',
      'appliedDate': 'Sat, 20 April',
      'title': 'Addis Ababa University Cleaning',
      'organization': 'Addis Ababa University',
      'date': 'Thu, 15 Sat',
      'time': '09:00 - 13:00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Pending', 'Approved', 'Canceled'];

    final filteredApps = selectedFilter == 'All'
        ? dummyApplications
        : dummyApplications
            .where((app) => app['status'] == selectedFilter)
            .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: filters.map((filter) {
              final isSelected = filter == selectedFilter;
              return Container(
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.blue : Colors.white,
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                        elevation: isSelected ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () {
                      setState(() => selectedFilter = filter);
                    },
                    child: Text(filter, style: const TextStyle(fontSize: 14)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filteredApps.length,
            itemBuilder: (context, index) {
              final app = filteredApps[index];
              return _buildApplicationCard(app);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> app) {
    final statusColor = {
      'Approved': Colors.green,
      'Pending': Colors.orange,
      'Canceled': Colors.grey,
    }[app['status']]!;

    final statusIcon = {
      'Approved': Icons.check_circle,
      'Pending': Icons.access_time,
      'Canceled': Icons.cancel,
    }[app['status']]!;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, size: 18, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  app['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Applied on ${app['appliedDate']}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              app['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(app['organization']),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14),
                const SizedBox(width: 4),
                Text(app['date']),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 14),
                const SizedBox(width: 4),
                Text(app['time']),
              ],
            ),
            if (app['status'] == 'Pending') ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        print("Canceled Successfully");
                      },
                      child: const Text('Edit',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        print("Canceled Successfully");
                      },
                      child: const Text('Cancel',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
