import 'dart:io';

import 'package:employee_directory/src/screen/empolyee_details_screen/employee_details_screen.dart';
import 'package:employee_directory/src/view_model/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeCard extends StatelessWidget {
  final int? index;

  const EmployeeCard({this.index});

  @override
  Widget build(BuildContext context) {
    EmployeeProvider provider = context.read<EmployeeProvider>();
    return InkWell(onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmployeeDetailsScreen(
                employee: provider.employeeList[index!],
              )));
    },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: provider.isDataStored
                        ? Image.file(
                            File(provider
                                    .employeeList[index!].profileImage ??
                                ""),
                            errorBuilder: (context, error, stackTrace) {
                            return Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.person,color: Colors.white,
                                  size: 35,
                                ));
                          })
                        : provider.employeeList[index!].profileImage ==
                                    null ||
                                provider.employeeList[index!].profileImage!
                                    .isEmpty
                            ? Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.person,
                                  size: 35,color: Colors.white,
                                ))
                            : Image.network(
                                provider.employeeList[index!]
                                        .profileImage ??
                                    "",
                              )),
                radius: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.employeeList[index!].name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    provider.employeeList[index!].company?.name ?? "",
                    style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 14),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
