<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";  // Inclure le fichier de connexion à la base de données

// Lire les données JSON envoyées dans le corps de la requête
$data = json_decode(file_get_contents("php://input"), true);
$deletionId = isset($data['deletionId']) ? (int)$data['deletionId'] : null;

if ($deletionId !== null) {
    // Préparer la requête SQL pour supprimer le client
    $sql = "DELETE FROM produits WHERE id = :id";
    $stmt = $connexion->prepare($sql);
    $stmt->bindParam(":id", $deletionId);  // Associer l'ID en tant qu'entier

    try {
        $stmt->execute();  // Exécuter la requête
        // Vérifier si une ligne a été affectée
        $returnValue = $stmt->rowCount() > 0 ? 1 : 0;
        echo json_encode($returnValue);  // Retourner 1 si suppression, 0 sinon
    } catch (PDOException $e) {
        // En cas d'erreur, renvoyer un message JSON avec le détail de l'erreur
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    // Renvoyer une erreur si l'ID est manquant
    echo json_encode(['error' => 'Aucun ID d\'Article fourni']);
}
