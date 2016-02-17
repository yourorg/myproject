#!/bin/bash
#
set -e;

echo "Purging meteor-nightwatch-runner from this filesystem."
cd $(dirname $0)
pwd
cd ./config
rm -f example_circle.yml
rm -f globals.json
rm -f nightwatch.json
rm -f constants.js
[ `ls -1A . | wc -l` -eq 0 ] && rm -fr ../config
cd ../bin
rm -f logger.js
rm -f nightwatch.js
rm -f chromedriver
rm -f install-nightwatch-dependencies.sh
rm -f selenium-server-standalone.jar
rm -f .gitignore
[ `ls -1A . | wc -l` -eq 0 ] && rm -fr ../bin
cd ../walkthroughs
rm -f example.js
rm -f bracketNightWatchTests.js
[ `ls -1A . | wc -l` -eq 0 ] && rm -fr ../walkthroughs
mkdir -p ../logs;
cd ../logs
rm -f *.log
[ `ls -1A . | wc -l` -eq 0 ] && rm -fr ../logs
mkdir -p ../reports
cd ../reports
rm -f *.xml
[ `ls -1A . | wc -l` -eq 0 ] && rm -fr ../reports
cd ..
rm -f runTests.js
rm -fr ./remove-meteor-nightwatch-runner.sh*
rm -fr ./.gitignore

[ `ls -1A . | wc -l` -eq 0 ] && rm -fr ../nightwatch
cd ..
[ `ls -1A . | wc -l` -eq 0 ] && rm -fr ../tests
