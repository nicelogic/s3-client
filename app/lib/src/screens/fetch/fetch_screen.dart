import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return FetchScreenState();
  }
}

class FetchScreenState extends State<FetchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("下载文件"),
        ),
        body: Center(
            child: ElevatedButton(
                child: const Text('登录网页客户端下载文件'),
                onPressed: () => launchUrl(Uri(
                    scheme: 'https',
                    host: "dash-tenant0.env0.luojm.com",
                    port: 9443)))));
  }
}
