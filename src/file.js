const { remote } = require('electron');
const { Observable } = require('rxjs/Observable');

const DIALOG_OPTIONS = Object.freeze({
  properties: ['openFile'],
  title: 'Open XPDL',
  filters: [
    { name: 'XPDLs', extensions: ['xpdl'] },
    { name: 'All Files', extensions: ['*'] },
  ],
});

function getFilename() {
  return Observable.create(observer => {
    remote.dialog.showOpenDialog(remote.getCurrentWindow(), DIALOG_OPTIONS, filenames => {
      if (filenames && filenames.length) {
        observer.next(filenames[0]);
        observer.complete();
      }
    });
  });
}

function wireElm({ ports }) {
  const { openFileDialog, recieveFilenameFromDialog } = ports;
  const openCmds = Observable.create(observer => {
    openFileDialog.subscribe(() => {
      observer.next();
    });
  });

  openCmds.switchMap(getFilename).subscribe(filename => {
    recieveFilenameFromDialog.send(filename);
  });
}

module.exports = wireElm;
