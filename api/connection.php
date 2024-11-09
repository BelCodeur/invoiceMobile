<?php
define("user", "xsqkqqjk_invoice1");
define("db", "xsqkqqjk_invoices");
define("password", "9~VVVA9x99b9ob8=!A");
define("server", "localhost");


$dsn = "mysql:host=" . server . ";dbname=" . db;

try {
    $connexion = new PDO($dsn, user, password);
} catch (PDOException $e) {
    printf("Échec de la connexion : %s\n", $e->getMessage());
    exit();
}
