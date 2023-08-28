// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:app/src/screens/fetch/fetch_screen.dart';
import 'package:app/src/screens/home/home_screen.dart';
import 'package:app/src/screens/login/login_screen.dart';
import 'package:app/src/screens/login/username_login_screen.dart';
import 'package:app/src/screens/scaffold_with_bottom_navigation_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/me/bloc/me_bloc.dart';
import '../screens/me/me_screen.dart';

part 'routes.g.dart';

const routePathHome = '/home';
const routePathFetch = '/fetch';
const routePathMe = '/me';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    initialLocation: '/home',
    redirect: (BuildContext context, GoRouterState state) {
      if (state.location == '/login/username_login') {
        return null;
      }
      final pwd = context.read<MeCubit>().state.me.pwd;
      if (pwd.isEmpty) {
        return '/login/username_login';
      } else {
        return null;
      }
    },
    routes: $appRoutes);

@TypedShellRoute<MyShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<HomeScreenRoute>(path: '/home'),
    TypedGoRoute<FetchScreenRoute>(path: '/fetch'),
    TypedGoRoute<MeScreenRoute>(path: '/me'),
  ],
)
class MyShellRouteData extends ShellRouteData {
  const MyShellRouteData();

  static final GlobalKey<NavigatorState> $navigatorKey = _shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return ScaffoldWithBottomNavigationBarScreen(
        childPageLocation: state.location, child: navigator);
  }
}

class HomeScreenRoute extends GoRouteData {
  const HomeScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

class FetchScreenRoute extends GoRouteData {
  const FetchScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FetchScreen();
  }
}

class MeScreenRoute extends GoRouteData {
  const MeScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MeScreen();
  }
}


@TypedGoRoute<LoginScreenRoute>(
  path: '/login',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<UserNameLoginScreenRoute>(path: 'username_login')
  ],
)
@immutable
class LoginScreenRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}

@immutable
class UserNameLoginScreenRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UserNameLoginScreen();
  }
}
