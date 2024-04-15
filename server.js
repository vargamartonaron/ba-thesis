const express = require('express');
const fs = require('fs');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const path = require('path');
const app = express();
const cors = require('cors');
const port = 3000;

// Serve static files from the current directory
app.use(express.static(__dirname));
app.use(bodyParser.json({ limit: '50mb' }));
app.use(cors());
app.use(function(req, res, next) {
  res.header('Access-Control-Allow-Origin', 'http://localhost:3000');
  res.header('Access-Control-Allow-Origin', 'http://localhost:3000/generate-trials');
  res.header('Access-Control-Allow-Headers', true);
  res.header('Access-Control-Allow-Credentials', true);
  res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
  next();
});

// Endpoint to run the Python script and serve the generated data
app.get('/generate-trials', (req, res) => {
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
