-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 14 Şub 2026, 14:24:03
-- Sunucu sürümü: 10.4.32-MariaDB
-- PHP Sürümü: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `hastane_randevu_sistemi`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `doktorlar`
--

CREATE TABLE `doktorlar` (
  `dr_id` int(11) NOT NULL,
  `dr_ad_soyad` varchar(100) NOT NULL,
  `pol_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `doktorlar`
--

INSERT INTO `doktorlar` (`dr_id`, `dr_ad_soyad`, `pol_id`) VALUES
(1, 'Dr. Ufuk Bozdoğan', 5),
(2, 'Prof. Dr. Ahmet Yılmaz', 1),
(3, 'Dr. Ayşe Kaya', 1),
(4, 'Dr. Mehmet Öz', 1),
(5, 'Dr. Emre Konur', 2),
(6, 'Dr. Selin Demir', 2),
(7, 'Prof. Dr. Burak Yılmaz', 2),
(8, 'Dr. Murat Aydın', 3),
(9, 'Dr. Fatma Şahin', 3),
(10, 'Dr. Kerem Aktürkoğlu', 3),
(11, 'Prof. Dr. Alex De Souza', 4),
(12, 'Dr. Leyla Gencer', 4),
(13, 'Dr. Volkan Demirel', 4),
(14, 'Dr. Arda Güler', 4),
(15, 'Dr. Muslera Fernando', 4),
(16, 'Dr. Pelin Çift', 5),
(17, 'Dr. Cengiz Ünder', 5),
(18, 'Dr. İrfan Can Kahveci', 5),
(19, 'Dr. Ferdi Kadıoğlu', 5);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `doktor_izinleri`
--

CREATE TABLE `doktor_izinleri` (
  `izin_id` int(11) NOT NULL,
  `dr_id` int(11) DEFAULT NULL,
  `izin_tarihi` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `doktor_izinleri`
--

INSERT INTO `doktor_izinleri` (`izin_id`, `dr_id`, `izin_tarihi`) VALUES
(1, 16, '2026-02-24'),
(2, 16, '2026-02-28'),
(3, 14, '2026-03-03');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `poliklinikler`
--

CREATE TABLE `poliklinikler` (
  `pol_id` int(11) NOT NULL,
  `pol_ad` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `poliklinikler`
--

INSERT INTO `poliklinikler` (`pol_id`, `pol_ad`) VALUES
(1, 'Patoloji'),
(2, 'Ortopedi'),
(3, 'Üroloji'),
(4, 'Kardiyoloji'),
(5, 'Nöroloji');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `randevular`
--

CREATE TABLE `randevular` (
  `randevu_id` int(11) NOT NULL,
  `dr_id` int(11) DEFAULT NULL,
  `hasta_ad_soyad` varchar(100) DEFAULT NULL,
  `randevu_tarihi` date DEFAULT NULL,
  `randevu_saati` time DEFAULT NULL,
  `durum` enum('aktif','iptal') DEFAULT 'aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `randevular`
--

INSERT INTO `randevular` (`randevu_id`, `dr_id`, `hasta_ad_soyad`, `randevu_tarihi`, `randevu_saati`, `durum`) VALUES
(1, 1, 'Eren Konur', '2026-02-20', '09:00:00', 'aktif'),
(2, 16, 'Yasemin Allame', '2026-02-20', '09:00:00', 'aktif'),
(3, 16, 'Mihriban Koz', '2026-02-20', '09:30:00', 'aktif'),
(4, 5, 'Mustafa Eryigit', '2026-02-21', '10:00:00', 'aktif'),
(5, 5, 'Pelin Kandemir', '2026-02-21', '10:30:00', 'aktif'),
(6, 10, 'Mustafa Topaloglu', '2026-02-22', '14:00:00', 'aktif'),
(7, 14, 'İrfan Can Egribayat', '2026-02-22', '15:30:00', 'aktif');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `doktorlar`
--
ALTER TABLE `doktorlar`
  ADD PRIMARY KEY (`dr_id`),
  ADD KEY `pol_id` (`pol_id`);

--
-- Tablo için indeksler `doktor_izinleri`
--
ALTER TABLE `doktor_izinleri`
  ADD PRIMARY KEY (`izin_id`),
  ADD KEY `dr_id` (`dr_id`);

--
-- Tablo için indeksler `poliklinikler`
--
ALTER TABLE `poliklinikler`
  ADD PRIMARY KEY (`pol_id`);

--
-- Tablo için indeksler `randevular`
--
ALTER TABLE `randevular`
  ADD PRIMARY KEY (`randevu_id`),
  ADD UNIQUE KEY `unique_randevu` (`dr_id`,`randevu_tarihi`,`randevu_saati`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `doktorlar`
--
ALTER TABLE `doktorlar`
  MODIFY `dr_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Tablo için AUTO_INCREMENT değeri `doktor_izinleri`
--
ALTER TABLE `doktor_izinleri`
  MODIFY `izin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Tablo için AUTO_INCREMENT değeri `poliklinikler`
--
ALTER TABLE `poliklinikler`
  MODIFY `pol_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `randevular`
--
ALTER TABLE `randevular`
  MODIFY `randevu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `doktorlar`
--
ALTER TABLE `doktorlar`
  ADD CONSTRAINT `doktorlar_ibfk_1` FOREIGN KEY (`pol_id`) REFERENCES `poliklinikler` (`pol_id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `doktor_izinleri`
--
ALTER TABLE `doktor_izinleri`
  ADD CONSTRAINT `doktor_izinleri_ibfk_1` FOREIGN KEY (`dr_id`) REFERENCES `doktorlar` (`dr_id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `randevular`
--
ALTER TABLE `randevular`
  ADD CONSTRAINT `randevular_ibfk_1` FOREIGN KEY (`dr_id`) REFERENCES `doktorlar` (`dr_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
