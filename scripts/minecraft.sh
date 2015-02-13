#!/bin/bash
export JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
java -DsocksProxyHost=127.0.0.1 -DsocksProxyPort=1080 -jar /Applications/Minecraft.app/Contents/Resources/Java/Bootstrap.jar
