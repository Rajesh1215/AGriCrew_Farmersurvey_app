import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class WorkerSurveyForm extends StatefulWidget {
  @override
  _WorkerSurveyFormState createState() => _WorkerSurveyFormState();
}

class _WorkerSurveyFormState extends State<WorkerSurveyForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController majorTasksController = TextEditingController();
  TextEditingController otherTasksController = TextEditingController();
  TextEditingController dailyWages8HoursController = TextEditingController();
  TextEditingController dailyWages12HoursController = TextEditingController();
  bool workReduction = false;
  bool worker_unavailability = false;

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    majorTasksController.dispose();
    otherTasksController.dispose();
    dailyWages8HoursController.dispose();
    dailyWages12HoursController.dispose();
    super.dispose();
  }
  void uploadWorkerDataToFirebase() async {
    try {
      // Create a data map from the form fields
      Map<String, dynamic> dataMap = {
        'name': nameController.text,
        'gender': genderController.text,
        'majorTasks': majorTasksController.text,
        'otherTasks': otherTasksController.text,
        'dailyWages8Hours': double.tryParse(dailyWages8HoursController.text) ?? 0.0,
        'dailyWages12Hours': double.tryParse(dailyWages12HoursController.text) ?? 0.0,
        'workReduction': workReduction,
        'workerUnavailability': worker_unavailability,
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
      await FirebaseFirestore.instance.collection('workers').add(dataMap);

      // Close the progress dialog
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      // Clear the form fields
      nameController.clear();
      genderController.clear();
      majorTasksController.clear();
      otherTasksController.clear();
      dailyWages8HoursController.clear();
      dailyWages12HoursController.clear();

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
          controller: genderController,
          decoration: InputDecoration(labelText: 'Gender'),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: majorTasksController,
          decoration: InputDecoration(labelText: 'Major Tasks (Up to 5)'),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: otherTasksController,
          decoration: InputDecoration(labelText: 'Other Tasks'),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: dailyWages8HoursController,
          decoration: InputDecoration(labelText: 'Daily Wages for 8 Hours'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: dailyWages12HoursController,
          decoration: InputDecoration(labelText: 'Daily Wages for 12 Hours'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              value: workReduction,
              onChanged: (value) {
                setState(() {
                  workReduction = value ?? false;
                });
              },
            ),
            Text('Work Reduced Day by Day'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: worker_unavailability,
              onChanged: (value) {
                setState(() {
                  worker_unavailability = value ?? false;
                });
              },
            ),
            Text('worker_unavailability'),
          ],
        ),
        SizedBox(height: 30,),
        ElevatedButton(onPressed: (){
          uploadWorkerDataToFirebase();
        },
            child: Text("Submit"))
      ],
    );
  }
}
