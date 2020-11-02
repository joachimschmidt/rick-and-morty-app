import 'package:backdrop/app_bar.dart';
import 'package:backdrop/backdrop.dart';
import 'package:backdrop/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rick_and_morty_app/ui/common/my_bottom_navigation_bar.dart';
import 'package:rick_and_morty_app/ui/common/my_bottom_navigation_bar_item.dart';
import 'package:rick_and_morty_app/ui/common/widgets/day_night_switcher.dart';
import 'package:rick_and_morty_app/ui/screens/characters_screen/characters_list/bloc/bloc.dart';
import 'package:rick_and_morty_app/ui/screens/characters_screen/characters_screen.dart';
import 'package:rick_and_morty_app/ui/screens/episodes_screen/episodes_list/bloc/bloc.dart';
import 'package:rick_and_morty_app/ui/screens/episodes_screen/episodes_screen.dart';
import 'package:rick_and_morty_app/ui/screens/favorite_characters_screen/favorite_characters_screen.dart';
import 'package:rick_and_morty_app/ui/screens/locations_screen/locations_list/bloc/bloc.dart';
import 'package:rick_and_morty_app/ui/screens/locations_screen/locations_screen.dart';
import 'package:rick_and_morty_app/ui/screens/navigation_screen/bloc/bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  NavigationScreenBloc _navigationScreenBloc;
  TextEditingController textEditingController;
  CharactersListBloc charactersListBloc;
  Map<String, String> filters = new Map();
  Map<String, String> filtersSetup = new Map();
  bool typingNameSearch = false;
  bool filterByStatus = false;
  bool filterBySpecies = false;
  bool filterByType = false;
  bool filterByGender = false;
  int statusSelection = 0;
  int genderSelection = 0;
  final GlobalKey<BackdropScaffoldState> _backdropKey = new GlobalKey();

  void navigateToNewScreen(int indexOfDestination) {
    _navigationScreenBloc.add(SwitchToScreen(indexOfDestination));
  }

  @override
  void didChangeDependencies() {
    _navigationScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);
    textEditingController = new TextEditingController();
    textEditingController.addListener(_searchListener);
    charactersListBloc = CharactersListBloc(filters, _navigationScreenBloc);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _navigationScreenBloc.close();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void applyNewFilter() {
    setState(() {
      if (filterByStatus) {
        if (filtersSetup["status"] == null || filtersSetup["status"] == "") {
          switch (statusSelection) {
            case 0:
              filtersSetup["status"] = 'alive';
              break;
            case 1:
              filtersSetup["status"] = 'dead';
              break;
            default:
              filtersSetup["status"] = 'unknown';
              break;
          }
        }
        filters["status"] = filtersSetup["status"];
      } else {
        filters["status"] = "";
      }
      if (filterByGender) {
        if (filtersSetup["gender"] == null || filtersSetup["gender"] == "") {
          switch (genderSelection) {
            case 0:
              filtersSetup["gender"] = 'female';
              break;
            case 1:
              filtersSetup["gender"] = 'male';
              break;
            case 2:
              filtersSetup["gender"] = 'genderless';
              break;
            default:
              filtersSetup["gender"] = 'unknown';
              break;
          }
        }
        filters["gender"] = filtersSetup["gender"];
      } else {
        filters["gender"] = "";
      }
      filtersSetup = new Map();
    });
    charactersListBloc.add(FiltersChanged(filters));
    _backdropKey.currentState.fling();
  }

  bool isFilterApplied() {
    print(!(filters["status"] == null || filters["status"] == ""));
    return !(filters["status"] == null || filters["status"] == "") ||
        !(filters["species"] == null || filters["species"] == "") ||
        !(filters["gender"] == null || filters["gender"] == "") ||
        !(filters["type"] == null || filters["type"] == "") ||
        textEditingController.text != "";
  }

  clearFilters() {
    setState(() {
      filters["status"] = "";
      filters["species"] = "";
      filters["gender"] = "";
      filters["type"] = "";
      textEditingController.text = "";
      typingNameSearch = false;
      filterByStatus = false;
      filterBySpecies = false;
      filterByType = false;
      filterByGender = false;
      statusSelection = 0;
      genderSelection = 0;
    });
    charactersListBloc.add(FiltersChanged(filters));
  }

  _searchListener() {
    if (filters['name'] != textEditingController.text) {
      filters['name'] = textEditingController.text;
      charactersListBloc.add(FiltersChanged(filters));
    }
  }

  _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FavoriteCharactersScreen(
              online: _navigationScreenBloc.hasInternetConnection)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationScreenBloc, NavigationScreenState>(
      builder: (BuildContext context, state) {
        return BackdropScaffold(
          floatingActionButton: state.index == 1
              ? FloatingActionButton(
                  onPressed: _navigateToFavorites,
                  child: Icon(FontAwesomeIcons.heart))
              : SizedBox(),
          resizeToAvoidBottomInset: false,
          key: _backdropKey,
          appBar: BackdropAppBar(
              automaticallyImplyLeading: false,
              leading: ThemeSwitcher(),
              title: state.index == 1
                  ? typingNameSearch
                      ? TextField(
                          autofocus: true,
                          controller: textEditingController,
                        )
                      : Text("Characters")
                  : state.index == 0
                      ? Text("Locations")
                      : Text("Episodes"),
              actions: state.hasConnection
                  ? [
                      IconButton(
                        icon: Icon(
                          typingNameSearch ? Icons.close : Icons.search,
                        ),
                        onPressed: () {
                          setState(() {
                            filters['name'] = "";
                            textEditingController.text = "";
                            charactersListBloc.add(FiltersChanged(filters));
                            typingNameSearch = !typingNameSearch;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () => _backdropKey.currentState.fling(),
                        icon: Icon(Icons.filter_list_sharp),
                      )
                    ]
                  : state.index == 1
                      ? [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text("You're offline!")),
                          )
                        ]
                      : null),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          primary: true,
          bottomNavigationBar: CustomNavigationBar(
            animationDuration: Duration(milliseconds: 500),
            selectedIndex: _navigationScreenBloc.state.index,
            navBarBackgroundColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            navBarHeight: 60,
            itemHeight: 50,
            emptySpacePercent: 0.4,
            defaultIndicatorColor: Theme.of(context).cardColor,
            onItemSelected: navigateToNewScreen,
            items: <NavBarItem>[
              NavBarItem(
                child: Icon(
                  FontAwesomeIcons.locationArrow,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
                ),
                activeChild: Icon(
                  FontAwesomeIcons.locationArrow,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                ),
              ),
              NavBarItem(
                child: Icon(
                  FontAwesomeIcons.user,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
                ),
                activeChild: Icon(
                  FontAwesomeIcons.user,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                ),
              ),
              NavBarItem(
                child: Icon(
                  FontAwesomeIcons.film,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
                ),
                activeChild: Icon(
                  FontAwesomeIcons.film,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                ),
              ),
            ],
          ),
          frontLayer: SafeArea(
            child: BlocBuilder<NavigationScreenBloc, NavigationScreenState>(
                builder: (context, state) {
              return IndexedStack(
                index: _navigationScreenBloc.state.index,
                children: <Widget>[
                  BlocProvider(
                      create: (BuildContext context) =>
                          LocationsListBloc(_navigationScreenBloc),
                      child: LocationsScreen()),
                  BlocProvider.value(
                      value: charactersListBloc, child: CharactersScreen()),
                  BlocProvider<EpisodesListBloc>(
                      create: (BuildContext context) =>
                          EpisodesListBloc(_navigationScreenBloc),
                      child: EpisodesScreen()),
                ],
              );
            }),
          ),
          backLayer: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    "Filter by status:",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color:
                                                Theme.of(context).buttonColor),
                                  ),
                                ),
                                Switch(
                                  activeColor: Theme.of(context).buttonColor,
                                  value: filterByStatus,
                                  onChanged: (value) {
                                    setState(() {
                                      filterByStatus = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        ToggleSwitch(
                          activeBgColors: [
                            Colors.green,
                            Colors.red,
                            Theme.of(context).backgroundColor
                          ],
                          initialLabelIndex: statusSelection,
                          labels: ['Alive', 'Dead', 'Unknown'],
                          onToggle: (index) {
                            setState(() {
                              switch (index) {
                                case 0:
                                  filtersSetup["status"] = 'alive';
                                  statusSelection = 0;
                                  break;
                                case 1:
                                  filtersSetup["status"] = 'dead';
                                  statusSelection = 1;
                                  break;
                                default:
                                  filtersSetup["status"] = 'unknown';
                                  statusSelection = 2;
                                  break;
                              }
                            });
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                "Filter by gender:",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Theme.of(context).buttonColor),
                              ),
                            ),
                            Switch(
                              activeColor: Theme.of(context).buttonColor,
                              value: filterByGender,
                              onChanged: (value) {
                                setState(() {
                                  filterByGender = value;
                                });
                              },
                            ),
                          ],
                        ),
                        ToggleSwitch(
                          activeBgColors: [
                            Colors.green,
                            Colors.red,
                            Theme.of(context).backgroundColor,
                            Colors.red,
                          ],
                          initialLabelIndex: genderSelection,
                          labels: ["", "", "", ""],
                          icons: [
                            FontAwesomeIcons.venus,
                            FontAwesomeIcons.mars,
                            FontAwesomeIcons.genderless,
                            FontAwesomeIcons.question
                          ],
                          onToggle: (index) {
                            setState(() {
                              switch (index) {
                                case 0:
                                  filtersSetup["gender"] = 'female';
                                  genderSelection = 0;
                                  break;
                                case 1:
                                  filtersSetup["gender"] = 'male';
                                  genderSelection = 1;
                                  break;
                                case 2:
                                  filtersSetup["gender"] = 'genderless';
                                  genderSelection = 2;
                                  break;
                                default:
                                  filtersSetup["gender"] = 'unknown';
                                  genderSelection = 3;
                                  break;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    isFilterApplied()
                        ? RaisedButton(
                            child: Text("Clear Filters"),
                            onPressed: clearFilters)
                        : SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                              child: Text("Close"),
                              onPressed: () =>
                                  _backdropKey.currentState.fling()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                              child: Text("Apply new Filter"),
                              onPressed: applyNewFilter),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
