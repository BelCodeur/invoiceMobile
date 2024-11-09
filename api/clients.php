<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";

class Client
{
    private $connexion;

    public function __construct($connexion)
    {
        $this->connexion = $connexion;
    }

    public function addClient($data)
    {
        if (
            isset(
                $data['nom'],
                $data['adresse'],
                $data['telephone'],
                $data['NIU'],
                $data['RCCM'],
                $data['BP'],
                $data['Bank'],
                $data['numeroCompteBancaire']
            )
        ) {
            try {
                $stmt = $this->connexion->prepare("INSERT INTO client (nom, adresse, telephone, NIU, RCCM, BP, Bank, numeroCompteBancaire) 
                    VALUES (:nom, :adresse, :telephone, :NIU, :RCCM, :BP, :Bank, :numeroCompteBancaire)");
                $stmt->bindParam(':nom', $data['nom']);
                $stmt->bindParam(':adresse', $data['adresse']);
                $stmt->bindParam(':telephone', $data['telephone']);
                $stmt->bindParam(':NIU', $data['NIU']);
                $stmt->bindParam(':RCCM', $data['RCCM']);
                $stmt->bindParam(':BP', $data['BP']);
                $stmt->bindParam(':Bank', $data['Bank']);
                $stmt->bindParam(':numeroCompteBancaire', $data['numeroCompteBancaire']);

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
        $sql = "SELECT * FROM client ORDER BY ID DESC";
        $stmt = $this->connexion->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function deleteClient($data)
    {
        if (isset($data['deletionId'])) {
            $sql = "DELETE FROM client WHERE id = :id";
            $stmt = $this->connexion->prepare($sql);
            $stmt->bindParam(":id", $data['deletionId'], PDO::PARAM_INT);

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

    public function updateClient($data)
    {
        if (
            isset(
                $data['id'],
                $data['nom'],
                $data['adresse'],
                $data['telephone'],
                $data['NIU'],
                $data['RCCM'],
                $data['BP'],
                $data['Bank'],
                $data['numeroCompteBancaire']
            )
        ) {
            try {
                $stmt = $this->connexion->prepare("UPDATE client SET 
                    nom = :nom, adresse = :adresse, telephone = :telephone, 
                    NIU = :NIU, RCCM = :RCCM, BP = :BP, Bank = :Bank, 
                    numeroCompteBancaire = :numeroCompteBancaire WHERE id = :id");
                $stmt->bindParam(':nom', $data['nom']);
                $stmt->bindParam(':adresse', $data['adresse']);
                $stmt->bindParam(':telephone', $data['telephone']);
                $stmt->bindParam(':NIU', $data['NIU']);
                $stmt->bindParam(':RCCM', $data['RCCM']);
                $stmt->bindParam(':BP', $data['BP']);
                $stmt->bindParam(':Bank', $data['Bank']);
                $stmt->bindParam(':numeroCompteBancaire', $data['numeroCompteBancaire']);
                $stmt->bindParam(':id', $data['id'], PDO::PARAM_INT);

                return $stmt->execute() ? ['success' => true] : ['success' => false, 'message' => 'Erreur lors de la mise à jour'];
            } catch (PDOException $e) {
                return ['success' => false, 'message' => 'Erreur SQL : ' . $e->getMessage()];
            }
        } else {
            return ['success' => false, 'message' => 'Données manquantes'];
        }
    }

    public function getClientById($data)
    {
        if (isset($data['SelectedID'])) {
            $sql = "SELECT * FROM client WHERE id = :id";
            $stmt = $this->connexion->prepare($sql);
            $stmt->bindParam(":id", $data['SelectedID'], PDO::PARAM_INT);

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

    public function searchClients($data)
    {
        if (isset($data['searchKey'], $data['userId'])) {
            $searchKey = '%' . $data['searchKey'] . '%';
            $sql = 'SELECT * FROM tblcontacts WHERE contact_name LIKE :searchKey AND contact_userId = :userId ORDER BY contact_name';
            $stmt = $this->connexion->prepare($sql);
            $stmt->bindParam(":searchKey", $searchKey);
            $stmt->bindParam(":userId", $data['userId']);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } else {
            return ['error' => 'Données de recherche manquantes'];
        }
    }
}

// Gestion de l’opération demandée
$operation = $_SERVER['REQUEST_METHOD'] == 'GET' ? $_GET['operation'] : $_POST['operation'];
$data = json_decode(file_get_contents("php://input"), true) ?? [];

$client = new Client($connexion);

switch ($operation) {
    case 'addClient':
        echo json_encode($client->addClient($data));
        break;
    case 'getClients':
        echo json_encode($client->getClients());
        break;
    case 'deleteClient':
        echo json_encode($client->deleteClient($data));
        break;
    case 'updateClient':
        echo json_encode($client->updateClient($data));
        break;
    case 'getClientById':
        echo json_encode($client->getClientById($data));
        break;
    case 'searchClients':
        echo json_encode($client->searchClients($data));
        break;
    default:
        echo json_encode(['error' => 'Opération non valide']);
}
