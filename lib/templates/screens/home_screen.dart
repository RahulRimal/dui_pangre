import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:two_wheelers/models/post_model.dart';

import '../../../providers/post_provider.dart';
import '../managers/global_variables.dart';
import '../widgets/courser_image.dart';
import 'item_details_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  List? searchResult;
  List priceResult = [];

  String _selectedPriceOrder = 'Low to High';
  final List<String> _priceOrderOptions = ['Low to High', 'High to Low'];
  String _selectedLocationOrder = 'All';
  // final List<String> _locationOrderOptions = [
  //   'Chabel',
  //   'Koteshwor',
  //   'New Road',
  //   'Thapathali'
  // ];
  final List<String> _locationOrderOptions = <String>[];

  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('posts')
        .where('vehicleName', isEqualTo: query)
        .get();

    // setState(() {
    //   searchResult = result.docs;
    // });
    var temp = result.docs;
    List<Post> res = [];
    for (var element in temp) {
      res.add(Post.fromJson(element.data()));
    }

    setState(() {
      searchResult = res;
    });

    // print(searchResult);
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      searchFromFirebase(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final poststream = ref.watch(postStream);
      return SafeArea(
          child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: AppBar(
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: GlobalVariables.appBarGradient,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 42,
                          margin: const EdgeInsets.only(left: 15),
                          child: Material(
                            borderRadius: BorderRadius.circular(7),
                            elevation: 1,
                            child: TextField(
                              // onFieldSubmitted: navigateToSearchScreen,
                              onSubmitted: (query) {
                                // print('hello');
                                searchFromFirebase(query);
                              },
                              decoration: InputDecoration(
                                prefixIcon: InkWell(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                      left: 6,
                                    ),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                      size: 23,
                                    ),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.only(top: 10),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black38,
                                    width: 1,
                                  ),
                                ),
                                hintText: 'Search for Vehicles',
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      const CarouselImage(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              'Place near to you',
                              style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0E0D0D),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(30),
                          //     border: Border.all(color: Colors.grey),
                          //   ),
                          //   padding: const EdgeInsets.symmetric(horizontal: 16),
                          //   child: DropdownButton<String>(
                          //     value: _selectedLocationOrder,
                          //     onChanged: (String? newValue) {
                          //       setState(() {
                          //         _selectedLocationOrder = newValue!;
                          //       });
                          //     },
                          //     items: _locationOrderOptions
                          //         .map<DropdownMenuItem<String>>(
                          //             (String value) {
                          //       return DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(
                          //           value,
                          //           style: const TextStyle(fontSize: 14),
                          //         ),
                          //       );
                          //     }).toList(),
                          //   ),
                          // ),
                          poststream.when(
                            data: (data) {
                              List<String> locationOrderOptions = <String>[];
                              locationOrderOptions.add('All');
                              for (var post in data) {
                                locationOrderOptions.contains(post.location)
                                    ? null
                                    : locationOrderOptions.add(post.location);
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.grey),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: DropdownButton<String>(
                                  value: _selectedLocationOrder,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedLocationOrder = newValue!;
                                    });
                                  },
                                  items: locationOrderOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (e, s) => Text(e.toString()),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              'Price',
                              style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0E0D0D),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.grey),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            // color: Colors.transparent,
                            // height: 42,
                            // margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<String>(
                              value: _selectedPriceOrder,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPriceOrder = newValue!;
                                });
                              },
                              items: _priceOrderOptions
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SafeArea(
                        child: SizedBox(
                            height: 463,
                            child: searchResult != null
                                ? searchResult!.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ItemDetails(
                                                        vItem:
                                                            searchResult!.first,
                                                        postProvider: ref.read(
                                                            postCRUDprovider),
                                                      )));
                                        },
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: searchResult!.length,
                                            itemBuilder: (context, index) {
                                              final result =
                                                  searchResult![index];

                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      searchResult!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return itemdetails(
                                                        searchResult
                                                            as List<Post>,
                                                        index);
                                                  });
                                            }),
                                      )
                                    : const Text('No content found')
                                : poststream.when(
                                    data: (data) {
                                      if (_selectedPriceOrder ==
                                          'Low to High') {
                                        data.sort((a, b) =>
                                            a.rentprice.compareTo(b.rentprice));
                                      } else {
                                        data.sort((a, b) =>
                                            b.rentprice.compareTo(a.rentprice));
                                      }
                                      if (_selectedLocationOrder != 'All') {
                                        data = data
                                            .where((element) =>
                                                element.location ==
                                                _selectedLocationOrder)
                                            .toList();
                                      }

                                      return GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 5,
                                            mainAxisExtent: 300,
                                          ),
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ItemDetails(
                                                              vItem:
                                                                  data[index],
                                                              postProvider:
                                                                  ref.read(
                                                                      postCRUDprovider),
                                                            )));
                                              },
                                              child: itemdetails(data, index),
                                            );
                                          });
                                    },
                                    error: (err, stack) => Text("$err"),
                                    loading: () =>
                                        const CircularProgressIndicator())),
                      ),
                    ]),
                  ))));
    });
  }

  Column itemdetails(List<Post> data, int index) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFC0BBBB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Row(
              //   mainAxisAlignment:
              //       MainAxisAlignment
              //           .spaceBetween,
              //   children: [
              //     Container(
              //       padding:
              //           const EdgeInsets
              //               .all(5),
              //       decoration:
              //           BoxDecoration(
              //         color: const Color(
              //             0xFF325E83),
              //         borderRadius:
              //             BorderRadius
              //                 .circular(
              //                     20),
              //       ),
              //       child: Text(
              //         '4.5',
              //         style: GoogleFonts
              //             .sourceSansPro(
              //           fontWeight:
              //               FontWeight
              //                   .bold,
              //           color: Colors
              //               .white,
              //           fontSize:
              //               13.0,
              //         ),
              //       ),
              //     ),
              //     const Icon(
              //       Icons
              //           .favorite_border,
              //       color: Colors.red,
              //     ),
              //   ],
              // ),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(data[index].licenceimageId),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data[index].vehiclename,
                    style: GoogleFonts.sourceSansPro(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0E0D0D),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    data[index].bikemodel,
                    style: GoogleFonts.sourceSansPro(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0E0D0D),
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rs.${data[index].rentprice.toString()}',
                    style: GoogleFonts.sourceSansPro(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0E0D0D),
                      fontSize: 16.0,
                    ),
                  ),
                  Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA28764),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 11.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
