'use strict';
const path = require('path');
const webpack = require('webpack');
const merge = require('webpack-merge');

function mod(baseConfig, { styleSheetModule, nodeModulesDir }) {
  return merge(baseConfig, {
    module: {
      rules: [{
        test: styleSheetModule,
        use: ['style-loader', 'css-loader', 'elm-css-webpack-loader'],
      }, {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/, styleSheetModule],
        use: [{
          loader: 'elm-webpack-loader',
          options: {
            cwd: __dirname,
            pathToMake: path.join(nodeModulesDir, '.bin/elm-make'),
            forceWatch: true,
          },
        }],
      }],
    },
    devServer: {
      inline: true,
      stats: 'minimal',
    },
  });
}

module.exports = mod;
