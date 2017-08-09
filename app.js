let port = process.env.PORT || 3000,
    http = require('http'),
    fs = require('fs'),
    urlTools = require('url')

const prepend = 'public/'

const getRequestedFile = function getRequestedFile(url) {
  const path = urlTools.parse(url).pathname 
  let file
  if(path === '/') {
    file = fs.readFileSync(prepend + 'index.html')
  } else {
    file = fs.readFileSync(prepend + path)
  }
  return file
}

let server = http.createServer(function (req, res) {
  const file = getRequestedFile(req.url);
  res.writeHead(200);
  res.write(file);
  res.end();
});

// Listen on port 3000, IP defaults to 127.0.0.1
server.listen(port);

// Put a friendly message on the terminal
console.log('Server running at http://127.0.0.1:' + port + '/');
