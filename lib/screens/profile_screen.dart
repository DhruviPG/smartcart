import 'package:flutter/material.dart';

import '../main.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'orders_screen.dart';
import 'preferences_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        AuthService.instance.currentUser ??
        const UserModel(
          uid: 'demo-user',
          name: 'Demo User',
          email: 'demo@smartcart.com',
          preference: 'Budget',
          address: '123 Green Avenue, Bengaluru',
        );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withAlpha((0.12 * 255).round()),
                    child: const Icon(Icons.person, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _ProfileOption(
                title: 'My Orders',
                subtitle: 'Track order status',
                icon: Icons.receipt_long,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OrdersScreen()),
                  );
                },
              ),
              _ProfileOption(
                title: 'Shopping Preferences',
                subtitle: user.preference,
                icon: Icons.tune,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PreferencesScreen(),
                    ),
                  );
                },
              ),
              _ProfileOption(
                title: 'Address',
                subtitle: user.address,
                icon: Icons.location_on_outlined,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await AuthService.instance.signOut();
                  if (context.mounted) {
                    goToLogin(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
