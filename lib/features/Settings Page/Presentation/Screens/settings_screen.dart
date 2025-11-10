import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("ACCOUNT"),
            const SizedBox(height: 8),
            _buildTile(
              icon: Icons.lock_outline,
              title: "Change Password",
              iconColor: iconOrange,
              onTap: () {},
            ),
            const SizedBox(height: 25),

            _buildSectionTitle("APPLICATION SETTINGS"),
            const SizedBox(height: 8),
            _buildSwitchTile(
              icon: Icons.notifications_none_rounded,
              title: "Enable Notification",
              iconColor: iconBlue,
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 25),

            _buildSectionTitle("ABOUT"),
            const SizedBox(height: 8),
            _buildTile(
              icon: Icons.info_outline,
              title: "About App",
              iconColor: Colors.greenAccent.shade700,
              onTap: () {
                
              },
            ),
            const SizedBox(height: 10),
            _buildTile(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              iconColor: Colors.purpleAccent,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _buildTile(
              icon: Icons.article_outlined,
              title: "Terms & Services",
              iconColor: Colors.amber,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _buildTile(
              icon: Icons.support_agent_outlined,
              title: "Support Center",
              iconColor: Colors.cyanAccent.shade700,
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Switch(
            inactiveTrackColor: Colors.grey.shade400,
            activeTrackColor: iconColor.withOpacity(0.6),
            activeColor: iconColor,
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
