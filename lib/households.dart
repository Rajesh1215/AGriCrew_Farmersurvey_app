import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HouseholdSurveyForm extends StatefulWidget {
  @override
  _HouseholdSurveyFormState createState() => _HouseholdSurveyFormState();
}

class _HouseholdSurveyFormState extends State<HouseholdSurveyForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController budgetRangeController = TextEditingController();
  TextEditingController essentialVegetablesController = TextEditingController();
  bool preferConstantPrice = false;
  double maxConstantPrice = 0.0;

  @override
  void dispose() {
    nameController.dispose();
    budgetRangeController.dispose();
    essentialVegetablesController.dispose();
    super.dispose();
  }
  void uploadHouseholdDataToFirebase() async {
    try {
      // Create a data map from the form fields
      Map<String, dynamic> dataMap = {
        'name': nameController.text,
        'budgetRange': budgetRangeController.text,
        'essentialVegetables': essentialVegetablesController.text,
        'preferConstantPrice': preferConstantPrice,
        'maxConstantPrice': maxConstantPrice,
      };

      // Display a progress dialog
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Upload the data to Firebase
      await FirebaseFirestore.instance.collection('households').add(dataMap);

      // Close the progress dialog
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      // Clear the form fields
      nameController.clear();
      budgetRangeController.clear();
      essentialVegetablesController.clear();

      // Display a success message or navigate to a new page
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data uploaded successfully.'),
      ));
    } catch (error) {
      // Close the progress dialog
      Navigator.of(context).pop();

      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading data: $error'),
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: budgetRangeController,
          decoration: InputDecoration(labelText: 'Range of Budget low,average,high'),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: essentialVegetablesController,
          decoration: InputDecoration(labelText: 'Essential Vegetables (Up to 10)'),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              value: preferConstantPrice,
              onChanged: (value) {
                setState(() {
                  preferConstantPrice = value ?? false;
                });
              },
            ),
            Text('Prefer to Buy Vegetables with Constant Price'),
          ],
        ),
        if (preferConstantPrice)
          TextFormField(
            decoration: InputDecoration(labelText: 'Max Price You Are Willing to Pay'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                maxConstantPrice = double.tryParse(value) ?? 0.0;
              });
            },
          ),
        SizedBox(height: 30,),
        ElevatedButton(onPressed: (){
          uploadHouseholdDataToFirebase();
        },
            child: Text("Submit"))
      ],
    );
  }
}
