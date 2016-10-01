'use strict';

function mod(baseConfig) {
  return Object.assign(baseConfig, {
    module: Object.assign(baseConfig.module, {
      loaders: baseConfig.module.loaders.concat([{
        test: baseConfig.$styleSheetModule,
        loaders: ['style', 'css', 'elm-css-webpack'],
      }]),
    }),
    output: Object.assign(baseConfig.output, {
      publicPath: 'http://localhost:3000/dist/',
    }),
  });
}

module.exports = mod;
