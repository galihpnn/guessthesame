class BoardItemModel {
  String imagePath; //untuk simpan lokasi gambar yang ditampilkan oleh boarditem
  bool isRevealed;  //state untuk boarditem terbuka atau tertutup
  bool isCompleted; // untuk cek boarditem sudah berpasangan atau belum

  BoardItemModel(
      {this.imagePath, this.isRevealed = false, this.isCompleted = false});

  void setCompleted(bool isCompleted) {
    this.isCompleted = isCompleted;
  }

  void setRevealed(bool isRevealed) {
    this.isRevealed = isRevealed;
  }

  BoardItemModel copy() {
    return BoardItemModel(
        imagePath: this.imagePath,
        isRevealed: this.isRevealed,
        isCompleted: this.isRevealed);
  }
}
