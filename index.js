'use strict';
process.env.NODE_ENV = process.env.NODE_ENV || 'production';
const electron = require('electron');
const app = electron.app;
const IS_DEV = process.env.NODE_ENV === 'development';

let mainWindow = null;

if (IS_DEV) {
  require('electron-debug')();
}

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('ready', () => {
  mainWindow = new electron.BrowserWindow({
    show: false,
    width: 1024,
    height: 728,
  });

  const srcDir = IS_DEV ? 'src' : 'dist';
  mainWindow.loadURL(`file://${__dirname}/${srcDir}/index.html`);
  mainWindow.maximize();
  mainWindow.setMenu(null);

  mainWindow.webContents.on('did-finish-load', () => {
    mainWindow.show();
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });

  if (IS_DEV) {
    mainWindow.openDevTools();
  }
});
