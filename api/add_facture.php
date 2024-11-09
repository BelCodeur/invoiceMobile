<?php
// header('Content-Type: application/json');
// header("Access-Control-Allow-Origin: *");
// include "connection.php";
// function genererNumeroFacture($dernierNumero)
// {
//     // Définir le préfixe fixe avec l'année actuelle
//     $anneeActuelle = date("Y");
//     $prefixe = "BTS/DC/" . $anneeActuelle . "/fac";

//     // Vérifier si le dernier numéro commence avec le préfixe
//     if (strpos($dernierNumero, $prefixe) !== 0) {
//         // Si le préfixe ne correspond pas, commencer à 001 pour l'année actuelle
//         $partieNumerique = 0;
//     } else {
//         // Extraire la partie numérique du dernier numéro de facture
//         $partieNumerique = substr($dernierNumero, strlen($prefixe));
//         $partieNumerique = intval($partieNumerique);
//     }

//     // Incrémenter le numéro
//     $nouveauNumero = $partieNumerique + 1;

//     // Formater le nouveau numéro avec les zéros nécessaires pour commencer à 001
//     $format = "%03d"; // 3 chiffres pour "001"
//     $numeroFormate = sprintf($format, $nouveauNumero);

//     // Retourner le nouveau numéro complet avec le préfixe
//     return $prefixe . $numeroFormate;
// }
// $client = $_POST['client'];
// $creeLe = $_POST['creeLe'];
// $state = $_POST['state'];

// $designations = $_POST['designation'];
// $quantites = $_POST['quantite'];
// $prixUnitaires = $_POST['prixUnitaire'];

//    // Calcul du montant HT
//    $montantHT = 0;
//    for ($i = 0; $i < count($designations); $i++) {
//        $quantite = (int)$quantites[$i];
//        $prixUnitaire = (float)$prixUnitaires[$i];
//        $montantHTProduit = $quantite * $prixUnitaire;
//        $montantHT += $montantHTProduit;
//    }

//    // Calcul de la TVA et du montant TTC
//    $tauxTVA = 19.25;
//    $montantTVA = ($montantHT * $tauxTVA) / 100;
//    $montantTTC = $montantHT + $montantTVA;

// try {
//     // Démarrer la transaction
//     $connexion->beginTransaction();

//     // Verrouiller la table ou la ligne pour obtenir le dernier numéro de facture
//     $stmt = $connexion->query("SELECT numeroFacture FROM facture ORDER BY id DESC LIMIT 1 FOR UPDATE");
//     $dernierNumero = $stmt->fetchColumn();

//     // Générer le nouveau numéro de facture
//     $numeroFacture = genererNumeroFacture($dernierNumero);

//     // Insertion de la facture
//     $stmt = $connexion->prepare("INSERT INTO facture (numeroFacture, client, montantHT, montantTTC, montantTVA, creeLe, statut) VALUES (:numeroFacture, :client, :montantHT, :montantTTC, :montantTVA, :creeLe, :state)");
//     $stmt->execute([
//         ":numeroFacture" => $numeroFacture,
//         ":client" => $client,
//         ":montantHT" => $montantHT,
//         ":montantTTC" => $montantTTC,
//         ":montantTVA" => $montantTVA,
//         ":creeLe" => $creeLe,
//         ":state" => $state
//     ]);

//     $factureId = $connexion->lastInsertId();

//     // Insertion des produits de la facture
//     $stmt = $connexion->prepare("INSERT INTO facture_produits (facture_id, designation, quantite, prix_unitaire) VALUES (:facture_id, :designation, :quantite, :prix_unitaire)");
//     for ($i = 0; $i < count($designations); $i++) {
//         $stmt->execute([
//             ":facture_id" => $factureId,
//             ":designation" => $designations[$i],
//             ":quantite" => $quantites[$i],
//             ":prix_unitaire" => $prixUnitaires[$i]
//         ]);
//     }

//     // Si tout s'est bien passé, commit la transaction
//     $connexion->commit();

//     // Retourner un succès si une ou plusieurs lignes ont été insérées
//     $returnValue = $stmt->rowCount() > 0 ? 1 : 0;
//     echo json_encode($returnValue);
// } catch (PDOException $e) {
//     // En cas d'erreur, rollback la transaction et retourner l'erreur
//     $connexion->rollBack();
//     echo json_encode(['error' => $e->getMessage()]);
// }

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
include "connection.php";

function genererNumeroFacture($dernierNumero)
{
    // Définir le préfixe fixe avec l'année actuelle
    $anneeActuelle = date("Y");
    $prefixe = "BTS/DC/" . $anneeActuelle . "/fac";

    // Vérifier si le dernier numéro commence avec le préfixe
    if (strpos($dernierNumero, $prefixe) !== 0) {
        // Si le préfixe ne correspond pas, commencer à 001 pour l'année actuelle
        $partieNumerique = 0;
    } else {
        // Extraire la partie numérique du dernier numéro de facture
        $partieNumerique = substr($dernierNumero, strlen($prefixe));
        $partieNumerique = intval($partieNumerique);
    }

    // Incrémenter le numéro
    $nouveauNumero = $partieNumerique + 1;

    // Formater le nouveau numéro avec les zéros nécessaires pour commencer à 001
    $format = "%03d"; // 3 chiffres pour "001"
    $numeroFormate = sprintf($format, $nouveauNumero);

    // Retourner le nouveau numéro complet avec le préfixe
    return $prefixe . $numeroFormate;
}

// Valider les données POST avant utilisation
if (isset($_POST['client'], $_POST['creeLe'], $_POST['state'], $_POST['designation'], $_POST['quantite'], $_POST['prixUnitaire'])) {
    $client = $_POST['client'];
    $creeLe = $_POST['creeLe'];
    $state = $_POST['state'];
    $designations = $_POST['designation'];
    $quantites = $_POST['quantite'];
    $prixUnitaires = $_POST['prixUnitaire'];

    // Vérification de la cohérence des données
    if (count($designations) === count($quantites) && count($quantites) === count($prixUnitaires)) {
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

            // Verrouiller la table ou la ligne pour obtenir le dernier numéro de facture
            $stmt = $connexion->query("SELECT numeroFacture FROM facture ORDER BY id DESC LIMIT 1 FOR UPDATE");
            $dernierNumero = $stmt->fetchColumn();

            if ($dernierNumero === false) {
                $dernierNumero = "BTS/DC/" . date("Y") . "/fac000";
            }

            // Générer le nouveau numéro de facture
            $numeroFacture = genererNumeroFacture($dernierNumero);

            // Insertion de la facture
            $stmt = $connexion->prepare("INSERT INTO facture (numeroFacture, client, montantHT, montantTTC, montantTVA, creeLe, statut) 
                VALUES (:numeroFacture, :client, :montantHT, :montantTTC, :montantTVA, :creeLe, :state)");
            $stmt->execute([
                ":numeroFacture" => $numeroFacture,
                ":client" => $client,
                ":montantHT" => $montantHT,
                ":montantTTC" => $montantTTC,
                ":montantTVA" => $montantTVA,
                ":creeLe" => $creeLe,
                ":state" => $state
            ]);

            $factureId = $connexion->lastInsertId();

            // Insertion des produits de la facture
            $stmt = $connexion->prepare("INSERT INTO facture_produits (facture_id, designation, quantite, prix_unitaire) 
                VALUES (:facture_id, :designation, :quantite, :prix_unitaire)");

            // Suivi du nombre d'insertions de produits
            $produitsInserts = 0;
            for ($i = 0; $i < count($designations); $i++) {
                $stmt->execute([
                    ":facture_id" => $factureId,
                    ":designation" => $designations[$i],
                    ":quantite" => $quantites[$i],
                    ":prix_unitaire" => $prixUnitaires[$i]
                ]);
                $produitsInserts += $stmt->rowCount();
            }

            // Si tout s'est bien passé, commit la transaction
            $connexion->commit();

            // Retourner un succès si au moins une ligne a été insérée
            $returnValue = ($produitsInserts > 0) ? 1 : 0;
            echo json_encode($returnValue);
        } catch (PDOException $e) {
            // En cas d'erreur, rollback la transaction et retourner l'erreur
            $connexion->rollBack();
            echo json_encode(['error' => $e->getMessage()]);
        }
    } else {
        // Les données ne sont pas cohérentes
        echo json_encode(['error' => 'Les données des produits ne sont pas cohérentes.']);
    }
} else {
    // Paramètres POST manquants
    echo json_encode(['error' => 'Données POST manquantes.']);
}
