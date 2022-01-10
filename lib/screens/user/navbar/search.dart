import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isLoading = false;
  TextEditingController _searchController = new TextEditingController();
  Map<String, dynamic> restaurantMap;

  Future<void> onSearch() async {
    setState(() {
      isLoading = true;
    });

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('restaurantTable')
          .where('nameRes', isGreaterThanOrEqualTo: _searchController.text)
          .get()
          .then((value) {
        setState(() {
          restaurantMap = value.docs[0].data();
          isLoading = false;
        });
        print(restaurantMap);
      }).catchError((e) {
        print(e.toString());
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // onSearch();
  }

  // Widget searchList() {
  //   return ListView.builder(
  //     itemCount: restaurantMap.length,
  //     itemBuilder: (context, index) {
  //       return SearchTile(nameRest: '', address: '', urlImageRest: '');
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.red[200],
      //   title: Text('Search'),
      // ),
      body: isLoading
          ? MyStyle().showProgress()
          // ? Column(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Container(
          //           child: TextField(
          //             controller: _searchController,
          //             decoration: InputDecoration(
          //               suffixIcon: Container(
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(360),
          //                   color: Colors.grey[350],
          //                 ),
          //                 margin: EdgeInsets.only(right: 15),
          //                 child: IconButton(
          //                   onPressed: () {
          //                     onSearch();
          //                   },
          //                   icon: Icon(
          //                     Icons.search,
          //                     size: 35,
          //                     color: Colors.red,
          //                   ),
          //                 ),
          //               ),
          //               hintText: 'Search',
          //               hintStyle: TextStyle(),
          //               border: InputBorder.none,
          //               enabledBorder: OutlineInputBorder(
          //                 borderSide: BorderSide(color: Colors.red),
          //                 borderRadius: BorderRadius.circular(20),
          //               ),
          //               focusedBorder: OutlineInputBorder(
          //                 borderSide: BorderSide(color: Colors.red),
          //                 borderRadius: BorderRadius.circular(20),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //           child: Container(child: Center(child: Text('No data'))))
          //     ],
          //   )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(360),
                            color: Colors.grey[350],
                          ),
                          margin: EdgeInsets.only(right: 15),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                onSearch();
                              });
                            },
                            icon: Icon(
                              Icons.search,
                              size: 35,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                restaurantMap != null
                    ? ListTile(
                        leading: Container(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            restaurantMap['urlImageRes'],
                          ),
                        ),
                        title: Text(restaurantMap['nameRes']),
                        subtitle: Text(restaurantMap['address']))
                    : Container(),
              ],
            ),
    );
  }
}

// class SearchTile extends StatelessWidget {
//   final String nameRest;
//   final String address;
//   final String urlImageRest;
//   const SearchTile({
//     Key key,
//     @required this.nameRest,
//     @required this.address,
//     @required this.urlImageRest,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: [
//           Container(
//             width: 150,
//             height: 150,
//             child: Image.network(urlImageRest),
//           ),
//           Text(nameRest),
//           Text(address),
//         ],
//       ),
//     );
//   }
// }
