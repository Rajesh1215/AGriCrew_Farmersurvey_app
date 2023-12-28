import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
class RetailerSurveyForm extends StatefulWidget {
  @override
  _RetailerSurveyFormState createState() => _RetailerSurveyFormState();
}

class _RetailerSurveyFormState extends State<RetailerSurveyForm> {
  int profitsFrequency = 0;
  double riskRewardMargin = 0.0;
  bool willingToWorkOnline = false;
  double expectedProfit = 0.0;

  bool isUploading = false; // Flag to track if data is being uploaded

  Future<void> uploadDataToFirebase(BuildContext context) async {
    setState(() {
      isUploading = true; // Start uploading, show circular progress
    });

    Map<String, dynamic> dataMap = {
      'profitsFrequency': profitsFrequency,
      'riskRewardMargin': riskRewardMargin,
      'willingToWorkOnline': willingToWorkOnline,
      'expectedProfit': expectedProfit,
    };

    try {
      final docRef = await FirebaseFirestore.instance.collection('retailers').add(dataMap);
      print('Data uploaded successfully with document ID: ${docRef.id}');

      setState(() {
        isUploading = false; // Upload completed, hide circular progress
      });

      // Navigate to a new page (RetailerHomeScreen in this example)
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data uploaded successfully.'),
      ));
    } catch (error) {
      print('Error uploading data: $error');
      setState(() {
        isUploading = false; // Upload error, hide circular progress
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'How often do you get profits for 10 trades?'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            profitsFrequency = int.tryParse(value) ?? 0;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(labelText: 'At what margin would it be better for risk-reward ratio?'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            riskRewardMargin = double.tryParse(value) ?? 0.0;
          },
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              value: willingToWorkOnline,
              onChanged: (value) {
                setState(() {
                  willingToWorkOnline = value ?? false;
                });
              },
            ),
            Text('Are you willing to work with any online platforms?'),
          ],
        ),
        SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(labelText: 'If yes, how much profit do you expect from working online?'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            expectedProfit = double.tryParse(value) ?? 0.0;
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: isUploading ? null : () => uploadDataToFirebase(context),
          child: Text("Submit"),
        ),
        SizedBox(height: 20),
        if (isUploading)
          CircularProgressIndicator(),

      ],
    );
  }
}
