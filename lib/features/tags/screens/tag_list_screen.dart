import 'package:flutter/material.dart';
import '../../../models/tag_model.dart';
import '../controllers/tag_controller.dart';
import 'create_tag_screen.dart';

class TagListScreen extends StatefulWidget {
  const TagListScreen({super.key});

  @override
  State<TagListScreen> createState() => _TagListScreenState();
}

class _TagListScreenState extends State<TagListScreen> {

  final TagController controller = TagController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Tags"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTagScreen(),
            ),
          );

          if(result != null){
            setState(() {
              controller.addTag(result);
            });
          }

        },
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(

        itemCount: controller.tags.length,

        itemBuilder: (context,index){

          TagModel tag = controller.tags[index];

          return ListTile(
            leading: const Icon(Icons.label),
            title: Text(tag.name),
          );

        },

      ),

    );

  }

}