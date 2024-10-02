import 'package:chat_01/method/Menthods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import '../method/currentuser.dart';
import 'chatroom.dart';
import 'login.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with WidgetsBindingObserver {
  //khai báo nội dung cần
  Map<String, dynamic>? curUserMap;
  late List<MapEntry<String, dynamic>?> allUserEntries;
  late List<MapEntry<String, dynamic>?> userMap;
  late List<MapEntry<String, dynamic>?> userFMap;
  late List<MapEntry<String, dynamic>?> userSMap;


  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String curUser;
  late List<String> emails=[];

//hàm lấy infor curuser từ onopen chạy khi khởi đong widget
  @override
  void initState() {
    super.initState();
    onOpen().then((map) {
      setState(() {
        curUserMap = map;
      });
    });
    WidgetsBinding.instance.addObserver(this);
    _firestore.collection('users').doc(_auth.currentUser?.uid).update({
      "status": "Online",
    });
    findFriends();
    all();
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser?.uid).update({
      "status": status,
    });
  }

//hàm này tự chạy riêng
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }

//đặt hàm
  String chatRoomId(String user1, String user2) {
    List<String> users = [user1, user2];
    users.sort(); // Sắp xếp danh sách users
    String combined = users.join("-");
    var bytes = utf8.encode(combined);
    var digest = sha1.convert(bytes);
    return digest.toString();
  }

  // String chatRoomId(String user1, String user2) {
  //   if (user1[0].toLowerCase().codeUnits[0] >
  //       user2.toLowerCase().codeUnits[0]) {
  //     return "$user1$user2";
  //   } else {
  //     return "$user1$user2";
  //   }
  // }
  void onPressSearch() async{

    List<MapEntry<String, dynamic>?> filteredList = [];
    if (_search.text.isNotEmpty) {
      print('in if onpresssearch');
      for (var userEntry in allUserEntries) {
        final userData = userEntry?.value;
        if (userData != null &&
            (userData['name']
                    .toString()
                    .toLowerCase()
                    .contains(_search.text.toLowerCase()) ||
                userData['email']
                    .toString()
                    .toLowerCase()
                    .contains(_search.text.toLowerCase()))) {
          filteredList.add(userEntry!);
        }
      }
    } else {
      // Nếu TextField trống, hiển thị toàn bộ danh sách
      print('in else onpresssearch');

      // findFriends();
      findFriends();
      filteredList= userSMap;

    }
    setState(() {
      userSMap = filteredList;
      print('useSmap after fillterlist onpresssearch');
      print(userSMap.toString());

    });
  }
//lay toan bo user trong firebase xuong
  void all() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true; // Bắt đầu loading
    });
    try {
      final querySnapshot = await _firestore.collection('users').get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          allUserEntries = querySnapshot.docs.map((doc) {
            final data = doc.data();

            // print(data.toString());

            return MapEntry(
                doc.id, data); // Tạo MapEntry với ID document và dữ liệu
          }).toList();
          isLoading = false; // Kết thúc loading
          userSMap = allUserEntries;
          print("trong hàm all in allUserEntries");
          print(allUserEntries.toString());
        });
      } else {
        print("No documents found");
        setState(() {
          allUserEntries?.clear();
          isLoading = false; // Kết thúc loading
        });
      }
    } catch (e) {
      print("Error fetching users: $e");
      setState(() {
        isLoading = false; // Kết thúc loading nếu có lỗi
      });
    }
  }


  //tao ra list email cua toan bo ban user hien tai roi dua vao list<string> emails
  void findFriends() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });
    try {
      final querySnapshot = await _firestore.collection('friends').doc(_auth.currentUser?.email).collection('friendlist').get();
        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            userFMap = querySnapshot.docs.map((doc) {
              final data = doc.data();
              // print(data.toString());


              return MapEntry(doc.id, data);
            }).toList();
            // print(allUserEntries);
            emails = userFMap.map((entry) => entry?.value['email'] as String?).whereType<String>().toList();
            isLoading = false;
            // userMap=userFMap;
            print("trong findFriend in list email");
            print(emails);
            List<MapEntry<String, dynamic>?> tempUserSMap = []; // Khởi tạo danh sách rỗng
            print('in if onpresssearch');

            for (var userEntry in allUserEntries) {
              final userData = userEntry?.value;
              if (emails.contains(userData['email'])) {
                tempUserSMap.add(userEntry);}
            }
            setState(() {
              userSMap = tempUserSMap;
            });
            print("Danh sách bạn bè:");
            print(userSMap);
          });
        } else {
          print("Không tìm thấy email nào trong list hết");
          emails=[];
          setState(() {
            // userFMap?.clear();
            isLoading = false;
          });
        }
    } catch (e) {
      print("Lỗi khi lấy danhsách bạn bè: $e");
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(

            onPressed: () async {
              logOut();
              await _firestore
                  .collection('users')
                  .doc(_auth.currentUser?.uid)
                  .update({"status": "Offline"});
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                          hintText: "Search",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: onPressSearch,
                  child: Text("Search"),
                ),
                SizedBox(
                  height: 72,
                ),
                if (!userSMap.isEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: userSMap.length, // Số lượng user
                      itemBuilder: (context, index) {
                        final userMapEntry =
                        userSMap[index]; // Lấy user tại vị trí index
                        return ListTile(
                          onTap: () {
                            //chỉnh xem hình người dùng hoặc gì đó
                            //tuỳ chỉnh
                          },
                          leading: IconButton(
                            icon: Icon(Icons.account_box),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12)),
                            color: Colors.black, //màu icon
                            onPressed: () {},
                          ),
                          title: Text(
                            userSMap[index]?.value['name']??'Unknown',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(userSMap[index]?.value['email'] ?? ''),
                          trailing: FittedBox(
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.add),
                                  color: Colors.black,
                                  onPressed: () async {
                                    //code thêm bạn
                                    //code này chưa làm
                                    //tìm lấy  curUserMap!['email']
                                    //thêm với userMap[index]?.value['email']
                                    //để gửi vào chức năng thêm bạn.

                                    if (await isFriendExists(
                                        curUserMap!['email'],
                                        userSMap[index]?.value['email'])) {
                                      Fluttertoast.showToast(
                                          msg: "Hai người đã làm bạn rồi!");
                                    } else {
                                      try {
                                        await addFriend(curUserMap!['email'],
                                            userSMap[index]?.value['email']);
                                        Fluttertoast.showToast(
                                            msg: "kết bạn thành công");
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.chat),
                                  color: Colors.black,
                                  onPressed: () {
                                    String roomId = chatRoomId(
                                        curUserMap!['email'],
                                        userSMap[index]?.value['email']);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => Chatroom(
                                        chatRoomId: roomId,
                                        user2Map: userMapEntry?.value,
                                      ),
                                    ));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Sorry but we can't findthis user\n Please ask your friend again or make sure that is the correct name.",
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
