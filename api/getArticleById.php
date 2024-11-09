<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";

// Lire les données JSON envoyées dans le corps de la requête
$data = json_decode(file_get_contents("php://input"), true);
$SelectedID = isset($data['SelectedID']) ? (int)$data['SelectedID'] : null;

if ($SelectedID !== null) {
    // Préparer la requête SQL pour récupérer le client
    $sql = "SELECT * FROM products WHERE id = :id";
    $stmt = $connexion->prepare($sql);
    $stmt->bindParam(":id", $SelectedID);  // Associer l'ID en tant qu'entier

    try {
        $stmt->execute();  // Exécuter la requête
        $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Vérifiez si des données ont été récupérées
        if (count($returnValue) > 0) {
            echo json_encode($returnValue[0]); // Renvoyer le premier élément comme un objet
        } else {
            echo json_encode(['error' => 'Aucun Article trouvé avec cet ID']);
        }
    } catch (PDOException $e) {
        // En cas d'erreur, renvoyer un message JSON avec le détail de l'erreur
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    // Renvoyer une erreur si l'ID est manquant
    echo json_encode(['error' => 'Aucun ID d\'article fourni']);
}
