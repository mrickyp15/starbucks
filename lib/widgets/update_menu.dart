import 'package:flutter/material.dart';
import 'package:starbucks/widgets/repository.dart';

import '../views/premium_page.dart';


class Updatefriends extends StatefulWidget {
  const Updatefriends({Key? key}) : super(key: key);

  @override
  State<Updatefriends> createState() => _UpdatefriendsState();
}

class _UpdatefriendsState extends State<Updatefriends> {
  final nameController = TextEditingController();
  final hashtagController = TextEditingController();

  Repository repository = Repository();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;
    if (args[1].isNotEmpty) {
      nameController.text = args[1];
    }
    if (args[2].isNotEmpty) {
      hashtagController.text = args[2];
    }
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Update Menu'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Name'),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: hashtagController,
              decoration: InputDecoration(hintText: 'Hashtag'),
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
                      bool response = await repository.updateData(
                          args[0], nameController.text, hashtagController.text);

                      if (response) {
                        Navigator.popAndPushNamed(context, 'home');
                      } else {
                        throw Exception('failed to update data');
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child: Text('Update')),
              ],
            )
          ],
        ),
      ),
    );
  }
}