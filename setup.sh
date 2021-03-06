#!/bin/sh

# Set script to exit on any errors.
set -e

# Initialize project dependency directories and the shrinkwrap file location.
init(){
  NODE_DIR=node_modules
  SHRINKWRAP=npm-shrinkwrap.json

  echo 'npm components directory:' $NODE_DIR
}

# Clean project dependencies.
clean(){
  # If the node directory already exist,
  # clear them so we know we're working with a clean
  # slate of the dependencies listed in package.json.
  if [ -d $NODE_DIR ]; then
    echo 'Removing project dependency directories...'
    rm -rf $NODE_DIR
  fi
  echo 'Project dependencies have been removed.'
}

# Install project dependencies.
install(){
  echo 'Installing project dependencies...'
  if [ -f $SHRINKWRAP ]; then
    echo 'Removing previous shrinkwrapped dependency settings...'
    rm -f $SHRINKWRAP
  fi
  npm install
  npm install --save --save-exact box-sizing-polyfill@0.1.0 jquery.easing@1.3.2 normalize-css@2.3.1 jquery@1.11.3 normalize-legacy-addon@0.1.0
  echo 'Shrinkwrapping project dependencies...'
  npm prune
  npm shrinkwrap --dev
}

# Run tasks to build the project for distribution.
build(){
  echo 'Building project...'
  gulp clean
  gulp build
  find paying_for_college -name '*.css' -exec \
      sed  -i '' 's/\/static\/vendor\/box-sizing-polyfill\/boxsizing.htc/\/static\/paying_for_college\/disclosures\/static\/js\/boxsizing.htc/g' {} \;
  find paying_for_college -name '*.css' -exec \
      sed  -i '' 's/\/cf-grid\/custom-demo\/static\/css\/boxsizing.htc/\/static\/paying_for_college\/disclosures\/static\/js\/boxsizing.htc/g' {} \;
}

init
clean
install
build
