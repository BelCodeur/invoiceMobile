<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";

$username = $_GET['username'];
$password = $_GET['password'];

$sql = "SELECT * FROM utilisateur WHERE nom = :username AND  password = :password";

$stmt = $connexion->prepare($sql);
$stmt->bindParam(":username", $username);
$stmt->bindParam(":password", $password);
$stmt->execute();
$returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($returnValue);
