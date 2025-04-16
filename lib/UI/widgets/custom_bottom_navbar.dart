import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea( // Đảm bảo không bị đè lên bởi system UI
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70, // Giảm chiều cao để tránh overflow
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.brown,
            unselectedItemColor: Colors.green[900],
            backgroundColor: Colors.white,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              // Đổi currentIndex để cập nhật trạng thái
              onTap(index);

              // Điều hướng đến các màn hình tương ứng
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home'); // Chuyển đến màn hình Home
                  break;
                case 1:
                  Navigator.pushNamed(context, '/humidity'); // Chuyển đến màn hình Humidity
                  break;
                case 2:
                  Navigator.pushNamed(context, '/temperature'); // Chuyển đến màn hình Temperature
                  break;
                case 3:
                  Navigator.pushNamed(context, '/watering'); // Chuyển đến màn hình Watering
                  break;
                case 4:
                  Navigator.pushNamed(context, '/prediction'); // Chuyển đến màn hình Prediction
                  break;
              }
            },
            items: List.generate(5, (index) {
              final icons = [
                'assets/Bungalow.png',
                'assets/Hygrometer.png',
                'assets/Temperature.png',
                'assets/Garden.png',
                'assets/Combo Chart.png',
              ];

              // Mặc định icon
              Widget iconWidget = ImageIcon(
                AssetImage(icons[index]),
                size: 30, // Giảm từ 34 xuống 28
              );

              // Nếu là icon được chọn đầu tiên thì highlight
              if (index == 0 && currentIndex == 0) {
                iconWidget = Container(
                  padding: const EdgeInsets.all(5), // Giảm padding
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEFDC),
                    shape: BoxShape.circle,
                  ),
                  child: ImageIcon(
                    AssetImage(icons[index]),
                    size: 25, // Icon nhỏ hơn khi trong container
                  ),
                );
              }

              return BottomNavigationBarItem(
                icon: iconWidget,
                label: '',
              );
            }),
          ),
        ),
      ),
    );
  }
}
