import 'package:flutter/material.dart';
import 'package:flutter_projects1/Constant/Constant.dart';
import '../../Api_Data/Api_Services/Api_Services.dart';
import '../../Api_Data/Model/Qari.dart';
import '../../CustomWidget/qariCustomListTile.dart';

class QariScreen extends StatefulWidget {
  const QariScreen({super.key});

  @override
  State<QariScreen> createState() => _QariScreenState();
}

class _QariScreenState extends State<QariScreen> {
  late Future<List<Qari>> _qariFuture;
  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    _qariFuture = _apiServices.getQariList(); // Call API once
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Qari",
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.05, // responsive font
            ),
          ),
          centerTitle: true,
          backgroundColor: Constants.kPrimary,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.08),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.03), // responsive padding
                  child: Row(
                    children: [
                      Text(
                        "Search",
                        style: TextStyle(fontSize: width * 0.045),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.search,
                        size: width * 0.06,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),

              // Qari List
              Expanded(
                child: FutureBuilder<List<Qari>>(
                  future: _qariFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                          child: Text("Qaris List Not Found"));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No Qari Found"));
                    }

                    final qariList = snapshot.data!;

                    return ListView.builder(
                      itemCount: qariList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: height * 0.005),
                          child: Qaricustomlisttile(
                            qari: qariList[index],
                            ontap: () {},
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
