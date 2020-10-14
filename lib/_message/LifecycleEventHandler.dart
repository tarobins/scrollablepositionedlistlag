import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;
  final AsyncCallback inactiveCallBack;
  final AsyncCallback pauseCallBack;

  LifecycleEventHandler({this.resumeCallBack, this.suspendingCallBack, this.inactiveCallBack, this.pauseCallBack});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("resumed");
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        if (inactiveCallBack != null) {
          await inactiveCallBack();
        }
        break;
      case AppLifecycleState.paused:
        print("paused");
        if (pauseCallBack != null) {
          await pauseCallBack();
        }
        break;
      case AppLifecycleState.detached:
        print("detached");
        if (suspendingCallBack != null) {
          await suspendingCallBack();
        }
        break;
    }
  }
}
