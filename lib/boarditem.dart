import 'package:flutter/material.dart';
import 'package:guess_the_same/boarditem_model.dart';

class BoardItem extends StatelessWidget {
  final BoardItemModel itemModel;
  final Function() onTap;

  BoardItem({this.itemModel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        //jika item reveal dan complete, maka ditampilkan gambar. selain itu akan ditampilkan box.png
        child: Image.asset(itemModel.isRevealed || itemModel.isCompleted 
          ? itemModel.imagePath 
          : "assets/box.png"),
      )
    );
  }
}
