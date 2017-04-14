'use strict';
const path = require('path');

const constants = {
  styleSheetModule: /\/src\/Stylesheets\.elm$/,
};

const base = {
  target: 'electron',
  module: {
    loaders: [{
      test: /\.html$/,
      exclude: /node_modules/,
      loader: 'file?name=[name].[ext]',
    }],
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
  },
  entry: ['./src/index'],
  plugins: [],
};

let configModifier;

if (process.env.NODE_ENV === 'development') {
  configModifier = require('./webpack-dev.config');
} else {
  configModifier = require('./webpack-prod.config');
}

module.exports = configModifier(base, constants);
