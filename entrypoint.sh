#!/bin/sh
set -e

cat > /var/www/html/database.ini <<EOF
[server]
host=${DB_HOST}
database=${DB_NAME}
port=${DB_PORT:-3306}
user=${DB_USER}
pass=${DB_PASS}

[deviceinfo]
device=${DEVICE_ID:-}
varification=${DEVICE_VERIFICATION:-}
activation=${DEVICE_ACTIVATION:-}
workinginbackground=true

[sound]
masuk=\suara\selamatbekerja.mp3
pulang=\suara\terimakasih.mp3
gagal=\suara\ulangi.mp3
notifikasi=\suara\notifikasi.mp3
alattakterhubung=\suara\alattakterhubung.mp3
aktivasigagal=\suara\aktivasigagal.mp3
sudahmasuk=\suara\sudahmasuk.mp3
EOF

exec apache2-foreground
