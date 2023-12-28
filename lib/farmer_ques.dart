import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class FarmerSurveyForm extends StatefulWidget {
  @override
  _FarmerSurveyFormState createState() => _FarmerSurveyFormState();
}

class _FarmerSurveyFormState extends State<FarmerSurveyForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cropsProducedController = TextEditingController();
  final TextEditingController landUsedController = TextEditingController();
  final TextEditingController expectedProfitcontroller=TextEditingController();

  double highExpenditure = 0.5; // Example values; update these as needed
  double weather = 0.3;
  double resourceAvailability = 0.8;
  double unknownDiseases = 0.2;
  double lowRates = 0.7;
  double others = 0.4;

  double expence_man_force=0;
  double expence_fertilizers=0;
  double expence_irrigation=0;
  double expence_ploughing=0;
  double expence_crop_cost=0;
  double expectedProfit = 0.0;
  double machineRent = 0.0;
  double machinePrice = 0.0;
  double monthlySalary = 0.0;
  double minimumProfit = 0.0;
  bool willingToBuyMachine = false;
  bool willingToWork=false;
  double timeForPlantation = 0.0;
  double maximumCompletionTime = 0.0;

  bool ownMachine = false;
  bool rentMachine = false;
  bool useManualLabor = false;
  bool testownMachine = false;
  bool testrentMachine = false;
  double maxMachinePrice=0;


  bool paddyCultivator = false; // Added paddyCultivator checkbox
  double paddyPlantationCost = 0.0;
  double paddyPlantationCostByMachines = 0.0;
  double paddyPlantationCostByManForce = 0.0;
  bool willingToBuyPaddyMachine_rents = false; // Added willingness to buy paddy machine checkbox
  bool willingToBuyPaddyMachine_not_rents = false; // Added willingness to buy paddy machine checkbox
  double willingtopayforPM=0.0;
  double maxPaddyPlantationTime = 0.0;

  // Custom widget for editable audio-like progress bars
  Widget buildEditableAudioProgressBar(
      String label, double progress, ValueChanged<double> onChanged
      ) {
    return Column(
      children: [
        Row(
          children: [
            Text(label),
            Spacer(), // To push the Slider and percentage to the right
            Text('${(progress * 100).toStringAsFixed(0)}%'), // Display the percentage
          ],
        ),
        Slider(
          value: progress,
          onChanged: (newValue) {
            onChanged(newValue);
          },
        ),
      ],
    );
  }
  Map<String, dynamic> createDataMap() {
    return {
      'name': nameController.text,
      'cropsProduced': cropsProducedController.text,
      'landUsed': landUsedController.text,
      'expectedProfit': expectedProfit,
      'highExpenditure': highExpenditure,
      'weather': weather,
      'resourceAvailability': resourceAvailability,
      'unknownDiseases': unknownDiseases,
      'lowRates': lowRates,
      'others': others,
      'expence_man_force': expence_man_force,
      'expence_fertilizers': expence_fertilizers,
      'expence_irrigation': expence_irrigation,
      'expence_ploughing': expence_ploughing,
      'expence_crop_cost': expence_crop_cost,
      'expectedProfit': expectedProfit,
      'machineRent': machineRent,
      'machinePrice': machinePrice,
      'monthlySalary': monthlySalary,
      'minimumProfit': minimumProfit,
      'willingToBuyMachine': willingToBuyMachine,
      'willingToWork': willingToWork,
      'timeForPlantation': timeForPlantation,
      'maximumCompletionTime': maximumCompletionTime,
      'ownMachine': ownMachine,
      'rentMachine': rentMachine,
      'useManualLabor': useManualLabor,
      'testownMachine': testownMachine,
      'testrentMachine': testrentMachine,
      'maxMachinePrice': maxMachinePrice,
      'paddyCultivator': paddyCultivator,
      'paddyPlantationCost': paddyPlantationCost,
      'paddyPlantationCostByMachines': paddyPlantationCostByMachines,
      'paddyPlantationCostByManForce': paddyPlantationCostByManForce,
      'willingToBuyPaddyMachine_rents': willingToBuyPaddyMachine_rents,
      'willingToBuyPaddyMachine_not_rents': willingToBuyPaddyMachine_not_rents,
      'willingtopayforPM': willingtopayforPM,
      'maxPaddyPlantationTime': maxPaddyPlantationTime,
    };
  }


  bool isUploading = false; // Flag to track if data is being uploaded

  Future<void> uploadDataToFirebase(BuildContext context) async {
    setState(() {
      isUploading = true; // Start uploading, show circular progress
    });

    Map<String, dynamic> dataMap = createDataMap();

    try {
      final docRef = await FirebaseFirestore.instance.collection('farmers').add(dataMap);
      print('Data uploaded successfully with document ID: ${docRef.id}');

      setState(() {
        isUploading = false; // Upload completed, hide circular progress
      });

      // Navigate to a new page (HomeScreen in this example)
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
  void dispose() {
    nameController.dispose();
    cropsProducedController.dispose();
    landUsedController.dispose();
    super.dispose();
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
          controller: cropsProducedController,
          decoration: InputDecoration(labelText: 'Crops Produced'),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: landUsedController,
          decoration: InputDecoration(labelText: 'Land Used'),
        ),
        SizedBox(height: 50),
        // You can add more text input fields as needed
        Text(
          "Contributions for losses",
          style: TextStyle(fontSize: 20), // Set the font size to 20
        ),

        SizedBox(height: 20),
        // Editable audio-like progress bars
        buildEditableAudioProgressBar('High Expenditure', highExpenditure, (newValue) {
          setState(() {
            highExpenditure = newValue;
          });
        }),
        buildEditableAudioProgressBar('Weather', weather, (newValue) {
          setState(() {
            weather = newValue;
          });
        }),
        buildEditableAudioProgressBar('Resource Availability', resourceAvailability, (newValue) {
          setState(() {
            resourceAvailability = newValue;
          });
        }),
        buildEditableAudioProgressBar('Unknown Diseases', unknownDiseases, (newValue) {
          setState(() {
            unknownDiseases = newValue;
          });
        }),
        buildEditableAudioProgressBar('Low Rates', lowRates, (newValue) {
          setState(() {
            lowRates = newValue;
          });
        }),
        buildEditableAudioProgressBar('Others', others, (newValue) {
          setState(() {
            others = newValue;
          });
        }),
        SizedBox(height: 50),
        // You can add more text input fields as needed
        Text(
          "Contributions for Expense",
          style: TextStyle(fontSize: 20), // Set the font size to 20
        ),

        SizedBox(height: 20),
        buildEditableAudioProgressBar('Man force', expence_man_force, (newValue) {
          setState(() {
            expence_man_force = newValue;
          });
        }),
        buildEditableAudioProgressBar('MFertilizers', expence_fertilizers, (newValue) {
          setState(() {
            expence_fertilizers = newValue;
          });
        }),
        buildEditableAudioProgressBar('Irrigation', expence_irrigation, (newValue) {
          setState(() {
            expence_irrigation = newValue;
          });
        }),
        buildEditableAudioProgressBar('Ploughing', expence_ploughing, (newValue) {
          setState(() {
            expence_ploughing = newValue;
          });
        }),
        buildEditableAudioProgressBar('Other crop cost', expence_crop_cost, (newValue) {
          setState(() {
            expence_crop_cost = newValue;
          });
        }),
        SizedBox(height: 30,),

        Text("Are you willing to work with contract farming and online platforms?"),
        Row(
          children: [
            Radio(
              value: true,
              groupValue: willingToWork,
              onChanged: (value) {
                setState(() {
                  willingToWork = value ?? false;
                });
              },
            ),
            Text("Yes"),
            Radio(
              value: false,
              groupValue: willingToWork,
              onChanged: (value) {
                setState(() {
                  willingToWork = value ?? false;
                });
              },
            ),
            Text("No"),
          ],
        ),

        Text("How much profit do you expect from a yield of 100 rupees?"),

        TextFormField(
          controller: expectedProfitcontroller,
          decoration: InputDecoration(labelText: 'Expected profit'),
        ),
        // Button to submit the form
        SizedBox(height: 20,),

        CheckboxListTile(
          title: Text('Own a machine'),
          value: ownMachine,
          onChanged: (bool? value) {
            setState(() {
              ownMachine = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Take a machine on rent'),
          value: rentMachine,
          onChanged: (bool? value) {
            setState(() {
              rentMachine = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Use manual labor'),
          value: useManualLabor,
          onChanged: (bool? value) {
            setState(() {
              useManualLabor = value ?? false;
            });
          },
        ),
        SizedBox(height: 25,),
        Text("At what price you wish to buy a machine maximum?"
    "consider a process need 5000 for an acre rupees by manforce  "
    "renting machine costs 2500 And its a 3 months time crop.do you "
            "wish to buy a machine at 80000 considering giving for rents to others,50000 "
            " if not how you are willing to pay for it."),

        CheckboxListTile(
          title: Text('Own a machine'),
          value: testownMachine,
          onChanged: (bool? value) {
            setState(() {
              testownMachine = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Take a machine on rent'),
          value: testrentMachine,
          onChanged: (bool? value) {
            setState(() {
              testrentMachine = value ?? false;
            });
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Maximum Price for Machine',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              maxMachinePrice = double.tryParse(value) ?? 0.0;
            });
          },
        ),

        SizedBox(height: 25),
        Text("-----Paddy------",style: TextStyle(fontSize: 20), ),


        Row(
          children: [
            Checkbox(
              value: paddyCultivator,
              onChanged: (value) {
                setState(() {
                  paddyCultivator = value ?? false;
                });
              },
            ),
            Text('Paddy Cultivator'),
          ],
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Paddy Plantation Cost',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              paddyPlantationCost = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Paddy Plantation Cost by Machines',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              paddyPlantationCostByMachines = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        SizedBox(height: 25),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Paddy Plantation Cost by Man Force',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              paddyPlantationCostByManForce = double.tryParse(value) ?? 0.0;
            });
          },
        ),

        // Checkboxes and input fields for paddy machine// Input fields for paddy plantation time
        SizedBox(height: 25),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Maximum Paddy Plantation Time',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              maxPaddyPlantationTime = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        SizedBox(height: 25),
        Text("are you willing to buy a paddy planting machine at 80000 considering giving it "
            "for rents to other farmers and at 50000 not considering for rents?"
        ),
        Row(
          children: [
            Checkbox(
              value: willingToBuyPaddyMachine_rents,
              onChanged: (value) {
                setState(() {
                  willingToBuyPaddyMachine_rents = value ?? false;
                });
              },
            ),
            Text('consider rents'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: willingToBuyPaddyMachine_not_rents,
              onChanged: (value) {
                setState(() {
                  willingToBuyPaddyMachine_not_rents = value ?? false;
                });
              },
            ),
            Text('not consider rents'),
          ],
        ),


        TextFormField(
          decoration: InputDecoration(
            labelText: 'Maximum Price for Machine',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              willingtopayforPM = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        SizedBox(height: 40,),
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
