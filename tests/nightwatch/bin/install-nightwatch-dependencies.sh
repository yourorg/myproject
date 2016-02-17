#!/bin/bash
#
# echo $(dirname $0)
# cd $(dirname $0)/..
#
# echo "  -- Ready to install NightWatch runner dependencies in -- $(pwd)."
set -e;

echo "  -- Ready to install NightWatch runner dependencies."
#
if [ "XX" == "X$(which java)X" ]; then
  echo "[FATAL] * * * Please install Java before running this script. * * * "
  exit 0;
fi;

SAFE_CHROME_VERSION="48.0.2564.109"; IS=0; CHROME_INSTALLED=${IS};
set +e;
CV=$(google-chrome --version) || {
  CHROME_INSTALLED=$?;
  echo "Chrome is not installed? - ${CHROME_INSTALLED}.";
}
set -e;

CHROME_VERSION=$(echo ${CV} | cut -f 3 -d " "); echo "Is minimum : '${SAFE_CHROME_VERSION}'' less than actual : '${CHROME_VERSION}'?";
if [[ ${CHROME_INSTALLED} != ${IS} || "${CHROME_VERSION}" < "${SAFE_CHROME_VERSION}" ]]; then
  if [[ ${CHROME_INSTALLED} == ${IS} ]]; then
    echo "Purging Chrome Browser ... ";
    sudo apt-get purge -y google-chrome-stable;
    echo "Purged Chrome Browser ... ";
  fi;

  echo "Installing Chrome Browser ... ";
  sudo apt-get install libxss1 libappindicator1 libindicator7;
  mkdir -p ${HOME}/tmp
  wget -P ${HOME}/tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb;
  sudo dpkg -i ${HOME}/tmp/google-chrome*.deb;
  echo "Installed Chrome Browser ... ";

fi;

export GLOBAL_NODEJS=$(npm config get prefix)
export GLOBAL_NODEJS_MODULES=${GLOBAL_NODEJS}/lib/node_modules
#
MDL="bunyan"
if [ -d ${GLOBAL_NODEJS_MODULES}/${MDL}/ ]; then
  echo "Node module '${MDL}' is already available.";
else
  if [ -w ${GLOBAL_NODEJS_MODULES} ] ; then
    echo "Installing '${MDL}' in directory -- ${GLOBAL_NODEJS_MODULES}."
    npm install -y --global --prefix ${GLOBAL_NODEJS} ${MDL};
  else
    echo "[FATAL] * * * No permissions to install ${MDL} * * * "
    echo "Please get ...
       npm install -y --global --prefix ${GLOBAL_NODEJS} ${MDL};
  ... to work properly.   For example try ...
       sudo npm install -y --global ${MDL}"
    exit 1;
  fi;
fi;


export LOCAL_NODEJS=${HOME}
export LOCAL_NODEJS_MODULES=${LOCAL_NODEJS}/node_modules
mkdir -p ${LOCAL_NODEJS_MODULES}
#
modules=( "touch" "bunyan" "underscore" "mkdirp" "nightwatch" "npm" "chromedriver" "minimist" "fs-extra" "request" )
for idx in "${modules[@]}"
do
  :
  if [ ! -d ${LOCAL_NODEJS_MODULES}/${idx}/ ]; then
    echo "Installing '${idx}' in directory -- ${LOCAL_NODEJS_MODULES}."
    npm install -y --prefix ${LOCAL_NODEJS} ${idx};
  else
    echo "Node module '${idx}' is already available.";
  fi;
done

echo "  -- linking chromedriver -- ${LOCAL_NODEJS_MODULES}/chromedriver to $(dirname $0)/chromedriver."
rm -f $(dirname $0)/chromedriver
ln -s ${LOCAL_NODEJS_MODULES}/chromedriver $(dirname $0)/chromedriver
#
echo "  -- installing Selenium in directory -- ${LOCAL_NODEJS_MODULES} $(dirname $0)."

wget -P ${LOCAL_NODEJS_MODULES} --no-clobber http://selenium-release.storage.googleapis.com/2.47/selenium-server-standalone-2.47.1.jar
rm -f $(dirname $0)/selenium-server-standalone.jar
ln -s ${LOCAL_NODEJS_MODULES}/selenium-server-standalone-2.47.1.jar $(dirname $0)/selenium-server-standalone.jar
#


echo "Dependencies have been installed."

