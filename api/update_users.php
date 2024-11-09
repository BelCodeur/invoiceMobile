<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection.php";

if (!isset($_POST['username'], $_POST['password'], $_POST['fullname'])) {
    echo json_encode(['error' => 'Paramètres manquants']);
    exit;
}

$username = $_POST['username'];
$password = $_POST['password'];
$fullname = $_POST['fullname'];
$email = $_POST['email'];
$telephone = $_POST['telephone'];
$id = (int)$_POST['id'];
if (isset($_POST['manager'])) {
    $manager = 1;  // La valeur sera "on" si le switch est coché
} else {
    $manager = 0;
}
$sql = "UPDATE utilisateur SET nom = :nom, prenom = :prenom, email = :email, telephone = :telephone, password = :password, manager = :manager WHERE ID = :id";

$stmt = $connexion->prepare($sql);
$stmt->bindParam(":nom", $username);
$stmt->bindParam(":password", $password);
$stmt->bindParam(":prenom", $fullname);
$stmt->bindParam(":email", $email);
$stmt->bindParam(":telephone", $telephone);
$stmt->bindParam(":manager", $manager);
$stmt->bindParam(":id", $id);

try {
    $stmt->execute();
    $returnValue = $stmt->rowCount() > 0 ? 1 : 0;
    echo json_encode($returnValue);
} catch (PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
