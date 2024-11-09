<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";

// Récupérer les données JSON envoyées
$data = json_decode(file_get_contents("php://input"), true);

// Vérifier si les données nécessaires sont présentes
if (
    isset($data['id']) && isset($data['designation']) && isset($data['unit_price']) &&
    isset($data['description'])
) {
    try {
        // Préparer la requête de mise à jour
        $stmt = $connexion->prepare("UPDATE products SET 
            designation = :designation, 
            unit_price = :unit_price, 
            description = :description
            WHERE id = :id");

        // Lier les paramètres
        $stmt->bindParam(':designation', $data['designation']);
        $stmt->bindParam(':unit_price', $data['unit_price']);
        $stmt->bindParam(':description', $data['description']);
        $stmt->bindParam(':id', $data['id'], PDO::PARAM_INT);

        // Exécuter la requête
        if ($stmt->execute()) {
            // Mise à jour réussie
            echo json_encode(['success' => true]);
        } else {
            // Erreur lors de l'exécution
            echo json_encode(['success' => false, 'message' => 'Erreur lors de la mise à jour']);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Erreur SQL : ' . $e->getMessage()]);
    }
} else {
    // Données manquantes
    echo json_encode(['success' => false, 'message' => 'Données manquantes']);
}
