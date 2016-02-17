// add tests to this file using the Nightwatch.js API
// http://nightwatchjs.org/api

/* NightWatch test */
module.exports = {
  "Layout and Static Pages": function pageLayout(client) {
    client
      .resizeWindow(1024, 768)
      .verify.elementPresent("body")

      .end();
  },
};

