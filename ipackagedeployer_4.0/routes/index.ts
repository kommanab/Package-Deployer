/*
 * GET home page.
 */
import express = require('express');
import fs = require('fs');
import path = require('path');

const router = express.Router();

router.get('/', (req: express.Request, res: express.Response) => {
  // res.sendFile(path.join(__dirname, + '/public/views/Index.html'));
  res.sendFile(path.join(__dirname, '../public/views/Index.html'));
});

export default router;