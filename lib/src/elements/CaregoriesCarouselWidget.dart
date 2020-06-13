import 'package:flutter/material.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories;

  CategoriesCarouselWidget({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 150)
        : Container(
            height: 350,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: GridView.builder(
              itemCount: this.categories.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              physics: new NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 0 : _marginLeft = 0;
                return new CategoriesCarouselItemWidget(
                  marginLeft: _marginLeft,
                  category: this.categories.elementAt(index),
                );
              },
            ),
            // ListView.builder(
            //   itemCount: this.categories.length,
            //   scrollDirection: Axis.vertical,
            //   itemBuilder: (context, index) {
            //     double _marginLeft = 0;
            //     (index == 0) ? _marginLeft = 0 : _marginLeft = 0;
            //     return new CategoriesCarouselItemWidget(
            //       marginLeft: _marginLeft,
            //       category: this.categories.elementAt(index),
            //     );
            //   },
            // ),
          );
  }
}
