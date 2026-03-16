import 'package:flutter/material.dart';
import '../../../models/tag_model.dart';

class CreateTagScreen extends StatefulWidget {

  final TagModel? tag;

  const CreateTagScreen({super.key, this.tag});

  @override
  State<CreateTagScreen> createState() => _CreateTagScreenState();
}

class _CreateTagScreenState extends State<CreateTagScreen> {

  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.tag != null){
      nameController.text = widget.tag!.name;
    }
  }

  void save(){

    if(nameController.text.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tag name required"))
      );
      return;
    }

    final tag = TagModel(
      id: widget.tag?.id ?? DateTime.now().toString(),
      name: nameController.text.trim(),
    );

    Navigator.pop(context, tag);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.tag == null ? "Create Tag" : "Edit Tag"),
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
              height: 50,
              child: ElevatedButton(
                onPressed: save,
                child: Text(widget.tag == null ? "Save Tag" : "Update Tag"),
              ),
            )

          ],

        ),
      ),

    );

  }

}