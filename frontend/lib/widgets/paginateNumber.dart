import 'package:flutter/material.dart';

class PaginateNumber extends StatefulWidget {
  final int maxPage;

  const PaginateNumber({
    super.key,
    required this.maxPage,
  });

  @override
  State<PaginateNumber> createState() => _PaginateNumberState();
}

class _PaginateNumberState extends State<PaginateNumber> {
  List<dynamic> items = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.maxPage + 1, // Extra item for loading indicator
        itemBuilder: (context, index) {
          if (index == widget.maxPage) {
            // Display a loading indicator at the end
            return isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox.shrink();
          }
          // Display each item in the list
          return ListTile(
            title: Text(
              "1",
              style: TextStyle(color: Colors.amber),
            ), // Adjust based on your API response
          );
        },
      ),
    );
  }
}
