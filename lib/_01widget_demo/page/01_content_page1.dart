import 'dart:async';

import 'package:ax_flutter_demo/config.dart';
import 'package:ax_flutter_demo/global_const.dart';
// import 'package:ax_flutter_util/ax_flutter_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class P01ContentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<P01ContentPage>
    with SingleTickerProviderStateMixin, RouteAware {
  /// Flutter里的viewWillAppear
  /// 2.重写didChangeDependencies方法加入监听
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // routeObserver.subscribe(this, ModalRoute.of(context));
  }

  /// 3.在页面dispose时销毁监听
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
    _streamController.close();
  }

  /// 当Push到该页面时：
  @override
  void didPush() {
    print('didPush');
  }

  ///当Pop到该页面时：
  @override
  void didPopNext() {
    print('didPopNext');
  }

  /// 当该页面Push到其他页面时：
  @override
  void didPushNext() {
    print('didPushNext');
  }

  /// 当该页面被Pop时：
  @override
  void didPop() {
    print('didPop');
  }

  /// 悬浮按钮
  final _floatingActionButton = FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
    backgroundColor: Colors.orange,

    ///形状,默认圆形
    //    shape: BeveledRectangleBorder(),

    /// 阴影
    elevation: 0,
  );

  bool isOffstage = false;
  bool isVisibility = false;
  bool isBack = true;
  TabController? tabController;

  Visibility abv = Visibility(
    visible: true,
    child: Container(color: Colors.lightGreen, height: 50),
  );

  StreamController<bool> _streamController = StreamController<bool>();
  bool _isShow = true;

  ValueNotifier<bool> isAbsorbPointer = ValueNotifier(true);

  @override
  void initState() {
    // ScrollController scrollController;

    super.initState();

    /// https://blog.csdn.net/zl18603543572/article/details/107553183
    ///单次 Frame 绘制回调，通过 addPostFrameCallback 实现。
    ///它会在当前 Frame 绘制完成后进行回调，并只会回调一次，如果要再次监听则需要再设置一次。
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      debugPrint('WidgetsBinding-addPostFrameCallback');
      // 只回调一次
      ///在第一次绘制完成时再添加实时回调的监听

      /// 都只能在这里,在外面报错
      WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
        debugPrint('WidgetsBinding-addPersistentFrameCallback'); // 只回调一次
      });

      SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
        debugPrint('SchedulerBinding-addPersistentFrameCallback');
      });
      ServicesBinding.instance.addPersistentFrameCallback((timeStamp) {
        debugPrint('ServicesBinding-addPersistentFrameCallback');
      });
      RendererBinding.instance.addPersistentFrameCallback((timeStamp) {
        debugPrint('RendererBinding-addPersistentFrameCallback');
      });
    });

    tabController = TabController(length: 10, vsync: this);
    tabController?.addListener(() {
      if (tabController?.index == tabController?.animation?.value) {
        print('tabController.index = ${tabController?.index}');
      }
    });

    ListView();
  }

  // _popupMenuItem(String title, {String imagePath='', IconData icon}) {
  //   return PopupMenuItem(
  //     child: Row(
  //       children: <Widget>[
  //         imagePath != null
  //             ? Image.asset(
  //                 imagePath,
  //                 width: 30.0,
  //                 height: 30.0,
  //               )
  //             : SizedBox(
  //                 width: 30.0,
  //                 height: 30.0,
  //                 child: Icon(
  //                   icon,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //         Container(
  //           padding: const EdgeInsets.only(left: 15.0),
  //           child: Text(
  //             title,
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isBack) {
          return true;
        }

        Navigator.of(context).pushNamed(
          '/sub2',
          arguments: {
            'title': '透传title',
            'name': 'postbird',
            'passw': '123456',
          },
        );

        return false;
        //        return await showAlert(
        //            context: context,
        //            title: '确定返回吗?',
        //            cancelCallback: () {},
        //            certainCallback: () {});
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('测试,状态栏颜色', style: TextStyle(color: Colors.red)),
          // backgroundColor: Colors.white,
          centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            indicatorWeight: 5,

            /// isScrollable 是否滚动无限大
            isScrollable: true,
            indicatorColor: Colors.red,
            tabs: List.generate(10, (index) {
              return const Tab(text: "主页", icon: Icon(Icons.local_florist));
            }),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),

        /// 悬浮按钮
        floatingActionButton: _floatingActionButton,
        //        floatingActionButton: _FloatingActionButton2,
        ///  悬浮按钮 位置 endDocked 有叠合效果 endFloat
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: StreamBuilder<bool>(
          // 监听Stream，每次值改变的时候，更新Text中的内容
          stream: _streamController.stream,

          /// 第一次监听值
          initialData: _isShow,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            print('snapshot.data = ${snapshot.data}');

            return BottomAppBar(
              color: Colors.red,

              /// 直接用_isShow 方便控制,比snapshot?.data 不知道为什么
              child: (!_isShow)
                  ? null
                  : SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,

                        ///交叉轴的布局方式，对于column来说就是水平方向的布局方式
                        crossAxisAlignment: CrossAxisAlignment.end,
                        verticalDirection: VerticalDirection.down,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              /// 充满 容器
                              alignment: Alignment.center,
                              color: Colors.orange,
                              child: TextButton(
                                child: const Text('请求'),
                                onPressed: () async {
                                  var options = BaseOptions(
                                    connectTimeout: const Duration(seconds: 15),
                                    receiveTimeout: const Duration(seconds: 15),
                                    //                                      responseType: ResponseType.plain,
                                    //                                      validateStatus: (status) {
                                    //                                        print('status = $status');
                                    //                                        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
                                    //                                        return false;
                                    //                                      },
                                    baseUrl: 'http://localhost:8080',
                                  );

                                  Map<String, dynamic> params = {'name': 'jim'};

                                  Dio _dio = Dio(options); // 使用默认配置

                                  _dio
                                      .post('/test6', data: params)
                                      .catchError((onError) {
                                        print('onError = $onError');
                                      })
                                      .then((value) {
                                        print('response = ${value}');
                                      });

                                  //                                    try{
                                  //                                      Response response = await Dio().get(
                                  //                                          'http://127.0.0.1:8080//test4?name=jim'
                                  //                                      );
                                  //                                       print(response);
                                  //                                    }catch(e){
                                  //                                       print(e);
                                  //                                    }
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 1),
                          Expanded(
                            flex: 1,
                            child: Container(
                              /// 充满 容器
                              alignment: Alignment.center,
                              color: Colors.orange,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('按钮1'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

              /// 切形状 自动根据被 重叠部分
              //              shape: CircularNotchedRectangle(),
            );
          },
        ),
        persistentFooterButtons: [Text('A'), Text('B'), Text('C')],

        body: Container(
          //        padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/IMG_3601.JPG'),
              fit: BoxFit.cover,
              //              repeat :ImageRepeat.repeatY
            ),
            color: Colors.blue,
          ),

          child: ListView(
            //          padding: EdgeInsets.all(20),
            children: [
              TextButton(
                child: Text('showModalBottomSheet 圆角'),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),

                    /// 能否满屏显示,
                    //                      isScrollControlled: true,
                    builder: (context) {
                      /// 不用高度,会给出一个默认高度
                      return Container(
                        //                            height: 200, //对话框高度就是此高度
                        color: Colors.red,
                        child: ListView(
                          children: List.generate(20, (index) {
                            return Text('title - $index');
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              ),

              TextButton(
                child: Text('InteractiveViewer如: 平移，缩放和拖动“N”下降甚至大小调整'),
                onPressed: () {
                  Get.to(InteractiveViewerDemo());
                },
              ),
              Image.asset(assetsOfImagePath('/A171.jpg'), fit: BoxFit.fill),
              Text(
                '黑白图片',
                style: TextStyle(color: Colors.red, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                assetsOfImagePath('/A171.jpg'),
                fit: BoxFit.fill,

                ///要有
                color: Colors.black,
                colorBlendMode: BlendMode.color,
              ),

              //            Row(
              //              children: <Widget>[
              Text('Expanded 等比分布,撑满剩余空间'),
              Row(
                children: <Widget>[
                  Text('头'),
                  Expanded(
                    child: Container(
                      color: Colors.red,
                      child: Text('aa', maxLines: 1),
                    ),
                  ),
                  Text('尾部'),
                  Text('尾部'),
                ],
              ),

              Row(
                children: <Widget>[
                  Container(width: 20, height: 100, color: Colors.orange),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        print('===========');
                      },
                      child: Container(
                        child: Text('Text1', textAlign: TextAlign.center),
                        height: 100,
                        alignment: AlignmentDirectional.center,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text('Text2', textAlign: TextAlign.center),
                      height: 100,
                      alignment: AlignmentDirectional.center,
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text('Text3', textAlign: TextAlign.center),
                      height: 100,
                      alignment: AlignmentDirectional.center,
                      color: Colors.cyan,
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  Text('头'),
                  Expanded(
                    child: Text(
                      'A=============================================================A',
                      maxLines: 1,
                    ),
                  ),
                  Text('尾部'),
                ],
              ),

              TextButton(
                child: Text('控制是否可以直接返回'),
                // splashColor: Colors.red,
                // color: Colors.green,
                // textColor: Colors.white,
                onPressed: () {
                  isBack = !isBack;
                },
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text('显示隐藏-Visibility'),
                // splashColor: Colors.red,
                // color: Colors.green,
                // textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
              ),
              TextButton(
                child: Text('显示隐藏-Offstage'),
                // splashColor: Colors.red,
                // color: Colors.green,
                // textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    isOffstage = !isOffstage;
                  });
                },
              ),
              Visibility(
                visible: isVisibility,
                child: Container(color: Colors.indigo, height: 50),
              ),
              Offstage(
                offstage: isOffstage,
                child: Container(color: Colors.orange, height: 50),
              ),
              Container(color: Colors.red, height: 50),
              TextButton(
                child: Text('控制下面这个'),
                // splashColor: Colors.red,
                // color: Colors.green,
                // textColor: Colors.white,
                onPressed: () async {
                  _isShow = !_isShow;
                  _streamController.sink.add(!_isShow);
                },
              ),
              CupertinoButton(
                color: Colors.orange,
                child: Text('ios DatePicker'),
                onPressed: () {},
              ),
              SizedBox(height: 20),

              Container(
                color: Colors.orange,
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2025),
                  onDateChanged: (d) {
                    print('$d');
                  },
                ),
              ),
              Text('CalendarDateRangePicker 为公共文件'),

              //              Container(
              //                color: Colors.orange,
              //                child: CalendarDateRangePicker(
              //
              //                ),
              //              ),
              TextButton(
                child: Text('flutter日期选择'),
                onPressed: () {
                  _selectDateFunc();
                },
                // splashColor: Colors.red,
                // color: Colors.green,
                // textColor: Colors.white,
              ),
              ElevatedButton(
                child: Text('范围日期'),
                onPressed: () {
                  showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2025),
                  );
                },
              ),
              SizedBox(height: 20),
              CupertinoButton(
                color: Colors.orange,
                child: Text('ios TimerPicker'),
                onPressed: () {
                  _showCupertinoTimerPicker(context);
                },
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text('flutter 时间选择'),
                onPressed: () {
                  _selectTimeFunc();
                },
                // splashColor: Colors.red,
                // color: Colors.green,
                // textColor: Colors.white,
              ),
              SizedBox(height: 20),
              Container(
                color: Colors.red,
                height: 300,
                width: 200,
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime.now().add(Duration(days: -1)),
                  maximumDate: DateTime.now().add(Duration(days: 1)),
                  onDateTimeChanged: (date) {
                    print('$date');
                  },
                ),
              ),
              CupertinoButton(
                color: Colors.orange,
                child: Text('ios DatePicker2'),
                onPressed: () {
                  _showCupertinoDatePicker(context);
                },
              ),

              /// 圆角
              TextButton(
                // color: Colors.pink,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(30),
                //   ),
                // ),
                child: Text('颜色按钮'),
                onPressed: () {},
              ),

              Material(
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.green,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Container(
                  child: TextButton(
                    onPressed: () {},
                    child: Text('22222222222'),
                  ),
                ),

                //                child: IconButton(
                //                    icon: Icon(Icons.play_arrow),
                //                    iconSize: 100,
                //                    onPressed: () {}),
              ),

              CircleAvatar(
                child: Container(
                  child: TextButton(
                    onPressed: () {},
                    child: Text('22222222222'),
                  ),
                ),
              ),

              FloatingActionButton(
                child: Text('22222222222'),
                onPressed: () {},
              ),
              Container(
                height: 80,
                child: ElevatedButton(
                  // color: Colors.orange,
                  child: Text('圆形按钮'),
                  // shape: CircleBorder(
                  //   side: BorderSide(color: Colors.pink),
                  // ),
                  onPressed: () {},
                ),
              ),

              Container(
                //                width: 50,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //                    shape:BoxShape.rectangle,
                  border: Border.all(color: Colors.green, width: 1),
                  //                 borderRadius: BorderRadius.circular(20.0),
                  color: Colors.orange,
                ),
                child: IconButton(
                  icon: Icon(Icons.add),
                  //                  iconSize: 100,
                  //                iconSize: 50,
                  onPressed: () {},
                ),
              ),
              Container(
                width: 100,
                height: 100,
                child: FloatingActionButton(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.play_arrow, size: 60),
                  onPressed: () {},
                ),
              ),

              Material(
                color: Colors.orange,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.green,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.play_arrow),
                  iconSize: 100,
                  onPressed: () {},
                ),
              ),

              DropdownButton(
                hint: Text('下拉选择你想要的数据'),
                items: [
                  DropdownMenuItem(child: Text('1'), value: '1'),
                  DropdownMenuItem(child: Text('2'), value: '2'),
                ],
                onChanged: (T) {
                  //下拉菜单item点击之后的回调
                },
              ),
              SizedBox(height: 20),
              Text('长按预览'),
              Container(
                color: Colors.greenAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CupertinoContextMenu(
                      //                       previewBuilder: (context, animation, child) {
                      //                         return Container(
                      //                           color: Colors.greenAccent,
                      // //                    width: 400,
                      // //                    height: 200,
                      //                           child: Image.asset(
                      //                             assetsOfImagePath('A171.jpg'),
                      //                           ),
                      //                         );
                      //                       },
                      actions: <Widget>[
                        CupertinoContextMenuAction(
                          child: const Text('Action one'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        CupertinoContextMenuAction(
                          child: const Text('Action two'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                      child: Container(
                        alignment: Alignment.centerLeft,
                        //                color: Colors.red,
                        width: 100,
                        height: 200,
                        child: Image.asset(
                          assetsOfImagePath('headIcon.png'),
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                child: const Text('控制AbsorbPointer'),
                onPressed: () {
                  isAbsorbPointer.value = !isAbsorbPointer.value;
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: isAbsorbPointer,
                builder: (BuildContext context, value, Widget? child) {
                  return AbsorbPointer(
                    absorbing: value,
                    child: TextButton(
                      // color: Colors.greenAccent,
                      // disabledColor: Colors.orange,
                      onPressed: value ? null : () {},
                      // color: Colors.greenAccent,
                      // disabledColor: Colors.orange,
                      child: const Text('AbsorbPointer'),
                    ),
                  );
                },
              ),

              TextButton(
                // color: Colors.orange,
                onPressed: () {
                  print('登陆');
                },
                child: Padding(
                  padding: EdgeInsets.all((50)),
                  child: Text('Padding测试Buton的宽度'),
                ),
                //                  ///圆角
                //                 shape: RoundedRectangleBorder(
                //                   side: BorderSide.none,
                // //                      borderRadius: BorderRadius.all(Radius.circular(double.minPositive)),
                //                   borderRadius: BorderRadius.circular(400),
                //                 ),
                //                  shape: CircleBorder(
                //                    side: BorderSide(),
                //                  ),
              ),

              Container(
                //            width: 200,
                //                  width: double.infinity,
                alignment: Alignment.center,
                //            height: 20,
                child: TextButton(
                  child: Text('TextButton 加宽'),
                  onPressed: () {},
                  // splashColor: Colors.red,
                  // color: Colors.green,
                  // textColor: Colors.white,
                ),
              ),

              TextButton(
                child: Text('TextButton'),
                onPressed: () {},
                // splashColor: Colors.red,
                // color: Colors.green,
                // textColor: Colors.white,
              ),

              TextButton.icon(
                icon: Icon(Icons.add),
                label: Text('TextButton.icon'),
                onPressed: () {},

                /// 点击高亮颜色
                // splashColor: Colors.orange,
                // color: Colors.red,
              ),

              TextButton.icon(
                ///
                icon: Image.asset('assets/image/红包.png', width: 40, height: 40),

                //ImageIcon(AssetImage('assets/image/红包.png')),
                //                  icon: ImageIcon(AssetImage('assets/image/红包.png'),color: Colors.red,),
                label: Text('TextButton'),
                onPressed: () {},
                // splashColor: Colors.orange,
                // color: Colors.green,
              ),

              /// 点击有波纹效果 阴影效果
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('ElevatedButton.icon'),
                onPressed: () {},

                /// 点击高亮颜色
                // splashColor: Colors.orange,
                // color: Colors.red,
                // elevation: 20,
              ),

              /// 描边
              OutlinedButton.icon(
                icon: Icon(Icons.add),
                label: Text('OutlineButton.icon'),
                onPressed: () {},

                /// 点击高亮颜色
                //              splashColor: Colors.orange,
                //                 color: Colors.red,
                //                 borderSide: BorderSide(
                //                   color: Colors.red,
                //                 ),
              ),

              /// 描边
              OutlinedButton(
                child: Text('OutlineButton'),
                onPressed: () {},

                /// 点击高亮颜色
                //              splashColor: Colors.orange,
                //                 color: Colors.red,
                //                 borderSide: BorderSide(
                //                   color: Colors.red,
                //                 ),
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: Text('TextButton'),
                      onPressed: () {},
                      // splashColor: Colors.red,
                      // color: Colors.green,
                      // textColor: Colors.white,
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  /// Expanded 可用空间
                  Expanded(
                    child: TextButton(
                      child: Text('TextButton'),
                      onPressed: () {},
                      // splashColor: Colors.red,
                      // color: Colors.green,
                      // textColor: Colors.white,
                    ),
                  ),

                  SizedBox(width: 20),

                  Expanded(
                    flex: 2,
                    child: TextButton(
                      child: Text('TextButton'),
                      onPressed: () {},
                      // splashColor: Colors.red,
                      // color: Colors.green,
                      // textColor: Colors.white,
                    ),
                  ),
                ],
              ),

              Text('ButtonBar 可以默认实现一个按钮组，通过 children 属性可以传入多个 Button'),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Text('TextButton'),
                    onPressed: () {},
                    // splashColor: Colors.red,
                    // color: Colors.green,
                    // textColor: Colors.white,
                  ),
                  TextButton(
                    child: Text('ButtonBar-TextButton'),
                    onPressed: () {},
                    // splashColor: Colors.red,
                    // color: Colors.green,
                    // textColor: Colors.white,
                  ),
                  TextButton(
                    child: Text('TextButton'),
                    onPressed: () {},
                    // splashColor: Colors.red,
                    // color: Colors.green,
                    // textColor: Colors.white,
                  ),
                ],
              ),

              SizedBox.fromSize(size: Size.fromHeight(20)),
              Text('PopupMenuButton'),
              PopupMenuButton(
                icon: Icon(Icons.add),
                onSelected: (value) {
                  print('value = $value');
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(value: 1, child: Text('1')),
                  PopupMenuItem(value: 2, child: Text('2')),
                ],
              ),

              SizedBox.fromSize(size: Size.fromHeight(20)),

              /// 自动换行的row
              Text('自动换行的row--Wrap'),
              Wrap(children: <Widget>[for (String item in tags) TagItem(item)]),
              //              ],
              //            )
            ],
          ),
        ),
      ),
    );
  }

  void _showCupertinoDatePicker(BuildContext cxt) async {
    /// 假如中文环境报错,配置 GlobalCupertinoLocalizations.delegate,
    final picker = CupertinoDatePicker(
      //      initialDateTime: DateTime(1995),
      initialDateTime: DateTime.now(),
      use24hFormat: true,
      mode: CupertinoDatePickerMode.date,
      onDateTimeChanged: (date) {
        print('the date is ${date.toString()}');
      },
    );

    showCupertinoModalPopup(
      context: cxt,
      builder: (cxt) {
        return Container(color: Colors.white, height: 200, child: picker);
      },
    );
  }

  void _showCupertinoTimerPicker(BuildContext cxt) {
    final picker = CupertinoTimerPicker(
      onTimerDurationChanged: (duration) {
        print('the time is $duration');
      },
    );

    showCupertinoModalPopup(
      context: cxt,
      builder: (cxt) {
        return Container(color: Colors.white, height: 200, child: picker);
      },
    );
  }

  _cupertinoDatePicker(cxt) {
    CupertinoPicker picker = CupertinoPicker(
      /// 每行的高度
      itemExtent: 50,
      children: const <Widget>[Text('1'), Text('2'), Text('3')],
      onSelectedItemChanged: (index) {},
    );

    showCupertinoModalPopup(
      context: cxt,
      builder: (cxt) {
        return Container(color: Colors.white, height: 200, child: picker);
      },
    );
  }

  _selectDateFunc() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      //      firstDate: DateTime(1900),
      /// 小于当前时间不选择
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: '选择日期',
      errorFormatText: 'errorFormatText',
      errorInvalidText: 'errorInvalidText',
      fieldHintText: 'fieldHintText',
      fieldLabelText: 'fieldLabelText',

      /// 主题
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child ?? Container());
      },
      //      selectableDayPredicate: (date) {
      //
      //        print('date = $date');
      //        /// 当前日期后,不可选择
      ////        return date.difference(DateTime.now()).inMilliseconds < 0;
      //
      //
      //        /// 当前日期后,不可选择
      ////        return DateTime.now().difference(date).inMilliseconds < 0;
      //
      //        return date.isBefore(DateTime.now());
      //      },
    );
  }

  _selectTimeFunc() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        /// 使用24小时
        //        return MediaQuery(
        //          data: MediaQuery.of(context)
        //              .copyWith(alwaysUse24HourFormat: true),
        //          child: child,
        //        );

        return Theme(
          data: ThemeData.dark(),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container(),
          ),
        );
      },
    );
    if (timeOfDay == null) {
      return;
    }
  }
}

class TagItem extends StatelessWidget {
  final String text;

  TagItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(margin: EdgeInsets.all(8), child: Text(text)),
    );
  }
}

const List<String> tags = [
  '肯德基',
  '小哥哥你的东西掉了',
  '小姐姐好漂亮啊',
  '这个东西是啥',
  '哈哈哈',
  '好困啊',
  '今天好运',
  '明天好运来',
  '今年快结束了',
  '我累啊',
  '你写的什么代码',
  '多多多',
];

///
/// desc:
///

class InteractiveViewerDemo extends StatefulWidget {
  @override
  _InteractiveViewerDemoState createState() => _InteractiveViewerDemoState();
}

class _InteractiveViewerDemoState extends State<InteractiveViewerDemo> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 100),
            child: Center(
              child: InteractiveViewer(
                ///alignPanAxis 参数表示是否只在水平和垂直方向上拖拽，默认为false，设置为true，无法沿着对角线（斜着）方向移动。
                //                alignPanAxis: true,
                //                maxScale: 2,
                //                minScale: 1,
                scaleEnabled: true,

                /// maxScale 、minScale、scaleEnabled 是缩放相关参数，分别表示最大缩放倍数、最小缩放倍数、是否可以缩放
                child: Image.asset('assets/image/A171.jpg'),
                transformationController: _transformationController,
              ),
            ),
          ),
          Expanded(child: Container()),
          Row(
            children: [
              ElevatedButton(
                child: Text('重置'),
                onPressed: () {
                  _transformationController.value = Matrix4.identity();
                },
              ),
              ElevatedButton(
                child: Text('左移'),
                onPressed: () {
                  var matrix = _transformationController.value.clone();
                  matrix.translate(-5.0);
                  _transformationController.value = matrix;
                },
              ),
              ElevatedButton(
                child: Text('放大'),
                onPressed: () {
                  var matrix = _transformationController.value.clone();
                  matrix.scale(1.5, 1.0, 1.0);
                  _transformationController.value = matrix;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
