<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";

$sql = "SELECT * FROM utilisateur ORDER BY ID";

$stmt = $connexion->prepare($sql);
$stmt->execute();
$returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($returnValue);
