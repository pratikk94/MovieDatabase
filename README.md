#Movie Querying Database.

Api Key : 753d7942043deaba39f0e512331e2414
Example : https://api.themoviedb.org/3/movie/550?api_key=753d7942043deaba39f0e512331e2414
Link : https://developers.themoviedb.org/3/search/search-movies
Sample API : https://api.themoviedb.org/3/search/movie?api_key=753d7942043deaba39f0e512331e2414&language=en-US&query=Aquaman&page=1&include_adult=false 

#PreRequisites 
For api testing:
1. Postman. 

For Flutter applications to run:
1. Android Studio.
2. Flutter SDK.

#Step 0 : House Keeping
1. Remove all the comments. 
2. Remove button and TextView and counter.
3. Change the app bar heading to FindMyMovie.
4. Change the background color of AppBar. I changed to purple.

#Step 1 : Create a base layout for image.
1. Remove all elements of the center widget.
2. Replace with this : 

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


#Step 1 : Create Placeholder for movieDatabase.
class Movie{
    final int id;
    final int originalTitle;
    final int overview;
    final int posterPath;
    Movie({required this.id,required this.originalTitle,required this.overview,required this.posterPath});
}

#Step 2 : Future.
1. Add http: ^0.13.3 to pubspec.yaml
2. Define method
Future<List<Movie>> _getMovies(var movieName) async {
    String movieURL = Uri.encodeFull('https://api.themoviedb.org/3/search/movie?api_key=753d7942043deaba39f0e512331e2414&language=en-US&query='+movieName+'&page=1&include_adult=false');
    var url = Uri.parse(movieURL);
    var data = await http.get(url);
    print(data);
    var jsonData = jsonDecode(data.body);
    print(jsonData["results"]);
    List<Movie> movies = [];
    for(var movie in jsonData["results"]){
        Movie movieObj = Movie(id: movie["id"], originalTitle: movie["original_title"], overview: movie["overview"], posterPath: movie["poster_path"]);
        movies.add(movieObj);
    }
    return movies;
}


#Step 3 List view Population.
1. Add future builder
child: FutureBuilder(
    future: _getMovies("Endgame"),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
        ),
        itemCount: snapshot.data==null?0:snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
        return Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.amber,
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
                        }, child: Text("Know more")
                    )
                ],
            ),
        );
    });
    },
)


#Step 4 Add information to the description phase 
1. Add stateless widget.
2. Pass Movie widget.
3. Populate the view.

#Step 5 
1. Add search functionality.