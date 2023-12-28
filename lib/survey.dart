import 'package:flutter/material.dart';
import 'farmer_ques.dart';
import 'fertilizers.dart';
import 'households.dart';
import 'workers.dart';
import 'retailers.dart';
class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  String selectedGenre = 'Farmer'; // Set an initial value that matches one of the DropdownMenuItem values
  List<String> genres = ['Farmer', 'Household', 'Worker', 'Shop',"Retailer"];
  int selectedGenreIndex = 0; // Initialize with the index of the default genre
  List<Widget> wids=[FarmerSurveyForm(),HouseholdSurveyForm(),WorkerSurveyForm(),FertilizerSurveyForm(),RetailerSurveyForm()];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Survey'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4, // Adjust the elevation for the shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the border radius for curved corners
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0), // Padding for the content inside the Card
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Selected Genre:"),
                      DropdownButton<int>(
                        value: selectedGenreIndex,
                        items: genres.asMap().entries.map((entry) {
                          int index = entry.key;
                          String genre = entry.value;
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(genre),
                          );
                        }).toList(),
                        onChanged: (int? newIndex) {
                          setState(() {
                            selectedGenreIndex = newIndex!;
                          });
                        },
                      ),
                    ],
                  )

                ),
              ),
              Card(
                elevation: 4, // Adjust the elevation for the shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the border radius for curved corners
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0), // Add the desired padding here
                  child: wids[selectedGenreIndex],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
