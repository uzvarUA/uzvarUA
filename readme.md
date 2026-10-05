# вічний стрим 24/7
```bash
#!/data/data/com.termux/files/usr/bin/sh

trap 'echo; echo "stop"; termux-wake-unlock; exit 0' INT

termux-wake-lock

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
    -c:v libx264 -preset veryfast \
    -b:v 6000k \
    -maxrate 6000k \
    -bufsize 12000k \
    -c:a aac -b:a 160k \
    -ar 44100 \
    -f flv "rtmp://live.twitch.tv/app/$KEY"
    echo "FFmpeg завершився. Перезапуск через 10 секунд..."
done
```
