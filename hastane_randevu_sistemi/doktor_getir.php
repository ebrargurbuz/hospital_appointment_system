<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "hastane_randevu_sistemi";

$conn = new mysqli($servername, $username, $password, $dbname);

if (isset($_POST['pol_id'])) {
    
    $pol_id = $_POST['pol_id'];
    
   
    $stmt = $conn->prepare("SELECT dr_id, dr_ad_soyad FROM doktorlar WHERE pol_id = ?");
    $stmt->bind_param("i", $pol_id); 
    $stmt->execute();
    
    $result = $stmt->get_result();
    
    $doktorlar = array();
    
    while($row = $result->fetch_assoc()) {
        $doktorlar[] = $row;
    }
    
    echo json_encode($doktorlar);
    
    $stmt->close();
}
$conn->close();

?>
