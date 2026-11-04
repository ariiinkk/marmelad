# Скачивает изображения для сайта с Wikimedia Commons и сохраняет их в assets/images.
# (images.unsplash.com недоступен из текущей сети, поэтому используем Commons)
# Запуск: powershell -NoProfile -ExecutionPolicy Bypass -Command "& '<путь к скрипту>'"

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$images = [ordered]@{
  # Главный баннер — фруктовый мармелад (pate de fruit)
  "hero.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/6/6f/Pate_de_fruit.jpg/1280px-Pate_de_fruit.jpg"
  # Ягодный микс — малина
  "product-berry-mix.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/5/50/Raspberry.jpg/960px-Raspberry.jpg"
  # Цитрусовый бум — дольки апельсина
  "product-citrus.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/c/c4/Orange-Fruit-Pieces.jpg/960px-Orange-Fruit-Pieces.jpg"
  # Вишнёвый сад — черешня
  "product-cherry.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/6/6b/Cherry_fruits.jpg/960px-Cherry_fruits.jpg"
  # Манго-маракуйя — манго в разрезе
  "product-mango.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/1/11/Mango_and_cross_section.jpg/960px-Mango_and_cross_section.jpg"
  # Яблочный сад — зелёное яблоко
  "product-apple.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/b/bb/Green_Apple.jpg/960px-Green_Apple.jpg"
  # Клубничное облако — спелая клубника
  "product-strawberry.jpg" = "https://upload.wikimedia.org/wikipedia/commons/2/29/PerfectStrawberry.jpg"
}

$outDir = Join-Path $PSScriptRoot "assets\images"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

foreach ($name in $images.Keys) {
  $url = $images[$name]
  $outFile = Join-Path $outDir $name
  Write-Host "Downloading $name ..." -NoNewline
  try {
    Invoke-WebRequest -Uri $url -OutFile $outFile -UseBasicParsing -UserAgent "Mozilla/5.0"
    $size = (Get-Item $outFile).Length
    Write-Host " OK ($([math]::Round($size/1KB)) KB)" -ForegroundColor Green
  }
  catch {
    Write-Host " FAILED: $($_.Exception.Message)" -ForegroundColor Red
  }
}

Write-Host "`nDone."
