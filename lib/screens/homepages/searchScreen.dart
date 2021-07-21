import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/models/searchMoviemodel.dart';
import 'package:mediahub/models/searchSeriesmodel.dart';
import 'package:mediahub/widgets/sMovieResult.dart';
import 'package:mediahub/widgets/sSeriesResult.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  Future resultsMovieLoaded;
  Future resultsSeriesLoaded;
  List _allMovieResults = [];
  List _allSeriesResults = [];
  List _resultsMovieList = [];
  List _resultsSeriesList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchMovieChanged);
    _searchController.addListener(_onSearchSeriesChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchMovieChanged);
    _searchController.removeListener(_onSearchSeriesChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsMovieLoaded = getMovieSnapshots();
    resultsSeriesLoaded = getSeriesSnapshots();
  }

  _onSearchMovieChanged() {
    searchMovieResultsList();
  }

  _onSearchSeriesChanged() {
    searchSeriesResultsList();
  }

  searchMovieResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allMovieResults) {
        var title =
            SearchMovieData.fromSnapshot(tripSnapshot).title.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(_allMovieResults);
    }
    setState(() {
      _resultsMovieList = showResults;
    });
  }

  searchSeriesResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allSeriesResults) {
        var title =
            SearchSeriesData.fromSnapshot(tripSnapshot).title.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(_allSeriesResults);
    }
    setState(() {
      _resultsSeriesList = showResults;
    });
  }

  getMovieSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('newmov').get();
    setState(() {
      _allMovieResults = data.docs;
    });
    searchMovieResultsList();
    return "complete";
  }

  getSeriesSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('newser').get();
    setState(() {
      _allSeriesResults = data.docs;
    });
    searchSeriesResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
                color: Colors.grey[800],
                border: Border.all(color: Colors.teal, width: 5),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.teal,
                ),
                Flexible(
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    controller: _searchController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Search Movies & series',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                SizedBox(width: 15)
              ],
            ),
          ),
          backgroundColor: Colors.grey[850],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Movies',
              ),
              Tab(
                text: 'TV Series',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: _resultsMovieList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildMovieResult(context, _resultsMovieList[index]),
                  )),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: _resultsSeriesList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildSeriesResult(context, _resultsSeriesList[index]),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
