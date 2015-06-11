#!/bin/sh
. /etc/rc.d/init.d/functions

piddir="/var/run/redis"
logdir="/var/log/redis"
dumpdir="/var/lib/redis"
port_list=(6379 6380 6381)

start(){
    for port in ${port_list[@]}
    do
        echo -n "redis-$port 起動中 :"
        sudo /usr/bin/redis-server /etc/redis.conf --port $port --daemonize yes --pidfile $piddir/redis-$port.pid --logfile $logdir/redis-$port.log --dir $dumpdir --dbfilename dump-$port.rdb
        retval=$?
        if [ $retval -eq 0 ]
        then
            success
        else
            failure
        fi
        echo
    done
}

stop(){
    for port in ${port_list[@]}
    do
        echo -n "redis-$port 停止中 :"
        pid=`cat $piddir/redis-$port.pid`
        sudo kill -9 $pid
        retval=$?
        if [ $retval -eq 0 ]
        then
            success
        else
            failure
        fi
        echo
    done
}

restart(){
    stop
    start
}

case "$1" in
    start)
        $1
        ;;
    stop)
        $1
        ;;
    restart)
        $1
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart}"
        exit 2
esac
exit $?
