// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pageIndexStreamController = StreamController<int>();
  Future<bool> refreshPage({required int pageIndex}) async {
    if (kDebugMode) {
      print('${DateTime.now()},_refresh page begin, pageIndex($pageIndex)');
    }
    await Future.delayed(const Duration(seconds: 3));
    if (kDebugMode) {
      print('${DateTime.now()},_refresh page end, pageIndex($pageIndex)');
    }
    return true;
  }

  sequentialRefreshPage() async {
    await for (final pageIndex in pageIndexStreamController.stream) {
      if (kDebugMode) {
        print('${DateTime.now()},received event, pageIndex($pageIndex)');
      }
      final success = await refreshPage(pageIndex: pageIndex);
      if (kDebugMode) {
        print('${DateTime.now()},_refreshPage, pageIndex($pageIndex), result($success)');
      }
    }
  }

  test('test await for', () async {
    sequentialRefreshPage();
    pageIndexStreamController.add(0);
    pageIndexStreamController.add(1);

    await Future.delayed(const Duration(seconds: 10));


    /*
    received event, pageIndex(0)
_refresh page begin, pageIndex(0)
_refresh page end, pageIndex(0)
_refreshPage, pageIndex(0), result(true)
received event, pageIndex(1)
_refresh page begin, pageIndex(1)
_refresh page end, pageIndex(1)
_refreshPage, pageIndex(1), result(true)
    */
  });
}
