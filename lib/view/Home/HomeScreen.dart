import 'package:alama_eorder_app/utils/constant.dart';
import 'package:alama_eorder_app/utils/pref_manager.dart';
import 'package:flutter/material.dart';

import '../../utils/DialogboxDesign.dart';
import 'TabScreen/ApprovedFranchiseScreen.dart';
import 'TabScreen/StudentList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _currentPage;

  @override
  void initState() {
    _currentPage = 0;
    super.initState();
  }

  _alertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BeautifulAlertDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dash Board"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _alertDialog(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      backgroundColor: Colors.grey.shade300,
      body: getPage(_currentPage),
      bottomNavigationBar: AnimatedBottomNav(
          currentIndex: _currentPage,
          onChange: (index) {
            setState(() {
              _currentPage = index;
            });
          }),
    );
  }

  getPage(int? page) {
    if (Prefs.getBoolen(SHARED_ADMIN) == true) {
      switch (page) {
        case 0:
          return const ApprovedFranchiseScreen();
        case 1:
          return const Center(child: Text("Profile Page"));
        case 2:
          return const Center(child: Text("Menu Page"));
      }
    } else {
      switch (page) {
        case 0:
          return const StudentList();
        case 1:
          return const Center(child: Text("Profile Page"));
        case 2:
          return const Center(child: Text("Menu Page"));
      }
    }
  }
}

class AnimatedBottomNav extends StatelessWidget {
  final int? currentIndex;
  final Function(int)? onChange;
  const AnimatedBottomNav({Key? key, this.currentIndex, this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool admin = Prefs.getBoolen(SHARED_ADMIN);
    return Container(
      height: kToolbarHeight,
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => onChange!(0),
              child: BottomNavItem(
                icon: admin ? Icons.verified_user : Icons.person,
                title: admin ? "Franchise" : "Student",
                isActive: currentIndex == 0,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange!(1),
              child: BottomNavItem(
                icon: admin
                    ? Icons.person
                    : Icons.local_convenience_store_rounded,
                title: admin ? "Students" : 'Order',
                isActive: currentIndex == 1,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange!(2),
              child: BottomNavItem(
                icon: Icons.menu,
                title: admin ? "Stock" : 'Extra Tab',
                isActive: currentIndex == 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final bool isActive;
  final IconData? icon;
  final Color? activeColor;
  final Color? inactiveColor;
  final String? title;
  const BottomNavItem(
      {Key? key,
      this.isActive = false,
      this.icon,
      this.activeColor,
      this.inactiveColor,
      this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 200),
      child: isActive
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: activeColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            )
          : Icon(
              icon,
              color: inactiveColor ?? Colors.grey,
            ),
    );
  }
}
