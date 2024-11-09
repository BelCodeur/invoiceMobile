<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";

// Récupérer les données JSON envoyées
$data = json_decode(file_get_contents("php://input"), true);

// Vérifier si les données nécessaires sont présentes
if (
    isset($data['nom']) && isset($data['adresse']) &&
    isset($data['telephone']) && isset($data['NIU']) &&
    isset($data['RCCM']) && isset($data['BP']) &&
    isset($data['Bank']) && isset($data['numeroCompteBancaire'])
) {
    try {
        // Préparer la requête d'insertion
        $stmt = $connexion->prepare("INSERT INTO client (nom, adresse, telephone, NIU, RCCM, BP, Bank, numeroCompteBancaire) 
            VALUES (:nom, :adresse, :telephone, :NIU, :RCCM, :BP, :Bank, :numeroCompteBancaire)");

        // Lier les paramètres
        $stmt->bindParam(':nom', $data['nom']);
        $stmt->bindParam(':adresse', $data['adresse']);
        $stmt->bindParam(':telephone', $data['telephone']);
        $stmt->bindParam(':NIU', $data['NIU']);
        $stmt->bindParam(':RCCM', $data['RCCM']);
        $stmt->bindParam(':BP', $data['BP']);
        $stmt->bindParam(':Bank', $data['Bank']);
        $stmt->bindParam(':numeroCompteBancaire', $data['numeroCompteBancaire']);

        // Exécuter la requête
        if ($stmt->execute()) {
            // Insertion réussie
            echo json_encode(['success' => true]);
        } else {
            // Erreur lors de l'exécution
            echo json_encode(['success' => false, 'message' => 'Erreur lors de l\'insertion']);
        }
    } catch (PDOException $e) {
        // Gestion des erreurs SQL
        echo json_encode(['success' => false, 'message' => 'Erreur SQL : ' . $e->getMessage()]);
    }
} else {
    // Données manquantes
    echo json_encode(['success' => false, 'message' => 'Données manquantes']);
}
