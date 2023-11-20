import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_si/data/helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:ujian_si/helper/addNilai.dart';
import 'package:ujian_si/helper/addStudent.dart';
import 'package:ujian_si/pages/login_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedStudent = '';
  int selectedId = 0;
  List<String> students = [];
  List<int> studentIds = [];

  String? name;
  String? role;
  late SharedPreferences _prefs;

  int harian = 0;
  int uts = 0;
  int uas = 0;

  double calculate = 0;

  Future<void> setPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      name = _prefs.getString('name') ?? 'Unknown';
      role = _prefs.getString('role') ?? '';
    });
  }
  Future<void> getStudents() async {
    List<Map<String, dynamic>> fetchedStudents = await DatabaseHelper.instance.getAllStudents();
    students = fetchedStudents.map((student) => student['nama_student'] as String).toList();
    studentIds = fetchedStudents.map((student) => student['student_id'] as int).toList();

    selectedStudent = students[0];

    setState(() {
      int selectedIndex = students.indexOf(selectedStudent);
      if (selectedIndex != -1) {
        selectedId = studentIds[selectedIndex];
      }
    });
  }
  Future<void> getNilai() async {
    Map<String, dynamic> nilaiData = await DatabaseHelper.instance.getNilaiById(selectedId);

    if (nilaiData.isNotEmpty) {
      harian = nilaiData['nilai_harian'].toInt();
      uts = nilaiData['nilai_uts'].toInt();
      uas = nilaiData['nilai_uas'].toInt();

      calculate = (harian * 0.1) + (uts * 0.3) + (uas * 0.6);
    } else {
      harian = 0;
      uts = 0;
      uas = 0;
    }
  }

  @override
  void initState() {
    setPrefs();
    getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 78,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xffececec),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selamat Datang,', style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontStyle: FontStyle.normal
                      )),
                      Text('$name ($role)', style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontStyle: FontStyle.normal
                      )),
                    ],
                  ),
                  Visibility(visible: (role == 'admin') ? true : false, child: Column(
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.score_rounded, size: 20),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (c) => const AddNilai()));
                        },
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        child: const Icon(Icons.people_alt_rounded, size: 20),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (c) => const AddStudent()));
                        },
                      ),
                    ],
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5, top: 20),
              height: 50,
              padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xffececec),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    value: selectedStudent,
                    items: students.map((String student) {
                      return DropdownMenuItem(
                        value: student,
                        child: Text(student),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedStudent = value!;
                        int selectedIndex = students.indexOf(selectedStudent);
                        if (selectedIndex != -1) {
                          selectedId = studentIds[selectedIndex];
                        }
                        print(selectedId);
                      });
                    },
                    underline: Container(),
                  ),
                  SizedBox(
                    width: 100,
                    height: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(6))))),
                      onPressed: () {
                        setState(() {
                          getNilai();
                        });
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Euclid Circular B',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kalkulasi\nNilai:", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 27,
                      fontStyle: FontStyle.normal
                  )),
                  const SizedBox(height: 10,),
                  Text("$calculate", style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 56,
                      fontStyle: FontStyle.normal
                  )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              width: double.infinity,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Harian", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                          fontStyle: FontStyle.normal
                      )),
                      const SizedBox(height: 10,),
                      Text("$harian", style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                          fontStyle: FontStyle.normal
                      )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("UTS", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                          fontStyle: FontStyle.normal
                      )),
                      const SizedBox(height: 10,),
                      Text("$uts", style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                          fontStyle: FontStyle.normal
                      )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("UAS", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                          fontStyle: FontStyle.normal
                      )),
                      const SizedBox(height: 10,),
                      Text("$uas", style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                          fontStyle: FontStyle.normal
                      )),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() async {
                  _prefs = await SharedPreferences.getInstance();
                  _prefs.remove('role');
                  _prefs.remove('name');
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginPage()));
                });
              },
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  width: double.infinity,
                  height: 50,
                  child: const Center(
                    child: Text("Keluar", style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        fontStyle: FontStyle.normal
                    )),
                  )
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            saveAndOpenPDF(name!, selectedStudent, harian.toDouble(), uts.toDouble(), uas.toDouble(), calculate);
          });
        },
        child: const Icon(Icons.save),
      ),
    );
  }


  Future<void> createPDF(String teacher, String student, double nilaiHarian, double nilaiUTS, double nilaiUAS, double totalKalkulasi) async {
    final pdf = pw.Document();

    // Menambahkan data ke PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text('Teacher: $teacher'),
              pw.Text('Student: $student'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                headers: ['Harian', 'UTS', 'UAS', 'Nilai Akhir'],
                data: [
                  ['${nilaiHarian.toStringAsFixed(2)}', '${nilaiUTS.toStringAsFixed(2)}', '${nilaiUAS.toStringAsFixed(2)}', '${totalKalkulasi.toStringAsFixed(2)}'],
                ],
              ),
            ],
          );
        },
      ),
    );

    // Simpan file PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/rapor.pdf");
    await file.writeAsBytes(await pdf.save());
  }
  Future<void> saveAndOpenPDF(String teacher, String student, double nilaiHarian, double nilaiUTS, double nilaiUAS, double totalKalkulasi) async {
    await createPDF(teacher, student, nilaiHarian, nilaiUTS, nilaiUAS, totalKalkulasi);

    // Mendapatkan path dari direktori aplikasi
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/rapor.pdf");

    // Open the PDF file using the open_file package
    OpenFile.open(file.path);
  }
}
