import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:domian/model/object.dart';
import 'package:flutter/material.dart';
import 'package:domian/constants/constants.dart';

class BottomButtons extends StatefulWidget {
  const BottomButtons({super.key, required this.object});

  final Object object;

  @override
  _BottomButtons createState() => _BottomButtons();
}

class _BottomButtons extends State<BottomButtons> {
  bool _isLoading = true;

  String phoneNumber = '';

  _launchWhatsapp() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'action_view',
        data: 'whatsapp://send?phone=$phoneNumber&text=hello',
        package: 'com.whatsapp',
      );
      await intent.launch().catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("WhatsApp is not installed on the device"),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not supported on this platform"),
        ),
      );
    }
  }

  _launchCaller() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'action_view',
        data: 'whatsapp://call?phone=$phoneNumber',
        package: 'com.whatsapp',
      );
      await intent.launch().catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not make a WhatsApp call. WhatsApp might not be installed."),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp calling is not supported on this platform"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  _loadData() async {
    final userObject = await ObjectModel().getObjectUser(widget.object.id!);

    phoneNumber = userObject['phone_number'];

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (_isLoading) {
      return const CircularProgressIndicator();
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: appPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: _launchWhatsapp,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: size.width * 0.4,
                height: 60,
                decoration: BoxDecoration(
                  color: cdomian,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: cdomian.withOpacity(0.6),
                      offset: const Offset(0, 10),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mail_rounded, color: white),
                    Text(
                      ' Написать',
                      style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: _launchCaller,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: size.width * 0.4,
                height: 60,
                decoration: BoxDecoration(
                  color: cdomian,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: cdomian.withOpacity(0.6),
                      offset: const Offset(0, 10),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call_rounded, color: white),
                    Text(
                      ' Позвонить',
                      style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
