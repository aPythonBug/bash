#!/bin/bash
echo ""
echo "Starting init script for Magento 2..."
echo ""

php_cli="php"
default_force="-f"

echo "Type in the language for magento deploying: "
echo "(ex: en_US nl_NL if it's left black will use en_US nl_NL by default)"

default_langs="en_US nl_NL"
read langs_string;

echo "Enable any modules? (ex: Module_name_one Module_name_two)"
echo "Leave it empty for no modules to enable."
read module_string;

echo "Enable force mode for setup:static-content:deploy?";
echo "Defaults to yes, if you do not want it enter no, else press enter to continue";
read force;

if [ -n "$1" ];then
    php_cli=$1;
fi

if [[ ! -z "$module_string" ]];then
    declare -a module_arr=($module_string);
    for module in ${module_arr[@]}
    do 
        $php_cli bin/magento module:enable $module
        $php_cli bin/magento setup:upgrade
    done
fi

echo "Removing static and temp files:"
rm -rf generated/* var/cache/* var/page_cache/* var/view_preprocessed/* var/tmp/* pub/static/*

$php_cli bin/magento setup:di:compile

if [ "$force" == "no" ];then
    default_force="olla";
fi

if [[ ! -z "$langs" ]];then
    default_langs=langs
fi

$php_cli bin/magento setup:static-content:deploy $default_force $default_langs
$php_cli bin/magento cache:flush

echo "Finished.";
