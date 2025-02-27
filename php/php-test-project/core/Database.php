<?php
class Database
{
    private $pdo;

    public function __construct()
    {
        $dsn = "mysql:host=" . getenv("DB_HOST") . ";dbname=" . getenv("DB_NAME") . ";charset=" . getenv("DB_CHARSET");
        try {
            $this->pdo = new PDO($dsn, getenv("DB_USER"), getenv("DB_PASSWORD"), [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
            ]);
        } catch (PDOException $e) {
            die("Datenbankverbindung fehlgeschlagen" . $e->getMessage());
        }
    }
}
