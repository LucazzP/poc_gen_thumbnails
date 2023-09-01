import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poc_gen_thumbnails/thumbnail_gen_page.dart';
import 'package:screenshot/screenshot.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  final screenshotController = ScreenshotController();
  Uint8List? imageBytes;

  Future<XFile?> getFileFromPicker() {
    // return ImagePicker().pickImage(source: ImageSource.gallery);
    return FilePicker.platform.pickFiles().then((value) {
      if (value == null) return null;
      return XFile(value.files.single.path!);
    });
  }

  Future<void> generateThumbnail(
    BuildContext context,
    XFile source,
    int maxWidth,
    int maxHeight,
  ) async {
    final image = await screenshotController.captureFromWidget(
      ThumbnailGenPage(source: source, maxWidth: maxWidth, maxHeight: maxHeight),
      context: context,
      delay: const Duration(milliseconds: 200),
      pixelRatio: MediaQuery.of(context).devicePixelRatio,
      targetSize: Size(maxWidth.toDouble(), maxHeight.toDouble()),
    );
    setState(() {
      imageBytes = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (imageBytes != null) Image.memory(imageBytes!),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final image = await getFileFromPicker();
          if (image == null) return;
          setState(() {
            isLoading = true;
          });
          try {
            await generateThumbnail(
              context,
              image,
              100,
              100,
            );
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        tooltip: 'Increment',
        child: isLoading ? const CircularProgressIndicator() : const Icon(Icons.add),
      ),
    );
  }
}
