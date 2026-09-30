#!/usr/bin/env bash
# Script helper kompilasi SIMRS-Khanza untuk macOS dan Linux

if [ -z "$JAVA_HOME" ]; then
    if [ "$(uname)" = "Darwin" ]; then
        if [ -x /usr/libexec/java_home ]; then
            export JAVA_HOME=$(/usr/libexec/java_home -v 1.8 2>/dev/null || /usr/libexec/java_home 2>/dev/null)
        fi
    fi
fi

export ANT_OPTS="-Xss64m -Xmx2048m"

echo "Menggunakan Java: $JAVA_HOME"
if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
    "$JAVA_HOME/bin/java" -version
else
    java -version
fi

if [ $# -eq 0 ]; then
    echo "Menjalankan ant clean compile..."
    ant clean compile
else
    echo "Menjalankan ant $*..."
    ant "$@"
fi
