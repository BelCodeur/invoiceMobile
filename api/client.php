<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");


class Client
{


    public function addClient($json)
    {
        include "connection.php";

        if (
            isset(
                $json['nom'],
                $json['adresse'],
                $json['telephone'],
                $json['NIU'],
                $json['RCCM'],
                $json['BP'],
                $json['Bank'],
                $json['numeroCompteBancaire']
            )
        ) {
            try {
                $stmt = $this->connexion->prepare("INSERT INTO client (nom, adresse, telephone, NIU, RCCM, BP, Bank, numeroCompteBancaire) 
                    VALUES (:nom, :adresse, :telephone, :NIU, :RCCM, :BP, :Bank, :numeroCompteBancaire)");
                $stmt->bindParam(':nom', $json['nom']);
                $stmt->bindParam(':adresse', $json['adresse']);
                $stmt->bindParam(':telephone', $json['telephone']);
                $stmt->bindParam(':NIU', $json['NIU']);
                $stmt->bindParam(':RCCM', $json['RCCM']);
                $stmt->bindParam(':BP', $json['BP']);
                $stmt->bindParam(':Bank', $json['Bank']);
                $stmt->bindParam(':numeroCompteBancaire', $json['numeroCompteBancaire']);

                return $stmt->execute() ? ['success' => true] : ['success' => false, 'message' => 'Erreur lors de l\'insertion'];
            } catch (PDOException $e) {
                return ['success' => false, 'message' => 'Erreur SQL : ' . $e->getMessage()];
            }
        } else {
            return ['success' => false, 'message' => 'Données manquantes'];
        }
    }

    public function getClients()
    {
        include "connection.php";

        $sql = "SELECT * FROM client ORDER BY ID DESC";
        $stmt = $this->connexion->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function deleteClient($json)
    {
        include "connection.php";

        if (isset($json['deletionId'])) {
            $sql = "DELETE FROM client WHERE id = :id";
            $stmt = $this->connexion->prepare($sql);
            $stmt->bindParam(":id", $json['deletionId'], PDO::PARAM_INT);

            try {
                $stmt->execute();
                return $stmt->rowCount() > 0 ? 1 : 0;
            } catch (PDOException $e) {
                return ['error' => $e->getMessage()];
            }
        } else {
            return ['error' => 'Aucun ID de client fourni'];
        }
    }

    public function updateClient($json)
    {
        include "connection.php";

        if (
            isset(
                $json['id'],
                $json['nom'],
                $json['adresse'],
                $json['telephone'],
                $json['NIU'],
                $json['RCCM'],
                $json['BP'],
                $json['Bank'],
                $json['numeroCompteBancaire']
            )
        ) {
            try {
                $stmt = $this->connexion->prepare("UPDATE client SET 
                    nom = :nom, adresse = :adresse, telephone = :telephone, 
                    NIU = :NIU, RCCM = :RCCM, BP = :BP, Bank = :Bank, 
                    numeroCompteBancaire = :numeroCompteBancaire WHERE id = :id");
                $stmt->bindParam(':nom', $json['nom']);
                $stmt->bindParam(':adresse', $json['adresse']);
                $stmt->bindParam(':telephone', $json['telephone']);
                $stmt->bindParam(':NIU', $json['NIU']);
                $stmt->bindParam(':RCCM', $json['RCCM']);
                $stmt->bindParam(':BP', $json['BP']);
                $stmt->bindParam(':Bank', $json['Bank']);
                $stmt->bindParam(':numeroCompteBancaire', $json['numeroCompteBancaire']);
                $stmt->bindParam(':id', $json['id'], PDO::PARAM_INT);

                return $stmt->execute() ? ['success' => true] : ['success' => false, 'message' => 'Erreur lors de la mise à jour'];
            } catch (PDOException $e) {
                return ['success' => false, 'message' => 'Erreur SQL : ' . $e->getMessage()];
            }
        } else {
            return ['success' => false, 'message' => 'Données manquantes'];
        }
    }

    public function getClientById($json)
    {
        include "connection.php";

        if (isset($json['SelectedID'])) {
            $sql = "SELECT * FROM client WHERE id = :id";
            $stmt = $this->connexion->prepare($sql);
            $stmt->bindParam(":id", $json['SelectedID'], PDO::PARAM_INT);

            try {
                $stmt->execute();
                $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);
                return count($returnValue) > 0 ? $returnValue[0] : ['error' => 'Aucun client trouvé avec cet ID'];
            } catch (PDOException $e) {
                return ['error' => $e->getMessage()];
            }
        } else {
            return ['error' => 'Aucun ID de client fourni'];
        }
    }

    public function searchClients($json)
    {
        include "connection.php";

        if (isset($json['searchKey'], $json['userId'])) {
            $searchKey = '%' . $json['searchKey'] . '%';
            $sql = 'SELECT * FROM tblcontacts WHERE contact_name LIKE :searchKey AND contact_userId = :userId ORDER BY contact_name';
            $stmt = $this->connexion->prepare($sql);
            $stmt->bindParam(":searchKey", $searchKey);
            $stmt->bindParam(":userId", $json['userId']);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } else {
            return ['error' => 'Données de recherche manquantes'];
        }
    }
}

// Gestion de l’opération demandée
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $operation = $_GET['operation'];
    $json = $_GET['json'];
} else if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $operation = $_POST['operation'];
    $json = $_POST['json'];
}

$client = new Client($connexion);

switch ($operation) {
    case 'addClient':
        echo json_encode($client->addClient($json));
        break;
    case 'getClients':
        echo json_encode($client->getClients());
        break;
    case 'deleteClient':
        echo json_encode($client->deleteClient($json));
        break;
    case 'updateClient':
        echo json_encode($client->updateClient($json));
        break;
    case 'getClientById':
        echo json_encode($client->getClientById($json));
        break;
    case 'searchClients':
        echo json_encode($client->searchClients($json));
        break;
    default:
        echo json_encode(['error' => 'Opération non valide']);
}
