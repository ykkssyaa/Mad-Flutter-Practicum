import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/app.dart';

import 'gen/l10n/app_localizations.dart';
import 'utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const CurrencyListPage(),
    const NewsListPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget currentPage = _pages[_selectedIndex];
    final AppLocalizations? loc = AppLocalizations.of(context);

    if (loc == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: context.colors.bottomNavBarShadow,
              blurRadius: 25,
              offset: const Offset(0.0, 0.75),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: TabWidget(
                assetPath: 'assets/icons/home.png',
                isSelected: _selectedIndex == 0,
              ),
              label: loc.currencyRate,
            ),
            BottomNavigationBarItem(
              icon: TabWidget(
                assetPath: 'assets/icons/news.png',
                isSelected: _selectedIndex == 1,
              ),
              label: loc.news,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: loc.profile,
            ),
          ],
        ),
      ),
    );
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({
    Key? key,
    required this.assetPath,
    required this.isSelected,
  }) : super(key: key);

  final String assetPath;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeColors colors = context.colors;

    return SizedBox.square(
      dimension: 24,
      child: Image.asset(
        assetPath,
        color: isSelected ? colors.bottomNavBarSelectedItem : colors.bottomNavBarUnselectedItem,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.circle,
          size: 18,
          color: isSelected ? colors.bottomNavBarSelectedItem : colors.bottomNavBarUnselectedItem,
        ),
      ),
    );
  }
}
