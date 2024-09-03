import 'package:flutter/material.dart';
import 'package:x_overlay/x_overlay.dart';

class MyOverlayData extends XOverlayData {
  MyOverlayData({
    required this.myVariable,
  });

  final String myVariable;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(MyApp(
    navigatorKey: navigatorKey,
  ));
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    required this.navigatorKey,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  /// 1/4. define a object of XOverlayController
  final overlayController = XOverlayController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      title: 'Flutter Demo',
      color: Colors.white,

      /// 2/4. replace directly quit app with back to desktop when click back button of mobile, otherwise the page will be destroyed.
      home: XOverlayPopScope(
        child: HomePage(
          overlayController: overlayController,
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            child!,

            /// 3/4. add overlay page in MaterialApp.builder
            XOverlayPage(
              controller: overlayController,
              contextQuery: () {
                return widget.navigatorKey.currentState!.context;
              },
              restoreWidgetQuery: (
                XOverlayData data,
              ) {
                /// By default, clicking overlay page will return to the content page.
                /// so, read your overlay data, and return your content page
                late MyOverlayData myOverlayData;
                if (data is MyOverlayData) {
                  myOverlayData = data;
                }

                /// then restore target widget
                return ContentPage(
                  overlayController: overlayController,

                  /// when returning from the overlay page, you can synchronize the results changed during the overlaying process.
                  customVariable: myOverlayData.myVariable,
                );
              },
              builder: (XOverlayData data) {
                /// read your overlay data and return your overlay page
                late MyOverlayData myOverlayData;
                if (data is MyOverlayData) {
                  myOverlayData = data;
                }

                return OverlayPage(
                  overlayController: overlayController,

                  /// data read from the content page, and may also change during overlaying
                  customVariable: myOverlayData.myVariable,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.overlayController,
  });

  final XOverlayController overlayController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Prevent the UI from moving up by text editor
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: Colors.white),
            const Align(
              alignment: Alignment.topCenter,
              child: Text("Home Page"),
            ),
            Center(child: contentButton()),
          ],
        ),
      ),
    );
  }

  Widget contentButton() {
    return ValueListenableBuilder<XOverlayPageState>(
      valueListenable: widget.overlayController.pageStateNotifier,
      builder: (context, overlayPageState, _) {
        return ElevatedButton(
          onPressed: () {
            if (XOverlayPageState.overlaying == overlayPageState) {
              /// in overlaying, restore content page directly
              widget.overlayController.restore(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentPage(
                    overlayController: widget.overlayController,
                  ),
                ),
              );
            }
          },
          child: const Text("Content Page"),
        );
      },
    );
  }
}

class ContentPage extends StatefulWidget {
  final XOverlayController overlayController;

  /// when returning from the overlay page, you can set back the results changed during the overlaying process.
  final String? customVariable;

  const ContentPage({
    super.key,
    required this.overlayController,
    this.customVariable,
  });

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textController.text = widget.customVariable ?? 'Custom Variable';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: Colors.blue),
            const Align(
              alignment: Alignment.topCenter,
              child: Text("Content Page"),
            ),
            Positioned(
              top: 10,
              left: 10,
              child:

                  /// 4.1/4. you can use [XOverlayButton] directly
                  XOverlayButton(
                buttonSize: const Size(30, 30),
                controller: widget.overlayController,
                dataQuery: () {
                  /// Data needed to return to the overlay page
                  return MyOverlayData(
                    myVariable: textController.text,
                  );
                },
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  /// 4.2/4. or you can custom a overlay button and call API
                  /// use `overlayController.overlay(context, data: MyOverlayData);`
                  /// to overlay current target widget on button's onClick event
                  onPressed: () {
                    /// Data needed to return to the overlay page
                    final overlayData = MyOverlayData(
                      myVariable: textController.text,
                    );

                    /// cache data, and overlaying target widget
                    widget.overlayController.overlay(
                      context,
                      data: overlayData,
                    );
                  },
                  child: const Text("Overlay Button"),
                ),
              ),
            ),
            Center(child: TextField(controller: textController))
          ],
        ),
      ),
    );
  }
}

class OverlayPage extends StatefulWidget {
  final String customVariable;
  final XOverlayController overlayController;

  const OverlayPage({
    super.key,
    required this.overlayController,

    /// data read from the content page, and may also change during overlaying
    required this.customVariable,
  });

  @override
  State<OverlayPage> createState() => _OverlayPageState();
}

class _OverlayPageState extends State<OverlayPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textController.text = widget.customVariable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Prevent the UI from moving up by text editor
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Text("Overlay Page"),
              ),
              Center(
                child: TextField(
                  controller: textController,
                  textAlign: TextAlign.center,
                  onChanged: (text) {
                    widget.overlayController.updateData(
                      MyOverlayData(myVariable: text),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
