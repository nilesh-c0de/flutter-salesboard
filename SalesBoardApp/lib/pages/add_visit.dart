import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/api_service.dart';

class AddVisit extends StatefulWidget {

  final String itemId;
  const AddVisit({super.key, required this.itemId});

  @override
  State<AddVisit> createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {

  ApiService apiService = ApiService();

  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Visit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: noteController,
              decoration: const InputDecoration(
                  hintText: "Feedback", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              child: AbsorbPointer(
                child: TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: selectedDate == null
                        ? 'No date selected!'
                        : 'Selected date: ${selectedDate!.toLocal()}'.split(' ')[2],
                      hintText: "Follow Up Date", border: const OutlineInputBorder(),),
                ),
              ),
              onTap: () {
                _selectDate(context);
              },
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(width: double.infinity,
                height: 48,
                child: ElevatedButton(onPressed: () {
                  _addVisit();
                }, child: Text("Submit")))
          ],
        ),
      ),
    );
  }

  void _addVisit() {
    String note = noteController.text;
    String date = selectedDate.toString().split(' ')[0];

    print("Note : $note\tDate: $date\nCustId: ${widget.itemId}");


    apiService.addVisit(note, date, widget.itemId);
  }
}
