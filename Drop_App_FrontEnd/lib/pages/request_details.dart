import 'package:flutter/material.dart';

class ShareDetailPage extends StatelessWidget {
  const ShareDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User profile row
          Container(
            color: const Color.fromARGB(255, 108, 106, 157),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 25,
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sabrina Millies',  //CHANGE
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                         color: Colors.white,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(Icons.star, color: Colors.amber, size: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Item details section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  const Text(
                    "Item Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("Cooking pot"),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Kitchenware"),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                                backgroundColor: const Color.fromARGB(255, 251, 124, 45),
                                radius: 44,
                                child: CircleAvatar(
                                  backgroundColor: Colors.yellow[700],
                                  radius: 38,
                                  child: const CircleAvatar(
                                    backgroundColor:  Color.fromARGB(255, 234, 157, 42),
                                    radius: 26,
                                  ),
                                ),
                              ),
                          const Text("1 Coin"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "From",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("17-10-2024   18:00"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Until",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("17-10-2024   20:00"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Pot for cooking meat.\n"
                    "Preferably big enough for four people and I need the specific type that works for an induction hob.\n"
                    "Thank you.",
                  ),
                ],
              ),
            ),
            const Spacer(),

          // Chat button above the navigation bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 108, 106, 157), 
                foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: const Center(child: Text('Chat', style: TextStyle(fontSize: 18))),
            ),
          ),

          const SizedBox(height: 10), // Space between Chat button and NavBar

          // REPLACE Navigation bar
        ],
      ),
    );
  }
}