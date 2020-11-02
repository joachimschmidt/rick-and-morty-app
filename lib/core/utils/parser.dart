class Parser {
  static List<int> parseCharacterList(List<String> dataToParse) {
    List<int> characterList = List<int>();
    for (String character in dataToParse) {
      var splited = character.split("/");
      int a = int.parse(splited[splited.length - 1]);
      characterList.add(a);
    }
    return characterList;
  }

  static List<int> parseEpisodeList(List<String> dataToParse) {
    List<int> episodesList = List<int>();
    for (String episode in dataToParse) {
      var splited = episode.split("/");
      int a = int.parse(splited[splited.length - 1]);
      episodesList.add(a);
    }
    return episodesList;
  }
}
