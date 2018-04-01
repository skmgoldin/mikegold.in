const express = require('express');

const app = express();

const port = process.env.PORT || 3000;

app.use((req, res, next) => {
  if ((!req.secure) && (req.get('X-Forwarded-Proto') !== 'https')) {
    res.redirect(`https://${req.get('Host')}${req.url}`);
  } else { next(); }
});
app.use(express.static('public'));

app.listen(port, () => {
  // eslint-disable-next-line
  console.log(`Server running at http://127.0.0.1:${port}/`);
});

