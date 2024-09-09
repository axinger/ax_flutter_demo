import 'package:ax_flutter_util/ax_flutter_util.dart';
import 'package:flutter/material.dart';

class P28RoutePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MaterialPage();
  }
}

class _MaterialPage extends State<P28RoutePage> {
  @override
  void initState() {
    super.initState();
  }

  void deactivate() {
    super.deactivate();
    print('deactivate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('路由'),
      ),
      body: ListView(
        children: <Widget>[
          TextButton(
            child: Text('pushNamed - P28RoutePageSub1'),
            onPressed: () {
              Navigator.of(context).pushNamed('/P28RoutePageSub1', arguments: {'title': '透传title', 'name': 'postbird', 'passw': '123456'});
            },
          ),
          TextButton(
            child: Text('push - P28RoutePageSub1,\n方式该页面的子页面无法Navigator.popUntil'),
            onPressed: () {
              push(context: context, widget: P28RoutePageSub1());
            },
          ),
          TextButton(
            child: Text('push-P28RoutePageSub1'),
            onPressed: () {
              push(context: context, widget: P28RoutePageSub1());
            },
          ),
          TextButton(
            child: Text('FlutterBoost 路由'),
            onPressed: () {
//              FlutterBoost.singleton.open('/P28RoutePageSub1',
//                  urlParams: <String, dynamic>{
//                    'present': true
//                  }).then((Map<dynamic, dynamic> value) {
//                print('FlutterBoost =  $value');
//              });
            },
          ),
          TextButton(
            child: Text('pushReplacement'),
            onPressed: () {
              pushReplacement(context: context, widget: P28RoutePageSub1());
            },
          ),
          TextButton(
            child: Text('pushAndRemoveUntil'),
            onPressed: () {
              pushAndRemoveUntil(context: context, widget: P28RoutePageSub1());

              Future.delayed(Duration(seconds: 2), () {
                pop(context);
              });
            },
          ),
        ],
      ),
    );
  }
}

class P28RoutePageSub1 extends StatelessWidget {
  final Map? sub1Map;

  P28RoutePageSub1({Key? key, this.sub1Map}) : super(key: key) {
    print(this.sub1Map);
  }

  @override
  Widget build(BuildContext context) {
//    String tmp = ModalRoute.of(context).settings.arguments.toString();
//    String tmp2 = this.sub1Map.toString();
//
//    print('tmp== $tmp');
//    print('tmp2== $tmp2');

    var arguments = pushNameOfArguments<Map<String, dynamic>>(context: context);
    print('arguments== $arguments');
    print((arguments as Map)['title']);
    return Scaffold(
      appBar: AppBar(
        title: Text('P28RoutePageSub1'),
      ),
      body: ListView(
        children: <Widget>[
          TextButton(
            child: Text('pushName-sub1,普通'),
            onPressed: () {
              Navigator.of(context).pushNamed('/P28RoutePageSub2', arguments: {'title': '透传title', 'name': 'postbird', 'passw': '123456'});
            },
          ),

          /// 这样的方式 Navigator.popUntil 无法被返回
          TextButton(
            child: Text('push-P28RoutePageSub2'),
            onPressed: () {
              push(context: context, widget: P28RoutePageSub2());
            },
          ),
        ],
      ),
    );
  }
}

class P28RoutePageSub2 extends StatelessWidget {
  final Map? sub2Map;

  P28RoutePageSub2({Key? key, this.sub2Map}) : super(key: key) {
    print(this.sub2Map);
  }

  @override
  Widget build(BuildContext context) {
    /// 上下文获得参数
    String tmp = ModalRoute?.of(context)?.settings.arguments.toString() ?? '';
    String tmp2 = this.sub2Map.toString();

    print('tmp== $tmp');
    print('tmp2== $tmp2');

    return Scaffold(
      appBar: AppBar(
        title: Text('P28RoutePageSub2'),
      ),
      body: ListView(
        children: <Widget>[
          TextButton(
            child: Text('to P28RoutePageSub3'),
            onPressed: () {
              Navigator.of(context).pushNamed('/P28RoutePageSub3');
            },
          ),
        ],
      ),
    );
  }
}

class P28RoutePageSub3 extends StatelessWidget {
  final Map? sub2Map;

  P28RoutePageSub3({
    Key? key,
    this.sub2Map,
  }) : super(key: key) {
    print(this.sub2Map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('P28RoutePageSub3'),
      ),
      body: ListView(
        children: <Widget>[
          TextButton(
            child: Text('返回P28RoutePageSub1'),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/P28RoutePageSub1'));
            },
          ),
          TextButton(
            child: Text('返回/P28RoutePageSub1,这个会卡死,\n因为P28RoutePageSub1 不是通过String路由显示的'),
            onPressed: () {
//              Navigator.popUntil(context, ModalRoute.withName('/P28RoutePageSub1'));
              /// 用这个方法,避免个别路由是拼接参数的
              Navigator.popUntil(context, (route) => route.settings.name!.startsWith('/P28RoutePageSub1'));
            },
          ),
        ],
      ),
    );
  }
}
