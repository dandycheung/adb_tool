import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:screenshot/screenshot.dart';
import 'package:settings/settings.dart';
import 'package:app_manager/app_manager.dart' as am;
import 'app/controller/controller.dart';
import 'app/routes/app_pages.dart';
import 'config/config.dart';
import 'config/settings.dart';
import 'generated/l10n.dart';
import 'global/instance/global.dart';

Future<void> initSetting() async {
  await initSettingStore(RuntimeEnvir.configPath);
  if (Settings.serverPath.setting.get() == null) {
    Settings.serverPath.setting.set(Config.adbLocalPath);
  }
}

class MaterialAppWrapper extends StatefulWidget {
  const MaterialAppWrapper({
    Key? key,
    this.isNativeShell = false,
  }) : super(key: key);
  final bool isNativeShell;

  @override
  State createState() => _MaterialAppWrapperState();
}

class _MaterialAppWrapperState extends State<MaterialAppWrapper> with WidgetsBindingObserver {
  ConfigController config = Get.put(ConfigController());
  bool isFull = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {});
  }

  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return ToastApp(
      child: app(),
    );
  }

  BackdropFilter app() {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 24.0,
        sigmaY: 24.0,
      ),
      child: GetBuilder<ConfigController>(
        builder: (config) {
          return Screenshot(
            controller: screenshotController,
            child: KeyboardListener(
              autofocus: true,
              focusNode: FocusNode(),
              onKeyEvent: ((value) {
                // Log.w(value);
                // if (value is RawKeyDownEvent) {
                //   screenshotController.captureAndSave('./screenshot');
                // }
              }),
              child: GetMaterialApp(
                showPerformanceOverlay: config.showPerformanceOverlay,
                showSemanticsDebugger: config.showSemanticsDebugger,
                debugShowMaterialGrid: config.debugShowMaterialGrid,
                checkerboardRasterCacheImages: config.checkerboardRasterCacheImages,
                debugShowCheckedModeBanner: false,
                title: 'ADB工具箱',
                navigatorKey: Global.instance!.navigatorKey,
                themeMode: ThemeMode.light,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                // ignore: deprecated_member_use
                locale: window.locale,
                supportedLocales: S.delegate.supportedLocales,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                defaultTransition: Transition.fadeIn,
                initialRoute: AdbPages.initial,
                getPages: AdbPages.routes + am.AppPages.routes,
                useInheritedMediaQuery: true,
                builder: (BuildContext context, Widget? navigator) {
                  return ResponsiveBreakpoints.builder(
                    child: Builder(
                      builder: (context) {
                        if (ResponsiveBreakpoints.of(context).isDesktop || ResponsiveBreakpoints.of(context).isTablet) {
                          ScreenAdapter.init(896);
                        } else {
                          ScreenAdapter.init(414);
                        }
                        return Theme(
                          data: config.theme!,
                          child: navigator ?? const SizedBox(),
                        );
                      },
                    ),
                    // landscapePlatforms: [
                    //   ResponsiveTargetPlatform.macOS,
                    // ],
                    breakpoints: const [
                      Breakpoint(start: 0, end: 500, name: MOBILE),
                      Breakpoint(start: 500, end: 800, name: TABLET),
                      Breakpoint(start: 800, end: 2000, name: DESKTOP),
                    ],
                    breakpointsLandscape: [
                      const Breakpoint(start: 0, end: 450, name: MOBILE),
                      const Breakpoint(start: 451, end: 800, name: TABLET),
                      const Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
