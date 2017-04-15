const { readFile } = require('fs');
const xml2js = require('xml2js');

process.once('message', filename => {
  readFile(filename, (error, xmlString) => {
    if (error) {
      process.send({ error, result: null });
      return;
    }
    const parser = new xml2js.Parser();
    parser.parseString(xmlString, (error, result) => {
      if (error) {
        process.send({ error, result: null });
        return;
      }
      process.send({ result });
    });
  });
});
