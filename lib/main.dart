import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
import 'package:task_management/ui/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  // var box = await Hive.openBox<NoteModel>('NoteModelBox');
  // box.clear();
  // print('box : ${box.length}');
  // NoteModel dummyNote = NoteModel(title: 'name', note: 'ashish lahre', bookmarked: false);
  // var box = await Hive.openBox<NoteModel>('NoteModelBox');
  // box.add(dummyNote);
  // print('local stored value : ${box.values.last.note}');
  runApp(
    ChangeNotifierProvider(
            create: (context) => NotesProvider(),
            child: MyApp(),
          ),);

}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Homescreen(),
    );
  }
}

// Reformat file = ctrl + alt + L