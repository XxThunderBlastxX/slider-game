// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

import 'core/puzzle_proxy.dart';
import 'flutter.dart';
import 'widgets/material_interior_alt.dart';

final puzzleAnimationDuration = kThemeAnimationDuration * 3;

abstract class SharedTheme {
  const SharedTheme();

  String get name;

  // final SMIBool? glow;   //needs to be explicitly set in the inherited class. Also needs a function to change its value, which will be extended.

  Color get puzzleThemeBackground;

  RoundedRectangleBorder puzzleBorder(bool small);

  Color get puzzleBackgroundColor;

  Color get puzzleAccentColor;

  EdgeInsetsGeometry tilePadding(PuzzleProxy puzzle) => const EdgeInsets.all(6);

  Widget tileButton(int i, PuzzleProxy puzzle, bool small);

  Ink createInk(
    Widget child, {
    DecorationImage? image,
    EdgeInsetsGeometry? padding,
  }) =>
      Ink(
        padding: padding,
        decoration: BoxDecoration(
          image: image,
        ),
        child: child,
      );

  // void onRiveInit(Artboard artboard) {
  //   print('RiveObject Initiated');
  //    final controller =
  //      StateMachineController.fromArtboard(artboard, 'GlowStateMachine');
  //    artboard.addController(controller!);
  //    glow = controller.findInput<bool>('isGlowing') as SMIBool;
  //  }

  Widget createButton(
    PuzzleProxy puzzle,
    bool small,
    int tileValue,
    Widget content, {
    Color? color,
    RoundedRectangleBorder? shape,
  }) =>
      AnimatedContainer(
        duration: puzzleAnimationDuration,
        padding: tilePadding(puzzle),
        // child: ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     elevation: 4,
        //     animationDuration: puzzleAnimationDuration,
        //     shape: shape ?? puzzleBorder(small),
        //     padding: const EdgeInsets.symmetric(),
        //     primary: color,
        //   ),
        //   clipBehavior: Clip.hardEdge,
        //   onPressed: () => puzzle.clickOrShake(tileValue),
        //   child: content,
        // ),
        child: GestureDetector(
          child: RiveAnimation.asset(
            'asset/rive/tile${tileValue + 1}.riv',
            fit: BoxFit.cover,
            onInit: puzzle.onRiveInit,
          ),
          onTap: () {
            puzzle.clickOrShake(tileValue);
            puzzle.glowToggle();
          },
        ),
      );

  // Thought about using AnimatedContainer here, but it causes some weird
  // resizing behavior
  Widget styledWrapper(bool small, Widget child) => MaterialInterior(
        duration: puzzleAnimationDuration,
        shape: puzzleBorder(small),
        color: puzzleBackgroundColor,
        child: child,
      );

  TextStyle get _infoStyle => TextStyle(
        color: puzzleAccentColor,
        fontWeight: FontWeight.bold,
      );

  // List<Widget> bottomControls(PuzzleControls controls) => <Widget>[
  //       Tooltip(
  //         message: 'Reset',
  //         child: IconButton(
  //           onPressed: controls.reset,
  //           icon: Icon(Icons.refresh, color: puzzleAccentColor),
  //         ),
  //       ),
  //       Tooltip(
  //         message: 'Auto play',
  //         child: Checkbox(
  //           value: controls.autoPlay,
  //           onChanged: controls.setAutoPlayFunction,
  //           activeColor: puzzleAccentColor,
  //         ),
  //       ),
  //       Expanded(
  //         child: Container(),
  //       ),
  //       RichText(
  //         text: TextSpan(
  //           children: [
  //             TextSpan(
  //               text: controls.clickCount.toString(),
  //               style: _infoStyle,
  //             ),
  //             const TextSpan(text: ' Moves'),
  //           ],
  //         ),
  //       ),
  //       SizedBox(
  //         width: 90,
  //         child: RichText(
  //           textAlign: TextAlign.right,
  //           text: TextSpan(
  //             children: [
  //               TextSpan(
  //                 text: controls.incorrectTiles.toString(),
  //                 style: _infoStyle,
  //               ),
  //               const TextSpan(text: ' Tiles left'),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ];

  Widget tileButtonCore(int i, PuzzleProxy puzzle, bool small) {
    if (i != puzzle.tileCount || puzzle.solved) {
      return tileButton(i, puzzle, small);
    }

    return const Center();

    // return Center(
    //     // child: SvgPicture.asset('asset/rive/placeholdertile.svg'),
    //     );
  }

  Widget tilePlaceholderCore(int i, PuzzleProxy puzzle, bool small) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            Center(child: SvgPicture.asset('asset/rive/placeholdertile.svg')),
      ),
    );
  }
}
