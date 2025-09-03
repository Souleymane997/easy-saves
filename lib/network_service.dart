import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ValueNotifier<bool> hasConnection = ValueNotifier(true);

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  OverlayEntry? _bannerEntry;

  void initialize() {
    _checkInitialConnection();

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = results.isNotEmpty && !results.contains(ConnectivityResult.none);

      _updateConnectionBanner(isConnected);
      hasConnection.value = isConnected;
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    final isConnected = results.isNotEmpty && !results.contains(ConnectivityResult.none);

    hasConnection.value = isConnected;
    _updateConnectionBanner(isConnected);
  }

  void _updateConnectionBanner(bool isConnected) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    if (!isConnected) {
      _bannerEntry?.remove();
      _bannerEntry = OverlayEntry(
        builder: (_) => _buildBanner(context, false),
      );
      navigatorKey.currentState?.overlay?.insert(_bannerEntry!);
    } else {
      _bannerEntry?.remove();
      _bannerEntry = null;

      final successBanner = OverlayEntry(
        builder: (_) => _buildBanner(context, true),
      );
      navigatorKey.currentState?.overlay?.insert(successBanner);

      Future.delayed(const Duration(seconds: 3), () {
        successBanner.remove();
      });
    }
  }

  Widget _buildBanner(BuildContext context, bool isConnected) {
    final color = isConnected ? Colors.green : Colors.red;
    final text = isConnected ? "Connexion établie" : "Pas de connexion Internet";
    final icon = isConnected ? Icons.wifi : Icons.wifi_off;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}
