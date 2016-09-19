'use strict';

function mod(baseConfig) {
  return Object.assign(baseConfig, {
    output: Object.assign(baseConfig.output, {
      publicPath: 'http://localhost:3000/dist/',
    }),
  });
}

module.exports = mod;
