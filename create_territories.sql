-- ============================================
-- TERRITORY (BÖLGE) OLUŞTURMA SCRIPTİ
-- ============================================
-- DBeaver'da bu scripti çalıştırarak tüm bölgeleri oluşturun
-- ============================================

BEGIN;

-- Tüm bölgeleri ekle (ON CONFLICT ile idempotent - tekrar çalıştırılabilir)
INSERT INTO territories (name) VALUES
    ('Akhisar 1'),
    ('Akhisar 2 ve Köyler'),
    ('Akhisar Kırkağaç'),
    ('Aktepe'),
    ('Alaşahir 2 ve Köyler'),
    ('Alaşehir 1'),
    ('Alaşehir 3 ve Köyler'),
    ('Alsancak'),
    ('Altındağ'),
    ('Askeri Birlik – Cezaevi'),
    ('Balçova'),
    ('Basmane'),
    ('Boğaziçi'),
    ('Bozyaka'),
    ('BUCA'),
    ('Çamlık'),
    ('Çeşme'),
    ('Demirci - Köprübaşı - Gördes'),
    ('GAZİEMİR'),
    ('GEDİZ'),
    ('Gölmarmara-Akhisar'),
    ('Göztepe'),
    ('Gültepe'),
    ('Gümüldür'),
    ('Hatay'),
    ('Kadifekale'),
    ('KARABAGLAR'),
    ('Karaburun'),
    ('Kemalpaşa'),
    ('Kemalpaşa Köyler'),
    ('Kısıkköy'),
    ('Kula - Selendi'),
    ('Limontepe'),
    ('Manisa Çarşı'),
    ('Manisa Karaköy'),
    ('Manisa Merkez'),
    ('Manisa Sanayi'),
    ('Menderes'),
    ('Muradiye'),
    ('Narlıdere'),
    ('Salihli 1'),
    ('Salihli 2'),
    ('Salihli 3 ve Köyler'),
    ('Salihli Köyler Ahmeli'),
    ('Sarıgöl'),
    ('Sarnıç'),
    ('Saruhanlı'),
    ('Seferihisar'),
    ('Soma 1'),
    ('Soma 2'),
    ('Şirinyer'),
    ('TINAZTEPE'),
    ('Turgutlu 1'),
    ('Turgutlu 2 - Manisa'),
    ('Turgutlu 3 ve Köyler'),
    ('Urla'),
    ('Yeşilyurt')
ON CONFLICT (name) DO NOTHING;

COMMIT;

-- ============================================
-- ✅ Tüm bölgeler başarıyla oluşturuldu!
-- ============================================
-- Toplam: 57 bölge
-- 
-- Oluşturulan bölgeleri kontrol etmek için:
-- SELECT COUNT(*) FROM territories;
-- SELECT * FROM territories ORDER BY name;
-- ============================================
