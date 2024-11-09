<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";

// Récupérer les données JSON envoyées
$data = json_decode(file_get_contents("php://input"), true);

// Vérifier si les données nécessaires sont présentes
if (
    isset($data['id']) && isset($data['nom']) && isset($data['adresse']) &&
    isset($data['telephone']) && isset($data['NIU']) &&
    isset($data['RCCM']) && isset($data['BP']) &&
    isset($data['Bank']) && isset($data['numeroCompteBancaire'])
) {


    // Préparer la requête de mise à jour
    $stmt = $connexion->prepare("UPDATE client SET 
        nom = ?, 
        adresse = ?, 
        telephone = ?, 
        NIU = ?, 
        RCCM = ?, 
        BP = ?, 
        Bank = ?, 
        numeroCompteBancaire = ? 
        WHERE id = ?");

    // Lier les paramètres
    $stmt->bindparam(
        "ssssssssi",
        $data['nom'],
        $data['adresse'],
        $data['telephone'],
        $data['NIU'],
        $data['RCCM'],
        $data['BP'],
        $data['Bank'],
        $data['numeroCompteBancaire'],
        $data['id']
    );

    // Exécuter la requête
    if ($stmt->execute()) {
        // Mise à jour réussie
        echo json_encode(['success' => true]);
    } else {
        // Erreur lors de l'exécution
        echo json_encode(['success' => false, 'message' => 'Erreur lors de la mise à jour']);
    }

    // Fermer la déclaration et la connexion
    $conn->close();
} else {
    // Données manquantes
    echo json_encode(['success' => false, 'message' => 'Données manquantes']);
}
///////////////////////
<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
    include "connection.php";

if (!$connexion) {
    echo json_encode(['success' => false, 'message' => 'Erreur de connexion à la base de données']);
    exit();
}
// Récupérer les données JSON envoyées
$data = json_decode(file_get_contents("php://input"), true);

// Vérifier si les données nécessaires sont présentes
if (
    isset($data['id']) && isset($data['nom']) && isset($data['adresse']) &&
    isset($data['telephone']) && isset($data['NIU']) &&
    isset($data['RCCM']) && isset($data['BP']) &&
    isset($data['Bank']) && isset($data['numeroCompteBancaire'])
) {

    $sql = "UPDATE client SET 
        nom = :nom, 
        adresse = :adress, 
        telephone = :tel, 
        NIU = :NIU, 
        RCCM = :RCCM, 
        BP = :BP, 
        Bank = :Bank, 
        numeroCompteBancaire = :numCmpt 
        WHERE id = :id";
    // Préparer la requête de mise à jour
    $stmt = $connexion->prepare($sql);

    // Lier les paramètres
    $stmt->bindparam(":nom",$data['nom']);
    $stmt->bindparam(":tel",$data['telephone']);
    $stmt->bindparam(":adress",$data['adresse']);
    $stmt->bindparam(":NIU",$data['NIU']);
    $stmt->bindparam(":RCCM",$data['RCCM']);
    $stmt->bindparam(":Bank",$data['Bank']);
    $stmt->bindparam(":numCmpt",$data['numeroCompteBancaire']);
    $stmt->bindparam(":id",$data['id']);

    // Exécuter la requête
    if ($stmt->execute()) {
        // Mise à jour réussie
        echo json_encode(['success' => true]);
    } else {
        // Erreur lors de l'exécution
        echo json_encode(['success' => false, 'message' => 'Erreur lors de la mise à jour']);
    }

} else {
    // Données manquantes
    echo json_encode(['success' => false, 'message' => 'Données manquantes']);
}
