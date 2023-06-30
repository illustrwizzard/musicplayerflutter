import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(SongDetailsApp());
}

class SongDetailsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SongDetailsScreen(),
    );
  }
}

class SongDetailsScreen extends StatefulWidget {
  @override
  _SongDetailsScreenState createState() => _SongDetailsScreenState();
}

class _SongDetailsScreenState extends State<SongDetailsScreen> {
  Future<Map<String, dynamic>> fetchSongDetails() async {
    final String apiUrl = 'https://api.genius.com/search?q=songs/378195'; // Replace with your specific API endpoint

    final Map<String, String> headers = {
      'Authorization': 'Bearer add api',
    };

    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final songDetails = jsonData['response']['song'];
      return songDetails;
    } else {
      throw Exception('Failed to fetch song details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchSongDetails(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final songDetails = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(songDetails!['header_image_url']),
                    SizedBox(height: 16.0),
                    Text(
                      songDetails['full_title'],
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text('Artist: ${songDetails!['artist_names']}'),
                    SizedBox(height: 8.0),
                    Text('Release Date: ${songDetails!['release_date_for_display']}'),
                    SizedBox(height: 8.0),
                    Text('Description: ${songDetails['description']}'),
                    SizedBox(height: 8.0),
                    Text('Lyrics State: ${songDetails['lyrics_state']}'),
                    SizedBox(height: 8.0),
                    Text('Lyrics Placeholder Reason: ${songDetails!['lyrics_placeholder_reason']}'),
                    SizedBox(height: 8.0),
                    Text('Pyongs Count: ${songDetails['pyongs_count']}'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

