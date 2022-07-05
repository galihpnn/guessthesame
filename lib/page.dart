import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guess_the_same/boarditem_model.dart';
import 'package:guess_the_same/boarditem.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  int numberItem = 8; //8 numberitem akan membuat 16 item (karena berpasangan)

  int score = 0;

  String status;

  //list untuk menyimpan board model yang jadi puzzle
  List<BoardItemModel> boardPuzzle = [];

  //untuk simpan board item yang dipilih, tapi belum complete
  List<BoardItemModel> chosenItem = [];
  Timer timeDelayed;

  @override
  void initState() {
    setUpBoard();
    setState(() {
      status = "Ketuk untuk bermain";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guess The Same"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(children: [
              Container(
                  alignment: Alignment.topLeft,
                  child: Text("Score: $score/${numberItem * 100}")),
              GridView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 0.0, maxCrossAxisExtent: 100.0),
                children: List.generate(boardPuzzle.length, (index) {
                  return BoardItem(
                    itemModel: boardPuzzle[index],
                    onTap: () {
                      onItemTap(index);
                    },
                  );
                }),
              ),
              //button untuk panggil method setupboard saat pressed
              ElevatedButton(
                onPressed: () => onPlay(),
                child: Text("Play",
                    style: TextStyle(fontSize: 10, color: Colors.white)),
              ),
              Text(status),
            ])),
      ),
    );
  }

  //agar page tau jika ada event click
  void onItemTap(int index) {
    var selectedItem = boardPuzzle[index];
    if (!selectedItem.isCompleted && !selectedItem.isRevealed) {
      setState(() {
        selectedItem.setRevealed(true);
        //jika memilih lebih dari 2, tutup dulu yang lama
        closePreviousChosenItem();

        chosenItem.add(selectedItem);
        if (chosenItem.length == 2) {
          //jika 2 item telah dipilih
          if (chosenItem[0].imagePath == chosenItem[1].imagePath) {
            //saat complete
            onItemCompleted();
          } else {
            //jika beda gambar
            if (timeDelayed != null) {
              timeDelayed.cancel();
            }
            //timer agar ditututp saat beda gambar
            timeDelayed = Timer(Duration(seconds: 1), () {
              closePreviousChosenItem();
            });
          }
        }
      });
    }
  }

  //method untuk memastikan user memilih 2
  void onItemCompleted() {
    if (chosenItem.length == 2) {
      setState(() {
        chosenItem[0].setCompleted(true);
        chosenItem[1].setCompleted(true);
        chosenItem.clear();

        score += 100;
        if (score == numberItem * 100) {
          onCompleted();
        }
      });
    }
  }

  void onCompleted() {
    print("oncompleted");
    setState(() {
      status = "Permainan Selesai, Ketuk play untuk bermain lagi...";
    });
  }

  //untuk menutup gambar yang terbuka setelah 1 detik jika gambar berbeda
  void closePreviousChosenItem() {
    if (chosenItem.length == 2) {
      setState(() {
        chosenItem[0].setRevealed(false);
        chosenItem[1].setRevealed(false);
        chosenItem.clear();
      });
    }
  }

  //mengisi board puzzle secara acak
  void setUpBoard() {
    List<BoardItemModel> allItem = [];
    for (int x = 1; x < 40; x++) {
      allItem.add(BoardItemModel(imagePath: "assets/$x.png"));
    }
    //hapus item terpilih
    boardPuzzle = [];

    //acak allItem dengan method shuffle dan ambil numberItem teratas (misal 8 teratas) dengan method take
    var randomItem = (allItem..shuffle()).take(numberItem);

    //tambah 2x karena tiap item berpasangan
    boardPuzzle.addAll(randomItem);
    boardPuzzle.addAll(randomItem.map((item) => item.copy()).toList());
    setState(() {
      boardPuzzle.shuffle();
      score = 0;
      status = "Temukan pasangan gambar";
    });
  }

  void onPlay() {
    setUpBoard();
    //menampilkan awal selama 2 detik
    boardPuzzle.forEach((element) {
      setState(() {
        element.isRevealed = true;
        status = "Ingat gambarnya dalam 3 detik...";
      });
    });
    if (timeDelayed != null) {
      timeDelayed.cancel();
    }
    timeDelayed = Timer(Duration(seconds: 2), () {
      boardPuzzle.forEach((element) {
        setState(() {
          element.isRevealed = false;
          status = "Temukan pasangan gambar !";
        });
      });
    });
  }
}

