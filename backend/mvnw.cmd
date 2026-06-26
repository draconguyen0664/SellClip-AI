@echo off
setlocal

set MAVEN_VERSION=3.9.9
set SCRIPT_DIR=%~dp0
set MAVEN_HOME=%SCRIPT_DIR%.mvn\apache-maven-%MAVEN_VERSION%
set MAVEN_BIN=%MAVEN_HOME%\bin\mvn.cmd

if exist "%MAVEN_BIN%" (
  call "%MAVEN_BIN%" %*
  exit /b %ERRORLEVEL%
)

where mvn >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  mvn %*
  exit /b %ERRORLEVEL%
)

echo Maven not found. Downloading Apache Maven %MAVEN_VERSION%...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "$version='%MAVEN_VERSION%';" ^
  "$root='%SCRIPT_DIR%.mvn';" ^
  "$zip=Join-Path $root ('apache-maven-' + $version + '-bin.zip');" ^
  "$url='https://archive.apache.org/dist/maven/maven-3/' + $version + '/binaries/apache-maven-' + $version + '-bin.zip';" ^
  "New-Item -ItemType Directory -Force $root | Out-Null;" ^
  "Invoke-WebRequest -UseBasicParsing $url -OutFile $zip;" ^
  "Expand-Archive -Force $zip $root;"

if not exist "%MAVEN_BIN%" (
  echo Maven bootstrap failed.
  exit /b 1
)

call "%MAVEN_BIN%" %*

