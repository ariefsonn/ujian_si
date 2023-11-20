import 'package:flutter/material.dart';
import 'package:ujian_si/data/helper.dart';

class AddNilai extends StatefulWidget {
  const AddNilai({super.key});

  @override
  State<AddNilai> createState() => _AddNilaiState();
}

class _AddNilaiState extends State<AddNilai> {
  final cId = TextEditingController();
  final cHarian = TextEditingController();
  final cUts = TextEditingController();
  final cUas = TextEditingController();

  Future<void> addNilai() async {
    String id = cId.text;
    String harian = cHarian.text;
    String uts = cUts.text;
    String uas = cUas.text;

    if (id.isNotEmpty && harian.isNotEmpty && uts.isNotEmpty && uas.isNotEmpty) {
      await DatabaseHelper.instance.addNilai(id, harian, uts, uas);
      print("ok");

      cId.text = "";
      cHarian.text = "";
      cUas.text = "";
      cUts.text = "";
    } else {
      print("gagal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter student id',
                ),
                keyboardType: TextInputType.number,
                controller: cId,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter nilai harian',
                ),
                controller: cHarian,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter nilai uts',
                ),
                controller: cUts,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter nilai uas',
                ),
                controller: cUas,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    addNilai();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF252DAD)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(49))),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Euclid Circular B',
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
