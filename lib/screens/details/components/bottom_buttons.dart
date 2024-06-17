import 'dart:io';
import 'package:domian/model/object.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$phoneNumber&text=hello");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  _launchCaller() async {
    final phoneUrl = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    } else {
      print("Could not make a phone call");
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