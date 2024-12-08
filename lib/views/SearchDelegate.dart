import 'package:flutter/material.dart';

class ArticleSearchDelegate extends SearchDelegate<dynamic> {
  // Implementing the buildLeading method to provide a leading icon (back button)
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search delegate
      },
    );
  }

  // Build the actions (right side icons), such as the clear button
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  // Build the search results screen, which displays matching results
  @override
  Widget buildResults(BuildContext context) {
    // You can implement the logic to show search results here based on the query.
    // For now, it's just a placeholder:
    return Center(
      child: Text('Results for "$query"'),
    );
  }

  // Build the suggestions screen, which shows suggestions as the user types
  @override
  Widget buildSuggestions(BuildContext context) {
    // You can implement logic to show suggestions based on the query.
    // For now, it's just a placeholder:
    final suggestions = query.isEmpty
        ? ['Suggestion 1', 'Suggestion 2', 'Suggestion 3']
        : ['Filtered Suggestion 1', 'Filtered Suggestion 2'];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index]; // Update the query when a suggestion is tapped
            showResults(context); // Show the search results screen
          },
        );
      },
    );
  }
}
