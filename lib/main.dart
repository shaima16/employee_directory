import 'package:employee_directory/src/screen/home_screen/home_screen.dart';
import 'package:employee_directory/src/services/hive_service.dart';
import 'package:employee_directory/src/view_model/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => EmployeeProvider())],
      child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Employee Directory App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen()),
    );
  }
}
