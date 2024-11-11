import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salesboardapp/TabSideBar.dart';
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
      if (typeList.isNotEmpty) {
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
    double screenWidth = MediaQuery.of(context).size.width;

    bool isMobileDevice = false;

    if (screenWidth <= 768) {
      setState(() {
        isMobileDevice = true;
      });
    }
    return Scaffold(
      appBar: AppBar(centerTitle: false,
        title: const Text("Add Expense"),
      ),
      body: Row(
        children: [
          if (!isMobileDevice) SizedBox(width: screenWidth / 3.5, child: drawerUi(context)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField(
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 1, color: Colors.grey))),
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
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: selectedDate == null ? 'Date' : 'Selected date: ${selectedDate!.toLocal()}'.split(' ')[2],
                          hintText: "Follow Up Date",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Amount", border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(hintText: "Note", border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                          onPressed: () {
                            _addExpense();
                          },
                          child: const Text("Submit")))
                ],
              ),
            ),
          ),
        ],
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
