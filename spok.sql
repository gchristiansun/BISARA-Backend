-- =========================================================================
-- SQL Schema for BISARA SPOK Learning & Quiz Management Feature
-- Compatible with SQLite, PostgreSQL, and MySQL
-- =========================================================================

-- Enable foreign key constraints (specific to SQLite, ignored/safe in others)
PRAGMA foreign_keys = ON;

-- -------------------------------------------------------------------------
-- 1. Table: kamus_bisindo
-- Stores vocabulary definitions, gestures, categories, and SPOK roles
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS kamus_bisindo (
    key VARCHAR(100) PRIMARY KEY,
    word VARCHAR(100) NOT NULL,
    category VARCHAR(100) NOT NULL,
    video_guide_path VARCHAR(255) NOT NULL,
    animation_clip_name VARCHAR(100) NOT NULL,
    description TEXT,
    last_updated BIGINT NOT NULL,
    unsur_spok CHAR(1) CHECK (unsur_spok IN ('S', 'P', 'O', 'K', 'L'))
);

-- Index for fast dictionary lookups and searches
CREATE INDEX IF NOT EXISTS idx_kamus_word ON kamus_bisindo(word);

-- -------------------------------------------------------------------------
-- 2. Table: assigned_quizzes
-- Created by Teacher roles to assign specific vocabulary quizzes to classes
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS assigned_quizzes (
    id VARCHAR(50) PRIMARY KEY,
    class_code VARCHAR(50) NOT NULL,
    word VARCHAR(100) NOT NULL,
    target_accuracy INT NOT NULL,
    difficulty VARCHAR(50) NOT NULL DEFAULT 'Adaptif AI',
    assigned_date VARCHAR(50) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Aktif', 'Ditutup')) DEFAULT 'Aktif'
);

-- Index for filtering active quizzes by class code
CREATE INDEX IF NOT EXISTS idx_quizzes_class ON assigned_quizzes(class_code);

-- -------------------------------------------------------------------------
-- 3. Table: quiz_submissions
-- Submitted by Student roles when completing a specific assigned quiz
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS quiz_submissions (
    id VARCHAR(50) PRIMARY KEY,
    student_code VARCHAR(50) NOT NULL,
    quiz_id VARCHAR(50) NOT NULL,
    best_accuracy INT NOT NULL,
    stars INT NOT NULL,
    completed_date VARCHAR(50) NOT NULL,
    FOREIGN KEY (quiz_id) REFERENCES assigned_quizzes(id) ON DELETE CASCADE
);

-- Indexes for performance on joins and queries
CREATE INDEX IF NOT EXISTS idx_submissions_quiz ON quiz_submissions(quiz_id);
CREATE INDEX IF NOT EXISTS idx_submissions_student ON quiz_submissions(student_code);


-- =========================================================================
-- Seed Data: Core Vocabularies & SPOK Roles
-- =========================================================================

-- Mock Seed Data (kamus_bisindo)
INSERT INTO kamus_bisindo (key, word, category, video_guide_path, animation_clip_name, description, last_updated, unsur_spok) VALUES
('halo', 'halo', 'Kata Santun', '/assets/video/halo.mp4', 'anim_halo', 'Lambaikan telapak tangan kanan terbuka di depan dada atau pelipis melambangkan sapaan hangat.', 1780300880, 'L'),
('terima-kasih', 'terima kasih', 'Kata Santun', '/assets/video/terima_kasih.mp4', 'anim_terima_kasih', 'Letakkan ujung jari di dekat dagu atau bibir bawah, kemudian gerakkan tangan melengkung ke depan dan bawah secara halus.', 1780300880, 'L'),
('tolong', 'tolong', 'Kata Santun', '/assets/video/tolong.mp4', 'anim_tolong', 'Katupkan kedua telapak tangan di depan dada seakan memohon bantuan dengan santun.', 1780300880, 'L'),
('saya', 'saya', 'Kata Benda', '/assets/video/saya.mp4', 'anim_saya', 'Ketuk dada tengah Anda perlahan menggunakan ibu jari atau telapak tangan kanan terbuka.', 1780300880, 'S'),
('kamu', 'kamu', 'Kata Benda', '/assets/video/kamu.mp4', 'anim_kamu', 'Arahkan jari telunjuk tangan kanan menunjuk lurus ke depan ke arah lawan bicara.', 1780300880, 'S'),
('dia', 'dia', 'Kata Benda', '/assets/video/dia.mp4', 'anim_dia', 'Tunjuk ke samping arah pihak ketiga menggunakan jari telunjuk kanan.', 1780300880, 'S'),
('kiko', 'kiko', 'Kata Benda', '/assets/video/kiko.mp4', 'anim_kiko', 'Tutor kelinci pintar di platform Bisara.', 1780300880, 'S'),
('guru', 'guru', 'Kata Benda', '/assets/video/guru.mp4', 'anim_guru', 'Sentuhkan ujung jari telunjuk dan jempol kanan di dekat kening kemudian gerakkan ke bawah.', 1780300880, 'S'),
('siswa', 'siswa', 'Kata Benda', '/assets/video/siswa.mp4', 'anim_siswa', 'Kedua tangan membentuk huruf S lalu gerakkan seperti merangkul melambangkan belajar.', 1780300880, 'S'),
('ayah', 'ayah', 'Kata Benda', '/assets/video/ayah.mp4', 'anim_ayah', 'Letakkan jari telunjuk mendatar di atas bibir kanan melambangkan kumis.', 1780300880, 'S'),
('ibu', 'ibu', 'Kata Benda', '/assets/video/ibu.mp4', 'anim_ibu', 'Sentuhkan jempol kanan di dagu lalu geser ke pipi kanan.', 1780300880, 'S'),
('kakak', 'kakak', 'Kata Benda', '/assets/video/kakak.mp4', 'anim_kakak', 'Posisikan telapak tangan kanan menghadap bawah di dekat pelipis lalu angkat sedikit.', 1780300880, 'S'),
('adik', 'adik', 'Kata Benda', '/assets/video/adik.mp4', 'anim_adik', 'Posisikan telapak tangan kanan menghadap bawah di dekat pinggul lalu turunkan sedikit.', 1780300880, 'S'),
('makan', 'makan', 'Kata Kerja', '/assets/video/makan.mp4', 'anim_makan', 'Bentuk ujung-ujung jari tangan kanan menyatu lalu arahkan mendekati mulut berulang kali.', 1780300880, 'P'),
('minum', 'minum', 'Kata Kerja', '/assets/video/minum.mp4', 'anim_minum', 'Bentuk genggaman tangan kanan seperti memegang gelas, lalu gerakkan ibu jari mengarah ke mulut seolah menenggak cairan.', 1780300880, 'P'),
('belajar', 'belajar', 'Kata Kerja', '/assets/video/belajar.mp4', 'anim_belajar', 'Buka telapak tangan kiri mendatar di depan dada, lalu ketukkan ujung jari tangan kanan berulang kali di atas telapak tangan kiri.', 1780300880, 'P'),
('membaca', 'membaca', 'Kata Kerja', '/assets/video/membaca.mp4', 'anim_membaca', 'Dua jari kanan menunjuk mata lalu menyapu telapak tangan kiri yang terbuka.', 1780300880, 'P'),
('menulis', 'menulis', 'Kata Kerja', '/assets/video/menulis.mp4', 'anim_menulis', 'Goreskan telunjuk-jempol kanan seperti memegang pena di atas telapak tangan kiri.', 1780300880, 'P'),
('bermain', 'bermain', 'Kata Kerja', '/assets/video/bermain.mp4', 'anim_bermain', 'Goyangkan pergelangan tangan kiri-kanan memutar bergantian dengan riang.', 1780300880, 'P'),
('pergi', 'pergi', 'Kata Kerja', '/assets/video/pergi.mp4', 'anim_pergi', 'Ayunkan telapak tangan kanan menghadap luar ke depan menjauh.', 1780300880, 'P'),
('buku', 'buku', 'Kata Benda', '/assets/video/buku.mp4', 'anim_buku', 'Satukan kedua telapak tangan merapat, lalu buka perlahan seperti membuka lembaran buku.', 1780300880, 'O'),
('roti', 'roti', 'Kata Benda', '/assets/video/roti.mp4', 'anim_roti', 'Sisi luar tangan kanan menyayat kepalan tangan kiri berulang.', 1780300880, 'O'),
('kopi', 'kopi', 'Kata Benda', '/assets/video/kopi.mp4', 'anim_kopi', 'Tangan memegang cangkir lalu gerakkan memutar di atas telapak tangan kiri seolah mengaduk.', 1780300880, 'O'),
('kamus', 'kamus', 'Kata Benda', '/assets/video/kamus.mp4', 'anim_kamus', 'Buka telapak tangan seperti buku lalu eja huruf A ke Z.', 1780300880, 'O'),
('surat', 'surat', 'Kata Benda', '/assets/video/surat.mp4', 'anim_surat', 'Sentuhkan jempol kanan ke bibir lalu tempel ke telapak kiri.', 1780300880, 'O'),
('bola', 'bola', 'Kata Benda', '/assets/video/bola.mp4', 'anim_bola', 'Jari kedua tangan melengkung seolah memegang lingkaran bola bulat.', 1780300880, 'O'),
('sekolah', 'sekolah', 'Kata Benda', '/assets/video/sekolah.mp4', 'anim_sekolah', 'Gambarkan atap rumah dengan tangan, kemudian ketukkan ujung jari kanan di telapak kiri melambangkan belajar.', 1780300880, 'K'),
('rumah', 'rumah', 'Kata Benda', '/assets/video/rumah.mp4', 'anim_rumah', 'Satukan ujung-ujung jari kedua tangan di atas membentuk atap segitiga menyiku.', 1780300880, 'K'),
('kantor', 'kantor', 'Kata Benda', '/assets/video/kantor.mp4', 'anim_kantor', 'Gambarkan atap rumah lalu ketuk dada kiri.', 1780300880, 'K'),
('lapangan', 'lapangan', 'Kata Benda', '/assets/video/lapangan.mp4', 'anim_lapangan', 'Gerakkan kedua telapak tangan datar ke luar membentuk persegi panjang datar luas.', 1780300880, 'K')
ON CONFLICT(key) DO UPDATE SET
    word=excluded.word,
    category=excluded.category,
    video_guide_path=excluded.video_guide_path,
    animation_clip_name=excluded.animation_clip_name,
    description=excluded.description,
    unsur_spok=excluded.unsur_spok;

-- Mock Seed Data (assigned_quizzes)
INSERT INTO assigned_quizzes (id, class_code, word, target_accuracy, difficulty, assigned_date, status) VALUES
('q1', 'INK3A', 'terima kasih', 85, 'Adaptif AI', '2 jam yang lalu', 'Aktif'),
('q2', 'INK3A', 'makan', 75, 'Adaptif AI', '1 hari yang lalu', 'Aktif'),
('q3', 'INK3A', 'belajar', 90, 'Adaptif AI', '3 hari yang lalu', 'Ditutup')
ON CONFLICT(id) DO NOTHING;
