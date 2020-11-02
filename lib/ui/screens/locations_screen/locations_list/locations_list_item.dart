import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/data/models/location/location.dart';
import 'package:rick_and_morty_app/ui/screens/detailed_location_screen/detailed_location_screen.dart';

class LocationsListItem extends StatelessWidget {
  final Location location;
  final bool online;

  LocationsListItem(this.location, this.online);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedLocationScreen(
                    location: location,
                    online: online,
                  )),
        );
      },
      child: Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(location.dimension)
                  ],
                ),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
