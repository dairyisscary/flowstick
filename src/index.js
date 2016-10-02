require('./Stylesheets.elm');
require('./index.html');

const Elm = require('./Main.elm');
const app = Elm.Main.fullscreen();

const xpdl = require('./XPDL');
xpdl(app);
