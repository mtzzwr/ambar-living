import 'dart:convert';

import 'package:ambar_living/model/repo.dart';
import 'package:http/http.dart';

class RepoController {
  Future<List<Repo>> getRepositories() async {
    String url = 'https://api.github.com/repositories';
    Response response = await get(url);
    if (response.statusCode == 200) {
      List<Repo> repositories = [];
      var body = jsonDecode(response.body);
      for (var r in body) {
        Repo repo = Repo.fromJson(r);
        repositories.add(repo);
      }
      print(repositories.length);
      return repositories;
    }

    return [];

  }
}
