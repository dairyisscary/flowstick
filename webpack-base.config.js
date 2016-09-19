'use strict';
const path = require('path');

module.exports = {
  module: {
    loaders: [{
      test: /\.elm$/,
      loaders: ['elm-hot', 'elm-webpack'],
      exclude: [/elm-stuff/, /node_modules/],
    }, {
      test: /\.html$/,
      exclude: /node_modules/,
      loader: 'file?name=[name].[ext]',
    }],
    noParse: /\.elm$/,
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
  },
  entry: ['./src/index'],
  plugins: [],
};
