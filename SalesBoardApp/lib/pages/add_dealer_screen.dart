import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/pages/add_farmer_screen.dart';

import '../api_service.dart';

class AddDealerScreen extends StatefulWidget {

  final String areaId;
  final String routeId;

  const AddDealerScreen({super.key, required this.areaId, required this.routeId});

  @override
  State<AddDealerScreen> createState() => _AddDealerScreenState();
}

class _AddDealerScreenState extends State<AddDealerScreen> {

  final ApiService apiService = ApiService();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _keeperController = TextEditingController();
  final TextEditingController _keeperMobileController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _panController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false,
        title: const Text("Add Dealer"),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _companyController,
                      decoration: const InputDecoration(
                          hintText: "Company", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _ownerController,
                      decoration: const InputDecoration(
                          hintText: "Owner", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _mobileController,
                      decoration: const InputDecoration(
                          hintText: "Contact", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _keeperController,
                      decoration: const InputDecoration(
                          hintText: "Keeper", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _keeperMobileController,
                      decoration: const InputDecoration(
                          hintText: "Keeper Contact", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _gstController,
                      decoration: const InputDecoration(
                          hintText: "GST No.", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _panController,
                      decoration: const InputDecoration(
                          hintText: "PAN No.", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(onPressed: () {
                        _addDealer();
                      }, child: const Text("SUBMIT")),
                    ),
        
        
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 8),
              //   child: SizedBox(
              //     width: double.infinity,
              //     height: 48,
              //     child: ElevatedButton(onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => AddFarmerScreen(areaId: widget.areaId, routeId: widget.routeId)),
              //       );
              //     }, child: const Text("ADD FARMER")),
              //   ),
              // )
            ]
        ),
      ),
    );
  }

  void _addDealer() {
    String company = _companyController.text;
    String owner = _ownerController.text;
    String mobile = _mobileController.text;
    String keeper = _keeperController.text;
    String keeperMobile = _keeperMobileController.text;
    String gst = _gstController.text;
    String pan = _panController.text;

    apiService.addDealer(
        "1",
      company,
      owner,
      mobile,
      keeper,
      keeperMobile,
      gst,
      pan
    );
  }
}
