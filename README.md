# fifi-baza
-- 1. Kreiranje baze podataka
CREATE DATABASE FiFi_DB;
GO

USE FiFi_DB;
GO

-- 2. Tabela: Korisnici
CREATE TABLE Korisnici (
    KorisnikID INT IDENTITY(1,1) PRIMARY KEY,
    Ime NVARCHAR(50) NOT NULL,
    Prezime NVARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Telefon VARCHAR(20),
    LozinkaHash VARCHAR(255) NOT NULL,
    DatumRegistracije DATETIME DEFAULT GETDATE()
);

-- 3. Tabela: Kategorije
CREATE TABLE Kategorije (
    KategorijaID INT IDENTITY(1,1) PRIMARY KEY,
    NazivKategorije NVARCHAR(50) NOT NULL UNIQUE
);

-- 4. Tabela: Lokacije
CREATE TABLE Lokacije (
    LokacijaID INT IDENTITY(1,1) PRIMARY KEY,
    Grad NVARCHAR(50) NOT NULL,
    OpstinaNaseobina NVARCHAR(50)
);

-- 5. Tabela: Predmeti (Glavna tabela za Lost & Found)
CREATE TABLE Predmeti (
    PredmetID INT IDENTITY(1,1) PRIMARY KEY,
    Naslov NVARCHAR(100) NOT NULL,
    Opis NVARCHAR(MAX),
    TipOglasa VARCHAR(10) NOT NULL CHECK (TipOglasa IN ('Izgubljeno', 'Nađeno')),
    DatumDogadjaja DATE NOT NULL,
    StatusOglasa VARCHAR(15) DEFAULT 'Aktivno' CHECK (StatusOglasa IN ('Aktivno', 'Rešeno', 'Arhivirano')),
    SlikaUrl VARCHAR(255),
    
    -- Strani ključevi
    KorisnikID INT NOT NULL,
    KategorijaID INT NOT NULL,
    LokacijaID INT NOT NULL,
    
    FOREIGN KEY (KorisnikID) REFERENCES Korisnici(KorisnikID) ON DELETE CASCADE,
    FOREIGN KEY (KategorijaID) REFERENCES Kategorije(KategorijaID),
    FOREIGN KEY (LokacijaID) REFERENCES Lokacije(LokacijaID)
);

-- 6. Tabela: Poruke/Kontakti
CREATE TABLE Poruke (
    PorukaID INT IDENTITY(1,1) PRIMARY KEY,
    PredmetID INT NOT NULL,
    PosiljalacID INT NOT NULL,
    PrimalacID INT NOT NULL,
    TekstPoruke NVARCHAR(MAX) NOT NULL,
    DatumSlanja DATETIME DEFAULT GETDATE(),
    
    FOREIGN KEY (PredmetID) REFERENCES Predmeti(PredmetID),
    FOREIGN KEY (PosiljalacID) REFERENCES Korisnici(KorisnikID),
    FOREIGN KEY (PrimalacID) REFERENCES Korisnici(KorisnikID)
);

-- 7. Indeksi za optimizaciju pretrage
CREATE INDEX
IX_Predmeti_Tip_Status ON Predmeti(TipOglasa, StatusOglasa);
CREATE INDEX IX_Predmeti_Kategorija ON Predmeti(KategorijaID);
CREATE INDEX IX_Predmeti_Lokacija ON Predmeti(LokacijaID);
-- Unos osnovnih kategorija
INSERT INTO Kategorije (NazivKategorije) VALUES 
('Dokumenta i Novčanici'), 
('Elektronika'), 
('Ključevi'), 
('Kućni ljubimci'), 
('Lične stvari');

-- Upit za pretragu svih aktivnih izgubljenih predmeta u kategoriji 'Elektronika'
SELECT 
    p.PredmetID,
    p.Naslov,
    p.Opis,
    p.DatumDogadjaja,
    k.NazivKategorije,
    l.Grad,
    u.Ime + ' ' + u.Prezime AS KontaktOsoba,
    u.Telefon
FROM Predmeti p
JOIN Kategorije k ON p.KategorijaID = k.KategorijaID
JOIN Lokacije l ON p.LokacijaID = l.LokacijaID
JOIN Korisnici u ON p.KorisnikID = u.KorisnikID
WHERE p.TipOglasa = 'Izgubljeno' 
  AND p.StatusOglasa = 'Aktivno'
  AND k.NazivKategorije = 'Elektronika';
