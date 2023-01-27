// import 'package:flutter/material.dart';

// class DrawerPage extends StatefulWidget {
//   const DrawerPage({super.key});

//   @override
//   State<DrawerPage> createState() => _DrawerPageState();
// }

// class _DrawerPageState extends State<DrawerPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: Drawer(
//             child: SingleChildScrollView(
//                 child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         buildHeader(context),
//         buildMenuItems(context),
//       ],
//     ))));
//   }

//   Widget buildHeader(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top,
//       ),
//     );
//   }

//   Widget buildMenuItems(BuildContext context) {
//     return Wrap(
//       runSpacing: 24,
//       children: [
//         ListTile(
//           leading: const Icon(Icons.home),
//           title: const Text('Home'),
//           onTap: () {},
//         ),
//         ListTile(
//           leading: const Icon(Icons.settings),
//           title: const Text('Settings'),
//           onTap: () {},
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class drawerWidgets extends StatelessWidget {
  Widget listTile({
    required String title,
    required IconData iconData,
  }) {
    return SizedBox(
      height: 50,
      child: ListTile(
        onTap: () {},
        leading: Icon(
          iconData,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: ListView(
              children: [
                DrawerHeader(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        CircleAvatar(
                          radius: 43,
                          backgroundColor: Colors.white54,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            backgroundImage: NetworkImage(
                                'https://th.bing.com/th/id/OIP.W2xIbYmLZhyVqZRp_dATDwAAAA?pid=ImgDet&w=300&h=284&rs=1'),
                            radius: 40,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outlined),
                  title: const Text('Profile'),
                  onTap: () {},
                ),
                const ListTile(
                  leading: Icon(Icons.shop_outlined),
                  title: Text('Cart'),
                ),
                const ListTile(
                  leading: Icon(Icons.home_outlined),
                  title: Text('Home'),
                ),
                const ListTile(
                  leading: Icon(Icons.notifications_outlined),
                  title: Text('Notification'),
                ),
                ListTile(
                  leading: const Icon(Icons.shop_outlined),
                  title: const Text('Review Cart'),
                  onTap: () {},
                ),
                const ListTile(
                  leading: Icon(Icons.format_quote_outlined),
                  title: Text('FAQ'),
                ),
                InkWell(
                  onTap: () {
                    // ref.read(logSignProvider).LogOut();
                  },
                  child: const ListTile(
                    leading: Icon(Icons.exit_to_app_outlined),
                    title: Text("Log Out"),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  height: 350,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Contact Support"),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Text("Call us:"),
                          SizedBox(
                            width: 10,
                          ),
                          Text("984125010"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: const [
                            Text("Mail us:"),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "bookshop@gmail.com",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
