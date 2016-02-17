#!/usr/bin/env node
// Get locations of important artifacts
const constants = require("./config/constants.js");

// Use logger to ensure central instantiation of Bunyan logging
const logger = require("./bin/logger.js");

// minimist lets us cleanly parse our cli arguments into an object
const minimist = require( "minimist" );

var reqd = "";
// Use touch to ensure needed files exist
var touch = null;
// Use mkdirp to ensure needed directories exist
var mkdirp = null;
// nightwatch module
var nightwatch = null; // eslint-disable-line no-unused-vars
// chromedriver module
var chromedriver = null;  // eslint-disable-line no-unused-vars

// Collect our comman line parameters
var options = minimist( process.argv );

// Set logging level to "info", but ...
logger.level("info");

// ... if log level set by caller use that instead
options.log && logger.level(options.log);
const hint = "Try executing '" + constants.DEPENDENCY_INSTALLER + "'";
try {
  reqd = "touch";
  touch = require(reqd);
  logger.debug("NodeJs module '" + reqd + "' is installed.");
  reqd = "mkdirp";
  mkdirp = require(reqd);
  logger.debug("NodeJs module '" + reqd + "' is installed.");
  reqd = "nightwatch";
  nightwatch = require(reqd);
  logger.debug("NodeJs module '" + reqd + "' is installed.");
  reqd = "chromedriver";
  chromedriver = require(reqd);
  logger.debug("NodeJs module '" + reqd + "' is installed.");
} catch (err) {
  logger.fatal("NodeJs module '" + reqd + "' is not installed. " + hint);
  process.exit( 1 );
}

// so we can get the npm install prefix
const npm = require( "npm" );

// so we can read files from the filesystem
const fs = require( "fs-extra" );

// Get script that does all the work
const runNightwatch = require("./bin/nightwatch.js");


mkdirp(constants.NIGHTWATCH_LOGS_DIR, function confirmDir(errMkDir) {
  if (errMkDir) {
    logger.fatal( "Cannot continue. Logs directory '" + constants.NIGHTWATCH_LOGS_DIR + "' could not be created." );
    process.exit( 1 );
  }
  touch(constants.SELENIUM_LOG_PATH, function confirmFile(errTouch) {
    if (errTouch) {
      logger.fatal( "Cannot continue. Selenium log file '" + constants.SELENIUM_LOG + "' could not be created." );
      process.exit( 1 );
    }
  });
});

fs.open(constants.SELENIUM_DRIVER_PATH, "r", function confirmFile(errSD, fd) {
  if (errSD) {
    logger.fatal( "Cannot continue. Selenium driver '" + constants.SELENIUM_DRIVER_PATH + "' needs to be installed." );
    logger.info( hint );
    process.exit( 1 );
  }
  fs.close(fd);
});

/*    Looks like we can run NightWatch now  */
npm.load(
  function loadRunner( error, envNpm ) {
    var npmPrefix;

    if ( error ) {
      throw error;
    }

    npmPrefix = envNpm.config.get( "prefix" );

    logger.debug( "npm prefix is", npmPrefix );

//    findNightWatchTestFiles();

    runNightwatch(npmPrefix, options);
  }
);


/*
String.prototype.endsWith = function(suffix) {
    return this.match(suffix+"$") == suffix;
};

function findNightWatchTestFiles() {

  recursive('.', function (err, files) {
    // 'files' is an array of filenames
    var selected = [];
    files.forEach(
      function selectFiles(element, index, array) {
        var pathFile = element.split(path.sep);
        if ( [".meteor", ".git"].indexOf(pathFile[0]) < 0 ) {
          var nameFile = pathFile.pop()
          console.log('a[' + index + '] = ' + nameFile);
          if ( nameFile.endsWith(".js") ) {
            var file = element;

            var data = fs.readFileSync(element);
            if(data.toString().indexOf("NightWatch") > -1) {
              console.log (  element + " is a NightWatch file");
              selected.push(element);
            }
          }
        }
      }
    );

    console.log("~~~~~~~~");
    console.log(selected);
  });
}
*/
