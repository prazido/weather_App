import 'dart:async';

import 'package:flutter/material.dart';
import 'package:beginner_stage/weatherApp/model/postcClass.dart';
import 'package:beginner_stage/weatherApp/model/widget.dart';

import 'error_page.dart';

class WeatherApp extends StatefulWidget {
  WeatherAppState createState() => WeatherAppState();
}

class WeatherAppState extends State<WeatherApp> {
  late Future data;
  dynamic city = "lagos";
  bool isloading = false;
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    data = new Network().getData(city);
    search;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        title: Text("FORECAST"),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: data,
          builder: (BuildContext, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView(scrollDirection: Axis.vertical, children: [
                isloading
                    ? Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: textField(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "${snapshot.data?.city?.name},${snapshot.data?.city?.country}",
                              style: Design(),
                            ),
                          ),
                          Two(snapshot),
                        ],
                      )
              ]);
            } else {
              if (snapshot.hasError) {
                return ErrorPage();
              } else
                return Center(child: CircularProgressIndicator(color: Colors.grey,));
            }
          },
        ),
      ),
    );
  }

  TextStyle Design() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  Widget textField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onTapOutside: (pointer) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        controller: search,
        showCursor: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    color: Colors.pink.shade900,
                    style: BorderStyle.solid)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: Colors.pink, style: BorderStyle.solid)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            label: Text("Enter city/country name"),
            prefixIcon: Icon(Icons.search,color: Colors.pink),
            labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        onSubmitted: (value) async {
          if (value.isNotEmpty) {
            setState(() {
              isloading = true;
              city = value.trim().toString();
              data = Network().getData(city);
              search.clear();
            });
            Timer(Duration(seconds: 2), () {
              setState(() {
                isloading = false;
              });
            });
          } else {}
        },
      ),
    );
  }
}
