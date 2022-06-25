import 'dart:io';

import 'package:employee_directory/src/models/employee.dart';
import 'package:employee_directory/src/screen/empolyee_details_screen/widgets/named_border.dart';
import 'package:employee_directory/src/theme/styles.dart';
import 'package:employee_directory/src/view_model/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final Employee? employee;

  EmployeeDetailsScreen({this.employee});
  @override
  Widget build(BuildContext context) {
    EmployeeProvider provider = context.read<EmployeeProvider>();
    double _height = MediaQuery.of(context).size.height / 812;
    double _width = MediaQuery.of(context).size.width / 375;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: _height * 35),
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: .05)
                    ],
                    gradient: const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [Colors.blue, Colors.white]),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: provider.isDataStored
                          ? Image.file(File(employee!.profileImage ?? ""),
                              errorBuilder: (context, error, stackTrace) {
                              return Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.person,
                                    size: 35,
                                  ));
                            })
                          : Image.network(employee!.profileImage ?? "",
                              errorBuilder: (context, error, stackTrace) {
                              return Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.person,
                                    size: 35,
                                  ));
                            }),
                    ),
                    radius: 65,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(employee?.username ?? "",
                      style: fontStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),

                  Text(
                    employee?.name ?? "",
                    style: fontStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    employee?.email ?? "",
                    style: fontStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),

                  employee?.phone != null
                      ? Text(
                          employee?.phone ?? "",
                          style: fontStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        )
                      : const SizedBox(),
                  employee?.website != null
                      ? Text(
                          employee?.website ?? "",
                          style: fontStyle(color: Colors.white),
                        )
                      : const SizedBox(),
                ]),
              ),
              const SizedBox(height: 10,),
              if (employee!.address != null)
                NamedBorderColumn(children: [
                  tableRow(employee?.address?.street ?? ""),
                  tableRow(employee?.address?.city ?? ""),
                  tableRow(employee?.address?.suite ?? ""),
                  tableRow(employee?.address?.zipcode ?? ""),
                  tableRow("Latitude : ${employee?.address?.geo?.lat ?? ""}"),
                  tableRow("Longitude : ${employee?.address?.geo?.lng ?? ""}"),
                ], title: "Address",),
              if (employee!.company != null)
                NamedBorderColumn(children: [
                  tableRow(
                    employee?.company?.name ?? "",
                    textStyle:
                        fontStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  tableRow(employee?.company?.catchPhrase ?? ""),
                  tableRow(employee?.company?.bs ?? ""),
                ], title: "Company Details"),
              SizedBox(
                height: _height * 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow tableRow(String adrress, {TextStyle? textStyle}) {
    return TableRow(children: [
      Text(
        adrress,
        style: textStyle ??
            fontStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600]),
      ),
    ]);
  }
}
