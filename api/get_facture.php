<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";


//$userId = $_GET['userId']; //$_GET['userId'];

$sql = "SELECT f.id, f.numeroFacture, f.client, f.montantHT, f.montantTTC, f.montantTVA, f.creeLe, f.statut
                            FROM facture f
                            ORDER BY f.id";

$stmt = $connexion->prepare($sql);
//$stmt->bindParam(":userId", $userId);
$stmt->execute();
$returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($returnValue);
