// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:food_menu/widgets/loading/loading_dialog.dart';
import '/utils/file%20handling/custom_file_picker.dart';

import '/widgets/styled_text.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

class ImagePickerIcon extends StatefulWidget {
  String url;
  Uint8List? data;
  bool changed = false;
  Function? refresh;
  ImagePickerIcon({
    this.url = "",
    this.data,
    this.refresh,
    super.key,
  }) {
    //print(url);
  }

  Uint8List? get value {
    return data;
  }

  void set value(Uint8List? val) {
    data = val;
  }

  @override
  State<ImagePickerIcon> createState() => _ImagePickerIconState();
}

class _ImagePickerIconState extends State<ImagePickerIcon> {
  Future<void> onTap() async {
    
    List<PlatformFile> res = await CustomFilePicker.pickImages();
    if (res.isEmpty) {
      return;
    }
    print("res.first.name: ${res.first.name}");
    print("res.first.extension: ${res.first.extension}");
    widget.data = res.first.bytes;
    widget.changed = true;

    if (mounted) setState(() {});

    if (widget.refresh != null) {
      widget.refresh!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        showLoadingDialog(
          context: context,
          f1: onTap,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100000),
          color: Colors.grey.withOpacity(0.7),
        ),
        padding: EdgeInsets.all(8),
        child: Icon(
          Icons.camera_alt,
          size: 28,
        ),
      ),
    );
  }
}
