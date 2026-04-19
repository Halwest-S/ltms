#!/bin/sh
set -eu

cd /var/www

if [ ! -f .env ]; then
  cp .env.example .env
fi

mkdir -p \
  storage/app/public \
  storage/framework/cache \
  storage/framework/sessions \
  storage/framework/views \
  storage/logs \
  bootstrap/cache

chown -R www-data:www-data storage bootstrap/cache

php artisan optimize:clear >/dev/null 2>&1 || true

if [ -z "${APP_KEY:-}" ]; then
  echo "APP_KEY is required for deployment." >&2
  exit 1
fi

php -r '
$host = getenv("DB_HOST") ?: "database";
$port = getenv("DB_PORT") ?: "5432";
$db = getenv("DB_DATABASE") ?: "transportation_management_system";
$user = getenv("DB_USERNAME") ?: "postgres";
$pass = getenv("DB_PASSWORD") ?: "";

for ($attempt = 1; $attempt <= 30; $attempt++) {
    try {
        new PDO(
            "pgsql:host={$host};port={$port};dbname={$db}",
            $user,
            $pass,
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );
        exit(0);
    } catch (Throwable $e) {
        fwrite(STDERR, "Waiting for database ({$attempt}/30)...\n");
        sleep(2);
    }
}

fwrite(STDERR, "Database connection failed.\n");
exit(1);
'

php artisan storage:link >/dev/null 2>&1 || true
php artisan migrate --force
php artisan db:seed --force
php artisan config:cache

php-fpm -D
exec nginx -g "daemon off;"
