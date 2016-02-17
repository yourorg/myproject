// add tests to this file using the Nightwatch.js API
// http://nightwatchjs.org/api

/* NightWatch test */
module.exports = {
  before: function connect(client) {
    client.url("http://localhost:3000");
  },
};
