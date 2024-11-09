<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";
$SelectedID = (int)$_POST['SelectedID'];  // Récupérer l'ID du client à supprimer

$sql = "SELECT * FROM client WHERE id = :id";

$stmt = $connexion->prepare($sql);
$stmt->bindParam(":id", $SelectedID);  // Associer l'ID en tant qu'entier
$stmt->execute();
$returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($returnValue);
