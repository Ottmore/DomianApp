import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({Key? key});

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0, 6),
                blurRadius: 15,
              ),
            ],
          ),
          child: BottomAppBar(
            notchMargin: 8.0,
            height: 65,
            color: Colors.transparent,
            child: IconTheme(
              data: IconThemeData(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
                      tooltip: 'Главная',
                      icon: const Icon(Icons.home),
                      color: route?.settings.name == '/' ? Colors.redAccent : Colors.grey,
                      onPressed: () {
                        if (route?.settings.name != '/') {
                          Navigator.pushNamed(context, '/');
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      tooltip: 'Каталог',
                      icon: const Icon(Icons.search),
                      color: route?.settings.name == '/register' ? Colors.redAccent : Colors.grey,
                      onPressed: () {
                        if (route?.settings.name != '/register') {
                           Navigator.pushNamed(context, '/register');
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      tooltip: 'Отзывы',
                      icon: const Icon(Icons.add_chart_sharp),
                      color: route?.settings.name == '/reviews' ? Colors.redAccent : Colors.grey,
                      onPressed: () {
                        if (route?.settings.name != '/reviews') {
                          Navigator.pushNamed(context, '/reviews');
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      tooltip: 'Профиль',
                      icon: const Icon(Icons.settings),
                      color: route?.settings.name == '/user-profile' ? Colors.redAccent : Colors.grey,
                      onPressed: () {
                        if (route?.settings.name != '/user-profile') {
                          Navigator.pushNamed(context, '/user-profile');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}