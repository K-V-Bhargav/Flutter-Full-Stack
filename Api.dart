import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_youtube/models/person_models.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://192.168.2.172/api";

  // Post API
  static addPerson(Map pdata) async {
    print(pdata);
    var url = Uri.parse("${baseUrl}/add_person");
    try {
      final res = await http.post(url, body: pdata);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("Failed to upload Data !!");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Get API
  static Future<List<Person>> getPerson() async {
    List<Person> persons = [];
    var url = Uri.parse("$baseUrl/get_person");
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
        if (data.containsKey('person')) {
          data['person'].forEach((value) {
            persons.add(
              Person(
                name: value['pname'],
                phone: value['pphone'],
                age: value['page'],
                id: value['_id'].toString(),
              ),
            );
          });
          return persons;
        } else {
          print("API response doesn't contain 'person' key");
          return [];
        }
      } else {
        print("Failed to display Data. Status code: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  // Update API
  static Future<void> updatePerson(String? id, Map<String, dynamic> body) async {
    try {
      var url = Uri.parse("$baseUrl/update/$id");
      final res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (res.statusCode == 200) {
        print("Person Updated Successfully!!");
        print(jsonDecode(res.body));
      } else {
        print("Failed to update Person. Status Code: ${res.statusCode}");
        print("Response Body: ${res.body}");
      }
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  // Delete API
  static Future<dynamic> deletePerson(String? id) async {
    try {
      var url = Uri.parse("$baseUrl/delete/$id");
      final res = await http.delete(url);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw Exception("Failed to delete person. Status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error deleting person: $e");
      throw e;
    }
  }
}
