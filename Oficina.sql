create database Oficina;
use Oficina;
CREATE TABLE Clientes (
    ID INT PRIMARY KEY,
    Nome VARCHAR(100),
    Endereço VARCHAR(200),
    Telefone VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE Carros (
    ID INT PRIMARY KEY,
    Modelo VARCHAR(50),
    Ano INT,
    Placa VARCHAR(10),
    Cliente_ID INT,
    FOREIGN KEY (Cliente_ID) REFERENCES Clientes(ID)
);

CREATE TABLE Funcionários (
    ID INT PRIMARY KEY,
    Nome VARCHAR(100),
    Cargo VARCHAR(50),
    Salário DECIMAL(10, 2)
);

CREATE TABLE Serviços (
    ID INT PRIMARY KEY,
    Descrição VARCHAR(200),
    Preço DECIMAL(10, 2)
);

CREATE TABLE Ordens_de_Serviço (
    ID INT PRIMARY KEY,
    Data DATE,
    Carro_ID INT,
    Funcionário_ID INT,
    Serviço_ID INT,
    FOREIGN KEY (Carro_ID) REFERENCES Carros(ID),
    FOREIGN KEY (Funcionário_ID) REFERENCES Funcionários(ID),
    FOREIGN KEY (Serviço_ID) REFERENCES Serviços(ID)
);

-- Recuperação simples de todos os clientes:
SELECT * FROM Clientes;

-- Recuperação dos carros de um determinado cliente:
SELECT Carros.ID, Carros.Modelo, Carros.Ano, Carros.Placa
FROM Carros
JOIN Clientes ON Carros.Cliente_ID = Clientes.ID
WHERE Clientes.Nome = 'NomeDoCliente';

-- Cálculo do valor total gasto por um cliente em serviços:
SELECT Clientes.Nome, SUM(Serviços.Preço) AS Valor_Total_Gasto
FROM Clientes
JOIN Carros ON Clientes.ID = Carros.Cliente_ID
JOIN Ordens_de_Serviço ON Carros.ID = Ordens_de_Serviço.Carro_ID
JOIN Serviços ON Ordens_de_Serviço.Serviço_ID = Serviços.ID
GROUP BY Clientes.ID, Clientes.Nome;

-- Listagem dos funcionários e a quantidade de ordens de serviço realizadas por cada um:
SELECT Funcionários.Nome, COUNT(Ordens_de_Serviço.ID) AS Quantidade_Ordens
FROM Funcionários
LEFT JOIN Ordens_de_Serviço ON Funcionários.ID = Ordens_de_Serviço.Funcionário_ID
GROUP BY Funcionários.ID, Funcionários.Nome;

-- Listagem dos carros que realizaram um serviço específico ordenados por ano do carro:
SELECT Carros.Modelo, Carros.Ano, Serviços.Descrição
FROM Carros
JOIN Ordens_de_Serviço ON Carros.ID = Ordens_de_Serviço.Carro_ID
JOIN Serviços ON Ordens_de_Serviço.Serviço_ID = Serviços.ID
WHERE Serviços.Descrição = 'DescriçãoDoServiço'
ORDER BY Carros.Ano;

-- Funcionários que realizaram mais de X serviços em um período específico:
SELECT Funcionários.Nome, COUNT(Ordens_de_Serviço.ID) AS Quantidade_Ordens
FROM Funcionários
JOIN Ordens_de_Serviço ON Funcionários.ID = Ordens_de_Serviço.Funcionário_ID
WHERE Ordens_de_Serviço.Data BETWEEN 'DataInicial' AND 'DataFinal'
GROUP BY Funcionários.ID, Funcionários.Nome
HAVING COUNT(Ordens_de_Serviço.ID) > X;




