import '../../../models/tag_model.dart';

class TagController {

  final List<TagModel> _tags = [
    TagModel(id: "1", name: "Food"),
    TagModel(id: "2", name: "Travel"),
  ];

  List<TagModel> get tags => _tags;

  void addTag(TagModel tag){
    _tags.add(tag);
  }

}