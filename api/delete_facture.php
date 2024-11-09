<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";
$deletionId = (int)$_POST['deletionId'];

try {
    // Démarrer la transaction
    $connexion->beginTransaction();

    // Supprimer les produits associés à la facture
    $stmt = $connexion->prepare("DELETE FROM facture_produits WHERE facture_id = :id");
    $stmt->execute([':id' => $deletionId]);

    // Supprimer la facture
    $stmt = $connexion->prepare("DELETE FROM facture WHERE id = :id");
    $stmt->execute([':id' => $deletionId]);

    // Commit de la transaction si tout s'est bien passé
    $connexion->commit();

    // Vérifier si des lignes ont été supprimées
    $returnValue = $stmt->rowCount() > 0 ? 1 : 0;
    echo json_encode($returnValue);

} catch (PDOException $e) {
    // Rollback de la transaction en cas d'erreur
    $connexion->rollBack();
    echo json_encode(['error' => $e->getMessage()]);
}
?>
