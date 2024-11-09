<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";

// Récupérer les données envoyées via la méthode POST
$id = $_POST['id'];
$numeroFacture = $_POST['numeroFacture'];
$client = $_POST['client'];
$creeLe = $_POST['creeLe'];
$state = $_POST['state'];

$designations = $_POST['designation'];
$quantites = $_POST['quantite'];
$prixUnitaires = $_POST['prixUnitaire'];

// Calcul du montant HT
$montantHT = 0;
for ($i = 0; $i < count($designations); $i++) {
    $quantite = (int)$quantites[$i];
    $prixUnitaire = (float)$prixUnitaires[$i];
    $montantHTProduit = $quantite * $prixUnitaire;
    $montantHT += $montantHTProduit;
}

// Calcul de la TVA et du montant TTC
$tauxTVA = 19.25;
$montantTVA = ($montantHT * $tauxTVA) / 100;
$montantTTC = $montantHT + $montantTVA;

try {
    // Démarrer la transaction
    $connexion->beginTransaction();

    // Mise à jour de la table facture
    $stmt = $connexion->prepare("
        UPDATE facture 
        SET numeroFacture = :numeroFacture, client = :client, montantHT = :montantHT, montantTTC = :montantTTC, montantTVA = :montantTVA, creeLe = :creeLe, statut = :state 
        WHERE id = :id
    ");
    $stmt->execute([
        ":numeroFacture" => $numeroFacture,
        ":client" => $client,
        ":montantHT" => $montantHT,
        ":montantTTC" => $montantTTC,
        ":montantTVA" => $montantTVA,
        ":creeLe" => $creeLe,
        ":state" => $state,
        ":id" => $id
    ]);

    // Suppression des produits existants associés à la facture
    $stmt = $connexion->prepare("DELETE FROM facture_produits WHERE facture_id = :facture_id");
    $stmt->execute([":facture_id" => $id]);

    // Vérification de la cohérence des données des produits
    if (count($designations) === count($quantites) && count($quantites) === count($prixUnitaires)) {

        // Réinsertion des produits
        $stmt = $connexion->prepare("
            INSERT INTO facture_produits (facture_id, designation, quantite, prix_unitaire) 
            VALUES (:facture_id, :designation, :quantite, :prix_unitaire)
        ");
        $produitsInserts = 0;
        for ($i = 0; $i < count($designations); $i++) {
            $stmt->execute([
                ":facture_id" => $id,
                ":designation" => $designations[$i],
                ":quantite" => $quantites[$i],
                ":prix_unitaire" => $prixUnitaires[$i]
            ]);
            $produitsInserts += $stmt->rowCount();
        }

        // Commit la transaction si tout est bien passé
        $connexion->commit();

        // Retourner un succès si au moins une ligne a été insérée
        $returnValue = ($produitsInserts > 0) ? 1 : 0;
        echo json_encode($returnValue);
    } else {
        // Les données ne sont pas cohérentes
        echo json_encode(['error' => 'Les données des produits ne sont pas cohérentes.']);
    }
} catch (PDOException $e) {
    // Rollback en cas d'erreur
    $connexion->rollBack();
    echo json_encode(['error' => $e->getMessage()]);
}
