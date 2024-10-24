import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salesboardapp/api_service.dart';

class AddMerchandise extends StatefulWidget {
  const AddMerchandise({super.key});

  @override
  State<AddMerchandise> createState() => _AddMerchandiseState();
}

class _AddMerchandiseState extends State<AddMerchandise> {

  ApiService apiService = ApiService();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  DateTime? selectedDate;
  XFile? _image;

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
        title: Text("Add Merchandise"),
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
                // child: DropdownButton(
                //   isExpanded: true,
                //   value: typeObj,
                //   onChanged: (ExpenseType? value) {
                //     typeObj = value;
                //     setState(() {});
                //   },
                //   items: typeList.map((ExpenseType type) {
                //     return DropdownMenuItem<ExpenseType>(
                //       value: type,
                //       child: Text(type.stateName), // Display the area name
                //     );
                //   }).toList(),
                // ),
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
              controller: quantityController,
              decoration: const InputDecoration(
                  hintText: "Quantity", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(width: double.infinity,
                height: 48,
                child: ElevatedButton(onPressed: () {
                  // _addExpense();
                }, child: Text("Submit")))
          ],
        ),
      ),
    );
  }
}
