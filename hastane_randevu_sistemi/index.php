<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "hastane_randevu_sistemi";

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = new mysqli($servername, $username, $password, $dbname);
} catch (mysqli_sql_exception $e) {
    die("Bağlantı hatası: " . $e->getMessage());
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $ad_soyad = $_POST['ad_soyad'];
    $tc_no = $_POST['tc_no'];
    $dr_id = $_POST['doktor_id'];
    $tarih = $_POST['randevu_tarihi'];
    $saat = $_POST['randevu_saati'];

    // Güvenlik: sadece 00 ve 30 kabul
    $minute = explode(":", $saat)[1];

    if ($minute != "00" && $minute != "30") {
        die("<script>alert('Randevu saatleri sadece 30 dakikalık aralıklarla alınabilir.'); window.history.back();</script>");
    }

    $ekle = "INSERT INTO randevular 
            (dr_id, hasta_ad_soyad, tc_no, randevu_tarihi, randevu_saati) 
            VALUES (?, ?, ?, ?, ?)";

    try {
        $stmt = $conn->prepare($ekle);
        $stmt->bind_param("issss", $dr_id, $ad_soyad, $tc_no, $tarih, $saat);
        $stmt->execute();

        echo "<script>
                alert('Randevunuz başarıyla oluşturuldu!');
                window.location.href = 'index.php';
              </script>";

    } catch (mysqli_sql_exception $e) {

        if ($e->getCode() == 1062) {
            echo "<script>alert('Bu saat dolu. Lütfen başka saat seçiniz.');</script>";
        } else {
            echo "<script>alert('Veritabanı Hatası: " . $e->getMessage() . "');</script>";
        }
    }

    if (isset($stmt)) {
        $stmt->close();
    }
}
?>

<!DOCTYPE html>
<html lang="tr">
    <head>
        <meta charset="UTF-8">
        <meta name= "viewport" content="width = device-width,initial-scale=1.0">
        <title> Hasta kayıt sistemi </title>
        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>

        <body>
            <div class = "ana-kutu">
                <div class ="randevu-kutusu">
                    <div class="randevu-kutusu-basligi">
                        <i class ="fa-solid fa-hospital-user"></i>
                        <h2>randevu olustur</h2>
                        <p>lutfen randevu bilgilerinizi giriniz.</p>
                    </div>
                    <form action="index.php" method="POST">
                    <div class="form-group">
                        <label>Ad Soyad</label>
                        <div class="input-kabi">
                            <i class="fa-solid fa-user"></i>
                            <input type="text" name="ad_soyad" placeholder="Örn: Ahmet Yilmaz" required>

                        </div>
                    </div>    

                    <div class="form-group">
                        <label>TC NO</label>
                        <div class="input-kabi">
                            <i class="fa-solid fa-id-card"></i>
                            <input type="text" name="tc_no" placeholder="11 haneli tc no" required>
                        </div>
                    </div>
                    

                    
                    <div class="form-row"> <div class="form-group half">
                        <label>Poliklinik</label>
                        <select name="poliklinik_id" id="poliklinik" required>
                        
                            <option value="">Seçiniz:</option>
                        <?php
                            $pol_sorgu = "SELECT * FROM poliklinikler";
                            $sonuc = $conn->query($pol_sorgu);
                            while($row = $sonuc->fetch_assoc()) {
                                echo "<option value='".$row['pol_id']."'>".$row['pol_ad']."</option>";
                            }
                        ?>
    
                        </select>
                    </div>

                    <div class="form-group half">
                        <label>Doktor</label>
                        <select name="doktor_id" id="doktor" required>
                            <option value="">Önce Poliklinik Seçin</option>
                            </select>
                    </div>

                    </div>

                    <div class="form-group">
    <label>Tarih</label>
    <input type="date" name="randevu_tarihi" required>
</div>

<div class="form-group">
    <label>Saat</label>
    <select name="randevu_saati" required>
        <option value="">Saat Seçiniz</option>
        <?php
        for ($saat = 9; $saat <= 17; $saat++) {
            echo "<option value='".sprintf("%02d:00", $saat)."'>".sprintf("%02d:00", $saat)."</option>";
            echo "<option value='".sprintf("%02d:30", $saat)."'>".sprintf("%02d:30", $saat)."</option>";
        }
        ?>
    </select>
</div>



                    <button type="submit" class="submit-btn">
                    <i class="fa-solid fa-calendar-check"></i> Randevuyu Onayla
                    </button>

                </form>
            </div>
        </div>

        <script>
        // HTML'deki poliklinik select kutusunu yakala
        const poliklinikSelect = document.getElementById('poliklinik');
        const doktorSelect = document.getElementById('doktor');

        // Kullanıcı poliklinik değiştirdiğinde (change) bu fonksiyon çalışsın
        poliklinikSelect.addEventListener('change', function() {
            
            const secilenPolId = this.value; // Hangi ID'yi seçti? (Örn: 1)

            // İçini temizle ve "Yükleniyor" yaz
            doktorSelect.innerHTML = '<option value="">Yükleniyor...</option>';

            // Eğer "Seçiniz" boş alanını seçmediyse, gerçekten bir bölüm seçtiyse
            if(secilenPolId !== "") {
                
                // Gönderilecek veriyi hazırla (POST datası)
                const formData = new FormData();
                formData.append('pol_id', secilenPolId);

                // Fetch API ile arka plana istek at
                fetch('doktor_getir.php', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json()) // PHP'den gelen JSON'ı oku
                .then(data => {
                    // Kutuyu temizle
                    doktorSelect.innerHTML = '<option value="">Doktor Seçiniz</option>';
                    
                    // Gelen doktor listesinde dön ve option'ları oluştur
                    data.forEach(function(doktor) {
                        const option = document.createElement('option');
                        // DİKKAT: Veritabanındaki sütun adlarına göre dr_id ve dr_ad_soyad kullanıldı.
                        option.value = doktor.dr_id;     
                        option.text = doktor.dr_ad_soyad; 
                        doktorSelect.add(option);
                    });
                })
                .catch(error => {
                    console.error('AJAX Hatası:', error);
                    doktorSelect.innerHTML = '<option value="">Bir hata oluştu</option>';
                });

            } else {
                // Poliklinik seçimi iptal edildiyse doktorları da sıfırla
                doktorSelect.innerHTML = '<option value="">Önce Poliklinik Seçin</option>';
            }
        });


    </script>

    



</body>

    
</html>