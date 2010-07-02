#!/usr/bin/env zsh

rootdir=/home/e640846/Developments/YPassword
releasedir=$rootdir/Build/Release/YPassword
publishdir=/Volumes/yann.esposito/Web/Sites/YPassword

cd $rootdir
jake release
cp sha1.js $releasedir
print -- 'commonjs'
cp $releasedir/CommonJS.environment/YPassword.sj $publishdir/CommonJS.environment
print -- 'browserjs'
cp $releasedir/Browser.environment/YPassword.sj $publishdir/Browser.environment
print -- 'done'
