import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starbucks/models/starbuck_model.dart';


class Repository {
  String uri = 'https://62c30040ff594c65676b9ac8.mockapi.io/coffeitem';

  Future getData() async {
    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<Starbuck> friends = it.map((e) => Starbuck.fromJson(e)).toList();
        return friends;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future createData(String minuman, String harga) async {
    try {
      final response = await http
          .post(Uri.parse(uri), body: {'minumman': minuman, 'harga': harga});

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future updateData(String id, String minuman, String harga) async {
    try {
      final response = await http
          .put(Uri.parse('$uri/$id'), body: {'minumman': minuman, 'harga': harga});

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteData(String id) async {
    try {
      final response = await http
          .delete(Uri.parse('$uri/$id'));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.toString();
    }
  }
}