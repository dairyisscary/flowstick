require('./Stylesheets.elm');
require('./index.html');

const Elm = require('./Main.elm');
const app = Elm.Main.fullscreen();

const xpdl = require('./Json/XPDL');
xpdl(app);

const file = require('./file');
file(app);
