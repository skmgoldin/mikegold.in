//TODO: Write proper headers

var http = require('http');
var fs = require('fs');

var PORT = 80;
var CONTENTPATH = 'html';

var reqHandler = function(req, resp) {
  var requrl = CONTENTPATH + req.url;
  if(requrl == CONTENTPATH + '/') {
    requrl = CONTENTPATH + '/index.html';
  }

  console.log(req.headers.host, 'is requesting resource', requrl);

  fs.open(requrl, 'r', function(err, fd) {
    if(err) {
      resp.end('Sorry, couldn\'t fetch ' + requrl);
      return;
    }

    fs.fstat(fd, function(err, stats) {
      var contentBuf = new Buffer(stats.size);

      fs.read(fd, contentBuf, 0, stats.size, 0, function(err, bytesRead, buf) {
        resp.end(buf);

        fs.close(fd, function(err) {
          if(err)
            console.log('Couldn\'t close ' + requrl);
        });
      });
    });
  });
};

var server = http.createServer(reqHandler);

server.listen(PORT);
