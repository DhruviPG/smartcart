import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/compare_provider.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/compare_screen.dart';
import 'screens/cart_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartCartApp());
}

class SmartCartApp extends StatelessWidget {
  const SmartCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthService.instance),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CompareProvider()),
      ],
      child: MaterialApp(
        title: 'SMARTCART',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        home: const SplashScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    CompareScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final compareBadge = context
        .watch<CompareProvider>()
        .selectedProducts
        .length;
    final cartBadge = context.watch<CartProvider>().itemCount;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: compareBadge > 0,
              label: Text(compareBadge.toString()),
              child: const Icon(Icons.compare_arrows_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: compareBadge > 0,
              label: Text(compareBadge.toString()),
              child: const Icon(Icons.compare_arrows),
            ),
            label: 'Compare',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartBadge > 0,
              label: Text(cartBadge.toString()),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartBadge > 0,
              label: Text(cartBadge.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
}

void goToLogin(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}

void goToMain(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    (route) => false,
  );
}
