import 'dart:io';

import 'package:ax_flutter_demo/main_app.dart';
import 'package:flutter/material.dart';
// import 'package:window_manager/window_manager.dart';

void main() async {
  runApp(MainApp());
}

//
// setupWindow() async {
//   // 在 runApp 之前设置全屏
//   // WidgetsFlutterBinding.ensureInitialized(); // 确保绑定已初始化
//   if (isDesktop()) {
//     // 可选：只在桌面平台设置
//
//     WidgetsFlutterBinding.ensureInitialized();
//     // 必须添加这一行
//     await windowManager.ensureInitialized();
//     // Level fullscreen
//     //     await WindowManager.instance.setFullScreen(false);
//     // 获取屏幕尺寸
//     // 获取屏幕尺寸
//     WindowOptions windowOptions = WindowOptions(
//       size: Size(800, 600),
//       // 设置窗口大小为800x600
//       // 设置为屏幕尺寸
//       center: true,
//       // 窗口居中显示
//       // minimumSize: Size(400, 300),       // 设置最小尺寸
//       // minimumSize: Size(400, 300),       // 设置最小尺寸
//       // minimumSize:  screenSize,       // 设置最小尺寸
//       // maximumSize:  screenSize,       // 设置最小尺寸
//       // maximumSize: Size(1920, 1080),     // 设置最大尺寸
//       alwaysOnTop: false,
//       // 不始终置顶
//       fullScreen: false,
//       // 全屏启动,会看不见窗口按钮栏
//       backgroundColor: Colors.blue,
//       // 设置背景色为蓝色
//       skipTaskbar: false,
//       // 在任务栏显示
//       title: "我的Flutter应用",
//       // 设置窗口标题
//       titleBarStyle: TitleBarStyle.normal,
//       // 使用正常标题栏
//       windowButtonVisibility: true, // 显示窗口控制按钮
//     );
//
//     windowManager.waitUntilReadyToShow(windowOptions).then((_) async {
//       //       await windowManager.setFullScreen(true); // 全屏,没有关闭按钮等
//
//       // 设置标题栏样式为normal，但隐藏窗口按钮（关闭、最小化、最大化按钮）
//       // await windowManager.setTitleBarStyle(
//       //   TitleBarStyle.normal,
//       //   windowButtonVisibility: false, // 隐藏窗口控制按钮
//       // );
//
//       // 将窗口移动到屏幕中央
//       // await windowManager.center();
//
//       // 设置窗口在任务栏/Dock中显示（false表示显示，true表示隐藏）
//       // await windowManager.setSkipTaskbar(false);
//
//       // 最大化窗口
//       await windowManager.maximize();
//       //
//       // // 让窗口获得焦点
//       // await windowManager.focus();
//       //
//       //
//       // // 显示窗口
//       await windowManager.show();
//     });
//   }
// }

// 检查是否为桌面平台的辅助函数
bool isDesktop() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return true;
  }
  return false;
}
