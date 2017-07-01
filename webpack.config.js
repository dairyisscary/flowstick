'use strict';
const path = require('path');
const HTMLWebpackPlugin = require('html-webpack-plugin');

const constants = Object.freeze({
  styleSheetModule: /\/src\/Stylesheets\.elm$/,
  nodeModulesDir: path.join(__dirname, 'node_modules'),
});

const base = {
  target: 'electron-main',
  module: {
    noParse: /^(?!.*Stylesheets\.elm$).*\.elm$/,
  },
  resolve: {
    modules: [path.join(__dirname, 'src'), constants.nodeModulesDir],
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
  },
  entry: path.join(__dirname, 'src/index.js'),
  plugins: [
    new HTMLWebpackPlugin({ template: 'src/index.ejs', inject: 'body' }),
  ],
};

let configModifier;

if (process.env.NODE_ENV === 'development') {
  configModifier = require('./webpack-dev.config');
} else {
  configModifier = require('./webpack-prod.config');
}

module.exports = configModifier(base, constants);
