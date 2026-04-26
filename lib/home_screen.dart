import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'category_items_page.dart';
import 'cart_page.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  
  final GlobalKey womensKey = GlobalKey();
  final GlobalKey mensKey = GlobalKey();
  final GlobalKey kidsKey = GlobalKey();
  final GlobalKey bagsKey = GlobalKey();
  final GlobalKey shoesKey = GlobalKey();

  final LinearGradient shopNowGradient = const LinearGradient(
    colors: [Color(0xFFD4AF37), Colors.white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  // සර්ච් කළ විට පෙන්වන පණිවිඩය
  void _onSearchSubmitted(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Searching for: $value"), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 45),
          
          // --- 1. HEADER WITH GOLD WELCOME TEXT ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: const Text(
                      "WELCOME TO SECRETS OF FASHION", 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFD4AF37), // Gold Color
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic, // Italic
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black, size: 28),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/LOGO 1.png'),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 15),

          // --- 2. ACTIVE SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFFFB6C1).withOpacity(0.5)), // Light Pink Border
              ),
              child: TextField(
                // මේක HomeScreen එක ඇතුළේ දාන්න
String searchKey = "";

void _onSearchSubmitted(String value) {
  setState(() {
    searchKey = value.toLowerCase();
  });
}

// StreamBuilder එකේ query එක මේ විදිහට වෙනස් කරන්න
stream: (searchKey.isEmpty) 
    ? FirebaseFirestore.instance.collection('products').snapshots()
    : FirebaseFirestore.instance.collection('products')
        .where('name_lowercase', isGreaterThanOrEqualTo: searchKey)
        .where('name_lowercase', isLessThanOrEqualTo: searchKey + '\uf8ff')
        .snapshots(),
                decoration: const InputDecoration(
                  hintText: "Search Secrets of Fashion...",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // --- 3. CATEGORY TABS ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _categoryTab("Womens", () => _scrollToSection(womensKey)),
                _categoryTab("Mens", () => _scrollToSection(mensKey)),
                _categoryTab("Kids", () => _scrollToSection(kidsKey)),
                _categoryTab("Bags", () => _scrollToSection(bagsKey)),
                _categoryTab("Shoes", () => _scrollToSection(shoesKey)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // --- BANNER ---
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 200, // බැනර් එකේ උස සුදුසු පරිදි වෙනස් කළා
                    width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/BANNER.png', 
                        fit: BoxFit.cover, 
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // --- NEW ARRIVALS (FIRESTORE) ---
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("LATEST ARRIVALS", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF1493))),
                    ),
                  ),
                  
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 260,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('products').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) return const Center(child: Text("Something went wrong"));
                        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 10),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var product = snapshot.data!.docs[index];
                            return Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 12),
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        child: Image.network(product['imageUrl'], fit: BoxFit.cover, width: double.infinity),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 4),
                                          Text("Rs. ${product['price']}", style: const TextStyle(color: Color(0xFFFF1493), fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- SECTIONS ---
                  _buildWideSection(womensKey, "Womens Collection", womensItems, ["Skirts", "Blouses", "Office Trousers", "Denim", "Croptops", "Frocks"]),
                  _buildWideSection(mensKey, "Mens Collection", mensItems, ["Shirts", "T-Shirts", "Trousers", "Denim"]),
                  _buildWideSection(kidsKey, "Kids Collection", kidsItems, ["Boy", "Girl", "Toys"]),
                  _buildWideSection(bagsKey, "Bags Collection", bagItems, ["Handbags", "Backpacks", "Clutches", "Wallets"]),
                  _buildWideSection(shoesKey, "Shoes Collection", shoesItems, ["Heels", "Sneakers", "Stands", "Office Shoes"]),
                  
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryTab(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 5),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFF1493), 
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget _buildWideSection(GlobalKey key, String title, List<Map<String, String>> items, List<String> subCats) {
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEEDC82)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFFDE7),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryItemsPage(title: title, subCategories: subCats, allItems: items)));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    gradient: shopNowGradient,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD4AF37)),
                  ),
                  child: const Text("SHOP NOW", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}