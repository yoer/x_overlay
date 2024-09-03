// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:x_overlay/src/controller.dart';
import 'package:x_overlay/src/defines.dart';

/// The page can be overlaying within the app
///
/// To support the overlay functionality in the app:
///
/// - 1/5:
///
/// custom your XOverlayData
/// ``` dart
/// class MyOverlayData extends XOverlayData {
///   MyOverlayData({
///     required this.myVariable,
///   });
///
///   final String myVariable;
/// }
/// ```
///
/// define a object of XOverlayController
/// final overlayController = XOverlayController();
///
/// - 2/5: use `XOverlayPopScope` as you home parent
///
/// that will replace directly quit app with back to desktop when click back button of mobile, otherwise the page will be destroyed.
///
/// - 3/5: Nest the `XOverlayPage` within builder of your MaterialApp widget.
///   - read your overlay data and return your overlay page in `builder`
///   - Make sure to return the correct context in the `contextQuery` with `navigatorKey`
///   - By default, clicking overlay page will return to the content page. so, read your overlay data and return your content page in `restoreWidgetQuery`
///
/// - 4/5: Add a overlay button in your content widget, or custom button and call controller.overlay()
///
///    - 4.1/5:
///
///    ``` dart
///     XOverlayButton(
///      controller: overlayController,
///      dataQuery: () {
///         return MyOverlayData(
///           myVariable: '',
///         );
///       },
///     );
///    ```
///    - 4.2/5:
///
///    Alternatively, if you have defined your own button, you can call:
///    ```dart
///    overlayController.overlay(
///      context,
///      data:MyOverlayData(
///         myVariable: '',
///      ),
///    );
/// ```
///
/// -------------------------------------------------------------------------
///
/// Example:
/// ```dart
///import 'package:flutter/material.dart';
///import 'package:x_overlay/x_overlay.dart';
///
///class MyOverlayData extends XOverlayData {
///  MyOverlayData({
///    required this.myVariable,
///  });
///
///  final String myVariable;
///}
///
///void main() {
///  WidgetsFlutterBinding.ensureInitialized();
///
///  final navigatorKey = GlobalKey<NavigatorState>();
///
///  runApp(MyApp(
///    navigatorKey: navigatorKey,
///  ));
///}
///
///class MyApp extends StatefulWidget {
///  final GlobalKey<NavigatorState> navigatorKey;
///
///  const MyApp({
///    required this.navigatorKey,
///    super.key,
///  });
///
///  @override
///  State<StatefulWidget> createState() => MyAppState();
///}
///
///class MyAppState extends State<MyApp> {
///  /// 1/4. define a object of XOverlayController
///  final overlayController = XOverlayController();
///
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp(
///      navigatorKey: widget.navigatorKey,
///      title: 'Flutter Demo',
///      color: Colors.white,
///
///      /// 2/4. replace directly quit app with back to desktop when click back button of mobile, otherwise the page will be destroyed.
///      home: XOverlayPopScope(
///        child: HomePage(
///          overlayController: overlayController,
///        ),
///      ),
///      builder: (BuildContext context, Widget? child) {
///        return Stack(
///          children: [
///            child!,
///
///            /// 3/4. add overlay page in MaterialApp.builder
///            XOverlayPage(
///              controller: overlayController,
///              contextQuery: () {
///                return widget.navigatorKey.currentState!.context;
///              },
///              restoreWidgetQuery: (
///                XOverlayData data,
///              ) {
///                /// By default, clicking overlay page will return to the content page.
///                /// so, read your overlay data, and return your content page
///                late MyOverlayData myOverlayData;
///                if (data is MyOverlayData) {
///                  myOverlayData = data;
///                }
///
///                /// then restore target widget
///                return ContentPage(
///                  overlayController: overlayController,
///
///                  /// when returning from the overlay page, you can synchronize the results changed during the overlaying process.
///                  customVariable: myOverlayData.myVariable,
///                );
///              },
///              builder: (XOverlayData data) {
///                /// read your overlay data and return your overlay page
///                late MyOverlayData myOverlayData;
///                if (data is MyOverlayData) {
///                  myOverlayData = data;
///                }
///
///                return OverlayPage(
///                  overlayController: overlayController,
///
///                  /// data read from the content page, and may also change during overlaying
///                  customVariable: myOverlayData.myVariable,
///                );
///              },
///            ),
///          ],
///        );
///      },
///    );
///  }
///}
///
///class HomePage extends StatefulWidget {
///  const HomePage({
///    super.key,
///    required this.overlayController,
///  });
///
///  final XOverlayController overlayController;
///
///  @override
///  State<HomePage> createState() => _HomePageState();
///}
///
///class _HomePageState extends State<HomePage> {
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      /// Prevent the UI from moving up by text editor
///      resizeToAvoidBottomInset: false,
///      body: SafeArea(
///        child: Stack(
///          children: [
///            Container(color: Colors.white),
///            const Align(
///              alignment: Alignment.topCenter,
///              child: Text("Home Page"),
///            ),
///            Center(child: contentButton()),
///          ],
///        ),
///      ),
///    );
///  }
///
///  Widget contentButton() {
///    return ValueListenableBuilder<XOverlayPageState>(
///      valueListenable: widget.overlayController.pageStateNotifier,
///      builder: (context, overlayPageState, _) {
///        return ElevatedButton(
///          onPressed: () {
///            if (XOverlayPageState.overlaying == overlayPageState) {
///              /// in overlaying, restore content page directly
///              widget.overlayController.restore(context);
///            } else {
///              Navigator.push(
///                context,
///                MaterialPageRoute(
///                  builder: (context) => ContentPage(
///                    overlayController: widget.overlayController,
///                  ),
///                ),
///              );
///            }
///          },
///          child: const Text("Content Page"),
///        );
///      },
///    );
///  }
///}
///
///class ContentPage extends StatefulWidget {
///  final XOverlayController overlayController;
///
///  /// when returning from the overlay page, you can set back the results changed during the overlaying process.
///  final String? customVariable;
///
///  const ContentPage({
///    super.key,
///    required this.overlayController,
///    this.customVariable,
///  });
///
///  @override
///  State<ContentPage> createState() => _ContentPageState();
///}
///
///class _ContentPageState extends State<ContentPage> {
///  final textController = TextEditingController();
///
///  @override
///  void initState() {
///    super.initState();
///
///    textController.text = widget.customVariable ?? 'Custom Variable';
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      body: SafeArea(
///        child: Stack(
///          children: [
///            Container(color: Colors.blue),
///            const Align(
///              alignment: Alignment.topCenter,
///              child: Text("Content Page"),
///            ),
///            Positioned(
///              top: 10,
///              left: 10,
///              child:
///
///                  /// 4.1/4. you can use [XOverlayButton] directly
///                  XOverlayButton(
///                buttonSize: const Size(30, 30),
///                controller: widget.overlayController,
///                dataQuery: () {
///                  /// Data needed to return to the overlay page
///                  return MyOverlayData(
///                    myVariable: textController.text,
///                  );
///                },
///              ),
///            ),
///            Positioned(
///              top: 10,
///              right: 10,
///              child: SizedBox(
///                height: 50,
///                child: ElevatedButton(
///                  /// 4.2/4. or you can custom a overlay button and call API
///                  /// use `overlayController.overlay(context, data: MyOverlayData);`
///                  /// to overlay current target widget on button's onClick event
///                  onPressed: () {
///                    /// Data needed to return to the overlay page
///                    final overlayData = MyOverlayData(
///                      myVariable: textController.text,
///                    );
///
///                    /// cache data, and overlaying target widget
///                    widget.overlayController.overlay(
///                      context,
///                      data: overlayData,
///                    );
///                  },
///                  child: const Text("Overlay Button"),
///                ),
///              ),
///            ),
///            Center(child: TextField(controller: textController))
///          ],
///        ),
///      ),
///    );
///  }
///}
///
///class OverlayPage extends StatefulWidget {
///  final String customVariable;
///  final XOverlayController overlayController;
///
///  const OverlayPage({
///    super.key,
///    required this.overlayController,
///
///    /// data read from the content page, and may also change during overlaying
///    required this.customVariable,
///  });
///
///  @override
///  State<OverlayPage> createState() => _OverlayPageState();
///}
///
///class _OverlayPageState extends State<OverlayPage> {
///  final textController = TextEditingController();
///
///  @override
///  void initState() {
///    super.initState();
///
///    textController.text = widget.customVariable;
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      /// Prevent the UI from moving up by text editor
///      resizeToAvoidBottomInset: false,
///      body: SafeArea(
///        child: Container(
///          decoration: BoxDecoration(
///            color: Colors.blue,
///            borderRadius: BorderRadius.circular(10),
///          ),
///          child: Stack(
///            children: [
///              const Align(
///                alignment: Alignment.topCenter,
///                child: Text("Overlay Page"),
///              ),
///              Center(
///                child: TextField(
///                  controller: textController,
///                  textAlign: TextAlign.center,
///                  onChanged: (text) {
///                    widget.overlayController.updateData(
///                      MyOverlayData(myVariable: text),
///                    );
///                  },
///                ),
///              ),
///            ],
///          ),
///        ),
///      ),
///    );
///  }
///}
/// ```
///
class XOverlayPage extends StatefulWidget {
  const XOverlayPage({
    super.key,
    required this.controller,
    required this.restoreWidgetQuery,
    required this.contextQuery,
    required this.builder,
    this.onVisibilityChanged,
    this.rootNavigator = true,
    this.navigatorWithSafeArea = true,
    this.size,
    this.topLeft = const Offset(100, 100),
    this.padding = 0.0,
    this.supportClickZoom = true,
  });

  final XOverlayController controller;

  /// You need to return the `context` of NavigatorState in this callback
  final BuildContext Function() contextQuery;

  /// By default, clicking overlay page will return to the content page.
  /// so, read your overlay data, and **return your content page**
  final Widget Function(
    XOverlayData data,
  ) restoreWidgetQuery;

  /// the visibility changed event of overlay page
  final void Function(bool visibility)? onVisibilityChanged;

  /// read your overlay data and **return your overlay page**
  final Widget Function(XOverlayData data) builder;

  /// set false if you don't want it
  final bool supportClickZoom;

  final Size? size;
  final double padding;
  final Offset topLeft;

  final bool rootNavigator;
  final bool navigatorWithSafeArea;

  @override
  State<XOverlayPage> createState() => _XOverlayPageState();
}

/// @nodoc
class _XOverlayPageState extends State<XOverlayPage>
    with SingleTickerProviderStateMixin {
  XOverlayPageState currentState = XOverlayPageState.idle;

  bool visibility = false;
  late Offset topLeft;
  final preferItemSizeNotifier = ValueNotifier<Size>(Size.zero);
  bool isZoom = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 1, end: 1.5).animate(_animationController);
    _animation.addListener(() {
      isZoom = _animation.value > 1.01;
      final preferSize = calculateItemSize();
      preferItemSizeNotifier.value = preferSize * _animation.value;
    });

    topLeft = widget.topLeft;

    widget.controller.private.updateRestoreWidgetQuery(
      restoreWidgetQuery: widget.restoreWidgetQuery,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.pageMachine.listenStateChanged(
        onOverlayPageStateChanged,
      );

      if (null != widget.controller.pageMachine.machine.current) {
        syncState();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();

    widget.controller.pageMachine
        .removeListenStateChanged(onOverlayPageStateChanged);
  }

  @override
  Widget build(BuildContext context) {
    final preferSize = calculateItemSize();
    preferItemSizeNotifier.value =
        isZoom ? preferSize * _animation.value : preferSize;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Visibility(
        visible: visibility,
        child: Positioned(
          left: topLeft.dx,
          top: topLeft.dy,
          child: ValueListenableBuilder<Size>(
            valueListenable: preferItemSizeNotifier,
            builder: (context, itemSize, _) {
              return GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    final contextSize = MediaQuery.of(context).size;

                    var x = topLeft.dx + details.delta.dx;
                    var y = topLeft.dy + details.delta.dy;
                    x = x.clamp(0.0, contextSize.width - itemSize.width);
                    y = y.clamp(0.0, contextSize.height - itemSize.height);
                    topLeft = Offset(x, y);
                  });
                },
                onDoubleTap: () {
                  if (!widget.supportClickZoom) {
                    return;
                  }

                  if (_animationController.status ==
                      AnimationStatus.completed) {
                    _animationController.reverse();
                  } else {
                    _animationController.forward();
                  }
                },
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width: itemSize.width,
                    height: itemSize.height,
                    child: overlayItem(),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  Size calculateItemSize() {
    if (null != widget.size) {
      return widget.size!;
    }

    if (!visibility) {
      return Size.zero;
    }

    final defaultSize = MediaQuery.of(context).size.width / 3.0;
    return Size(defaultSize, defaultSize);
  }

  Widget overlayItem() {
    switch (currentState) {
      case XOverlayPageState.idle:
      case XOverlayPageState.restored:
        return Container();
      case XOverlayPageState.overlaying:
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => GestureDetector(
                onTap: () {
                  widget.controller.restore(
                    widget.contextQuery(),
                    rootNavigator: widget.rootNavigator,
                    withSafeArea: widget.navigatorWithSafeArea,
                  );
                },
                child: widget.builder.call(
                  widget.controller.data!,
                ),
              ),
            ),
          ],
        );
    }
  }

  void syncState() {
    setState(() {
      currentState = widget.controller.pageMachine.state();
      visibility = currentState == XOverlayPageState.overlaying;

      widget.onVisibilityChanged?.call(visibility);
    });
  }

  void onOverlayPageStateChanged(XOverlayPageState state) {
    /// Overlay and setState may be in different contexts, causing the framework to be unable to update.
    ///
    /// The purpose of Future.delayed(Duration.zero, callback) is to execute the callback function in the next frame,
    /// which is equivalent to putting the callback function at the end of the queue,
    /// thus avoiding conflicts with the current frame and preventing the above-mentioned error from occurring.
    Future.delayed(Duration.zero, () {
      syncState();
    });
  }
}
