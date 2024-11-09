<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";
$deletionId = (int)$_POST['deletionId'];

$sql = "DELETE FROM utilisateur WHERE ID = :id";

$stmt = $connexion->prepare($sql);
$stmt->bindParam(":id", $id);

try {
    $stmt->execute();
    $returnValue = $stmt->rowCount() > 0 ? 1 : 0;
    echo json_encode($returnValue);
} catch (PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
