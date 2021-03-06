import 'package:ambar_living/controller/repo_controller.dart';
import 'package:ambar_living/model/repo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RepoController repoController = RepoController();
  Future<List<Repo>> repoFuture;

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  @override
  void initState() {
    repoFuture = repoController.getRepositories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage('assets/images/git.jpg'),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: FutureBuilder(
                future: repoFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Erro ao tentar carregar os repositórios'),
                        IconButton(
                          icon: Icon(
                            Icons.refresh,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              repoFuture = repoController.getRepositories();
                            });
                          },
                        )
                      ],
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.black12,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            launchURL(snapshot.data[index].htmlUrl);
                          },
                          child: Container(
                            padding: EdgeInsets.all(18),
                            height: 100,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data[index].owner.avatarUrl,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].name,
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        snapshot.data[index].owner.login,
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
