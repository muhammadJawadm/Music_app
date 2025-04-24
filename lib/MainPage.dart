import 'package:flutter/material.dart';
import 'package:music_app/Favourite.dart';
import 'package:music_app/MusicList.dart';
import 'Account_page.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Musiclist(),
    FavouriteList(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF6A11CB),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(_selectedIndex == 0 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0
                        ? Color(0xFF6A11CB).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(_selectedIndex == 1 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1
                        ? Color(0xFF6A11CB).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.search),
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(_selectedIndex == 2 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2
                        ? Color(0xFF6A11CB).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.favorite),
                ),
                label: 'Favourite',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(_selectedIndex == 3 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 3
                        ? Color(0xFF6A11CB).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.face),
                ),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Home Page"));
  }
}
