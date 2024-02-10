import 'dart:convert';
import 'package:daily_challenge/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class userList extends StatefulWidget {
  @override
  _userListState createState() => _userListState();
}

class _userListState extends State<userList> {
  List<DataModel> users = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.1.119:3002/listUsers'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        users = jsonData.map((data) => DataModel.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }


  void deleteUser(String uid) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.119:3002/deleteUser/$uid'),
      );
      if (response.statusCode == 200) {
        print('Delete User Successful');
        setState(() {
          users.removeWhere((user) => user.uid == uid);
        });
      } else {
        print('Error: Delete User: ${response.statusCode}');
        
      }
    } catch (error) {
      print('Request Error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: users.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                  return ListTile(
                    title: Text(user.email),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteUser(user.uid);
                      },
                    ),
                  );              
              },
            ),
    );
  }
}