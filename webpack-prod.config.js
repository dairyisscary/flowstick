'use strict';
const extractTextPlugin = require('extract-text-webpack-plugin');
const cssExtract = new extractTextPlugin('styles.css');

function mod(baseConfig) {
  return Object.assign(baseConfig, {
    module: Object.assign(baseConfig.module, {
      loaders: baseConfig.module.loaders.concat([{
        test: baseConfig.$styleSheetModule,
        loader: cssExtract.extract(['css', 'elm-css-webpack']),
      }, {
        test: /\.elm$/,
        loaders: ['elm-webpack'],
        exclude: [/elm-stuff/, /node_modules/, baseConfig.$styleSheetModule],
      }]),
    }),
    plugins: baseConfig.plugins.concat([cssExtract]),
  });
}

module.exports = mod;
