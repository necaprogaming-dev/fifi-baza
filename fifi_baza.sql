IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'FifiDB')
BEGIN
    CREATE DATABASE FifiDB;
END
GO

USE FifiDB;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Korisnici') AND type in (N'U'))
BEGIN
    CREATE TABLE Korisnici (
        KorisnikID INT IDENTITY(1,1) PRIMARY KEY,
        KorisnickoIme VARCHAR(50) NOT NULL UNIQUE,
        Email VARCHAR(100) NOT NULL UNIQUE,
        LozinkaHash VARCHAR(255) NOT NULL,
        Telefon VARCHAR(20),
        Grad VARCHAR(50),
        DatumRegistracije DATETIME DEFAULT GETDATE()
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'GlavneKategorije') AND type in (N'U'))
BEGIN
    CREATE TABLE GlavneKategorije (
        GlavnaKategorijaID INT IDENTITY(1,1) PRIMARY KEY,
        NazivGlavneKategorije VARCHAR(100) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Podkategorije') AND type in (N'U'))
BEGIN
    CREATE TABLE Podkategorije (
        PodkategorijaID INT IDENTITY(1,1) PRIMARY KEY,
        GlavnaKategorijaID INT FOREIGN KEY REFERENCES GlavneKategorije(GlavnaKategorijaID),
        NazivPodkategorije VARCHAR(100) NOT NULL
    );
END
GO
USE FifiDB;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Predmeti') AND type in (N'U'))
BEGIN
    CREATE TABLE Predmeti (
        PredmetID INT IDENTITY(1,1) PRIMARY KEY,
        KorisnikID INT FOREIGN KEY REFERENCES Korisnici(KorisnikID),
        PodkategorijaID INT FOREIGN KEY REFERENCES Podkategorije(PodkategorijaID),
        Naslov VARCHAR(150) NOT NULL,
        Opis TEXT,
        Status VARCHAR(20) CHECK (Status IN ('Izgubljeno', 'Pronadjeno', 'Preuzeto')) NOT NULL,
        LokacijaNaziv VARCHAR(200),
        GeografskaSirina DECIMAL(9,6),
        GeografskaDuzina DECIMAL(9,6),
        DatumObjave DATETIME DEFAULT GETDATE()
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SlikePredmeta') AND type in (N'U'))
BEGIN
    CREATE TABLE SlikePredmeta (
        SlikaID INT IDENTITY(1,1) PRIMARY KEY,
        PredmetID INT FOREIGN KEY REFERENCES Predmeti(PredmetID),
        PutanjaDoSlike VARCHAR(500) NOT NULL,
        GlavnaSlika BIT DEFAULT 0
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Poruke') AND type in (N'U'))
BEGIN
    CREATE TABLE Poruke (
        PorukaID INT IDENTITY(1,1) PRIMARY KEY,
        PredmetID INT FOREIGN KEY REFERENCES Predmeti(PredmetID),
        PosiljalacID INT FOREIGN KEY REFERENCES Korisnici(KorisnikID),
        PrimalacID INT FOREIGN KEY REFERENCES Korisnici(KorisnikID),
        SadrzajPoruke TEXT NOT NULL,
        Procitano BIT DEFAULT 0,
        DatumSlanja DATETIME DEFAULT GETDATE()
    );
END
GO
USE FifiDB;
GO

IF NOT EXISTS (SELECT * FROM GlavneKategorije)
BEGIN
    INSERT INTO GlavneKategorije (NazivGlavneKategorije) VALUES 
    ('Elektronika i uredjaji'),
    ('Licni dokumenti i kartice'),
    ('Novac i dragocenosti'),
    ('Odeca i obuca'),
    ('Skolska oprema i knjige'),
    ('Kljucevi i privesci'),
    ('Kucni ljubimci i zivotinje'),
    ('Sport i rekreacija'),
    ('Alat i oprema'),
    ('Ostale stvari');
END
GO

IF NOT EXISTS (SELECT * FROM Podkategorije)
BEGIN
    INSERT INTO Podkategorije (GlavnaKategorijaID, NazivPodkategorije) VALUES 
    (1, 'Pametni telefoni'), (1, 'Laptop racunari'), (1, 'Tableti'), 
    (1, 'Pametni satovi i narukvice'), (1, 'Bezicne slusalice'), (1, 'Punjaci i kablovi'), (1, 'Prenosive baterije');

    INSERT INTO Podkategorije (GlavnaKategorijaID, NazivPodkategorije) VALUES 
    (2, 'Licna karta'), (2, 'Pasos'), (2, 'Vozacka dozvola'), 
    (2, 'Zdravstvena knjizica'), (2, 'Skolska kartica'), (2, 'Bankovne kartice'), (2, 'BusPlus kartica');

    INSERT INTO Podkategorije (GlavnaKategorijaID, NazivPodkategorije) VALUES 
    (3, 'Kozni novcanici'), (3, 'Muske torbice'), (3, 'Zenske tasne'), 
    (3, 'Zlatni nakit'), (3, 'Srebrni nakit'), (3, 'Rucni satovi');

    INSERT INTO Podkategorije (GlavnaKategorijaID, NazivPodkategorije) VALUES 
    (4, 'Jakne i kaputi'), (4, 'Dukserice'), (4, 'Sportske patike'), 
    (4, 'Kape, šalovi i rukavice'), (4, 'Suncane naocare'), (4, 'Dioptrijske naocare');

    INSERT INTO Podkategorije (GlavnaKategorijaID, NazivPodkategorije) VALUES 
    (5, 'Rancevi i torbe'), (5, 'Sveske i knjige'), (5, 'Pernice i pribor'), 
    (5, 'Kalkulatori'), (5, 'Likovni pribor');

    INSERT INTO Podkategorije (GlavnaKategorijaID, NazivPodkategorije) VALUES 
    (6, 'Kljucevi od stana'), (6, 'Kljucevi od automobila'), (6, 'Katanci i lanci');

    INSERT INTO Podkategorije (GlavnaKategorijaID, NazivPodkategorije) VALUES 
    (7, 'Izgubljeni psi'), (7, 'Izgubljene macke'), (7, 'Ptice'), (7, 'Ogrlice za pracenje'
);
END
GO