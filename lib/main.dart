import 'package:agricrew/firebase_options.dart';
import 'package:flutter/material.dart';
import 'survey.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Genre> genres = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Initialize Firebase Firestore
      final firestore = FirebaseFirestore.instance;

      // Get a list of all collections
      final collections_name = ["farmers","households","retailers","fertilizers","workers"];
      final collections=[];
      for (var i in collections_name){
        collections.add(FirebaseFirestore.instance.collection(i));
      }

      // Iterate through the collections and count documents in each
      for (final collection in collections) {
        final querySnapshot = await collection.get();
        final surveyCount = querySnapshot.size;
        final genreName = collection.id;
        genres.add(Genre(genreName, surveyCount));
      }

      // Refresh the UI
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    genres.isNotEmpty ? genres.map((genre) => genre.surveyCount).reduce((a, b) => a + b).toString() : '0',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Surveys conducted',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: genres.map((genre) => GenreCard(genre)).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SurveyScreen()),
          );
        },
        child: Icon(Icons.chat),
      ),
    );
  }
}

class Genre {
  final String genreName;
  final int surveyCount;

  Genre(this.genreName, this.surveyCount);
}

class GenreCard extends StatelessWidget {
  final Genre genre;

  GenreCard(this.genre);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CollectionDocumentsScreen(collectionName: genre.genreName),
        ),
      );}
      ,
      child: Card(
        margin: EdgeInsets.all(4),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(
                genre.genreName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Surveys: ${genre.surveyCount}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class CollectionDocumentsScreen extends StatelessWidget {
  final String collectionName;

  CollectionDocumentsScreen({required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents in $collectionName Collection'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No documents in this collection.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              // Customize the display of each document here.
              return GestureDetector(
                onTap: () {
                  // Navigate to the DetailScreen and pass the document data.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(doc.data() as Map<String, dynamic>),
                    ),
                  );
                },
                child: ListTile(
                  title: Text((doc.data() as Map<String, dynamic>)['name'] ?? 'No Title'),
                  subtitle: Text((doc.data() as Map<String, dynamic>)['des'] ?? 'No des'),
                ),
              );



            }).toList(),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> documentData;

  DetailScreen(this.documentData);

  @override
  Widget build(BuildContext context) {
    // Create a widget to display the details of the document.
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var entry in documentData.entries)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${entry.key}: ${entry.value}'),
                  Divider(), // Add a divider between entries
                ],
              ),
          ],
        ),
      ),
    );
  }
}

