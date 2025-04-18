import 'package:flutter/material.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';

class WateringDetailsScreen extends StatelessWidget {
  const WateringDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data source
    final List<Map<String, String>> data = [
      {'date': '12-04-2025', 'time': '12:50', 'duration': '02:00:00'},
      {'date': '12-04-2025', 'time': '12:50', 'duration': '00:05:00'},
      {'date': '12-04-2025', 'time': '12:50', 'duration': '00:05:00'},
      {'date': '12-04-2025', 'time': '12:50', 'duration': '00:05:00'},
      {'date': '12-04-2025', 'time': '12:50', 'duration': '00:05:00'},
      {'date': '12-04-2025', 'time': '12:50', 'duration': '00:05:00'}
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFCEBD5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCEBD5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.brown,
            fontFamily: 'Open Sans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5185CA),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5185CA),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Duration',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5185CA),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Table Content
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey, width: 0.5),
                              ),
                            ),
                            child: _buildTableRow(
                              item['date']!,
                              item['time']!,
                              item['duration']!,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(  
        currentIndex: 3, // Index cho tab Watering
        onTap: (index) {}, // Thêm onTap callback
      ),
    );
  }

  Widget _buildTableRow(String date, String time, String duration) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                time,
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                duration,
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 