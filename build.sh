#!/bin/sh
if [ -d "/home/q/php/STC" ];then
STC_PATH="/home/q/php/STC"
else
STC_PATH="/Users/welefen/Develop/git/stc/src"
fi
path=`dirname $0`;
first=${path:0:1};
if [[ $first != '/' ]];then
    path=$(pwd);
fi

if [ -d ${path}"/output" ];then
  rm -rf ${path}"/output";
fi

if [ -d ${path}"/output.theme" ];then
  rm -rf ${path}"/output.theme";
fi

mkdir ${path}"/output";
if [ ! -f ${path}"/config.php" ];then
  cp $STC_PATH/config/config.php ${path};
fi
if [ -f /usr/local/bin/php ];then
    PHP="/usr/local/bin/php";
else
    PHP="/usr/bin/php";
fi

rm -rf www/static/js/admin.bundle.js.map;
webpack;

$PHP $STC_PATH/index.php ${path} test online;

mkdir -p www/theme/firekylin.build/html;
cp -r www/theme/firekylin/*.html www/theme/firekylin.build/html/
cp -r www/theme/firekylin/inc www/theme/firekylin.build/html/


$PHP $STC_PATH/index.php ${path} test online config_theme.php output.theme;
cp -r output.theme/www/theme/firekylin.build/html/* output.theme/www/theme/firekylin;
rm -rf output.theme/www/theme/firekylin.build;
cp -r output.theme/www/ output/www/
rm -rf output.theme;


if [ -f ${path}"/stc.error.log" ]; then
    rm -rf ${path}"/stc.error.log";
    exit 1;
fi

npm run compile;
npm run copy-package;
cp -r app output;
cp -r nginx.conf output;
cp -r pm2.json output;
cp -r www/*.js output/www;