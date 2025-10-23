import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';


class UpdateService {
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  /// Check for updates and show dialog if available
  Future<bool> checkForUpdates(BuildContext context) async {
    try {
      final upgrader = Upgrader(durationUntilAlertAgain: const Duration(days: 1));

      await upgrader.initialize();
      final isUpdateAvailable = upgrader.isUpdateAvailable();

      if (isUpdateAvailable) {
        log('Update available: ${upgrader.currentAppStoreVersion}');
        if (context.mounted) {
          _showUpdateDialog(context, upgrader);
        }
        return true;
      }

      log('No update available');
      return false;
    } catch (e) {
      log('Error checking for updates: $e');
      return false;
    }
  }

  /// Show custom update dialog
  Future<void> _showUpdateDialog(BuildContext context, Upgrader upgrader) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // color: mainPurpleColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.system_update,
                      // color: mainPurpleColor,
                      size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Update Available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A new version of Savour is available in the store.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                if (upgrader.currentAppStoreVersion != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Current: ${upgrader.currentInstalledVersion}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Latest: ${upgrader.currentAppStoreVersion}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            // color: mainPurpleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Update now to enjoy the latest features and improvements.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Later',
                  style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  upgrader.sendUserToAppStore();
                },
                style: ElevatedButton.styleFrom(
                  // backgroundColor: mainPurpleColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Update Now', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          );
        },
      );
    });
  }
}
