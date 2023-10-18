import 'dart:math';

import 'package:attendance_app/screens/signin_screen.dart';
import 'package:attendance_app/screens/take_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/widgets.dart';
//import 'package:mysql1/mysql1.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> courseNames = [];
  List<String> divisionNames = [];
  List<String> subjectNames = [];
  var isLoadingFile = false;
  var isLoadingUpload = false;
  final _formKey = GlobalKey<FormState>();
  final subController = TextEditingController();
  String? _selectedSubject;
  String? selectedExcelFileName;
  String? _selectedCourse;
  String? _selectedDiv;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  DateTime? selectedDateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCourseNames();
    _loadDivisionNames();
  }

  FirebaseAuth user = FirebaseAuth.instance;
  Future<void> _loadCourseNames() async {
    try {
      QuerySnapshot courseSnapshot =
          await FirebaseFirestore.instance.collection('courses').get();
      setState(() {
        courseNames = courseSnapshot.docs
            .map((doc) => doc['course_name'] as String)
            .toList();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _loadSubjectsName(String courseId, String courseName) async {
    print(courseId);
    print(courseName);
    try {
      QuerySnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection("courses")
          .where('course_name', isEqualTo: courseName)
          .get();
      if (courseSnapshot.docs.isNotEmpty) {
        String courseId = courseSnapshot.docs[0].id;
        QuerySnapshot subjectSnapshot = await FirebaseFirestore.instance
            .collection("courses")
            .doc(courseId)
            .collection("subjects")
            .get();

        setState(() {
          subjectNames = subjectSnapshot.docs
              .map((doc) => doc['subject_name'] as String)
              .toList();
        });
      }

      // QuerySnapshot subjectSnapshot = await FirebaseFirestore.instance
      //     .collection('courses')
      //     .doc(courseId)
      //     .collection("subjects")
      //     .get();

      // setState(() {
      //   subjectNames = subjectSnapshot.docs
      //       .map((doc) => doc['subject_name'] as String)
      //       .toList();
      // });
      print(subjectNames);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _loadDivisionNames() async {
    try {
      QuerySnapshot divSnapshot =
          await FirebaseFirestore.instance.collection('divisions').get();
      setState(() {
        divisionNames =
            divSnapshot.docs.map((doc) => doc['div_name'] as String).toList();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> _fetchCourseId(String courseName) async {
    try {
      QuerySnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('course_name', isEqualTo: courseName)
          .get();

      if (courseSnapshot.docs.isNotEmpty) {
        return courseSnapshot.docs.first.id;
      }
    } catch (e) {
      print("Error fetching courseId: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double spacing = 16.0;
    if (MediaQuery.of(context).size.width > 600) {
      spacing = 32.0;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                textFormField(
                  subController,
                  "Enter Subject",
                  false,
                  TextInputType.name,
                  (value) {
                    if (value!.isEmpty) {
                      return "Please enter subject";
                    }
                    return null;
                  },
                  context,
                  Icons.subject_rounded,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text("Select Date"),
                        ),
                        Text(_selectedDate != null
                            ? "Date: ${DateFormat('yyyy-MM-dd-hh-mm').format(_selectedDate!)}"
                            : ""),
                      ],
                    ),
                  ],
                ),

                DropdownButtonFormField<String>(
                  value: _selectedCourse,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  hint: Text("Select Course"),
                  items: courseNames
                      .map(
                        (courseName) => DropdownMenuItem<String>(
                          value: courseName,
                          child: Text(courseName),
                        ),
                      )
                      .toList(),
                  onChanged: (selectedcourse) async {
                    String? courseId = await _fetchCourseId(selectedcourse!);
                    if (courseId != null) {
                      _loadSubjectsName(courseId, selectedcourse);
                      setState(() {
                        _selectedCourse = selectedcourse;
                        _selectedSubject = null;
                      });
                    } else {
                      print(
                          "Course ID not found for selected course: $_selectedCourse");
                    }
                  },
                  validator: (val) {
                    if (val == null) {
                      return "Please select a course";
                    }
                    return null;
                  },
                ),

                // if (_selectedCourse != null)
                //   DropdownButtonFormField<String>(
                //     value: _selectedSubject,
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     hint: Text("Select Subject"),
                //     items: subjectNames
                //         .map(
                //           (subject) => DropdownMenuItem<String>(
                //             value: subject,
                //             child: Text(subject),
                //           ),
                //         )
                //         .toList(),
                //     onChanged: (selectedSub) async {
                //       setState(() {
                //         _selectedSubject = selectedSub;
                //       });
                //     },
                //   ),
                const SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField<String>(
                  value: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  hint: const Text("Select Division"),
                  items: divisionNames
                      .map(
                        (divName) => DropdownMenuItem<String>(
                          value: divName,
                          child: Text(divName),
                        ),
                      )
                      .toList(),
                  onChanged: (selecteddiv) {
                    setState(() {
                      _selectedDiv = selecteddiv;
                    });
                  },
                  validator: (val) {
                    if (val == null) {
                      return "Please select a Division";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButtonFormField<int>(
                            value: _selectedStartDate?.year,
                            items: List.generate(101, (index) {
                              final year = DateTime.now().year - 50 + index;
                              return DropdownMenuItem<int>(
                                  value: year, child: Text(year.toString()));
                            }),
                            onChanged: (selectedYear) {
                              setState(() {
                                _selectedStartDate = DateTime(selectedYear!);
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Select Start Year",
                            ),
                            validator: (val) {
                              if (val == null) {
                                return "Please select start year";
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(_selectedStartDate != null
                              ? "Start Year: ${DateFormat('yyyy').format(_selectedStartDate!)}"
                              : ""),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: spacing,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButtonFormField<int>(
                            value: _selectedEndDate?.year,
                            items: List.generate(101, (index) {
                              final year = DateTime.now().year - 50 + index;
                              return DropdownMenuItem<int>(
                                  value: year, child: Text(year.toString()));
                            }),
                            onChanged: (selectedYear) {
                              setState(() {
                                _selectedEndDate = DateTime(selectedYear!);
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Select End Year",
                            ),
                            validator: (val) {
                              if (val == null) {
                                return "Please select end year";
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(_selectedEndDate != null
                              ? "End Year: ${DateFormat('yyyy').format(_selectedEndDate!)}"
                              : ""),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                // ),
                // CustomWidgets.loginButton(
                //     context, _getData, isLoadingUpload, "Next")
                if (_selectedCourse != null && _selectedDiv != null)
                  ElevatedButton(
                      child: Text("Next"),
                      onPressed: () {
                        DateTime startDate = _selectedStartDate!;
                        DateTime endDate = _selectedEndDate!;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TakeAttendance(
                                  date: selectedDateTime.toString(),
                                  time: _selectedTime
                                      .toString(), // Pass the selected time
                                  course: _selectedCourse,
                                  subject: subController.text,
                                  div: _selectedDiv,
                                  start_year: startDate.year,
                                  end_year: endDate.year,
                                )));

                        // Combine the selected date and time into a DateTime object

                        //_getData();
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => TakeAttendance(
                        //       date: selectedDateTime.toString(),
                        //       time: _selectedTime
                        //           .toString(), // Pass the selected time
                        //       course: _selectedCourse,
                        //       subject: _selectedSubject,
                        //       div: _selectedDiv,
                        //       start_year: _selectedStartDate.toString(),
                        //       end_year: _selectedEndDate.toString(),
                        //     ),
                        //   ),
                        // );
                      }),
                // CustomWidgets.loginButton(
                //     context, _getData, isLoadingUpload, "Next"),
                const SizedBox(height: 20),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: excelData.length,
                //     itemBuilder: (context, index) {
                //       var rowData = excelData[index];
                //       return Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text('RollNo: ${rowData['RollNo'] ?? ''}',
                //               style: TextStyle(fontSize: 16)),
                //           Text('EnrollmentNo: ${rowData['EnrollmentNo'] ?? ''}',
                //               style: TextStyle(fontSize: 16)),
                //           Text('Name: ${rowData['Name'] ?? ''}',
                //               style: TextStyle(fontSize: 16)),
                //           SizedBox(height: 10),
                //         ],
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: TimeOfDay.now().hour,
            minute: TimeOfDay.now().minute,
          ),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            );
          });
      if (pickedTime != null) {
        final selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDate = selectedDate;
        });
      }
    }
  }

  Future<void> _getData() async {
    if (_selectedDate != null &&
        _selectedCourse != null &&
        _selectedDiv != null) {
      if (_selectedDate != null && _selectedTime != null) {
        // Combine the selected date and time into a DateTime object
        selectedDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => TakeAttendance(
        //           date: selectedDateTime.toString(),
        //           time: _selectedTime.toString(), // Pass the selected time
        //           course: _selectedCourse,
        //           subject: subController.text,
        //           div: _selectedDiv,
        //           start_year: _selectedStartDate.toString() ,
        //           end_year: _selectedEndDate.toString(),
        //         )));

        //_getData();
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => TakeAttendance(
        //       date: selectedDateTime.toString(),
        //       time: _selectedTime
        //           .toString(), // Pass the selected time
        //       course: _selectedCourse,
        //       subject: _selectedSubject,
        //       div: _selectedDiv,
        //       start_year: _selectedStartDate.toString(),
        //       end_year: _selectedEndDate.toString(),
        //     ),
        //   ),
        // );
      }
    }
  }
}
