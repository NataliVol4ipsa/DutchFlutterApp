import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/newword');
                  },
                  child: const Text("Add word")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/wordlist');
                  },
                  child: const Text("See words")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/practice');
                  },
                  child: const Text("Practice")),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Words collections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Word',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/newword');
              break;
            case 1:
              Navigator.pushNamed(context, '/wordlist');
              break;
            case 2:
              Navigator.pushNamed(context, '/practice');
              break;
          }
        },
      ),
    );
  }
}
