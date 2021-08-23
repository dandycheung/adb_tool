import 'dart:io';
import 'package:adb_tool/themes/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/config.dart';
import '../help_page.dart';

class DesktopPhoneDrawer extends StatefulWidget {
  const DesktopPhoneDrawer({
    Key key,
    this.onChanged,
    this.groupValue,
    this.width,
  }) : super(key: key);
  final void Function(int index) onChanged;
  final int groupValue;
  final double width;

  @override
  _DesktopPhoneDrawerState createState() => _DesktopPhoneDrawerState();
}

class _DesktopPhoneDrawerState extends State<DesktopPhoneDrawer> {
  @override
  Widget build(BuildContext context) {
    final double width = widget.width;
    return OrientationBuilder(
      builder: (context, orientation) {
        return Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimens.gap_dp20),
              bottomRight: Radius.circular(Dimens.gap_dp20),
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              width: width,
              height: MediaQuery.of(context).size.height,
              child: Builder(
                builder: (_) {
                  if (orientation == Orientation.portrait) {
                    return buildBody(context);
                  }
                  return SingleChildScrollView(
                    child: SizedBox(
                      child: buildBody(context),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Column buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.gap_dp12,
                  vertical: Dimens.gap_dp8,
                ),
                child: const Text(
                  'ADB TOOL',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
            _DrawerItem(
              title: '概览',
              value: 0,
              groupValue: widget.groupValue,
              onTap: (index) {
                widget.onChanged?.call(index);
              },
              iconData: Icons.home,
            ),
            // _DrawerItem(
            //   title: '连接设备',
            //   value: 1,
            //   groupValue: widget.groupValue,
            //   onTap: (index) {
            //     widget.onChanged?.call(index);
            //   },
            //   iconData: Icons.data_saver_off,
            // ),
            // _DrawerItem(
            //   title: '当前设备ip',
            //   onTap: () {},
            // ),
            if (GetPlatform.isAndroid)
              Column(
                children: [
                  _DrawerItem(
                    value: 4,
                    groupValue: widget.groupValue,
                    iconData: Icons.signal_wifi_4_bar,
                    title: '远程调试',
                    onTap: (index) {
                      widget.onChanged?.call(index);
                    },
                  ),
                  _DrawerItem(
                    value: 3,
                    groupValue: widget.groupValue,
                    title: '查看局域网ip',
                    onTap: (index) {
                      widget.onChanged?.call(index);
                    },
                    iconData: Icons.wifi_tethering,
                  ),
                ],
              ),
            if (GetPlatform.isAndroid)
              _DrawerItem(
                value: 2,
                groupValue: widget.groupValue,
                title: '安装到系统',
                iconData: Icons.file_download,
                onTap: (index) {
                  widget.onChanged?.call(index);
                },
              ),
            _DrawerItem(
              value: 5,
              groupValue: widget.groupValue,
              title: '执行自定义命令',
              iconData: Icons.code,
              onTap: (index) {
                widget.onChanged?.call(index);
              },
            ),

            _DrawerItem(
              value: 6,
              groupValue: widget.groupValue,
              title: '历史连接',
              iconData: Icons.history,
              onTap: (index) async {
                widget.onChanged?.call(index);
              },
            ),
            _DrawerItem(
              value: 7,
              groupValue: widget.groupValue,
              title: '日志',
              iconData: Icons.pending_outlined,
              onTap: (index) async {
                widget.onChanged?.call(index);
              },
            ),
            _DrawerItem(
              value: 8,
              groupValue: widget.groupValue,
              title: '关于软件',
              iconData: Icons.info_outline,
              onTap: (index) async {
                widget.onChanged?.call(index);
              },
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DrawerItem(
              groupValue: widget.groupValue,
              title: '其他平台下载',
              onTap: (index) async {
                const String url =
                    'http://39.96.60.133/YanTool/resources/AdbTool/';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false,
                    forceWebView: false,
                    // headers: <String, String>{'my_header_key': 'my_header_value'},
                  );
                } else {
                  throw 'Could not launch $url';
                }
                // http://nightmare.fun/adbtool
                // widget.onChange?.call(index);
              },
            
            ),
          ],
        ),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    Key key,
    this.title,
    this.onTap,
    this.value,
    this.groupValue,
    this.iconData,
  }) : super(key: key);
  final String title;
  final void Function(int index) onTap;
  final int value;
  final int groupValue;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final bool isChecked = value == groupValue;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: InkWell(
        onTap: () => onTap(value),
        onTapDown: (_) {
          Feedback.forLongPress(context);
        },
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(8.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 50.w,
              decoration: isChecked
                  ? BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.w),
                    )
                  : null,
            ),
            SizedBox(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        iconData ?? Icons.open_in_new,
                        size: 18.w,
                        color:
                            isChecked ? AppColors.accent : AppColors.fontTitle,
                      ),
                      SizedBox(
                        width: Dimens.gap_dp8,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          color: isChecked
                              ? AppColors.accent
                              : AppColors.fontTitle,
                          fontSize: 14.w,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
