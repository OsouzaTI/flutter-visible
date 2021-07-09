class EndPoint {
  String _endPointTrending = "https://api.giphy.com/v1/gifs/trending?api_key=nzJJcRLfpt3wZZ3nMUMC9mT04UO7YJ4U";
  String _endPointSearch = "https://api.giphy.com/v1/gifs/search?api_key=nzJJcRLfpt3wZZ3nMUMC9mT04UO7YJ4U";

  EndPoint();

  String getEndPointTrending(int limit){
    return _endPointTrending + "&limit=$limit&rating=g";
  }

  String getEndPointSearch(String search, int limit, int offset){
    return _endPointSearch + "&q=$search&limit=$limit&offset=$offset&rating=g&lang=en";
  }

}