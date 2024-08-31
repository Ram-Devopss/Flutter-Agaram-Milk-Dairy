import 'package:agaram_dairy/WalletPage.dart';
import 'package:agaram_dairy/products.dart';
import 'package:agaram_dairy/profile.dart';
import 'package:agaram_dairy/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'SubscriptionCard.dart';
import 'calendar.dart';


class Dashboard extends StatefulWidget {
  final String uid;

  const Dashboard({Key? key, required this.uid}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class  _DashboardState extends State<Dashboard> {

  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  int _backButtonPressCount = 0;// Default index is 2 (ProductsPage)


  @override
  void dispose() {
    _pageController.dispose();
  }




  @override
  Widget build(BuildContext context)  {
    return WillPopScope(
        onWillPop: () async {
      if (_backButtonPressCount < 2) {
        setState(() {
          _backButtonPressCount++;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      } else {
        return true;
      }
    },
    child: Scaffold(
      appBar: MyAppBar(uid: widget.uid),
        body: PageView(
          controller: _pageController,
          children:  <Widget>[
            ProductsPage(uid: widget.uid),
            // SubscriptionGrid(uid: widget.uid),
            CalendarPage(uid: widget.uid),
            WalletPage(uid: widget.uid),
            FirebaseListPage(uid: widget.uid),
          ],
        ),
        extendBody: true,


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Dashboard(uid: widget.uid)),
                (Route<dynamic> route) => false, // Prevents going back to the intro page
          );
        },
        child: Icon(Icons.storefront_outlined),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: CircleBorder(),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 20.0,
        notchMargin: 10.0,
        shape: CircularNotchedRectangle(),
        color: Colors.lightGreen,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 0,left: 0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) =>   SubscriptionGrid(uid: widget.uid),),
                  //        // Prevents going back to the intro page
                  // );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.subscriptions,
                      color: Colors.white,
                      size:25,
                    ),
                    Text(
                      "Subcription",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 70),
              child: GestureDetector(
                onTap: () {

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>   CalendarPage(uid: widget.uid),),
                    // Prevents going back to the intro page
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                      size:25,
                    ),
                    Text(
                      "Calendar",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0,right: 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>   WalletPage(uid: widget.uid),),
                    // Prevents going back to the intro page
                  );
                  //
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wallet,
                      color: Colors.white,
                    ),
                    Text(
                      "Wallet",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FirebaseListPage(uid: widget.uid),),
                    // Prevents going back to the intro page
                  );

                  //
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_sharp,
                      color: Colors.white,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
        // bottomNavigationBar: RollingBottomBar(
        //   color: Colors.white60,
        //   controller: _pageController,
        //   flat: true,
        //   useActiveColorByDefault: false,
        //
        //   items: const [
        //     RollingBottomBarItem(Icons.production_quantity_limits_sharp,
        //         label: 'Products', activeColor: Colors.lightGreen),
        //     RollingBottomBarItem(Icons.calendar_month_sharp,
        //         label: 'Calendar', activeColor: Colors.lightGreen),
        //     RollingBottomBarItem(Icons.subscriptions,
        //         label: 'Recharge', activeColor: Colors.lightGreen),
        //     RollingBottomBarItem(Icons.wallet,
        //         label: 'Wallet', activeColor: Colors.lightGreen),
        //     RollingBottomBarItem(Icons.person,
        //         label: 'Person', activeColor: Colors.lightGreen),
        //   ],
        //   enableIconRotation: true,
        //   onTap: (index) {
        //     setState(() {
        //       _currentIndex = index;
        //     });
        //     _pageController.animateToPage(
        //       index,
        //       duration: const Duration(milliseconds: 400),
        //       curve: Curves.easeOut,
        //     );
        //   },
        // ),
      )
    );
  }
}


class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String uid;

  const MyAppBar({required this.uid, Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(
            backgroundColor: Colors.lightGreen,
            automaticallyImplyLeading: false,
            title: const Text('Loading...'),
          );
        } else if (snapshot.hasError) {
          return AppBar(
            backgroundColor: Colors.lightGreen,
            automaticallyImplyLeading: false,
            title: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return AppBar(
            backgroundColor: Colors.lightGreen,
            automaticallyImplyLeading: false,
            title: const Text('No data available'),
          );
        } else {
          DocumentSnapshot document = snapshot.data!;
          String username = document['username'];
          String address = document['address'];

          return AppBar(
            backgroundColor: Colors.lightGreen,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/icons/person_icon.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16.0,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          address,
                          style: const TextStyle(
                            fontSize: 8.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Container(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: <Widget>[
                        //       Row(
                        //         children: [
                        //           Icon(
                        //             Icons.account_balance_wallet,
                        //             color: Colors.white,
                        //           ),
                        //           Text(
                        //             'Wallet',
                        //             style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontWeight: FontWeight.normal),
                        //           ),
                        //         ],
                        //       ),
                        //
                        //       Text(
                        //         'Rs.50',
                        //         style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 1),
                        //       ),
                        //       SizedBox(height: 0),
                        //       Text(
                        //         'Available Balance',
                        //         style: TextStyle(
                        //             color: Colors.white, fontWeight: FontWeight.normal),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

          );
        }
      },
    );
  }
}


