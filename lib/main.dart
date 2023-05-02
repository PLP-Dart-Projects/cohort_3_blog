import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Blog'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _loading = false;
  List _posts = [];
  final TextEditingController controller = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _getPosts() async {
    setState(() {
      _loading = true;
    });
    var uri = Uri.https("blogsapi.p.rapidapi.com");
    var response = await http.get(uri, headers: {
      "X-RapidAPI-Key": "1bcc54021dmsh97d51e96ad8b6dap1fccf1jsn1291f8f0226d",
      "X-RapidAPI-Host": "blogsapi.p.rapidapi.com"
    });
    setState(() {
      _loading = false;
    });
    Map jsonResponse = jsonDecode(response.body);
    setState(() {
      _posts = jsonResponse["results"];
    });
    print(jsonResponse["count"]);
  }

  void _search() async {
    setState(() {
      _loading = true;
    });
    var uri =
        Uri.https("blogsapi.p.rapidapi.com", '', {"search": controller.text});
    var response = await http.get(uri, headers: {
      "X-RapidAPI-Key": "1bcc54021dmsh97d51e96ad8b6dap1fccf1jsn1291f8f0226d",
      "X-RapidAPI-Host": "blogsapi.p.rapidapi.com"
    });
    setState(() {
      _loading = false;
    });
    Map jsonResponse = jsonDecode(response.body);
    setState(() {
      _posts = jsonResponse["results"];
    });
    print(jsonResponse["count"]);
    // controller.text = "";
  }

  @override
  void initState() {
    // TODO: implement initState
    _getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(onPressed: _getPosts, child: Text("Get Posts")),
                SizedBox(width: 10),
                ElevatedButton(onPressed: _search, child: Text("Search")),
                SizedBox(width: 10),
                _loading ? CircularProgressIndicator() : SizedBox(),
              ],
            ),
            TextField(
              controller: controller,
              onChanged: (search) => _search(),
              decoration: InputDecoration(
                label: Text("Search"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  Map _post = _posts[index];
                  return Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        Image.network(_post["image"]),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Text(_post["excerpt"]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
