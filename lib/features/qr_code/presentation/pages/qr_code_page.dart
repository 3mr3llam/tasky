import 'dart:async';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tasky/features/qr_code/presentation/widgets/scan_error.dart';
import 'package:tasky/features/tasks/logic/tasks_controller.dart';

// DLS2eyJoYW5kc2hha2VDb2RlIjoiMTAyOTE0ODcwLVRYbE5iMkpwYkdWUWNtOXEiLCJtYWluU2VydmVyVVJMIjoiaHR0cHM6Ly9tZGxzLmR5bmFtc29mdG9ubGluZS5jb20iLCJvcmdhbml6YXRpb25JRCI6IjEwMjkxNDg3MCIsInN0YW5kYnlTZXJ2ZXJVUkwiOiJodHRwczovL3NkbHMuZHluYW1zb2Z0b25saW5lLmNvbSIsImNoZWNrQ29kZSI6NTIwMTE0NzcyfQ==
class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    autoStart: true,
  );
  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      if (_barcode == null) {
        setState(() async {
          _barcode = barcodes.barcodes.firstOrNull;
          await Get.find<TasksController>().getTask(_barcode?.rawValue ?? "");
          controller.stop();
        });
      }
    }
  }

  @override
  void initState() {
    // To fix on start error
    controller.stop();
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);

    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: controller,
        fit: BoxFit.contain,
        errorBuilder: (context, error, child) {
          return ScannerErrorWidget(error: error);
        },
        onDetect: (capture) {
          //final List<Barcode> barcodes = capture.barcodes;
          // final Uint8List? image = capture.image;
          //for(final barcode in barcodes) {
          // print(barcode.rawValue);
          //}
        },
      ),
    );
  }
}
