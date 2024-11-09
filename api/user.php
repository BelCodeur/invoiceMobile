<?php
include "header.php";

class User
{
    function login($json)
    {
        include "connection.php";

        $json = json_decode($json, true);

        $sql = "SELECT * FROM utilisateur WHERE nom = :username AND  password = :password";

        $stmt = $connexion->prepare($sql);
        $stmt->bindParam(":username", $json['username']);
        $stmt->bindParam(":password", $json['password']);
        $stmt->execute();
        $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);
        unset($connexion);
        unset($stmt);
        return json_encode($returnValue);
    }
    // function register($json)
    // {
    //     include "connection.php";

    //     $json = json_decode($json, true);

    //     $sql = "INSERT INTO tblusers (usr_username, usr_password, usr_fullname) VALUES (:username, :password, :fullname)";

    //     $stmt = $connexion->prepare($sql);
    //     $stmt->bindParam(":username", $json['username']);
    //     $stmt->bindParam(":password", $json['password']);
    //     $stmt->bindParam(":fullname", $json['fullname']);

    //     try {
    //         $stmt->execute();
    //         $returnValue = $stmt->rowCount() > 0 ? 1 : 0;
    //         unset($connexion);
    //         unset($stmt);
    //         return json_encode($returnValue);
    //     } catch (PDOException $e) {
    //         return json_encode(['error' => $e->getMessage()]);
    //     }
    // }

}

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $operation = $_GET['operation'];
    $json = $_GET['json'];
    # code...
} else if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $operation = $_POST['operation'];
    $json = $_POST['json'];
}

$user = new User();
switch ($operation) {
    case 'login':
        echo $user->login($json);
        break;
    default:
        echo json_encode(['error' => 'Opération non valide']);
}
