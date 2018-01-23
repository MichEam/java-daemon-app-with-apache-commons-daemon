#! /bin/bash

NAME="mydaemon"
DESC="MyDaemon service"

EXEC="jsvc"
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIB_DIR="$WORK_DIR/build/libs"
JAVA_HOME=$(/usr/libexec/java_home)
CLASS_PATH="$LIB_DIR/mydaemon.jar"
CLASS="com.github.micheam.sample.MyDaemonApp"
ARGS=""
#USER="guest"
PID="/var/run/$NAME.pid"
LOG_OUT="$WORK_DIR/log/$NAME.out"
LOG_ERR="$WORK_DIR/log/$NAME.err"

jsvc_exec()
{   
    cd $WORK_DIR
    $EXEC -cwd $WORK_DIR -home $JAVA_HOME -cp $CLASS_PATH -outfile $LOG_OUT -errfile $LOG_ERR -pidfile $PID $1 $CLASS $ARGS
}

case "$1" in
    check)  
        echo "EXEC=$EXEC"
        echo "WORK_DIR=$WORK_DIR"
        echo "LIB_DIR=$LIB_DIR"
        echo "JAVA_HOME=$JAVA_HOME"
        echo "CLASS_PATH=$CLASS_PATH"
        echo "CLASS=$CLASS"
        echo "ARGS=$ARGS"
        echo "PID=$PID"
        echo "LOG_OUT=$LOG_OUT"
        echo "LOG_ERR=$LOG_ERR"

        jsvc_exec -check
    ;;
    start)  
        echo "Starting the $DESC..."        
        
        # Start the service
        jsvc_exec
        
        echo "The $DESC has started."
    ;;
    stop)
        echo "Stopping the $DESC..."
        
        # Stop the service
        jsvc_exec "-stop"       
        
        echo "The $DESC has stopped."
    ;;
    restart)
        if [ -f "$PID" ]; then
            
            echo "Restarting the $DESC..."
            
            # Stop the service
            jsvc_exec "-stop"
            
            # Start the service
            jsvc_exec
            
            echo "The $DESC has restarted."
        else
            echo "Daemon not running, no action taken"
            exit 1
        fi
            ;;
    *)
    echo "Usage: $WORK_DIR/`basename $0` {start|stop|restart|check}" >&2
    exit 3
    ;;
esac
