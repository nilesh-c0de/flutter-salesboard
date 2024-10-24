import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salesboardapp/models/ExpenseType.dart';

import '../api_service.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  ApiService apiService = ApiService();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime? selectedDate;
  List<ExpenseType> typeList = [];
  ExpenseType? typeObj;

  XFile? _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadExpenseTypes();
  }

  Future<void> _loadExpenseTypes() async {
    typeList = [];
    typeObj = null;
    typeList = await apiService.fetchExpenseTypes();

    setState(() {
      if(typeList.isNotEmpty) {
        typeObj = typeList[0];
      }
    });
  }

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
        title: Text("Add Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Border color
                  width: 1, // Border width
                ),
                // Optional: you can specify the border radius
                borderRadius: BorderRadius.circular(3), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                  isExpanded: true,
                  value: typeObj,
                  onChanged: (ExpenseType? value) {
                    typeObj = value;
                    setState(() {});
                  },
                  items: typeList.map((ExpenseType type) {
                    return DropdownMenuItem<ExpenseType>(
                      value: type,
                      child: Text(type.stateName), // Display the area name
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              child: AbsorbPointer(
                child: TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: selectedDate == null
                        ? 'Date'
                        : 'Selected date: ${selectedDate!.toLocal()}'
                            .split(' ')[2],
                    hintText: "Follow Up Date",
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              onTap: () {
                _selectDate(context);
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                  hintText: "Amount", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: noteController,
              decoration: const InputDecoration(
                  hintText: "Note", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: double.infinity,
                height: 48,

                child: ElevatedButton(
                    onPressed: () {
                      // _addVisit();
                    },
                    child: Text("Submit")))
          ],
        ),
      ),
    );
  }
                child: ElevatedButton(onPressed: () {
                  _addExpense();
                }, child: Text("Submit")))
          ],
        ),
      ),
    );
  }

  Future<void> _addExpense() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });

    var date = selectedDate.toString().split(' ')[0];
    var amount = amountController.text;
    var note = noteController.text;
    var typeId = typeObj?.stateId ?? "";

    ApiService apiService = ApiService();
    await apiService.addExpense(_image?.path ?? "", date, amount, note, typeId);
  }
}
