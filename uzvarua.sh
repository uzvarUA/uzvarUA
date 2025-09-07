#!/data/data/com.termux/files/usr/bin/bash

# Значення яскравості: 0.7 означає темніше на 30%

read -p "Ставте URL:  " opt

yt-dlp -f bestvideo+bestaudio --merge-output-format mp4 "$opt"
BRIGHTNESS=0.7

for file in *.mp4; do
  base="${file%.*}"
  output="${base}_1.mp4"

  # Обчислюємо значення для фільтра ffmpeg
  BRIGHTNESS_FILTER=$(awk "BEGIN {print $BRIGHTNESS - 1}")

  ffmpeg -i "$file" \
    -vf "eq=brightness=$BRIGHTNESS_FILTER" \
    -c:a copy "$output"
done
