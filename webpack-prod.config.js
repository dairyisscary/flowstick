'use strict';
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const merge = require('webpack-merge');

function mod(baseConfig, { styleSheetModule }) {
  return merge(baseConfig, {
    module: {
      rules: [{
        test: styleSheetModule,
        use: ExtractTextPlugin.extract({
          use: ['css-loader', 'elm-css-webpack-loader'],
        }),
      }, {
        test: /\.elm$/,
        loader: 'elm-webpack-loader',
        exclude: [/elm-stuff/, /node_modules/, styleSheetModule],
      }],
    },
    plugins: [new ExtractTextPlugin('styles.css')],
  });
}

module.exports = mod;
