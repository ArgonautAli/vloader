import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late TextEditingController textEditingController;
  late WebViewController webViewController;
  String searchEngineUrl = "https://google.com";
  var uTubeUrl;
  bool isLoading = false;
  final List actions = ["back", "forward", "reload"];

  @override
  void initState() {
    textEditingController = TextEditingController(text: searchEngineUrl);
    webViewController = WebViewController();
    webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webViewController
        .setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
      textEditingController.text = url;
      setState(() {
        isLoading = true;
      });
    }, onPageFinished: (url) {
      setState(() {
        isLoading = false;
      });
    }));
    loadUrl(textEditingController.text);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  void _downloadVideo() async {
    var url = await webViewController.currentUrl();
    var ytExplode = YoutubeExplode();
    debugPrint('videourl:${url}');

    var video = await ytExplode.videos.get(url);

    debugPrint('video:${video}');

    var manifest = await ytExplode.videos.streamsClient.getManifest(video);

    var streamInfo = manifest.audioOnly.first;
    var videoStream = manifest.video.first;

    var audioStream = ytExplode.videos.streamsClient.get(streamInfo);
    var videoFile = await ytExplode.videos.streamsClient.get(videoStream);
    debugPrint('videoFile:${videoFile}');
    // Implement file saving logic here
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
            child: Scaffold(
              body: Stack(
                children: [
                  Column(children: [
                    _buildTopWidget(),
                    _buildLoadingWidget(),
                    Expanded(child: _buildWebWidget()),
                    _buildBottomWidget(),
                  ]),
                  Positioned(
                      bottom: 60.0,
                      right: 16.0,
                      child: FloatingActionButton(
                        onPressed: () {
                          _downloadVideo();
                        },
                        backgroundColor: Colors
                            .purple, // Use custom color similar to YouTube's red
                        child: Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ),
            onWillPop: onWillPop));
  }

  Future<bool> onWillPop() {
    return Future.value(false);
  }

  loadUrl(String value) {
    Uri uri = Uri.parse(value);
    print('uri:${uri} ');
    if (!uri.isAbsolute) {
      uri = Uri.parse("${searchEngineUrl}/search?q=$value");
    }
    webViewController.loadRequest(uri);
    setState(() {
      uTubeUrl = uri;
    });
  }

  _buildTopWidget() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(32))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  loadUrl(searchEngineUrl);
                },
                icon: const Icon(Icons.home)),
            Expanded(
                child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search or type web address",
                    ),
                    onSubmitted: (value) {
                      loadUrl(value);
                    })),
            IconButton(
                onPressed: () {
                  textEditingController.clear();
                },
                icon: const Icon(Icons.cancel)),
          ],
        ),
      ),
    );
  }

  _buildLoadingWidget() {
    return Container(
        height: 2,
        color: Colors.grey,
        child: isLoading ? const LinearProgressIndicator() : Container());
  }

  _buildWebWidget() {
    return WebViewWidget(controller: webViewController);
  }

  _buildBottomWidget() {
    return BottomNavigationBar(
      onTap: (value) async {
        print("value:${actions[value]}");
        if (actions[value] == "back") {
          if (await webViewController.canGoBack()) {
            await webViewController.goBack();
          }
        }
        if (actions[value] == "forward") {
          if (await webViewController.canGoForward()) {
            await webViewController.goForward();
          }
        }
        if (actions[value] == "reload") {
          await webViewController.reload();
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
        BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward), label: "Forward"),
        BottomNavigationBarItem(
            icon: Icon(Icons.replay_outlined), label: "Reload"),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedItemColor: Colors.black54,
      selectedItemColor: Colors.black54,
    );
  }
}
