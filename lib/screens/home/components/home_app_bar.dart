import 'package:flutter/material.dart';
import 'package:domian/constants/constants.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, required this.city, required this.updateCity});

  final String city;
  final Function updateCity;

  @override
  _CustomAppBar createState() => _CustomAppBar();
}

class _CustomAppBar extends State<CustomAppBar> {
  List<String> listCities = <String>['Ростов-на-Дону', 'Батайск'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(
        left: appPadding,
        right: appPadding,
        top: appPadding * 2,
      ),
      child: Container(
        height: size.height * 0.12,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Город',
                    style: TextStyle(
                      color: black.withOpacity(0.4),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: widget.city,
                      onChanged: (String? value) {
                        widget.updateCity(value!);
                      },
                      items: listCities.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return listCities.map<Widget>((String item) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            constraints: const BoxConstraints(minWidth: 100),
                            child: Text(
                              item,
                              style: const TextStyle(
                                  color: black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          );
                        }).toList();
                      },
                    )
                  ),
                  const Divider(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}