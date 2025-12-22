import 'dart:developer';

import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ShorebirdUpdateChecker {
  final _updater = ShorebirdUpdater();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Future<void> checkForUpdates({
    bool showUpToDateMessage = false,
    bool silent = false,
  }) async {
    if (kDebugMode) {
      log(
        'Shorebird updates are NOT available in Debug mode. Use "shorebird release" to test.',
      );
      if (!silent) {
        _showToast('Shorebird needs Release build', Colors.orange);
      }
      return;
    }

    log('Checking for Shorebird updates...');

    try {
      final isAvailable = _updater.isAvailable;
      if (!isAvailable) {
        log('Code push is not available');
        if (!silent) {
          _showToast('Code push not available', Colors.orange);
        }
        return;
      }

      final currentPatch = await _updater.readCurrentPatch();
      log('Current patch number: ${currentPatch?.number ?? "None"}');

      final status = await _updater.checkForUpdate();
      log('Update status: $status');

      switch (status) {
        case UpdateStatus.outdated:
          log('New patch available for download.');
          await downloadUpdate(silent: silent);
          break;

        case UpdateStatus.upToDate:
          log('App is up to date.');
          if (showUpToDateMessage && !silent) {
            _showToast('App is up to date ✓', Colors.green);
          }
          break;

        case UpdateStatus.restartRequired:
          log('Restart required to apply previously downloaded update.');
          if (!silent) {
            _showRestartDialog();
          }
          break;

        case UpdateStatus.unavailable:
          log('Shorebird update unavailable.');
          if (!silent) {
            _showToast('Updates unavailable', Colors.grey);
          }
          break;
      }
    } catch (e) {
      log('Error checking for updates: $e');
      if (!silent) {
        _showToast('Error checking updates', Colors.red);
      }
    }
  }

  Future<void> downloadUpdate({bool silent = false}) async {
    log('Downloading update...');
    if (!silent) {
      _showToast('Downloading update...', Colors.blue);
    }

    try {
      await _updater.update();
      log('Update downloaded successfully. Restart required to apply.');

      if (!silent) {
        _showRestartDialog();
      }
    } catch (e) {
      log('Error downloading update: $e');
      if (!silent) {
        _showToast('Update failed: ${e.toString()}', Colors.red);
      }
    }
  }

  void _showRestartDialog() {
    final context = navigatorKey.currentContext;
    if (context == null) {
      _showToast('Update ready! Please restart the app.', Colors.green);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.system_update, color: Colors.green),
              SizedBox(width: 10),
              Text('Update Ready'),
            ],
          ),
          content: const Text(
            'A new update has been downloaded. Please restart the app to apply the changes.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _restartApp();
              },
              child: const Text('Restart Now'),
            ),
          ],
        );
      },
    );
  }

  void _restartApp() {
    _showToast(
      'Please close and reopen the app to complete the update.',
      Colors.green,
    );
  }

  Future<int?> getCurrentPatchNumber() async {
    try {
      final currentPatch = await _updater.readCurrentPatch();
      log('Current patch number: ${currentPatch?.number ?? "None"}');
      return currentPatch?.number;
    } catch (e) {
      log('Error reading current patch: $e');
      return null;
    }
  }

  Future<bool> isUpdateAvailable() async {
    if (kDebugMode) return false;

    try {
      final isAvailable = _updater.isAvailable;
      if (!isAvailable) return false;

      final status = await _updater.checkForUpdate();
      return status == UpdateStatus.outdated;
    } catch (e) {
      log('Error checking if update available: $e');
      return false;
    }
  }

  Future<UpdateStatus> getUpdateStatus() async {
    if (kDebugMode) return UpdateStatus.unavailable;

    try {
      final isAvailable = _updater.isAvailable;
      if (!isAvailable) return UpdateStatus.unavailable;

      return await _updater.checkForUpdate();
    } catch (e) {
      log('Error getting update status: $e');
      return UpdateStatus.unavailable;
    }
  }

  void _showToast(String msg, Color color) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
