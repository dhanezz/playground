<?php
// define("DB_HOST", "localhost");
// define("DB_NAME", "php_test");
// define("DB_USER", "root");
// define("DB_PASSWORD", "");
// define("DB_CHARSET", "utf8mb4");

// define("APP_NAME", "Meine PHP-Test-App");
// define("APP_ENV", "development");

$lines = file(__DIR__ . "/.env", FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
foreach ($lines as $line) {
    $line = trim($line);
    if (strpos(trim($line), "#") === 0) continue; // Skip comments
    putenv($line);
}
