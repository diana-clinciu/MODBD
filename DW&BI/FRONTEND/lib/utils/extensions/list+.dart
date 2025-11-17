extension ListSorted<T extends Comparable<T>> on List<T> {
  List<T> sorted() {
    final newList = List<T>.from(this);
    newList.sort();
    return newList;
  }
}
