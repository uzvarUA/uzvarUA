#!/bin/bash

trap 'echo; echo "stop"; exit 0' INT

> list.txt
for f in *.mp4; do
    [ -f "$f" ] && echo "file '$f'" >> list.txt
done

if [ ! -s list.txt ]; then
    echo "Не знайдено MP4-файлів"
    exit 1
fi

echo "list.txt створено"
echo
echo "Оберіть платформу:"
echo "1) YouTube"
echo "2) Twitch"
echo

read -p "Введіть номер: " choice

read -s -p "Введіть ключ трансляції: " STREAM_KEY
echo

case $choice in
    1)
        URL="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
        ;;
    2)
        URL="rtmp://live.twitch.tv/app/$STREAM_KEY"
        ;;
    *)
        echo "Невірний вибір"
        exit 1
        ;;
esac

while true; do
    echo "Запуск трансляції..."

    ffmpeg \
    -stream_loop -1 \
    -re \
    -f concat \
    -safe 0 \
    -i list.txt \
    -c:v libx264 \
    -preset veryfast \
    -b:v 6000k \
    -c:a aac \
    -b:a 160k \
    -f flv \
    "$URL"

    echo "Перезапуск через 10 секунд..."
    sleep 10
done
