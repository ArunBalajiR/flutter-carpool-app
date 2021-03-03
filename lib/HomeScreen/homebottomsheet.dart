import 'package:flutter/material.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.15,
        minChildSize: 0.15,
        maxChildSize: 0.379,
        builder: (context, scrollController) {
          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: SingleChildScrollView(
              controller: scrollController,
              physics: ClampingScrollPhysics(),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[300],
                              ),
                              height: 5,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _WhereToWidget(),
                    _RecommendedTrip(
                        postcode: 'AB65 7UQ', addressLine1: 'Design District'),
                    Divider(),
                    _RecommendedTrip(
                        postcode: 'YF82 2LO', addressLine1: 'Flutter Avenue'),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class _WhereToWidget extends StatelessWidget {
  const _WhereToWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 52.5,
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Where to?',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 52.5,
              color: Colors.grey[200],
              child: Padding(
                padding: EdgeInsets.only(right: 14.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Chip(
                    avatar: Icon(
                      Icons.watch_later,
                      color: Colors.black87,
                      size: 21,
                    ),
                    backgroundColor: Colors.white,
                    label: _TimeSelectorWidget(),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TimeSelectorWidget extends StatelessWidget {
  const _TimeSelectorWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: 'Now',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          WidgetSpan(
            child: SizedBox(
              width: 2.5,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }
}

class _RecommendedTrip extends StatelessWidget {
  final String postcode;
  final String addressLine1;
  const _RecommendedTrip({
    Key key,
    String postcode,
    String addressLine1,
  })  : this.postcode = postcode,
        this.addressLine1 = addressLine1,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        leading: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: ShapeDecoration(
              color: Colors.grey[200],
              shape: CircleBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.location_on,
                size: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              postcode,
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            Text(
              addressLine1,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 17,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
