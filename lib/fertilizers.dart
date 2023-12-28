import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FertilizerSurveyForm extends StatefulWidget {
  @override
  _FertilizerSurveyFormState createState() => _FertilizerSurveyFormState();
}

class _FertilizerSurveyFormState extends State<FertilizerSurveyForm> {
  bool effectiveFertilizers = false;
  int farmersManaged = 0;
  int farmersWillingBranded = 0;
  int farmersWillingMedium = 0;
  int farmersWillingCheap = 0;
  double budgetForFertilizers = 0.0;

  void uploadFertilizerDataToFirebase() async {
    try {
      // Create a data map from the form fields
      Map<String, dynamic> dataMap = {
        'effectiveFertilizers': effectiveFertilizers,
        'farmersManaged': farmersManaged,
        'farmersWillingBranded': farmersWillingBranded,
        'farmersWillingMedium': farmersWillingMedium,
        'farmersWillingCheap': farmersWillingCheap,
        'budgetForFertilizers': budgetForFertilizers,
      };
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );


      // Upload the data to Firebase
      await FirebaseFirestore.instance.collection('fertilizers').add(dataMap);

      // Clear the form fields
      setState(() {
        effectiveFertilizers = false;
        farmersManaged = 0;
        farmersWillingBranded = 0;
        farmersWillingMedium = 0;
        farmersWillingCheap = 0;
        budgetForFertilizers = 0.0;
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      // Display a success message or navigate to a new page
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data uploaded successfully.'),
      ));
    } catch (error) {
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
        Row(
          children: [
            Checkbox(
              value: effectiveFertilizers,
              onChanged: (value) {
                setState(() {
                  effectiveFertilizers = value ?? false;
                });
              },
            ),
            Text('Were the present fertilizers effective for 100%?'),
          ],
        ),
        SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(labelText: 'On 100 farmers, how many of them managed to make out from diseases and low-nutritious land?'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            farmersManaged = int.tryParse(value) ?? 0;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(labelText: 'On 100 farmers, how many of them are willing to buy branded fertilizers?'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            farmersWillingBranded = int.tryParse(value) ?? 0;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(labelText: 'On 100 farmers, how many of them are willing to buy medium-priced fertilizers?'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            farmersWillingMedium = int.tryParse(value) ?? 0;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(labelText: 'On 100 farmers, how many of them are willing to buy cheap fertilizers?'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            farmersWillingCheap = int.tryParse(value) ?? 0;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(labelText: 'At what cost are farmers willing to spend on fertilizers for a 100 rupees budget?'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            budgetForFertilizers = double.tryParse(value) ?? 0.0;
          },
        ),
        SizedBox(height: 30,),
        ElevatedButton(onPressed: (){
          uploadFertilizerDataToFirebase();
        },
            child: Text("Submit"))
      ],
    );
  }
}
