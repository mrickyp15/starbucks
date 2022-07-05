import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/starbuck_model.dart';
import '../widgets/repository.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen ({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Repository repository = Repository();
  List<Starbuck> listFriends = [];

  getData() async {
    listFriends = await repository.getData();
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Add New Menu',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: listFriends.length,
        itemBuilder: (context, index) {
          Starbuck friends = listFriends[index];
          return InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, 'update',
                  arguments: [friends.id, friends.minumman, friends.harga]);
            },
            child: Dismissible(
              key: Key(friends.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Icon(Icons.delete_forever, color: Colors.white),
              ),
              confirmDismiss: (direction) {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Delete Data'),
                      content: Text('Yakin ingin di hapus?'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              bool response =
                              await repository.deleteData(friends.id);

                              if (response) {
                                Navigator.pop(context, true);
                              } else {
                                Navigator.pop(context, false);
                              }
                            },
                            child: Text('Yes')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text('No'))
                      ],
                    );
                  },
                );
              },
              child: ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('images/1one.png'),
                          fit: BoxFit.cover)),
                ),
                title: Text(
                  friends.minumman,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  friends.harga,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () {
          Navigator.popAndPushNamed(context, 'create');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}