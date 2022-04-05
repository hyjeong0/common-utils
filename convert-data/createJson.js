const path = require('path');
const xlsx = require('xlsx');
const fs = require('fs');

const excelName = `2022ePOP_Master_Tecace_v1.6.1.xlsx`;

const createJsonData = () => {
  const excelPath = path.join(__dirname, `./${excelName}`);
  const resultPath = path.join(__dirname, `./result`);
  const excel = xlsx.readFile(excelPath, {
    type: 'base64',
  });

  if (!fs.existsSync(resultPath)) {
    fs.mkdirSync(resultPath);
  }
  ['Pontus_Data', 'Kant_Data', 'History'].forEach(s => {
    const name = `${resultPath}/${
      s === 'History' ? `version.json` : `input_${s.replace('_Data', '').toLowerCase()}.json`
    }`;

    fs.writeFileSync(name, JSON.stringify(xlsx.utils.sheet_to_json(excel.Sheets[s])));
  });
};
createJsonData();
