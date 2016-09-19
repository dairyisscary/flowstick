'use strict';
const base = require('./webpack-base.config');
const config = Object.create(base);

let configModifier;

if (process.env.NODE_ENV === 'development') {
  configModifier = require('./webpack-dev.config');
} else {
  configModifier = require('./webpack-prod.config');
}

module.exports = configModifier(base);
