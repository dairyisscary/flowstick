'use strict';
const path = require('path');
const $styleSheetModule = /\/src\/Stylesheets\.elm$/;

module.exports = {
  $styleSheetModule,
  module: {
    loaders: [{
      test: /\.elm$/,
      loaders: ['elm-hot', 'elm-webpack'],
      exclude: [/elm-stuff/, /node_modules/, $styleSheetModule],
    }, {
      test: /\.html$/,
      exclude: /node_modules/,
      loader: 'file?name=[name].[ext]',
    }],
    noParse: /\src\/.*\.elm$/,
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
  },
  entry: ['./src/index'],
  plugins: [],
};
