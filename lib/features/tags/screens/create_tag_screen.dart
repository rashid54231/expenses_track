import 'package:flutter/material.dart';
import '../../../models/tag_model.dart';

class CreateTagScreen extends StatefulWidget {

  const CreateTagScreen({super.key});

  @override
  State<CreateTagScreen> createState() => _CreateTagScreenState();
}

class _CreateTagScreenState extends State<CreateTagScreen> {

  final nameController = TextEditingController();

  void save(){

    final tag = TagModel(
      id: DateTime.now().toString(),
      name: nameController.text,
    );

    Navigator.pop(context, tag);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Tag"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Tag Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height:30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
                child: const Text("Save Tag"),
              ),
            )

          ],

        ),
      ),

    );

  }

}