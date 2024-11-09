<?php
include "header.php";
class Contact
{
    function getContacts($json)
    {
        include "connection.php";

        // $userId = $_GET['userId']; //$_GET['userId'];
        $json = json_decode($json, true);

        $sql = $json['groupId'] == 0
            ? "SELECT * FROM tblcontacts WHERE contact_userId = :userId"
            : "SELECT * FROM tblcontacts WHERE contact_userId = :userId AND contact_group = :groupId";

        $sql .= " ORDER BY contact_name";

        $stmt = $connexion->prepare($sql);
        $stmt->bindParam(":userId", $json['userId']);
        if ($json['groupId'] > 0) {
            $stmt->bindParam(":groupId", $json["groupId"]);
        }
        $stmt->execute();
        $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);
        unset($connexion);
        unset($stmt);
        return json_encode($returnValue);
    }
    function getGroups($json)
    {
        include "connection.php";

        $sql = 'SELECT * FROM tblgroups ORDER BY grp_name';
        $stmt = $connexion->prepare($sql);
        $stmt->execute();
        $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

        return json_encode($returnValue);
    }
    function search($json)
    {
        include "connection.php";

        $json = json_decode($json, true);
        $searchKey = '%' . $json['searchKey'] . '%';

        $sql = 'SELECT * FROM tblcontacts WHERE contact_name LIKE :searchKey AND contact_userId = :userId ORDER BY contact_name';
        $stmt = $connexion->prepare($sql);
        $stmt->bindParam(":searchKey", $searchKey);
        $stmt->bindParam(":userId", $json['userId']);

        $stmt->execute();
        $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

        return json_encode($returnValue);
    }
}

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $operation = $_GET['operation'];
    $json = $_GET['json'];
} else if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $operation = $_POST['operation'];
    $json = $_POST['json'];
}

$contact = new Contact();

switch ($operation) {
    case 'getContacts':
        echo $contact->getContacts($json);
        break;
    case 'getGroups':
        echo $contact->getGroups($json);
        break;
    case 'search':
        echo $contact->search($json);
        break;
}
