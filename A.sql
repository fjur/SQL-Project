-- CREATE Customer Orders Database

PRINT '**********';
PRINT '* A1 - Creating Cus_Orders Database *';

-- !!! Do validation checks here

CREATE DATABASE Cus_Orders;
GO

-- Create User Defined Data Types

CREATE TYPE cusidt FROM char(5) NOT NULL;
GO

CREATE TYPE orderidt FROM int NOT NULL;
GO

CREATE TYPE prodidt FROM int NOT NULL;
GO

CREATE TYPE titleidt FROM char(3) NOT NULL;
GO

