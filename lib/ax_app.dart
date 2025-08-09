import 'dart:io';

import 'package:ax_flutter_demo/_01widget_demo/page/01_content_page1.dart';
import 'package:ax_flutter_demo/_01widget_demo/page/28_test_route_page.dart';
import 'package:ax_flutter_demo/_02get_demo/demo_translations.dart';
import 'package:ax_flutter_demo/_02get_demo/route/route_pages.dart';
import 'package:ax_flutter_demo/theme_data_notifier.dart';
// import 'package:ax_flutter_util/ax_flutter_util.dart';
// import 'package:ax_flutter_util/ax_flutter_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '_01root/root_page.dart';
import 'app_theme.dart';
import 'event/login_success_event.dart';
import 'event/update_user_info_event.dart';
import 'generated/l10n.dart';
import 'global_const.dart';
import 'module/login/view/login_view.dart';

class AxApp extends StatefulWidget {
//  var adapter = Hive.registerAdapter(StudentAdapter(),0);
//  void log(String? name){
//print();
//
//  }

  @override
  State<StatefulWidget> createState() => _MyApp();
}

///WidgetsBindingObserver 进入后台
class _MyApp extends State<AxApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    /// build完成
    WidgetsBinding.instance.addPostFrameCallback((callback) {
//      _overlayEntry();
      if (mounted) {
        _overlayEntry();
      }
    });
    eventBus();

    getDeviceInfo();
    packageInfo();

//    testStr = 'tom';
//    testStr2 = 'tom';
//window.padding;
    time3 = DateTime.now();

    ///需要注意的是，匿名函数声明调用结束时追加了小括号（），
    ///这是因为断言只能检查布尔值，这里使用括号强制执行这个始终返回true的匿名函数，以保证函数里的代码被执行
//    assert((1==2){
//      // Do something for debug
//      print('这是asset下的输出内容');
//      return true;
//    };

    if (kReleaseMode) {
      //
      //release
      print('Mode = kReleaseMode');
    } else {
      //debug
      print('Mode = kBug');
    }

    const bool inProduction = const bool.fromEnvironment("dart.vm.product");
    print('inProduction = $inProduction');
    _androidBack();
    _boost();

    /// FlutterBoost 注册
//    FlutterBoost.singleton.registerPageBuilders(
//      {
//        "route_MaterialPage1": (pageName, params, _) => MaterialPage1(),
//      },
//    );

//    FlutterBoost.singleton
//        .addBoostNavigatorObserver(TestBoostNavigatorObserver());

    /// debug 不会被打印
//    log.Logger.level = log.Level.info;

//    getTemporaryDirectory().then((value) {
//      String tempPath = value.path;
//    });
//
//    getApplicationDocumentsDirectory().then((value) {
//      String appDocPath = value.path;
//    });
//
//    accelerometerEvents.listen((AccelerometerEvent event) {
//      print(event);
//    });
//// [AccelerometerEvent (x: 0.0, y: 9.8, z: 0.0)]
//
//    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
//      print(event);
//    });
//// [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]
//
//    gyroscopeEvents.listen((GyroscopeEvent event) {
//      print(event);
//    });
// [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]
  }

  @override
  Widget build(BuildContext context) {
    // return _buildMultiProvider;

    return _getMaterialApp;
  }

  /// 监听安卓返回按键
  void _androidBack() {
    const basicMessageChannel =
        const BasicMessageChannel('Android_back', StringCodec());

//接受并回复消息

    basicMessageChannel.setMessageHandler(
      (String? message) => Future<String>(() {
        // print('收到消息===============');

//        setState(() {
//          this.message = message;
//        });
        return "回复native消息";
      }),
    );
  }

  /// 咸鱼路由
  void _boost() {
//    FlutterBoost.singleton.registerPageBuilders(<String, PageBuilder>{
//      '/P28RoutePageSub1':
//          (String pageName, Map<String, dynamic> params, String uniqueId) {
//        print('P00ShowTestPage params:$params');
//        return P28RoutePageSub1();
//      },
//
//      ///可以在native层通过 getContainerParams 来传递参数
//      'aa': (String pageName, Map<String, dynamic> params, String uniqueId) {
//        print('P47RouteWidget params:$params');
//
//        return P47RouteWidget(map: params);
//      },
//
//      ///可以在native层通过 getContainerParams 来传递参数
//      'P47RouteWidget2':
//          (String pageName, Map<String, dynamic> params, String uniqueId) {
//        print('P47RouteWidget2 params:$params');
//
//        return P47RouteWidget2();
//      },
//    });
//    FlutterBoost.singleton
//        .addBoostNavigatorObserver(TestBoostNavigatorObserver());
  }

  /// 全局浮层
  void _overlayEntry() {
    var btn = Material(
      color: Colors.transparent,
      shape: const CircleBorder(
        side: BorderSide(
          color: Colors.green,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: GestureDetector(
        child: Container(
          width: 80,
          height: 80,
          color: Colors.transparent,
          child: Icon(Icons.add),
        ),
        onTap: () {
          print('add==========');
        },
      ),
    );

    double OffsetY = 200;
    ValueNotifier<Offset> offsetNotifier =
        ValueNotifier<Offset>(Offset(0, OffsetY));
    var entry = OverlayEntry(
        maintainState: true,
        builder: (BuildContext context) {
          return ValueListenableBuilder(
            valueListenable: offsetNotifier,
            builder: (BuildContext? context, Offset? value, Widget? child) {
              return Positioned(
                top: value!.dy > 0 ? value.dy : 0,
                left: value.dx > 0 ? value.dx : 0,
                child: Draggable(
                    //创建可以被拖动的Widget
                    child: btn,
                    //拖动过程中的Widget
                    feedback: btn,
                    //拖动过程中，在原来位置停留的Widget，设定这个可以保留原本位置的残影，如果不需要可以直接设置为Container()
                    childWhenDragging: Container(),
                    //拖动结束后的Widget
                    onDraggableCanceled: (Velocity velocity, Offset offset) {
                      //更新位置信息
                      offsetNotifier.value = offset;
                    }),
              );
            },
          );
        });
    navigatorStateKey.currentState?.overlay?.insert(entry);
  }

  void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (kDebugMode) {
        print('IOS设备 = ${iosInfo.toString()}');
      }
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (kDebugMode) {
        print('Android设备 = $androidInfo}');
      }
    }
  }

  void packageInfo() async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    if (kDebugMode) {
      print(
          "appName = $appName packageName = $packageName version = $version buildNumber = $buildNumber");
    }

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print("state = " + state.toString());
    }
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        if (kDebugMode) {
          print("app转态 不活跃");
        }
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        if (kDebugMode) {
          print("app转态 前台");
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        if (kDebugMode) {
          print("app转态 后台");
        }
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        if (kDebugMode) {
          print("app转态 暂时暂停");
        }
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }

  void eventBus() {
    EVENT_BUS.on<UpdateUserInfoEvent>().listen((event) {
      if (kDebugMode) {
        print("UpdateUserInfoEvent = " + event.name);
      }
    });
    EVENT_BUS.on<LoginSuccessEvent>().listen((event) {
      if (kDebugMode) {
        print("LoginSuccessEvent = " + event.name);
      }
    });
  }

  Widget get _rootView {
    /// 全局点击空白处隐藏键盘
//    return GestureDetector(
//      onTap: () {
//        FocusScopeNode currentFocus = FocusScope.of(context);
//        if (!currentFocus.hasPrimaryFocus &&
//            currentFocus.focusedChild != null) {
//          FocusManager.instance.primaryFocus.unfocus();
//        }
//      },
//      child: P00ShowTestPage(),
////      child: DismissKeyboardDemo(),
//    );

    // return P00ShowTestPage();
    return RootPage();
    // return TestHomePage();
//   return RootPage();
  }

  Widget get _buildMultiProvider {
    return MultiProvider(
      providers: [
//        ChangeNotifierProvider(create: (context) => mainConfigModel),
        ChangeNotifierProvider.value(value: ThemeDataNotifier())
      ],
      child: Consumer<ThemeDataNotifier>(
        builder: (context, value, child) {
          return _materialApp(value.themeData);
        },
      ),
    );
  }

  /// get库
  Widget get _getMaterialApp {
    return GetMaterialApp(
      title: '阿星 Flutter Demo',
      navigatorKey: navigatorStateKey,

      /// 自定义文字 国际化
      translations: DemoTranslations(),
      locale: const Locale('zh', 'CN'),
      //设置默认语言
      fallbackLocale: const Locale("zh", "CN"),

      /// 路由
      getPages: RoutePages.pages,
      unknownRoute: RoutePages.notFoundRoute,

      ///Flutter里的viewWillAppear
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
      /// 分别设置,就表示 跟随系统,
      // theme: AppTheme.lightTheme(),
      // darkTheme: ThemeData.dark(),

      // theme: Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),

      /// 系统的控件 本地化
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("zh", "CN"), ...S.delegate.supportedLocales,
      ],

      builder: (context, child) => Scaffold(
        // Global GestureDetector that will dismiss the keyboard
        body: GestureDetector(
          onTap: () {
            hideKeyboard(context);
          },
          child: child,
        ),
      ),
      home: _rootView,

//      home: P00ShowTestPage(),
      /// 影响我的浮层
//      builder: FlutterBoost.init(postPush: _onRoutePushed),
//      builder: FlutterBoost.init(),
      /// 根路由,一般设置 和 onGenerateRoute 冲突,不能同时存在
//      initialRoute: "/",
      routes: {
        "/Root": (context) => RootPage(),
        "/route_login": (context) => LoginView(),
        "/P28RoutePage": (context) => P28RoutePage(),
        "/P28RoutePageSub1": (context) => P28RoutePageSub1(),
        "/P28RoutePageSub2": (context) => P28RoutePageSub2(),
        "/P28RoutePageSub3": (context) => P28RoutePageSub3(),
        "/MaterialPage1": (context) => P01ContentPage(),
      },

      /// Navigator.of(context).pushNamed('/new');  Navigator.pushNamed 时无法直接给新页面传参数
      ///和 routes 冲突 可以传参的，相比于命名路由，可以多做一些相关的拦截
//      onGenerateRoute: (RouteSettings settings) {
//        String routeName = settings.name;
//        print("routeName = : $routeName");
//        print("settings.arguments: ${settings.arguments}");
//        switch (routeName) {
//          case "/sub2":
//            return MaterialPageRoute(builder: (context) {
//              return P28RoutePageSub2(
//                sub2Map: settings.arguments,
//              );
//            });
//          default:
//            return MaterialPageRoute(builder: (BuildContext context) {
//              return Scaffold(
//                  body: Center(
//                child: Text("Page not found"),
//              ));
//            });
//        }
//      },
    );
  }

  MaterialApp _materialApp(ThemeData themeData) {
    return MaterialApp(
      title: '阿星 Flutter Demo',
      navigatorKey: navigatorStateKey,

      ///Flutter里的viewWillAppear
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
      /// 分别设置,就表示 跟随系统,
      theme: AppTheme.lightTheme(themeData: themeData),
      // darkTheme: ThemeData.dark(),

      /// 本地化
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("zh", "CN"), ...S.delegate.supportedLocales,
      ],

      builder: (context, child) => Scaffold(
        // Global GestureDetector that will dismiss the keyboard
        body: GestureDetector(
          onTap: () {
            hideKeyboard(context);
          },
          child: child,
        ),
      ),
      home: _rootView,

//      home: P00ShowTestPage(),
      /// 影响我的浮层
//      builder: FlutterBoost.init(postPush: _onRoutePushed),
//      builder: FlutterBoost.init(),
      /// 根路由,一般设置 和 onGenerateRoute 冲突,不能同时存在
//      initialRoute: "/",
      routes: {
        "/Root": (context) => RootPage(),
        "/route_login": (context) => LoginView(),
        "/P28RoutePage": (context) => P28RoutePage(),
        "/P28RoutePageSub1": (context) => P28RoutePageSub1(),
        "/P28RoutePageSub2": (context) => P28RoutePageSub2(),
        "/P28RoutePageSub3": (context) => P28RoutePageSub3(),
        "/MaterialPage1": (context) => P01ContentPage(),
      },

      /// Navigator.of(context).pushNamed('/new');  Navigator.pushNamed 时无法直接给新页面传参数
      ///和 routes 冲突 可以传参的，相比于命名路由，可以多做一些相关的拦截
//      onGenerateRoute: (RouteSettings settings) {
//        String routeName = settings.name;
//        print("routeName = : $routeName");
//        print("settings.arguments: ${settings.arguments}");
//        switch (routeName) {
//          case "/sub2":
//            return MaterialPageRoute(builder: (context) {
//              return P28RoutePageSub2(
//                sub2Map: settings.arguments,
//              );
//            });
//          default:
//            return MaterialPageRoute(builder: (BuildContext context) {
//              return Scaffold(
//                  body: Center(
//                child: Text("Page not found"),
//              ));
//            });
//        }
//      },
    );
  }

  ///   全局隐藏键盘
  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      // FocusManager.instance.primaryFocus.unfocus();///会反复弹起
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }

  void _onRoutePushed(
      String pageName, String uniqueId, Map params, Route route, Future _) {
    if (kDebugMode) {
      print('_onRoutePushed == $pageName  uniqueId = $uniqueId');
    }
  }
}

class TestBoostNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('flutterboost#didPush');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('flutterboost#didPop');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('flutterboost#didRemove');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (kDebugMode) {
      print('flutterboost#didReplace');
    }
  }
}

class DismissKeyboardDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: const Text('0000'),
          onPressed: () {
            // push(context: context, widget: const DismissKeyboardDemo2());
          },
        ),
      ),
    );
  }
}

class DismissKeyboardDemo2 extends StatelessWidget {
  const DismissKeyboardDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: TextField(),
      ),
    );
  }
}
