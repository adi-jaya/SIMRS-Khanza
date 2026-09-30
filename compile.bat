@echo off
setlocal
set "JAVA_HOME=C:\Program Files\BellSoft\LibericaJDK-15-Full"
set "PATH=%JAVA_HOME%\bin;%PATH%"
set "ANT_OPTS=-Xss64m -Xmx2048m"

echo Menggunakan Java:
"%JAVA_HOME%\bin\java.exe" -version

if "%~1"=="" (
    echo Menjalankan ant clean compile...
    call ant clean compile
) else (
    echo Menjalankan ant %*...
    call ant %*
)

echo Selesai.
endlocal
