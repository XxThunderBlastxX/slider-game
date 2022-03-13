// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter_svg/flutter_svg.dart';
// import 'package:rive/rive.dart';

import 'core/puzzle_proxy.dart';
import 'flutter.dart';
import 'shared_theme.dart';

const _accentBlue = Color(0xff000579);
const _accentGreen = Color(0xff47251c);

class ThemeSimple extends SharedTheme {
  @override
  String get name => 'Simple';

  const ThemeSimple();
  @override
  Color get puzzleThemeBackground => _accentGreen;

  @override
  Color get puzzleBackgroundColor => Colors.transparent;

  @override
  Color get puzzleAccentColor => _accentBlue;

  @override
  RoundedRectangleBorder puzzleBorder(bool small) =>
      const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent, width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      );

  @override
  Widget tileButton(int i, PuzzleProxy puzzle, bool small) {
    // if (i == puzzle.tileCount) {
    //   assert(puzzle.solved);
    //
    //   return const Center(
    //     child: Icon(
    //       Icons.thumb_up,
    //       size: 72,
    //       color: _accentBlue,
    //     ),
    //   );
    // }

    final correctPosition = puzzle.isCorrectPosition(i);

    // @override
    // void glowCheck(SMIBool glow) {
    //   //TODO: implement onRiveInit
    //   if (correctPosition) {
    //     glow.change(true);
    //   } else {
    //     glow.change(false);
    //   }
    // }

    // @override
    // void onRiveInit(Artboard artboard) {
    //   SMIBool? glow;
    //   final controller =
    //       StateMachineController.fromArtboard(artboard, 'GlowStateMachine');
    //   artboard.addController(controller!);
    //   glow = controller.findInput<bool>('isGlowing') as SMIBool;
    // }

    final content = createInk(
      Center(
        child: Text(
          (i + 1).toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: correctPosition ? FontWeight.bold : FontWeight.normal,
            fontSize: small ? 30 : 49,
          ),
        ),
      ),
    );

    return Stack(children: [
      createButton(
        puzzle,
        small,
        i,
        content,
        color: const Color.fromARGB(255, 13, 87, 155),
      ),
      SvgPicture.asset('asset/rive/placeholder.svg'),
    ]);
  }
}
