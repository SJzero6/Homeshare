import 'package:flutter/material.dart';
import 'package:homeshare/Screens/Animations/login_prompt_dialog.dart';
import 'package:homeshare/services/phone_auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Account',
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6FD3A8), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // 🔒 FIXED HEADER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?img=3',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Good Morning",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Budiono Siregar",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔍 Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔽 SCROLLABLE CONTENT STARTS HERE
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Categories card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.only(top: 16, bottom: 24),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  categoryItem(
                                    Icons.hotel_rounded,
                                    "Bed Space",
                                  ),
                                  categoryItem(Icons.home_rounded, "Studio"),
                                  categoryItem(Icons.villa_rounded, "Rooms"),
                                  categoryItem(Icons.sell_rounded, "Sell/Buy"),
                                ],
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "All Category",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Icon(Icons.arrow_forward_ios, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Property Listings
                      propertyCard(
                        onTap: () {
                          final user = Provider.of<OEmailAuthProvider>(
                                    context,
                                    listen: false,
                                  ).currentUser;
                                  if (user == null) {
                                    // Not logged in, show dialog
                                    showDialog(
                                      context: context,
                                      builder: (_) => const LoginPromptDialog(),
                                    );
                                  } else {
                                    // Proceed to room details
                                    print('object is coming');
                                  }
                        },
                        imageUrl:
                            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
                        title: 'Whispering Pines Lakeview Estate',
                        price: '\$850,000',
                        beds: 4,
                        baths: 3,
                        sqft: 7500,
                        rating: 4.9,
                        reviews: 123,
                      ),
                      const SizedBox(height: 20),
                      propertyCard(
                        onTap: () {
                          
                        },
                        imageUrl:
                            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
                        title: 'Luxury Family Home',
                        price: '\$990,000',
                        beds: 5,
                        baths: 4,
                        sqft: 8600,
                        rating: 4.8,
                        reviews: 98,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28, color: Colors.green),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget propertyCard({
  required String imageUrl,
  required String title,
  required String price,
  required int beds,
  required int baths,
  required int sqft,
  required double rating,
  required int reviews,
  required VoidCallback onTap, // <-- Add this
}) {
  return GestureDetector(
    onTap: onTap, // <-- Handle tap
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.circle, size: 8, color: Colors.green),
                    SizedBox(width: 4),
                    Text('For Sale', style: TextStyle(color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$beds Bed   $baths Bath   $sqft sqft',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$rating Rating ($reviews review)',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}