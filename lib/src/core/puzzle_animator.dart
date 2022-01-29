// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:rive/rive.dart';
import 'dart:math' show Point, Random;

import 'body.dart';
import 'puzzle.dart';
import 'puzzle_proxy.dart';
import '../shared_theme.dart';

class PuzzleAnimator implements PuzzleProxy {
  final _rnd = Random();
  final List<Body> _locations;
  final _controller = StreamController<PuzzleEvent>();
  bool _nextRandomVertical = true;
  Puzzle _puzzle;
  int _clickCount = 0;

  bool _stable = true;

  bool get stable => _stable;

  @override
  bool get solved => _puzzle.incorrectTiles == 0;

  @override
  int get width => _puzzle.width;

  @override
  int get height => _puzzle.height;

  @override
  int get length => _puzzle.length;

  @override
  int get tileCount => _puzzle.tileCount;

  int get incorrectTiles => _puzzle.incorrectTiles;

  int get clickCount => _clickCount;


  void reset() => _resetCore();

  Stream<PuzzleEvent> get onEvent => _controller.stream;

  @override
  bool isCorrectPosition(int value) => _puzzle.isCorrectPosition(value);

  @override
  Point<double> location(int index) => _locations[index].location;

  int? _lastBadClick;
  int _badClickCount = 0;

  PuzzleAnimator(int width, int height) : this._(Puzzle(width, height));

  PuzzleAnimator._(this._puzzle)
      : _locations = List.generate(_puzzle.length, (i) {
          return Body.raw(
              (_puzzle.width - 1.0) / 2, (_puzzle.height - 1.0) / 2, 0, 0);
        });

  void playRandom() {
    if (_puzzle.fitness == 0) {
      return;
    }
    _puzzle = _puzzle.clickRandom(vertical: _nextRandomVertical)!;
    _nextRandomVertical = !_nextRandomVertical;
    _clickCount++;
    _controller.add(PuzzleEvent.random);
  }

  @override
  void clickOrShake(int tileValue) {


    if (solved) {
      _controller.add(PuzzleEvent.noop);
      // _shake(tileValue);
      _lastBadClick = null;
      _badClickCount = 0;
      return;
    }

    _controller.add(PuzzleEvent.click);
    if (!_clickValue(tileValue)) {
      // _shake(tileValue);

      // This is logic to allow a user to skip to the end – useful for testing
      // click on 5 un-movable tiles in a row, but not the same tile twice
      // in a row
      if (tileValue != _lastBadClick) {
        _badClickCount++;
        if (_badClickCount >= 5) {
          // Do the reset!
          final newValues = List.generate(_puzzle.length, (i) {
            if (i == _puzzle.tileCount) {
              return _puzzle.tileCount - 1;
            } else if (i == (_puzzle.tileCount - 1)) {
              return _puzzle.tileCount;
            }
            return i;
          });
          _resetCore(source: newValues);
          _clickCount = 999;
        }
      } else {
        _badClickCount = 0;
      }
      _lastBadClick = tileValue;
    } else {
      _lastBadClick = null;
      _badClickCount = 0;
    }

  }
  SMIBool? glow;
  List TileGlowArray = [];
  int tileIndex = 0;

  @override
  void onRiveInit(Artboard artboard) {
    final controller =
      StateMachineController.fromArtboard(artboard, 'GlowStateMachine');
    artboard.addController(controller!);
    glow = controller.findInput<bool>('isGlowing') as SMIBool;
    TileGlowArray.insert(tileIndex, glow);
    tileIndex++;
    if(tileIndex == 15)
      {
        glowToggle();
      }
  }

@override
  void glowToggle(){
    int i;
    for (i = 0; i < 15; i++) {
      if (isCorrectPosition(i)) {
        TileGlowArray[i].change(true);
      }
      else {
        TileGlowArray[i].change(false);
      }
    }
}



  void _resetCore({List<int>? source}) {
    _puzzle = _puzzle.reset(source: source);
    _clickCount = 0;
    _lastBadClick = null;
    _badClickCount = 0;
    _controller.add(PuzzleEvent.reset);
    glowToggle();
  }

  bool _clickValue(int value) {
    final newPuzzle = _puzzle.clickValue(value);
    if (newPuzzle == null) {
      return false;
    } else {
      _clickCount++;
      _puzzle = newPuzzle;
      return true;
    }
  }


  void update(Duration timeDelta) {
    assert(!timeDelta.isNegative);
    assert(timeDelta != Duration.zero);

    var animationSeconds = timeDelta.inMilliseconds / 60.0;
    if (animationSeconds == 0) {
      animationSeconds = 0.1;
    }
    assert(animationSeconds > 0);

    _stable = true;
    for (var i = 0; i < _puzzle.length; i++) {
      final target = _target(i);
      final body = _locations[i];

      _stable = !body.animate(animationSeconds,
              force: target - body.location,
              drag: 2,
              maxVelocity: 1.0,
              snapTo: target) &&
          _stable;
    }
  }

  Point<double> _target(int item) {
    final target = _puzzle.coordinatesOf(item);
    return Point(target.x.toDouble(), target.y.toDouble());
  }
}
