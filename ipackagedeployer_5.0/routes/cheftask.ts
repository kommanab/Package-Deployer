/*
 * GET users listing.
 */
import express = require('express');
import fs = require('fs');
import moment = require('moment');

const router = express.Router();

router.get('/', (req: express.Request, res: express.Response) => {
  res.send("Get is not impleted");
  
});

router.post('/', (req: express.Request, res: express.Response) => {    
  let message = '';
  var data = req.body;

   var name_part = "ipackage.json_"
   var date_part = moment().format('DDMMYYYY_HHmmss');
   // console.log('---- debug mode file generation ---------');
   // var filePath = "../chef_json/ipackage"+date_part+".json";
   var filePath = "/home/scripts/chef_json/ipackage"+date_part+".json";

  if (data !== undefined) {
    fs.writeFile(filePath, JSON.stringify(data), (err) => {
      if (err) {
        message = 'Some error writing the file'
        console.log(err);
      }
      message = 'task was succcessfully written to disk'
    
    });
   
  } else {
    message = 'no data found to write';
  }
  res.send(message);
});

export default router;
