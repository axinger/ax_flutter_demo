import 'package:flutter/material.dart';

import '../_01widget_demo/01root_test_page.dart';
import '../_02get_demo/02demo_getx_page.dart';
import '../controller/history_page.dart';

class TabbarItemController {
  TabbarItemController({
    required String title,
    required Widget icon,
    Widget? activeIcon,
    required Widget controller,
  })  : _icon = icon,
        _title = title,
        _activeIcon = activeIcon,
        controller = controller,
        item = BottomNavigationBarItem(
          label: title,
          icon: icon,
//          activeIcon: activeIcon,
          backgroundColor: Colors.white,
        );

  final String _title;
  final Widget _icon;
  final Widget? _activeIcon;
  final BottomNavigationBarItem item;
  final Widget controller;
}

class RootPage extends StatefulWidget {
  @override
  _01rootController createState() => _01rootController();
}

class _01rootController extends State<RootPage> //    with SingleTickerProviderStateMixin
{
  //TabController + tabview组合动画不好控制,
//  TabController _tabController;

  // PageView 嵌套 PageController+BottomNavigationBarItem 手动点击事件,好控制动画
//  PageController _pageController;

  //PageController 没有记录index,所以自定义
  int _tabItemCurrentIndex = 0;

  List<TabbarItemController>? _tabbarItemControllerList;

  @override
  void initState() {
    super.initState();
  }

  void _initPageList() {
    _tabbarItemControllerList = <TabbarItemController>[
      // TabbarItemController(
      //   title: "首页",
      //   icon: Icon(Icons.home),
      //   activeIcon: Icon(
      //     Icons.home,
      //   ),
      //   controller: HomePage(),
      // ),

      TabbarItemController(
        title: "测试页面",
        icon: const Icon(Icons.desktop_mac),
        controller: RootHomePage(),
      ),
      TabbarItemController(
        title: 'getX 示例',
        icon: const Icon(Icons.desktop_mac),
        controller: DemoGetXPage(),
      ),
      TabbarItemController(
        title: "记录",
        icon: const Icon(Icons.history),
        activeIcon: const Icon(Icons.history),
        controller: HistoryPage(),
      ),
      // TabbarItemController(
      //   title: "我的",
      //   icon: Icon(Icons.person),
      //   activeIcon: Icon(Icons.person),
      //   controller: MinePage(),
      // ),
    ];
  }

  @override
  void dispose() {
//    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initPageList();

    return Scaffold(

        /// 子页面保持状态数据,不会每次刷新
        body: IndexedStack(
          index: _tabItemCurrentIndex,
          children: _tabbarItemControllerList!.map((item) {
            return item.controller;
          }).toList(),
        ),

        // body: _tabbarItemControllerList[_tabItemCurrentIndex].controller,
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.orange,
            /**选中颜色*/
            fixedColor: Colors.blue,

//            selectedItemColor: Colors.red,
//            unselectedItemColor: Colors.black12,

            //选中,非选中颜色
            type: BottomNavigationBarType.fixed,
            //fixedColor 才起作用
            items: _tabbarItemControllerList!.map((item) {
              return item.item;
            }).toList(),
            currentIndex: _tabItemCurrentIndex,
            onTap: (int index) {
              setState(() {
                _tabItemCurrentIndex = index;
              });
            }));
  }
}
