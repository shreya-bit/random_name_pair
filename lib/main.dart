import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    //final wordPair= WordPair.random();
    return  MaterialApp(
      title:"Name Generator",
      theme: ThemeData(
        appBarTheme:  const AppBarTheme(
          backgroundColor : Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}



class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();

    //return Text(wordPair.asUpperCase);
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Name Generator'),
              actions:[
                IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: _pushSaved,
                  tooltip: 'Saved Suggestions'
                ),
              ],
            ),
            body: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, i) {
                  //i is row iterator
                  if (i.isOdd) return const Divider();
                  final index = i ~/ 2;
                  if (index >= _suggestions.length) {
                    _suggestions.addAll(generateWordPairs().take(10));
                  }
                  final alreadySaved = _saved.contains(_suggestions[index]);
                  return ListTile(
                      title: Text(
                        _suggestions[index].asUpperCase,
                        style: _biggerFont,
                      ),
                      trailing: Icon(
                        alreadySaved ? Icons.favorite : Icons.favorite_border,
                        color: alreadySaved ? Colors.red : null,
                        semanticLabel: alreadySaved
                            ? 'Remove from saved'
                            : 'Save',
                      ),
                      onTap: () {
                        setState(() {
                          if (alreadySaved) {
                            _saved.remove(_suggestions[index]);
                          }
                          else {
                            _saved.add(_suggestions[index]);
                          }
                        });
                      }
                  );
                }
            )
        )
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:(context) {
          final tiles = _saved.map(
              (pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
          );
          final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(
            context:context,
            tiles: tiles,
          ).toList()
              :<Widget>[];

          return Scaffold(
            appBar: AppBar(
              title:const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

