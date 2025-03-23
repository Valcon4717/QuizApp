import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/theme_controller.dart';

Future<void> clearUserSession(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.pushReplacementNamed(context, '/login');
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'No Name';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final bool isDarkMode = themeController.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      // Material 3 NavigationDrawer
      drawer: NavigationDrawer(
        selectedIndex: null,
        onDestinationSelected: (index) async {
          switch (index) {
            case 0:
              themeController.toggleTheme();
              break;
            case 1:
              await clearUserSession(context);
              break;
          }
        },
        children: [
          // Custom Drawer Header with a dismiss (X) button
          DrawerHeader(
            child: Stack(
              children: [
                // Close Button at the top right
                Positioned(
                  top: 0,
                  left: 230,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); // Dismiss the drawer
                    },
                  ),
                ),
                // Header content (profile avatar and greeting)
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(
                          isDarkMode
                              ? 'assets/icons/HoneyDarkComplex.png'
                              : 'assets/icons/HoneyLightComplex.png',
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Hello,",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        _username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Navigation items
          NavigationDrawerDestination(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            label: const Text("Toggle Theme"),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Welcome, $_username!",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}