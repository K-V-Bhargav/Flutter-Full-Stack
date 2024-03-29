import 'package:flutter/material.dart';
import 'package:flutter_project_youtube/models/person_models.dart';
import 'package:flutter_project_youtube/services/Api.dart';

class Delete extends StatefulWidget {
  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Color.fromARGB(255, 7, 130, 192)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        child: const Text(
                          "DELETE SCREEN",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: FutureBuilder<List<Person>>(
                          future: Api.getPerson(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              List<Person> pdata = snapshot.data!;
                              return ListView.builder(
                                itemCount: pdata.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    color: Colors.yellowAccent,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: ListTile(
                                        leading: const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.black,
                                        ),
                                        title: Text(
                                          "Name: ${pdata[index].name}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Phone: ${pdata[index].phone}, Age: ${pdata[index].age}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () async {
                                            try {
                                              dynamic deletedPerson = await Api.deletePerson(pdata[index].id);
                                              print("Deleted Person: $deletedPerson");
                                              setState(() {
                                                pdata.removeAt(index);
                                              });
                                            } catch (e) {
                                              print("Error deleting person: $e");
                                            }
                                          },

                                          icon: const Icon(
                                            Icons.delete_forever_sharp,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        )
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "No Data Found !!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}