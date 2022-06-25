import 'package:employee_directory/src/models/employee.dart';
import 'package:employee_directory/src/services/api_service.dart';
import 'package:employee_directory/src/services/download_helper.dart';
import 'package:employee_directory/src/services/file_service.dart';
import 'package:employee_directory/src/services/hive_service.dart';
import 'package:employee_directory/src/utilities/api_constants.dart';
import 'package:employee_directory/src/utilities/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

class EmployeeProvider extends ChangeNotifier {
  List<Employee> _employeeList = [];
  List<Employee> get employeeList => _employeeList;
  ProviderStatus dataFetchStatusDB = ProviderStatus.IDLE;
  ProviderStatus dataFetchStatusWeb = ProviderStatus.IDLE;
  String appDataPath = "";
  bool isDataStored = false;

  set dataStored(bool value) {
    isDataStored = value;
  }

  Future<void> searchEmployee(String search) async {
    var employeeDb = await Hive.openBox<Employee>(HiveService.EMPLOYEE);
    try {
      _employeeList.clear();
      employeeDb.isNotEmpty
          ? _employeeList = employeeDb.values
              .where((c) => (c.name!
                      .replaceAll(' ', '')
                      .toLowerCase()
                      .contains(search.replaceAll(' ', '').toLowerCase()) ||
                  c.email!
                      .replaceAll(' ', '')
                      .toLowerCase()
                      .contains(search.replaceAll(' ', '').toLowerCase())))
              .toList()
          : null;
      notifyListeners();
    } catch (e) {
      debugPrint("searchEmployee :  $e");
    }
  }

  Future<void> saveToDB(Employee employee) async {
    var employeeDb = await Hive.openBox<Employee>(HiveService.EMPLOYEE);
    try {
      employeeDb.add(employee);
    } catch (e) {
      debugPrint("saveToDB :  $e");
    }
  }

  Future<void> getDataFromDb() async {
    try {
      _employeeList.clear();
      dataFetchStatusDB = ProviderStatus.LOADING;
      notifyListeners();
      final employeeDb = await Hive.openBox<Employee>(HiveService.EMPLOYEE);
      if (employeeDb.length > 0) {
        for (var element in employeeDb.values) {
          _employeeList.add(element);
        }
      }
      dataFetchStatusDB = ProviderStatus.LOADED;
      dataStored = true;
      notifyListeners();
    } catch (e) {
      dataFetchStatusDB = ProviderStatus.ERROR;
      notifyListeners();
      debugPrint("getDataFromDb : $e");
    }
  }

  Future<void> initializeAppDataPath() async {
    appDataPath = await FileService.getApplicationDataPath();
  }

  Future<void> downloadProfileImage(Employee employee) async {
    try {
      await DownloadHelper.downloadFileFromUrl(
        url: employee.profileImage ?? "",
        filePath: "$appDataPath/Profiles/${employee.username}.jpg",
        downloadSuccessActions: () {},
        downloadFailedActions: () {},
      );
    } catch (e) {
      debugPrint("downloadProfileImage: $e");
    }
  }

  Future<void> fetchDataAndSaveToDB() async {
    dataFetchStatusWeb = ProviderStatus.LOADING;
    notifyListeners();
    employeeList.clear();
    try {
      var response = await ApiService.getApiData(url: ApiConstants.api);
      response.data.forEach((data) async {
        _employeeList.add(Employee.fromJson(data));
        Employee employee = Employee.fromJson(data);
        downloadProfileImage(employee);
        employee.profileImage =
            "$appDataPath/Profiles/${employee.username}.jpg";
        saveToDB(employee);
      });
      dataFetchStatusWeb = ProviderStatus.LOADED;
      notifyListeners();
    } catch (e) {
      dataFetchStatusWeb = ProviderStatus.ERROR;
      notifyListeners();
      debugPrint("fetchDataAndSaveToDB: $e");
    }
  }
}
