import 'package:flutter/material.dart';
import 'package:movie_database/movie.dart';

class MovieDescription extends StatelessWidget {
  const MovieDescription({Key? key,required this.movie}) : super(key: key);
  final Movie movie;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        children: [
          Image.network(movie.posterPath),
          Text(movie.originalTitle,style: TextStyle(color: Colors.purple,fontSize: 42)),
          Text(movie.overview,style: TextStyle(color: Colors.purple,fontSize: 14))
        ],
      ),
    );
  }
}
