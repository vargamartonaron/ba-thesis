const express = require('express');
const fs = require('fs');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const path = require('path');
const cors = require('cors');
const app = express();
app.use(cors());
const port = 3000;

// Serve static files from the current directory
app.use(express.static(__dirname));
app.use(bodyParser.json({ limit: '50mb' }));
// Endpoint to run the Python script and serve the generated data
app.get('/generate-trials', cors(), (req, res) => {
 exec('python3 gen_trials.py', {maxBuffer: undefined}, (error, stdout, stderr) => {
    if (error) {
      console.log(`error: ${error.message}`);
      return;
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`);
      return;
    }
    // Assuming the Python script outputs JSON
    var trialsData = JSON.parse(stdout);
    res.json(trialsData);
    console.log('Trials data sent');
    // console.log(trialsData);
 });
});

app.post('/save-data', (req, res) => {
  console.log(req.body);
  if (!req.body) {
    console.error('No data posted');
    res.status(400).send('No data posted');
    return;
  }
  //get data as json from this request function ajax call
  var data = JSON.stringify(req.body);
  // save data to file
  fs.appendFile('data.json', data + '\n', (err) => {
        if (err) {
            console.error('Error appending data to file:', err);
            res.status(500).send('Error saving data');
        } else {
            console.log('Data appended successfully');
            res.status(200).send('Data saved successfully');
        }
  });
});

// Serve the cse.html file
app.get('/', (req, res) => {
 res.sendFile(path.join(__dirname, 'cse.html'));
});

app.listen(port, () => {
 console.log(`Server running at http://localhost:${port}`);
});
