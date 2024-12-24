import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

//todo move to card builder and apply DRY
  Widget _buildNavigationCard(
      BuildContext context, String cardText, String navigationPath) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, navigationPath);
      },
      child: Card(
        elevation: 4,
        child: Center(child: Text(cardText)),
      ),
    );
  }

  Widget _buildNavigationCardWithHeader(BuildContext context,
      String cardHeaderText, Widget cardBody, String navigationPath) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, navigationPath);
      },
      child: Card(
        elevation: 4,
        child: Center(
            child: Column(
          children: [
            Flexible(
              fit: FlexFit.loose, // Take only as much space as needed
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ), // Clip only the top corners(
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      cardHeaderText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            //const SizedBox(height: 8), // Space between header and body
            Expanded(child: cardBody),
          ],
        )),
      ),
    );
  }

  Widget _buildCollectionProgress(double percentage) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.green.withOpacity(percentage / 100),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("stat1"),
            Text("$percentage %"),
          ],
        ),
      ),
    );
  }

  Widget _buildGridViewTwoColumns(List<Widget> children,
      {double childAspectRatio = 1}) {
    return GridView.count(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 8, // Space between columns
        mainAxisSpacing: 8, // Space between rows
        childAspectRatio: childAspectRatio, // Aspect ratio for each tile
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: children);
  }

  Widget _buildNavigationSection(BuildContext context) {
    return _buildGridViewTwoColumns([
      _buildNavigationCard(context, "Add word", '/newword'),
      _buildNavigationCard(context, "Practice", '/exercisesselector'),
      _buildNavigationCard(context, "See words", '/wordlist'),
      _buildNavigationCard(context, "See collections", '/wordcollections'),
    ], childAspectRatio: 4.0);
  }

  Widget _buildProgressSection(BuildContext context) {
    return Container(
      child: const Text("Progress stats"),
      // show overall progress - how many new words are studied and old words improved'
      // some diagram with days/words axis grid and two lines with dots at days
    );
  }

  Widget _buildRecentCollectionsSection(BuildContext context) {
    // todo apply to cards BG colors - to reflect how complete are they. From grey to green with alpha based on completion %
    return Container(
      child: Column(
        children: [
          const Text("Recent collections studied"),
          _buildGridViewTwoColumns([
            _buildNavigationCardWithHeader(
                context, "Collection 1", _buildCollectionProgress(87), '/1'),
            _buildNavigationCardWithHeader(
                context, "Collection 2", _buildCollectionProgress(12), '/2'),
            _buildNavigationCardWithHeader(
                context, "Collection 3", _buildCollectionProgress(45), '/3'),
          ], childAspectRatio: 2.0),
        ],
      ),
      // show top 3-5 recent collections.
      // show number of studied & unstudied words, and words to practice, in percent.
      // perhaps a circle diagram?
      // add button to see all collections. after navigation to col list:
      // Order collections by recency of practice (but allow to sort by alphabet too)
    );
  }

  Widget _buildFavoriteExercisesSection(BuildContext context) {
    return Container(
      child: const Text("Favorite Exercises"),
      // show top 1-3 most favorite exercises. in form of bordered buttons.
      // allow to click on them and do a quick practice
      // words would be selected randomly
    );
  }

  Widget _buildIncompleteStashesSection(BuildContext context) {
    return Container(
      child: const Text("Incomplete Stashes"),
      // show top 1-3 recent stashes (if not too old - check last edited).
      // allow to see all stashes
      // Stash is a text snippet that is being prepared to be imported as a word list later.
      // Can be any text with max length
      // todo explain it somewhere
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home page',
        ),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: [
            _buildNavigationSection(context),
            _buildProgressSection(context),
            _buildIncompleteStashesSection(context),
            _buildFavoriteExercisesSection(context),
            _buildRecentCollectionsSection(context),
          ]),
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
              Navigator.pushNamed(context, '/exercisesselector');
              break;
            case 1:
              Navigator.pushNamed(context, '/wordlist');
              break;
            case 2:
              Navigator.pushNamed(context, '/newword');
              break;
          }
        },
      ),
    );
  }
}
