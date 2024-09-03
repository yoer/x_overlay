*If you find this package helpful, please help by giving it a 👍 on pub.dev! ↗️*

*Your support and encouragement motivate us to continue improving and maintaining this package.*

*Thank you for recognizing our work! 👏👏*

----------------------------------------


## Features

Easy to support overlay

## Usage

- custom overlay data
>
> you can add custom variables with extends
> 
> ```dart
> /// define 
> class MyOverlayData extends XOverlayData {
>   MyOverlayData({
>     required this.myVariable,
>   });
> 
>   final String myVariable;
> }
> 
> /// convert
> final overlayData = XOverlayData();
> late MyOverlayData myOverlayData;
> if (data is MyOverlayData) {
>   myOverlayData = data;
> }
> myOverlayData.myVariable;
> 
> ```

- define a object of XOverlayController
  ```dart
  final overlayController = XOverlayController();
  ```

- use `XOverlayPopScope` as you home parent

  that will replace directly quit app with back to desktop when click back button of mobile, otherwise the page will be destroyed.
  
  ```dart
  MaterialApp(
    ...
    home: XOverlayPopScope(
      child: YourHomePage(),
    ),
  )
  ```

- Nest the `XOverlayPage` within builder of your MaterialApp widget.
  - read your overlay data and return your overlay page in `builder`
  - Make sure to return the correct context in the `contextQuery` with `navigatorKey`
  - By default, clicking overlay page will return to the content page. so, read your overlay data and return your content page in `restoreWidgetQuery`

  ```dart
  MaterialApp(
    ...
    navigatorKey: widget.navigatorKey,
    builder: (BuildContext context, Widget? child) {
      return Stack(
        children: [
          child!,
          /// add overlay page in MaterialApp.builder
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
              return YourContentPage();
            },
            builder: (XOverlayData data) {
              /// read your overlay data and return your overlay page
              return YourOverlayPage();
            },
          ),
        ],
      );
    },
  )
  ```

- Add `XOverlayButton` in your content widget, or custom a button and call controller.overlay()

  ```dart
  XOverlayButton(
    controller: widget.overlayController,
    dataQuery: () {
      /// Data needed to return to the overlay page
      return YourOverlayData();
    },
  )
  ```

## [Examples](https://pub.dev/packages/x_overlay/example)

## Previews

<img src="https://media-resource.spreading.io/docuo/workspace564/27e54a759d23575969552654cb45bf89/80abea3cf5.gif" alt="ezgif-4-69f0f056a6.gif"/>
