"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
/*
 * GET home page.
 */
var express = require("express");
var path = require("path");
var router = express.Router();
router.get('/', function (req, res) {
    // res.sendFile(path.join(__dirname, + '/public/views/Index.html'));
    res.sendFile(path.join(__dirname, '../public/views/Index.html'));
});
exports.default = router;
//# sourceMappingURL=index.js.map