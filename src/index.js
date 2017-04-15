require('./Stylesheets.elm');
require('./index.html');

const Elm = require('./Main.elm');
const app = Elm.Main.fullscreen();

const xpdl = require('./Json/Decode/Xpdl');
xpdl(app);

const file = require('./file');
file(app);
