import debug = require('debug');
import express = require('express');
import path = require('path');
import bodyParser = require('body-parser');
import morgan = require('morgan');
import methodOverride = require('method-override');
import routes from './routes/index';
import cheftasks from './routes/cheftask';

var app = express();
app.use(bodyParser.json());  
app.use(bodyParser.json({ type: 'application/vnd.api+json' }));
app.use(methodOverride());
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public/views')));
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');
app.use(morgan('dev'));
app.use(bodyParser.urlencoded(
  {
    'extended': true,
  }
));  

app.use('/', routes);
app.use('/api/cheftasks', cheftasks);


// catch 404 and forward to error handler
app.use(function (req, res, next) {
    var err = new Error('Not Found');
    err['status'] = 404;
    next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use((err: any, req, res, next) => {
        res.status(err['status'] || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use((err: any, req, res, next) => {
  res.status(err.status || 500);
  res.render('error', {
        message: err.message,
        error: err
    });
});

app.set('port', process.env.PORT || 3200);

var server = app.listen(app.get('port'), function () {
    console.log('Express server listening on port ' + server.address().port);
});
