import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:repair_minds/Screen/main_screens/common_screen/offline_screen.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final bool isOffline =
            snapshot.hasData &&
            snapshot.data!.contains(ConnectivityResult.none);

        if (isOffline) {
          return const OfflineScreen();
        }

        // Otherwise, return the normal screen
        return child;
      },
    );
  }
}