import 'package:flutter/material.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
class WateringScreen extends StatelessWidget {
  const WateringScreen({super.key});

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
            icon: ImageIcon(AssetImage('assets/details.png'), color: Colors.brown),
            onPressed: () => Navigator.pushNamed(context, '/watering_details'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCard(
              context,
              'Auto mode',
              'assets/automation.png',
              Colors.purple,
              true,
              true,
            ),
            const SizedBox(height: 30),
            _buildCard(
              context,
              'Status',
              'assets/pump_watering.png',
              Colors.green,
              true,
              false,
            ),
            const SizedBox(height: 20),
            _buildDurationCard(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildInfoCard('Times', '20', Colors.green, Icons.timer, showSuperscript: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoCard('Usage', '10m³', Colors.blue, Icons.water_drop)),
              ],
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

  Widget _buildCard(BuildContext context, String title, String assetPath, Color color, bool isSwitch, bool isAutoMode) {
    return Container(
      padding: const EdgeInsets.all(30),
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
              Image.asset(assetPath, width: 120, height: 120),
              const SizedBox(width: 16),
              Expanded(
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
              child: isAutoMode ? _AutoModeSwitch(color: color) : _StatusSwitch(color: color),
            ),
        ],
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
            children: const [
              Icon(Icons.timer, color: Colors.pink, size: 25),
              SizedBox(width: 4),
              Text(
                'Today Duration',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '01:30:22',
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color, IconData icon, {bool showSuperscript = false}) {
    return Container(
      width: 120,
      height: 120,
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
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 38,
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
                            fontSize: 20,
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
          const Spacer(),
        ],
      ),
    );
  }
}

class _AutoModeSwitch extends StatefulWidget {
  final Color color;

  const _AutoModeSwitch({Key? key, required this.color}) : super(key: key);

  @override
  __AutoModeSwitchState createState() => __AutoModeSwitchState();
}

class __AutoModeSwitchState extends State<_AutoModeSwitch> {
  bool isOn = true;

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
          onChanged: (value) {
            setState(() {
              isOn = value;
            });
          },
          activeColor: widget.color,
        ),
      ],
    );
  }
}

class _StatusSwitch extends StatefulWidget {
  final Color color;

  const _StatusSwitch({Key? key, required this.color}) : super(key: key);

  @override
  __StatusSwitchState createState() => __StatusSwitchState();
}

class __StatusSwitchState extends State<_StatusSwitch> {
  bool isWorking = true;

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
          onChanged: (value) {
            setState(() {
              isWorking = value;
            });
          },
          activeColor: widget.color,
        ),
      ],
    );
  }
}
