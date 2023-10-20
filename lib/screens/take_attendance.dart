import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TakeAttendance extends StatefulWidget {
  final DateTime? date;
  final TimeOfDay? time;
  final String? course;
  final String? subject;
  final String? div;
  final int? start_year;
  final int? end_year;
  const TakeAttendance({
    super.key,
    required this.date,
    required this.time,
    required this.course,
    required this.subject,
    required this.div,
    required this.start_year,
    required this.end_year,
  });

  @override
  State<TakeAttendance> createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  int selectedCount = 0;
  List<Map<String, dynamic>> studentDataList = [];
  List<bool> isSelectedList = [];
  User? user2 = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    print(widget.course);
    print(widget.div);
    print(widget.start_year);
    print(user2!.uid);
    print(widget.end_year);
    print(DateFormat('dd-mm-yyyy').format(widget.date!));
    print(DateFormat('hh-mm').format(widget.date!));
    printStudents();
  }

  // Future<void> printStudents() async {
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   final CollectionReference studentsCollection =
  //       firestore.collection("students");

  //   // Define your query criteria
  //   // final String selectedCourse = "course 5";
  //   // final String selectedDiv = "A";
  //   // final int startYear = widget.start_year
  //   // final int endYear = widget.end_year;

  //   // Query for the student document based on your criteria
  //   QuerySnapshot studentsQuery = await studentsCollection
  //       .where('course_name', isEqualTo: widget.course)
  //       .where('div_name', isEqualTo: widget.div)
  //       .where('start_year', isEqualTo: widget.start_year)
  //       .where('end_year', isEqualTo: widget.end_year)
  //       .get();

  //   if (studentsQuery.docs.isNotEmpty) {
  //     // Student document found, now retrieve data from the enrollments subcollection
  //     final DocumentReference studentDocRef =
  //         studentsQuery.docs.first.reference;
  //     final CollectionReference enrollmentsCollection =
  //         studentDocRef.collection('enrollments');

  //     QuerySnapshot enrollmentsQuery = await enrollmentsCollection.get();
  //     if (enrollmentsQuery.docs.isNotEmpty) {
  //       // Data found, iterate through the documents and print them
  //       for (QueryDocumentSnapshot enrollmentDoc in enrollmentsQuery.docs) {
  //         print("Enrollment No: ${enrollmentDoc['EnrollmentNo']}");
  //         print("Roll No: ${enrollmentDoc['RollNo']}");
  //         print("Name: ${enrollmentDoc['Name']}");
  //       }
  //     } else {
  //       // No data found in enrollments collection
  //       print("No student data found.");
  //     }
  //   } else {
  //     // No student document matching the criteria found
  //     print("No student document found.");
  //   }
  // }
  Future<List<Map<String, dynamic>>?> printStudents() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference studentsCollection =
        firestore.collection("students");

    try {
      QuerySnapshot studentsQuery = await studentsCollection
          .where('course_name', isEqualTo: widget.course)
          .where('div_name', isEqualTo: widget.div)
          .where('start_year', isEqualTo: widget.start_year)
          .where('end_year', isEqualTo: widget.end_year)
          .get();

      if (studentsQuery.docs.isNotEmpty) {
        final DocumentReference studentDocRef =
            studentsQuery.docs.first.reference;
        final CollectionReference enrollmentsCollection =
            studentDocRef.collection('enrollments');

        QuerySnapshot enrollmentsQuery = await enrollmentsCollection.get();
        if (enrollmentsQuery.docs.isNotEmpty) {
          List<Map<String, dynamic>> studentDataList = [];
          for (QueryDocumentSnapshot enrollmentDoc in enrollmentsQuery.docs) {
            Map<String, dynamic> studentData = {
              'EnrollmentNo': enrollmentDoc['EnrollmentNo'],
              'RollNo': enrollmentDoc['RollNo'],
              'Name': enrollmentDoc['Name'],
            };
            studentDataList.add(studentData);
          }
          return studentDataList;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: printStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students found.'));
          } else {
            studentDataList = snapshot.data ?? [];
            isSelectedList = List.filled(studentDataList.length, false);
            // List<Map<String, dynamic>> studentDataList = snapshot.data!;
            return studentDataList.isEmpty
                ? Center(child: Text('No students found.'))
                : Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              itemCount: studentDataList.length,
                              separatorBuilder: (context, index) => Divider(),
                              itemBuilder: (context, index) {
                                Map<String, dynamic> studentData =
                                    studentDataList[index];

                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSelectedList[index] =
                                            !isSelectedList[index];
                                        if (isSelectedList[index]) {
                                          selectedCount++;
                                        } else {
                                          selectedCount--;
                                        }

                                        //isSelected = !isSelected;
                                        // if (isSelected) {
                                        //   selectedCount++;
                                        // } else {
                                        //   selectedCount--;
                                        // }
                                      });
                                    },
                                    child: Container(
                                      color: isSelectedList[index]
                                          ? Colors.lightGreen.withOpacity(0.6)
                                          : null,
                                      child: ListTile(
                                        leading: Text(
                                          '${studentData['RollNo']}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text('${studentData['Name']}'),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                              '${studentData['EnrollmentNo']}'),
                                        ),
                                        // You can add more content to the ListTile if needed
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: Text('Submit'),
                          ),
                        ),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }

  Future<void> _submit() async {
    print(widget.date);
    print(widget.time);
    try {
      String pickedDate = DateFormat('dd-mm-yyyy').format(widget.date!);
      String pickedTime = DateFormat('HH-mm').format(widget.date!);

      User? user = FirebaseAuth.instance.currentUser;
      String facultyId = user?.uid ?? '';
      Map<String, dynamic> documentData = {
        'course': widget.course,
        'div': widget.div,
        'subject': widget.subject,
        'date': widget.date,
        'time': widget.time
      };

      if (user != null) {
        // The user is logged in, and you can access their user information
        //String facultyName = user.displayName ?? 'Unknown Faculty';
        CollectionReference facultiesCol =
            FirebaseFirestore.instance.collection("faculties");
        DocumentSnapshot facultiesDocSnap =
            await facultiesCol.doc(facultyId).get();

        if (facultiesDocSnap.exists) {
          String facultyName = facultiesDocSnap['username'];
          documentData['faculty'] = facultyName;

          // Update documentData with the faculty name

          CollectionReference attendanceCollection =
              FirebaseFirestore.instance.collection("attendance");
          Query existingDocQuery = attendanceCollection
              .where('course', isEqualTo: widget.course)
              .where('div', isEqualTo: widget.div)
              .where('subject', isEqualTo: widget.subject)
              .where('date', isEqualTo: pickedDate)
              .where('time', isEqualTo: pickedTime)
              .where('faculty', isEqualTo: facultyName);

          QuerySnapshot existingDocs = await existingDocQuery.get();

          if (existingDocs.docs.isNotEmpty) {
            DocumentReference docRef = existingDocs.docs.first.reference;

            // Create or update the "enrollments" sub-collection
            CollectionReference enrollmentsCollection =
                docRef.collection('enrollments');
            for (int i = 0; i < studentDataList.length; i++) {
              Map<String, dynamic> studentData = studentDataList[i];
              String enrollmentNo = studentData['EnrollmentNo'];
              bool isPresent = isSelectedList[i];

              // Create or update the document for each student in the sub-collection
              await enrollmentsCollection.doc(enrollmentNo).set({
                'RollNo': studentData['RollNo'],
                'Name': studentData['Name'],
                'EnrollmentNo': enrollmentNo,
                'Present': isPresent,
              });
            }
          } else {
            DocumentReference docRef =
                await attendanceCollection.add(documentData);

            // Create the "enrollments" sub-collection
            CollectionReference enrollmentsCollection =
                docRef.collection('enrollments');
            for (int i = 0; i < studentDataList.length; i++) {
              Map<String, dynamic> studentData = studentDataList[i];
              String enrollmentNo = studentData['EnrollmentNo'];
              bool isPresent = isSelectedList[i];

              // Create a document for each student in the sub-collection
              await enrollmentsCollection.doc(enrollmentNo).set({
                'RollNo': studentData['RollNo'],
                'Name': studentData['Name'],
                'EnrollmentNo': enrollmentNo,
                'Present': isPresent,
              });
            }
          }
        }
        _showSuccessDialog();
      }
    } catch (e) {
      print('Error while getting the currently logged-in user: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Data has been successfully sent to the database.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
