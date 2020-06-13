import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CaregoriesCarouselWidget.dart';
import '../elements/DeliveryAddressBottomSheetWidget.dart';
import '../elements/GridWidget.dart';
import '../elements/ProductsCarouselWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  /*****************************************************
  * SLIDER HEADER INIT
  ****************************************************/
  int _currentIndex = 0;
  List cardList = [
    Item1(),
    Item2(),
    Item3(),
  ];
  List<T> maps<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  /*****************************************************
  * 
  ****************************************************/
  HomeController _con;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshHome,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              /*****************************************************
              * Widget Search
              ****************************************************/
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(
                  onClickFilter: (event) {
                    widget.parentScaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ),
              /*****************************************************
              * Widget Slider
              ****************************************************/
              Padding(
                padding: const EdgeInsets.only(top: 15),
              ),
              CarouselSlider(
                height: 200.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: Duration(seconds: 10),
                aspectRatio: 2.0,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: cardList.map((card) {
                  return Builder(builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.blueAccent,
                        child: card,
                      ),
                    );
                  });
                }).toList(),
              ),
              /*****************************************************
              * Category
              ****************************************************/
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.category,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).product_categories,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              /*****************************************************
              * Category Card
              ****************************************************/
              CategoriesCarouselWidget(
                categories: _con.categories,
              ),
              /*****************************************************
              * Top Markets
              ****************************************************/
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.stars,
                    color: Theme.of(context).hintColor,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      if (currentUser.value.apiToken == null) {
                        _con.requestForCurrentLocation(context);
                      } else {
                        var bottomSheetController = widget
                            .parentScaffoldKey.currentState
                            .showBottomSheet(
                          (context) => DeliveryAddressBottomSheetWidget(
                              scaffoldKey: widget.parentScaffoldKey),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                        );
                        bottomSheetController.closed.then((value) {
                          _con.refreshHome();
                        });
                      }
                    },
                    icon: Icon(
                      Icons.my_location,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  title: Text(
                    S.of(context).top_markets,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    S.of(context).near_to +
                        " " +
                        (settingsRepo.deliveryAddress.value?.address ??
                            S.of(context).unknown),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              /*****************************************************
              * Top Markets Cards
              ****************************************************/
              CardsCarouselWidget(
                  marketsList: _con.topMarkets, heroTag: 'home_top_markets'),
              /*****************************************************
              * Trending
              ****************************************************/
              // ListTile(
              //   dense: true,
              //   contentPadding: EdgeInsets.symmetric(horizontal: 20),
              //   leading: Icon(
              //     Icons.trending_up,
              //     color: Theme.of(context).hintColor,
              //   ),
              //   title: Text(
              //     S.of(context).trending_this_week,
              //     style: Theme.of(context).textTheme.headline4,
              //   ),
              //   subtitle: Text(
              //     S.of(context).clickOnTheProductToGetMoreDetailsAboutIt,
              //     style: Theme.of(context)
              //         .textTheme
              //         .caption
              //         .merge(TextStyle(fontSize: 11)),
              //   ),
              // ),
              /*****************************************************
              * Trendin Card
              ****************************************************/
              // ProductsCarouselWidget(
              //     productsList: _con.trendingProducts,
              //     heroTag: 'home_product_carousel'),
              /*****************************************************
              * Popular
              ****************************************************/
              // Padding(
              //   padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              //   child: ListTile(
              //     dense: true,
              //     contentPadding: EdgeInsets.symmetric(vertical: 0),
              //     leading: Icon(
              //       Icons.trending_up,
              //       color: Theme.of(context).hintColor,
              //     ),
              //     title: Text(
              //       S.of(context).most_popular,
              //       style: Theme.of(context).textTheme.headline4,
              //     ),
              //   ),
              // ),
              /*****************************************************
              * Popular Card
              ****************************************************/
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: GridWidget(
              //     marketsList: _con.popularMarkets,
              //     heroTag: 'home_markets',
              //   ),
              // ),
              /*****************************************************
              * Review
              ****************************************************/
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: ListTile(
              //     dense: true,
              //     contentPadding: EdgeInsets.symmetric(vertical: 20),
              //     leading: Icon(
              //       Icons.recent_actors,
              //       color: Theme.of(context).hintColor,
              //     ),
              //     title: Text(
              //       S.of(context).recent_reviews,
              //       style: Theme.of(context).textTheme.headline4,
              //     ),
              //   ),
              // ),
              /*****************************************************
              * Review List
              ****************************************************/
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: ReviewsListWidget(reviewsList: _con.recentReviews),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

/*****************************************************
* SLIDER CLASS
****************************************************/
class Item1 extends StatelessWidget {
  const Item1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffffffff),
              Color(0xffffffff),
            ]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset(
              'assets/img/1.jpg',
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffffffff),
              Color(0xffffffff),
            ]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset(
              'assets/img/2.jpg',
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffffffff),
              Color(0xffffffff),
            ]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset(
              'assets/img/3.jpg',
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
