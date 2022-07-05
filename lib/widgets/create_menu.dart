
import 'package:flutter/material.dart';
import 'package:starbucks/widgets/repository.dart';

import '../views/premium_page.dart';

class Createfriends extends StatefulWidget {
  const Createfriends({Key? key}) : super(key: key);

  @override
  State<Createfriends> createState() => _CreatefriendsState();
}

class _CreatefriendsState extends State<Createfriends> {
  final nameController = TextEditingController();
  final hashtagController = TextEditingController();

  Repository repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add New Friends'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: 'Minumman', hintStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: hashtagController,
              decoration: InputDecoration(
                  hintText: 'Harga',
                  hintStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    child: Text('Cencel')),
                ElevatedButton(
                    onPressed: () async {
                      bool response = await repository.createData(
                          nameController.text, hashtagController.text);

                      if (response) {
                        Navigator.popAndPushNamed(context, 'home');
                      } else {
                        throw Exception('failed to create data');
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child: Text('Submit')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}