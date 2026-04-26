import 'package:flutter/material.dart';
import 'product_details.dart';

class CategoryItemsPage extends StatefulWidget {
  final String title;
  final List<String> subCategories;
  final List<Map<String, String>> allItems;

  const CategoryItemsPage({
    super.key, 
    required this.title, 
    required this.subCategories, 
    required this.allItems
  });

  @override
  State<CategoryItemsPage> createState() => _CategoryItemsPageState();
}

class _CategoryItemsPageState extends State<CategoryItemsPage> {
  String selectedSub = "";

  @override
  void initState() {
    super.initState();
    if (widget.subCategories.isNotEmpty) {
      selectedSub = widget.subCategories.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 'Office Pants' සහ අනෙකුත් සියලුම දත්ත සඳහා ගැලපෙන පෙරනය
    final filteredItems = widget.allItems.where((item) {
      String itemType = (item['type'] ?? "").trim().toLowerCase();
      String currentSelected = selectedSub.trim().toLowerCase();
      
      // 1. නම හරියටම ගැලපේදැයි බැලීම
      bool isExactMatch = itemType == currentSelected;

      // 2. 'Office Pants' හෝ 'Office Trousers' වැනි අවස්ථා සඳහා නම්‍යශීලීව පරීක්ෂා කිරීම
      // මෙහිදී 'Pants' හෝ 'Trousers' යන වචන දෙකම එක ලෙස සලකා පරීක්ෂා කරයි
      bool isOfficeMatch = (currentSelected.contains("office") && 
                           (itemType.contains("pants") || itemType.contains("trouser") || itemType.contains("office")));

      return isExactMatch || isOfficeMatch || currentSelected.contains(itemType) || itemType.contains(currentSelected);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 
        backgroundColor: const Color(0xFFD4AF37), // Gold
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          // Category Icons (Skirts, Blouses, Office Pants, etc.)
          SizedBox(
            height: 130, 
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.subCategories.length,
              itemBuilder: (context, index) {
                String subName = widget.subCategories[index];
                bool isSelected = selectedSub == subName;

                return GestureDetector(
                  onTap: () => setState(() => selectedSub = subName),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSelected 
                                ? Border.all(color: const Color(0xFFFF1493), width: 3) 
                                : null,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF1493), Color(0xFFD4AF37)],
                            ),
                          ),
                          child: const Icon(Icons.checkroom, color: Colors.white, size: 30),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subName, 
                          style: TextStyle(
                            fontSize: 11, 
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xFFFF1493) : Colors.black,
                          )
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const Divider(),

          // භාණ්ඩ පෙන්වන GridView එක
          Expanded(
            child: filteredItems.isEmpty 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off, size: 60, color: Colors.grey),
                      const SizedBox(height: 15),
                      Text("No items found in '$selectedSub'", 
                        style: const TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    childAspectRatio: 0.7, 
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ProductDetails(product: item))
                      ),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                child: Image.asset(
                                  item['image'] ?? '', 
                                  fit: BoxFit.cover, 
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) => 
                                      const Center(child: Icon(Icons.broken_image)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] ?? '', 
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['price'] ?? '', 
                                    style: const TextStyle(color: Color(0xFFFF1493), fontWeight: FontWeight.bold)
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}