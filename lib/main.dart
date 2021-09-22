import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_database/movie.dart';
/// import http package and make an object http.
import 'package:http/http.dart' as http;
import 'package:movie_database/movie_description.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Find My Movie'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Add the future method which has returns the List<Movies>
  /// 1. Uri.Parse to get the url in proper encoded format.
  /// 2. Uri.encode full to handle movies with space in it.
  /// 3. Explain async and await functionality
  /// 4. Need of jsonDecode method.
  /// 5. Push all jsonData fetched in MovieList.

  /// Search functionality
  TextEditingController _movieNameController = new TextEditingController();




  Future<List<Movie>> _getMovies(var movieName) async {
    ///Added after 2.2
    String movieURL = Uri.encodeFull(
        'https://api.themoviedb.org/3/search/movie?api_key=753d7942043deaba39f0e512331e2414&language=en-US&query=' +
            movieName +
            '&page=1&include_adult=false&sort_by=popularity.desc');

    /// Removed after 2.2
    /// print(movieURL);
    var url = Uri.parse(movieURL);

    /// 2.3 Tell about Asynchronous programming.
    var data = await http.get(url);

    /// 2.4
    /// Uncomment this line to see the difference.
    /// print(data);+
    /// if we print this line we get and output of instance of response.
    /// To decode it into json use jsonDecode method.
    ///
    var jsonData = jsonDecode(data.body);

    /// 2.4 continued. See the result of using jsonDecode method.
    print(jsonData["results"]);

    List<Movie> movies = [];

    /// 2.5 Pushing data received from jsonData[results] to movie list variable.
    /// Sometimes posterPath is null so we need to put a null check or placeholder image
    var posterPathNotFound = "https://www.publicdomainpictures.net/pictures/280000/velka/not-found-image-15383864787lu.jpg";
    for (var movie in jsonData["results"]) {
      var poster;
      if(movie["poster_path"] == null)
        poster = posterPathNotFound;
      else
        poster = "https://image.tmdb.org/t/p/w500" + movie["poster_path"];
      Movie movieObj = Movie(
          id: movie["id"],
          originalTitle: movie["title"],
          overview: movie["overview"],
          posterPath: poster);
      movies.add(movieObj);
      print(poster);
    }
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    /// Remove this last line from version 3
    /// _getMovies("Jab we met");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        /*
              GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //number of columns
                      crossAxisCount: 2,
                  ),
                  itemCount: 30,
                  itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: Colors.amber,
                          child: Center(child: Text((index+1).toString())),
                      );
                  }
              ),
          */


          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter your movie",
                      ),
                      controller: _movieNameController,
                    ),
                  ),
                  ElevatedButton(onPressed: () {
                    setState(() {
                      print(_movieNameController.text);
                      //_getMovies(_movieNameController.text);
                    });

                  },
                      child: Text("Search"))
                ],
              ),


              SizedBox(
                height: 600,
                /// 3.1 Add future builder to incorporate the future method
                ///     add add to the child method.
                child: FutureBuilder(
                  future: _getMovies(_movieNameController.text),
                  /// 3.2 Builder will have context and AsyncSnapshot which will be
                  ///     returned by the future.
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    /// 3.3 Builder to return GridView.builder.
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //number of columns
                          crossAxisCount: 2,
                        ),
                        /// 3.4 itemCount -> check for null check. Use the ternary
                        ///     operator for the null check. if null return 0 or else
                        ///     add the snapshot.data.length
                        itemCount: snapshot.data==null?0:snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.amber,
                            /// 3.5 Remove the child method and replace it with new method.
                            /// child: Center(child: Text((snapshot.data[index].originalTitle))),
                            child : Column(
                              children: [
                                SizedBox(
                                  height: 130,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(snapshot.data[index].posterPath,fit: BoxFit.fitHeight,),
                                  ),
                                ),
                                ElevatedButton(onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDescription(movie:snapshot.data[index]),
                                    ),
                                  );
                                }, child: Text("Know more"))
                              ],
                            ),

                          );
                        });
                  },
                ),
              ),
            ],
          )),
    );
  }

}
