
import 'package:hive/hive.dart';

import '../models/notes_model.dart';

class Boxes{
  static Box<NotesModel> getDAta() => Hive.box("notes");
}