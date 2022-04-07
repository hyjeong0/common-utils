echo off

echo.
echo           Code optimization for build by HY..
echo.

echo -----------------------------------
echo         Closure Compiler
echo -----------------------------------
echo.

for /f %%I in ('dir /s/b "..\js\*.js"') do (
    echo %%~nxI..
    call java -jar compiler.jar --compilation_level SIMPLE_OPTIMIZATIONS --js %%I --js_output_file ..\build\js\%%~nxI 
)

for /f %%I in ('dir /s/b "..\lib\*.js"') do (
    if %%~nxI == tau.js (
        echo %%~nxI..
        call java -jar compiler.jar --compilation_level SIMPLE_OPTIMIZATIONS --js %%I --js_output_file ..\build\js\%%~nxI 
    )
)

echo -----------------------------------
echo        Initialize Grunt
echo -----------------------------------
echo.

call cd ..\
call npm install -g grunt-cli
call npm install grunt --save-dev
call npm init
call npm install --save-dev grunt-contrib-concat
call npm install --save-dev grunt-contrib-cssmin


REM -----------------------------------
REM         Create Grunfile
REM -----------------------------------
echo module.exports = function(grunt) { >> Gruntfile.js
echo    var jsResources = [ >> Gruntfile.js

for /f %%I in ('dir /s/b "build\js\*.js"') do echo 'build/js/%%~nxI', >> Gruntfile.js

echo    ]; >> Gruntfile.js
echo    var cssResources = [ >> Gruntfile.js

for /f %%I in ('dir /s/b "css\*.css"') do echo 'css/%%~nxI', >> Gruntfile.js

echo    ]; >> Gruntfile.js
echo. >> Gruntfile.js
echo    grunt.initConfig({ >> Gruntfile.js
echo        pkg: grunt.file.readJSON('package.json'), >> Gruntfile.js
echo. >> Gruntfile.js
echo        concat: { >> Gruntfile.js
echo            dist: { >> Gruntfile.js
echo              src: jsResources, >> Gruntfile.js
echo              dest: 'result/application.min.js', >> Gruntfile.js
echo            } >> Gruntfile.js
echo        }, >> Gruntfile.js
echo. >> Gruntfile.js
echo        cssmin: { >> Gruntfile.js
echo            target: { >> Gruntfile.js
echo              files: [{ >> Gruntfile.js
echo                  src: cssResources, >> Gruntfile.js
echo                  dest: 'result/style.min.css', >> Gruntfile.js
echo              }] >> Gruntfile.js
echo            } >> Gruntfile.js
echo        }, >> Gruntfile.js
echo    }); >> Gruntfile.js
echo. >> Gruntfile.js
echo    grunt.loadNpmTasks('grunt-contrib-concat'); >> Gruntfile.js
echo    grunt.loadNpmTasks('grunt-contrib-cssmin'); >> Gruntfile.js
echo    grunt.registerTask('default', ['concat', 'cssmin']); >> Gruntfile.js
echo } >> Gruntfile.js

REM -----------------------------------
REM          Execute grunt
REM -----------------------------------
call grunt

REM ---------------------------------------------
REM     Create code to init tizen application
REM ---------------------------------------------
call cd result\
echo (function () { >> initApplication.js
echo    window.onload = function(){ >> initApplication.js
echo        var script = document.createElement('script'); >> initApplication.js
echo        script.type = 'text/javascript'; >> initApplication.js
echo        script.src = 'result/application.min.js'; >> initApplication.js
echo        document.body.appendChild(script); >> initApplication.js
echo    }; >> initApplication.js
echo }()); >> initApplication.js

REM -----------------------------------
REM              Clear
REM -----------------------------------
call cd ..\
call rmdir /s /q build
call rmdir /s /q node_modules
call del package.json
call del package-lock.json
call del Gruntfile.js

pause

