import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/ui/screens/locations_screen/locations_list/bloc/bloc.dart';
import 'package:rick_and_morty_app/ui/screens/navigation_screen/bloc/bloc.dart';

import '../../../common/widgets/bottom_loader.dart';
import 'bloc/locations_list_bloc.dart';
import 'locations_list_item.dart';

class LocationsList extends StatefulWidget {
  @override
  _LocationsListState createState() => _LocationsListState();
}

class _LocationsListState extends State<LocationsList> {
  final _mainScrollController = ScrollController();

  LocationsListBloc _locationsListBloc;

  void _onMainScroll() {
    if (_mainScrollController.offset >=
            _mainScrollController.position.maxScrollExtent &&
        !_mainScrollController.position.outOfRange) {
      _locationsListBloc.add(ReachedBottomOfLocationsList());
    }
  }

  @override
  void initState() {
    _locationsListBloc = BlocProvider.of<LocationsListBloc>(context);
    _locationsListBloc.add(ReachedBottomOfLocationsList());
    _mainScrollController.addListener(_onMainScroll);
    super.initState();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsListBloc, LocationsListState>(
      builder: (BuildContext context, state) {
        if (state is InitialLocationsListState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is LocationsListError) {
          return Center(
            child: Text("Could not load locations"),
          );
        }
        if (state is LocationsListLoaded) {
          if (state.locations.isEmpty) {
            return Center(
              child: Text('No Locations'),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index >= state.locations.length) {
                if (!state.hasReachedMax)
                  return BottomLoader();
                else
                  return Center(
                      child: Text(
                    "Could not load locations",
                    style: TextStyle(fontSize: 20),
                  ));
              } else {
                return LocationsListItem(
                    state.locations[index],
                    BlocProvider.of<NavigationScreenBloc>(context)
                        .hasInternetConnection);
              }
            },
            itemCount: state.locations.length + 1,
            controller: _mainScrollController,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
