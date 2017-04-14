'use strict';

function mod(baseConfig, { styleSheetModule }) {
  return Object.assign(baseConfig, {
    module: Object.assign(baseConfig.module, {
      loaders: baseConfig.module.loaders.concat([{
        test: styleSheetModule,
        loaders: ['style', 'css', 'elm-css-webpack'],
      }, {
        test: /\.elm$/,
        loaders: ['elm-webpack'],
        exclude: [/elm-stuff/, /node_modules/, styleSheetModule],
      }]),
    }),
    output: Object.assign(baseConfig.output, {
      publicPath: 'http://localhost:3000/dist/',
    }),
  });
}

module.exports = mod;
