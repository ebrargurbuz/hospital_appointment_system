<?php
// doktor_getir.php

// 1. Veritabanı Bağlantısı
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "hastane_randevu_sistemi";

$conn = new mysqli($servername, $username, $password, $dbname);

// 2. JS'den 'pol_id' adında bir POST isteği gelmiş mi kontrol et
if (isset($_POST['pol_id'])) {
    
    $pol_id = $_POST['pol_id'];
    
    // 3. GÜVENLİK: Prepared Statement (SQL Injection koruması)
    // Sütun isimlerini kendi veritabanına göre KONTROL ET!
    $stmt = $conn->prepare("SELECT dr_id, dr_ad_soyad FROM doktorlar WHERE pol_id = ?");
    $stmt->bind_param("i", $pol_id); // "i" -> integer
    $stmt->execute();
    
    $result = $stmt->get_result();
    
    $doktorlar = array();
    
    // 4. Gelen satırları bir diziye doldur
    while($row = $result->fetch_assoc()) {
        $doktorlar[] = $row;
    }
    
    // 5. Diziyi JSON formatına çevirip tarayıcıya (JS'e) fırlat
    echo json_encode($doktorlar);
    
    $stmt->close();
}
$conn->close();
?>