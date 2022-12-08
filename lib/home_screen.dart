import 'package:flutter/material.dart';
import 'package:flutter_hive_learning/boxes/boxes.dart';
import 'package:flutter_hive_learning/models/notes_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final descriptionController = TextEditingController();
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Hive DataBase"))),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getDAta().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                itemCount: box.length,
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data[index].title.toString()),
                              Spacer(),
                              InkWell(onTap: () {
                                _update(
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString());
                              }, child: Icon(Icons.edit)),
                              SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                  onTap: () {
                                    delete(data[index]);
                                  },
                                  child: Icon(Icons.delete))
                            ],
                          ),
                          Text(data[index].description.toString()),
                        ],
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialogue();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    notesModel.delete();
  }
  Future<void> _update(NotesModel notesModel, String title,String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Notes"),
            content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(hintText: "Enter Title"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(hintText: "Enter Descriptions"),
                    ),
                  ],
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    notesModel.title = titleController.text.toString();
                    notesModel.description = descriptionController.text.toString();
                    notesModel.save();
                    titleController.clear();
                    descriptionController.clear();
                    },
                  child: Text("Ok")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }

  Future<void> _showMyDialogue() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Notes"),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: "Enter Title"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: "Enter Descriptions"),
                ),
              ],
            )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    var data = NotesModel(
                        title: titleController.text,
                        description: descriptionController.text);
                    final box = Boxes.getDAta();
                    box.add(data);
                    // data.save();
                    descriptionController.clear();
                    titleController.clear();
                    print(box);
                  },
                  child: Text("Add")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }
}
