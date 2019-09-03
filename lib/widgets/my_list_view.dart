import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';


/// 自定义ListView，集成空View、下拉刷新和上拉加载更多
class MyListView<T> extends StatefulWidget {

  List<T> data;

  IndexedWidgetBuilder itemBuilder;

  Widget emptyWidget;

  OnRefresh onRefresh;

  LoadMore loadMore;

  ScrollController controller;

  MyListView({
    @required this.data,
    @required _TypedItemBuilder<T> itemBuilder,
    this.controller,
    this.emptyWidget,
    this.onRefresh,
    this.loadMore
  }) {
    this.itemBuilder = itemBuilder == null ? null :
      (context, index) => itemBuilder(context, index, data[index]);
  }

  @override
  _MyListViewState createState() => _MyListViewState<T>();
}

class _MyListViewState<T> extends State<MyListView> {

  List<T> get data => widget?.data;

  IndexedWidgetBuilder get itemBuilder => widget?.itemBuilder;

  Widget get emptyWidget => widget?.emptyWidget ?? defaultEmptyWidget;

  OnRefresh get onRefresh => widget?.onRefresh;

  LoadMore get loadMore => widget?.loadMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: EasyRefresh(
        firstRefresh: true,
        onRefresh: onRefresh,
        loadMore: loadMore,
        emptyWidget: emptyWidget,
        child: ListView.builder(
          itemCount: data?.length ?? 0,
          itemBuilder: itemBuilder,
          controller: widget.controller
        )
      )
    );
  }
}

typedef _TypedItemBuilder<T> = Widget Function(BuildContext context, int index, T item);

/// 默认替换为空的构建方法
final Widget defaultEmptyWidget = Container(
  alignment: Alignment.center,
  margin: EdgeInsets.only(top: 10),
  child: Text(
    "没有加载到任何数据",
    style: TextStyle(
      fontSize: 20,
      color: Colors.grey
    )
  )
);