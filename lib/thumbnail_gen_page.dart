import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:thumbnailer/thumbnailer.dart';

class ThumbnailGenPage extends StatelessWidget {
  final XFile source;
  final int maxWidth;
  final int maxHeight;

  const ThumbnailGenPage(
      {super.key, required this.source, required this.maxWidth, required this.maxHeight});

  @override
  Widget build(BuildContext context) {
    // renders a small image to be used as a thumbnail
    // this page will be invisible for the user, it will be used only to generate the thumbnail
    // doing that by taking a screenshot of the image widget
    return SizedBox(
      width: maxWidth.toDouble(),
      height: maxHeight.toDouble(),
      child: thumbWidget(),
    );
  }

  Widget thumbWidget() {
    String? mimeType = source.mimeType;
    if (mimeType == null) {
      // determine mime type from file extension
      final fileExtension = source.path.split('.').last;
      if (['png', 'jpg'].contains(fileExtension)) {
        mimeType = 'image/$fileExtension';
      } else {
        mimeType = 'application/$fileExtension';
      }
    }
    return Thumbnail(
      mimeType: 'application/pdf',
      widgetSize: maxWidth.toDouble(),
      dataResolver: () => source.readAsBytes(),
    );
  }
}
