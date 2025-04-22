import 'package:flutter/material.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WateringScreen extends StatefulWidget {
  const WateringScreen({super.key});

  @override
  State<WateringScreen> createState() => _WateringScreenState();
}

class _WateringScreenState extends State<WateringScreen> {
  bool isLoading = true;
  Map<String, dynamic> waterStats = {
    'duration': '00:00:00',
    'waterConsumption': 0.0,
    'waterTimes': 0
  };
  bool isAutoMode = false;
  bool isPumpOn = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    http.Client client = http.Client();
    try {
      // Get water statistics
      final statsResponse = await client.get(
        Uri.parse('https://adapting-doe-precious.ngrok-free.app/ifarm-be/water/statistics'),
      );

      if (statsResponse.statusCode == 200) {
        if (mounted) {
          setState(() {
            waterStats = json.decode(statsResponse.body);
          });
        }
      }
      
      // Lấy trạng thái của máy bơm
      try {
        final pumpStatusResponse = await client.get(
          Uri.parse('https://adapting-doe-precious.ngrok-free.app/ifarm-be/water/pump'),
        );
        
        if (pumpStatusResponse.statusCode == 200) {
          final statusData = json.decode(pumpStatusResponse.body);
          if (mounted) {
            setState(() {
              // Cập nhật trạng thái máy bơm từ response
              isPumpOn = statusData['status'] == 1;
            });
          }
        }
      } catch (e) {
        print('Error fetching pump status: $e');
        // Không cập nhật isPumpOn nếu có lỗi
      }
      
      // Lưu ý: API không có endpoint để lấy trạng thái chế độ tự động
      // Nếu có thể, hãy yêu cầu backend thêm API này
      
    } catch (e) {
      print('Error loading water data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading water data: $e')),
        );
      }
    } finally {
      client.close(); // Đóng HTTP client
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _togglePump(bool value) async {
    http.Client client = http.Client();
    try {
      final int state = value ? 1 : 0;
      final response = await client.post(
        Uri.parse('https://adapting-doe-precious.ngrok-free.app/ifarm-be/water/pump/$state'),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            isPumpOn = value;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pump turned ${value ? 'ON' : 'OFF'} successfully')),
          );
        }
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to toggle pump');
      }
    } catch (e) {
      print('Error toggling pump: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling pump: $e')),
        );
      }
    } finally {
      client.close(); // Đóng HTTP client
    }
  }

  Future<void> _toggleAutoMode(bool value) async {
    http.Client client = http.Client();
    try {
      final String endpoint = value 
        ? 'https://adapting-doe-precious.ngrok-free.app/ifarm-be/water/pump/auto/enable'
        : 'https://adapting-doe-precious.ngrok-free.app/ifarm-be/water/pump/auto/disable';
      
      final response = await client.post(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            isAutoMode = value;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Auto mode ${value ? 'enabled' : 'disabled'} successfully')),
          );
        }
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to toggle auto mode');
      }
    } catch (e) {
      print('Error toggling auto mode: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling auto mode: $e')),
        );
      }
    } finally {
      client.close(); // Đóng HTTP client
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Watering',
          style: TextStyle(
            color: Colors.brown,
            fontFamily: 'Open Sans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const ImageIcon(AssetImage('assets/details.png'), color: Colors.brown),
            onPressed: () => Navigator.pushNamed(context, '/watering_details'),
          ),
        ],
      ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                    AppBar().preferredSize.height - 
                    MediaQuery.of(context).padding.top - 
                    MediaQuery.of(context).padding.bottom - 80, // Trừ đi chiều cao của bottom nav bar
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.8,
                        child: _buildCard(
                          context,
                          'Auto mode',
                          'assets/automation.png',
                          Colors.purple,
                          true,
                          true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AspectRatio(
                        aspectRatio: 1.8,
                        child: _buildCard(
                          context,
                          'Status',
                          'assets/pump_watering.png',
                          Colors.green,
                          true,
                          false,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AspectRatio(
                        aspectRatio: 2.7,
                        child: _buildDurationCard(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: _buildInfoCard('Times', '${waterStats['waterTimes']}', Colors.green, Icons.timer, showSuperscript: true)
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: _buildInfoCard('Usage', '${waterStats['waterConsumption']}m³', Colors.blue, Icons.water_drop)
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
      bottomNavigationBar: CustomBottomNavBar(  
        currentIndex: 3, // Index cho tab Watering
        onTap: (index) {}, // Thêm onTap callback
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String assetPath, Color color, bool isSwitch, bool isAutoMode) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Image.asset(assetPath, fit: BoxFit.contain),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
          if (isSwitch)
            Positioned(
              bottom: 0,
              right: 0,
              child: isAutoMode 
                ? _AutoModeSwitch(
                    color: color, 
                    isOn: this.isAutoMode,
                    onChanged: _toggleAutoMode,
                  ) 
                : _StatusSwitch(
                    color: color,
                    isWorking: this.isPumpOn,
                    onChanged: _togglePump,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.timer, color: Colors.pink, size: 25),
              SizedBox(width: 4),
              Text(
                'Today Duration',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  waterStats['duration'] ?? '00:00:00',
                  style: const TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color, IconData icon, {bool showSuperscript = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      if (showSuperscript)
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, -10),
                            child: Text(
                              'x',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AutoModeSwitch extends StatelessWidget {
  final Color color;
  final bool isOn;
  final Function(bool) onChanged;

  const _AutoModeSwitch({
    Key? key, 
    required this.color, 
    required this.isOn,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          isOn ? 'On' : 'Off',
          style: const TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        Switch(
          value: isOn,
          onChanged: onChanged,
          activeColor: color,
        ),
      ],
    );
  }
}

class _StatusSwitch extends StatelessWidget {
  final Color color;
  final bool isWorking;
  final Function(bool) onChanged;

  const _StatusSwitch({
    Key? key, 
    required this.color, 
    required this.isWorking,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = isWorking ? Colors.red : Colors.blue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Center(
          child: Text(
            isWorking ? 'Working...' : 'Idle',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Switch(
          value: isWorking,
          onChanged: onChanged,
          activeColor: color,
        ),
      ],
    );
  }
}
