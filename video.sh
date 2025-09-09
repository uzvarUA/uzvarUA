#!/data/data/com.termux/files/usr/bin/bash

# 🎨 Стильне ASCII-привітання
echo -e "\e[1;35m╔══════════════════════════════╗"
echo -e "║ 🎬 Відео-Трансформатор v1.0 ║"
echo -e "╚══════════════════════════════╝\e[0m"

read -p "🔗 Вставте URL відео: " url
[[ -z "$url" ]] && echo "❌ URL не вказано. Вихід." && exit 1

yt-dlp -f bestvideo+bestaudio --merge-output-format mp4 "$url" -o "%(title)s.%(ext)s"
latest=$(ls -t *.mp4 | head -n1)
base="${latest%.*}"

echo -e "\n🎛️ Оберіть трансформації:"
echo "1) 🔁 Реверс"
echo "2) 🌒 Затемнення"
echo "3) ✂️  Обрізка (перші 10 сек)"
echo "4) 🖼️  Вставка логотипу"
echo "5) ✅ Все одразу"
read -p "👉 Введіть номер (можна кілька через пробіл): " choice

filters=""
audio_filter=""
output="${base}_mod.mp4"

# 🧠 Обробка вибору
for opt in $choice; do
  case $opt in
    1) filters+="reverse,"; audio_filter="areverse" ;;
    2) filters+="eq=brightness=-0.3," ;;
    3) trim="-t 10" ;;
    4) logo="logo.png"
       [[ ! -f "$logo" ]] && echo "⚠️ Логотип logo.png не знайдено. Пропускаємо." || filters+="overlay=10:10," ;;
    5) filters="reverse,eq=brightness=-0.3,overlay=10:10,"; audio_filter="areverse"; trim="-t 10" ;;
  esac
done

# 🧹 Очистка фільтрів
filters="${filters%,}"

# 🧪 Побудова команди ffmpeg
cmd="ffmpeg -i \"$latest\""
[[ -n "$trim" ]] && cmd+=" $trim"
[[ -n "$filters" ]] && cmd+=" -vf \"$filters\""
[[ -n "$audio_filter" ]] && cmd+=" -af \"$audio_filter\""
cmd+=" \"$output\""

echo -e "\n🚀 Виконуємо:"
echo "$cmd"
eval "$cmd"

echo -e "\n✅ Готово! Збережено як: $output"
