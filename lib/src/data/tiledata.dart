import '../modals/Tiles.dart';

var tileCollection = [
  Tiles(id: 1, imageUrl: 'asset/rive/tile1.riv'),
  Tiles(id: 2, imageUrl: 'asset/rive/tile2.riv'),
  Tiles(id: 3, imageUrl: 'asset/rive/tile3.riv'),
  Tiles(id: 4, imageUrl: 'asset/rive/tile4.riv'),
  Tiles(id: 5, imageUrl: 'asset/rive/tile5.riv'),
  Tiles(id: 6, imageUrl: 'asset/rive/tile6.riv'),
  Tiles(id: 7, imageUrl: 'asset/rive/tile7.riv'),
  Tiles(id: 8, imageUrl: 'asset/rive/tile8.riv'),
  Tiles(id: 9, imageUrl: 'asset/rive/tile9.riv'),
  Tiles(id: 10, imageUrl: 'asset/rive/tile10.riv'),
  Tiles(id: 11, imageUrl: 'asset/rive/tile11.riv'),
  Tiles(id: 12, imageUrl: 'asset/rive/tile12.riv'),
  Tiles(id: 13, imageUrl: 'asset/rive/tile13.riv'),
  Tiles(id: 14, imageUrl: 'asset/rive/tile14.riv'),
  Tiles(id: 15, imageUrl: 'asset/rive/tile15.riv'),
];

var getTileAddress = (int id) {
  return tileCollection.firstWhere((element) => element.id == id).imageUrl;
};
