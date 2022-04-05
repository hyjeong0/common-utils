const path = require('path');
const xlsx = require('xlsx');
const fs = require('fs');

const excelName = '[File name]';
const extractData = [];

const createJsonData = () => {
  const excelPath = path.join(__dirname, `./${excelName}`);
  const resultPath = path.join(__dirname, `./result`);
  const excel = xlsx.readFile(excelPath, {
    type: 'base64',
  });

  if (!fs.existsSync(resultPath)) {
    fs.mkdirSync(resultPath);
  }
  extractData.forEach(s => {
    const name = `${resultPath}/result.json`;
    fs.writeFileSync(name, JSON.stringify(xlsx.utils.sheet_to_json(excel.Sheets[s])));
  });
};
createJsonData();
