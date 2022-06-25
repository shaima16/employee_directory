import 'package:employee_directory/src/screen/home_screen/widgets/employee_card.dart';
import 'package:employee_directory/src/services/hive_service.dart';
import 'package:employee_directory/src/utilities/enums.dart';
import 'package:employee_directory/src/view_model/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    EmployeeProvider _employeeProvider = context.read<EmployeeProvider>();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await _employeeProvider.initializeAppDataPath();
      if (await HiveService.isExists(HiveService.EMPLOYEE) == true) {
        await _employeeProvider.getDataFromDb();
        _employeeProvider.dataStored = true;
      } else {
        await _employeeProvider.fetchDataAndSaveToDB().whenComplete(() {
          if (_employeeProvider.dataFetchStatusWeb == ProviderStatus.LOADED) {
            ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
                const SnackBar(
                    content: Text("Employees Data Stored Successfully")));
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Consumer<EmployeeProvider>(builder: (context, provider, child) {
          if (provider.dataFetchStatusDB == ProviderStatus.ERROR ||
              provider.dataFetchStatusWeb == ProviderStatus.ERROR) {
            return const Center(
              child: Text("Error Occurred.."),
            );
          } else if (provider.dataFetchStatusDB == ProviderStatus.LOADED ||
              provider.dataFetchStatusWeb == ProviderStatus.LOADED) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  toolbarHeight: 80,
                  backgroundColor: Colors.blue,
                  title: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Center(
                      child: TextField(
                        onChanged: (String value) async {
                          provider.dataStored = true;
                          if (value.isNotEmpty || value.characters.isNotEmpty) {
                            await provider.searchEmployee(value);
                          } else {
                            await provider.getDataFromDb();
                          }
                        },
                        cursorColor: Colors.black54,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.all(12),
                          border: InputBorder.none,
                          hintText: "Search name or email",
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      margin: const EdgeInsets.only(top: 10),
                      child: provider.employeeList.isEmpty
                          ? const Center(
                              child: Text("No Data Found"),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: provider.employeeList.length,
                              itemBuilder: (context, index) {
                                return EmployeeCard(
                                  index: index,
                                );
                              })),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 2,
            ),
          );
        }),
      ),
    );
  }
}
