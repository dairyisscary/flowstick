const { fork } = require('child_process');
const { Observable } = require('rxjs/Observable');
require('rxjs/add/operator/switchMap');

function read(filename) {
  return Observable.create(observer => {
    const worker = fork('./src/XPDL/read-worker.js');
    worker.send(filename);
    worker.once('message', msg => {
      observer.next(msg);
      observer.complete();
    });
  });
}

function wireElm({ ports }) {
  const { readXPDL, jsonXPDL } = ports;
  const filenames = Observable.create(observer => {
    readXPDL.subscribe(filename => {
      observer.next(filename);
    });
  });

  filenames.switchMap(read).subscribe(({ result, error }) => {
    if (result) {
      jsonXPDL.send({ result, error: null });
    } else if (error) {
      jsonXPDL.send({ error: error.code.toString(), result: null });
    } else {
      // This should never occur.
      jsonXPDL.send({ error: 'Unknown file XPDL read result.', result: null });
    }
  });
}

module.exports = wireElm;
