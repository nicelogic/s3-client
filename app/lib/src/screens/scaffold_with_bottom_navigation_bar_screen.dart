import 'package:app/src/routes/routes.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class ScaffoldWithBottomNavigationBarScreen extends StatefulWidget {
  final Widget child;
  final String childPageLocation;

  const ScaffoldWithBottomNavigationBarScreen(
      {super.key, required this.child, required this.childPageLocation});

  @override
  State<StatefulWidget> createState() {
    return ScaffoldWithBottomNavigationBarScreenState();
  }
}

class ScaffoldWithBottomNavigationBarScreenState
    extends State<ScaffoldWithBottomNavigationBarScreen> {
  @override
  Widget build(BuildContext context) {
    return _ScaffoldWithBottomNavigationBarScreen(
      childPageLocation: widget.childPageLocation,
      child: widget.child,
    );
  }
}

class _ScaffoldWithBottomNavigationBarScreen extends StatefulWidget {
  final Widget child;
  final String childPageLocation;

  const _ScaffoldWithBottomNavigationBarScreen(
      {required this.child, required this.childPageLocation});

  @override
  State<StatefulWidget> createState() {
    return _ScaffoldWithBottomNavigationBarScreenState();
  }
}

class _ScaffoldWithBottomNavigationBarScreenState
    extends State<_ScaffoldWithBottomNavigationBarScreen> {
  int _selectedIndex = 0;
  final routePaths = [routePathHome, routePathFetch, routePathMe];
  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      final routePath = routePaths[_selectedIndex];
      if (routePath == routePathFetch) {
        const FetchScreenRoute().go(context);
      } else if (routePath == routePathMe) {
        const MeScreenRoute().go(context);
      } else {
        const HomeScreenRoute().go(context);
      }
    });
  }

  _updateSelectedIndex() {
    for (int index = 0; index != routePaths.length; ++index) {
      if (widget.childPageLocation.startsWith(routePaths[index])) {
        final goRoutePageNavigationBarIndex = index;
        if (_selectedIndex != goRoutePageNavigationBarIndex) {
          setState(() {
            _selectedIndex = goRoutePageNavigationBarIndex;
          });
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateSelectedIndex();
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: _onItemTapped,
          selectedIndex: _selectedIndex,
          destinations: const [
            NavigationDestination(
              label: '实时备份',
              icon: Stack(children: <Widget>[
                Icon(Icons.backup_outlined),
              ]),
              // Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.backup),
            ),
            NavigationDestination(
                label: '下载',
                icon: Icon(Icons.download_outlined),
                selectedIcon: Icon(Icons.download)),
            NavigationDestination(
                label: '我',
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person)),
          ]),
    );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundStartColor = Theme.of(context).colorScheme.primary;
    final backgroundEndColor = Theme.of(context).colorScheme.primary;
    return WindowTitleBarBox(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundStartColor, backgroundEndColor],
              stops: const [0.0, 1.0]),
        ),
        child: Row(
          children: [
            Expanded(
              child: MoveWindow(),
            ),
            const WindowButtons()
          ],
        ),
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
      iconNormal: Theme.of(context).colorScheme.onPrimary,
      mouseOver: Theme.of(context).colorScheme.onPrimary,
      mouseDown: Theme.of(context).colorScheme.secondary,
      iconMouseOver: Theme.of(context).colorScheme.secondary,
      iconMouseDown: Theme.of(context).colorScheme.secondary,
    );

    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(
          colors: buttonColors,
          onPressed: () {},
        ),
      ],
    );
  }
}
