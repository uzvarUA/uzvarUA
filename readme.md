# Вічний стрим
## Файл start.sh

```sh
#!/data/data/com.termux/files/usr/bin/sh

trap 'echo; echo "stop"; termux-wake-unlock; exit 0' INT

termux-wake-lock

if [ ! -f twitch.key ]; then
    echo "Помилка: файл twitch.key не знайдено!"
    exit 1
fi

KEY=$(cat twitch.key)

if ! ls *.mp4 >/dev/null 2>&1; then
    echo "Помилка: MP4-файли не знайдені!"
    exit 1
fi

VIDEO=$(ls *.mp4 | head -n 1)

echo "Знайдено файл: $VIDEO"

while true; do
    ffmpeg -stream_loop -1 \
    -re \
    -i "$VIDEO" \
    -c:v libx264 \
    -preset veryfast \
    -b:v 6000k \
    -maxrate 6000k \
    -bufsize 12000k \
    -c:a aac \
    -b:a 160k \
    -ar 44100 \
    -f flv "rtmp://live.twitch.tv/app/$KEY"

    echo
    echo "FFmpeg завершився. Перезапуск через 10 секунд..."
    sleep 10
done
```

## Файл twitch.key

```text
live_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## Запуск

```bash
chmod +x start.sh
./start.sh
```

## Приклад структури каталогу

```text
.
├── start.sh
├── twitch.key
├── video.mp4
└── 
