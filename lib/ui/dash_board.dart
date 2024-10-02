import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../res/color.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  final controller = PersistentTabController(initialIndex: 0);

  List<Widget>_buildScreen(){
    return [
      Text("Home"),
      Text("Chat"),
      Text("Add"),
      Text("Message"),
      Text("Profile"),
    ];
  }

List<PersistentBottomNavBarItem>_navBarItem(){
    return[
      PersistentBottomNavBarItem(icon: Icon(Icons.home)),
      PersistentBottomNavBarItem(icon: Icon(Icons.chat)),
      PersistentBottomNavBarItem(icon: Icon(Icons.add)),
      PersistentBottomNavBarItem(icon: Icon(Icons.message)),
      PersistentBottomNavBarItem(icon: Icon(Icons.person)),
    ];
}
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        context,
        screens: _buildScreen(),
      items: _navBarItem(),
      backgroundColor: AppColors.secondaryTextColor,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(1)
      ),
    );
  }
}
