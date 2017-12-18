"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
/*
 * GET users listing.
 */
var express = require("express");
var fs = require("fs");
var moment = require("moment");
var router = express.Router();
router.get('/', function (req, res) {
    res.send("Get is not impleted");
});
router.post('/', function (req, res) {
    var message = '';
    var data = req.body;
    var name_part = "ipackage.json_";
    var date_part = moment().format('DDMMYYYY_HHmmss');
    // console.log('---- debug mode file generation ---------');
    // var filePath = "../chef_json/ipackage"+date_part+".json";
    var filePath = "/home/scripts/chef_json/ipackage" + date_part + ".json";
    if (data !== undefined) {
        fs.writeFile(filePath, JSON.stringify(data), function (err) {
            if (err) {
                message = 'Some error writing the file';
                console.log(err);
            }
            message = 'task was succcessfully written to disk';
        });
    }
    else {
        message = 'no data found to write';
    }
    res.send(message);
});
exports.default = router;
//# sourceMappingURL=cheftask.js.map