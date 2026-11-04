# Скачивает изображения для сайта с Wikimedia Commons и сохраняет их в assets/images.
# (images.unsplash.com недоступен из текущей сети, поэтому используем Commons)
# Запуск: powershell -NoProfile -ExecutionPolicy Bypass -Command "& '<путь к скрипту>'"

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$images = [ordered]@{
  # Главный баннер — фруктовый мармелад (pate de fruit)
  "hero.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/6/6f/Pate_de_fruit.jpg/1280px-Pate_de_fruit.jpg"
  # Ягодный микс — мармелад «малина-ежевика»
  "product-berry-mix.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/d/db/Haribo_Gelee-Himbeeren_und_-Brombeeren-5467.jpg/960px-Haribo_Gelee-Himbeeren_und_-Brombeeren-5467.jpg"
  # Цитрусовый бум — мармеладные цитрусовые дольки
  "product-citrus.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/1/1c/Russian_Marmalade_-_Lemon_Slices.jpg/960px-Russian_Marmalade_-_Lemon_Slices.jpg"
  # Вишнёвый сад — красный ягодный мармелад
  "product-cherry.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/5/54/Pihlaja_candy.jpg/960px-Pihlaja_candy.jpg"
  # Манго-маракуйя — манговый мармелад
  "product-mango.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/4/4e/Fudge_mango_jelly_from_Vietnam.jpg/960px-Fudge_mango_jelly_from_Vietnam.jpg"
  # Яблочный сад — яблочный мармелад
  "product-apple.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/2/2d/Apple_marmalade_01.JPG/960px-Apple_marmalade_01.JPG"
  # Клубничное облако — клубничный мармелад
  "product-strawberry.jpg" = "https://thumb.wikimedia.org/wikipedia/commons/thumb/0/06/Haribo_giant_strawbs_uk_candy.jpg/960px-Haribo_giant_strawbs_uk_candy.jpg"
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
