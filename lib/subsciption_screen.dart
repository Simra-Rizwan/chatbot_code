import "package:flutter/material.dart";

class SubsciptionScreen extends StatefulWidget {
  @override
  State<SubsciptionScreen> createState() => _SubsciptionScreenState();
}

class _SubsciptionScreenState extends State<SubsciptionScreen> {
  int? selectedIndex ;
  final List<Map<String, dynamic>> subscriptionOptions = [
    {
      'title': "Weekly",
      'days': '7 Days',
      'amount': '100 Pkr',
      'image': "assets/images/weekly_image.png",
    },
    {
      'title': "Monthly",
      'days': '30 Days',
      'amount': '1000 Pkr',
      'image': "assets/images/yearly_image.png",
    },
    {
      'title': "Yearly",
      'days': '365 days',
      'amount': '2500 Pkr',
      'image': "assets/images/monthly_image.png",
    }
  ];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7F00FF),
                Color(0xFFE100FF),
              ],
            ),
          ),
        ),
        Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      const Text("Premium",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "assets/images/crown_image.png",
                        height: 40,
                        width: 40,
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subscriptionOptions.length,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (_, __) => const SizedBox(
                              height: 20,
                            ),
                        itemBuilder: (context, index) {
                          final option = subscriptionOptions[index];
                          // TODO: check if the item is selected
                          final bool isSelected = selectedIndex == index;
                         return GestureDetector(
                              onTap: () {
                                // TODO: set the selected index value in selected index object
                                setState(() {
                                  selectedIndex=index;
                                });
                              },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              // TODO: if the index is selected then change the color of that index container
                              color:isSelected ? Colors.deepPurple : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option['title'],
                                        style:  TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                          color:isSelected? Colors.white: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        option['days'],
                                        style:  TextStyle(
                                          fontSize: 18.0,
                                          color:isSelected? Colors.white: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        option['amount'],
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color:isSelected? Colors.white: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  option['image'],
                                  height: 50,
                                ),
                              ],
                            ),
                          )
                          );
                        }),
                  ],
                ))),
      ],
    );
  }
}
