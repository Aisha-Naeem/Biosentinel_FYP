import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white), // Header text color set to white
        ),
        backgroundColor: const Color(0xFF1E3A5F), // Deep Blue for the AppBar
        iconTheme: const IconThemeData(color: Colors.white), // Back icon set to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search courses, sessions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // Implement search functionality
                setState(() {
                  searchResults = _performSearch(value);
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(searchResults[index]),
                      onTap: () {
                        // Handle search result selection
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _performSearch(String query) {
    // Mock search results - replace with actual search logic
    final allItems = [
      'AI Basics - Session 10:10-11:45',
      'Advanced Flutter - Session 1:45-3:15',
      'Machine Learning Fundamentals',
      'Mobile App Development',
      'Data Structures',
    ];

    if (query.isEmpty) return [];

    return allItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
