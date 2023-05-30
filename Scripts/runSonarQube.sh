#!/bin/sh

export SONAR_SCANNER_VERSION=4.7.0.2747
export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-macosx
curl --create-dirs -sSLo $HOME/.sonar/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-macosx.zip
unzip -o $HOME/.sonar/sonar-scanner.zip -d $HOME/.sonar/
export PATH=$SONAR_SCANNER_HOME/bin:$PATH
export SONAR_SCANNER_OPTS="-server"

sonar-scanner \
  -Dsonar.projectKey=checkout_NetworkClient-iOS_AYhsdjYEfXz2nF6wDAnO \
  -Dsonar.sources=. \
  -Dsonar.c.file.suffixes=- \
  -Dsonar.cpp.file.suffixes=- \
  -Dsonar.objc.file.suffixes=- \
  -Dsonar.coverage.exclusions=Tests/** \
  -Dsonar.host.url=https://sonarqube-ext.mgmt.ckotech.co
