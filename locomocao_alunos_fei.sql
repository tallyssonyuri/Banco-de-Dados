-- Criar o banco de dados
CREATE DATABASE locomocao_alunos_fei;
USE locomocao_alunos_fei;

-- Criar a tabela Aluno
CREATE TABLE aluno (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    RA VARCHAR(20) UNIQUE NOT NULL,
    endereco TEXT
);

-- Criar a tabela Transporte
CREATE TABLE transporte (
    id_transporte INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    valor DECIMAL(6,2) NOT NULL,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    municipio VARCHAR(100) NOT NULL
);

-- Criar a tabela Trajeto
CREATE TABLE trajeto (
    id_trajeto INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_transporte INT NOT NULL,
    origem VARCHAR(255) NOT NULL,
    destino VARCHAR(255) NOT NULL,
    horario_saida TIME NOT NULL,
    horario_chegada TIME NOT NULL,
    tempo_estimado TIME NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    FOREIGN KEY (id_transporte) REFERENCES transporte(id_transporte)
);

-- Criar a tabela Gasto_Diario
CREATE TABLE gasto_diario (
    id_gasto INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    data DATE NOT NULL,
    valor_total DECIMAL(6,2) NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno)
);

-- Criar a tabela Origem_Aluno
CREATE TABLE origem_aluno (
    id_origem INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    local VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno)
);

-- Criar a tabela Desconto_Transporte
CREATE TABLE desconto_transporte (
    id_desconto INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_transporte INT NOT NULL,
    percentual INT NOT NULL CHECK (percentual IN (50, 100)),
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    FOREIGN KEY (id_transporte) REFERENCES transporte(id_transporte)
);

-- Criar a tabela Trafego
CREATE TABLE trafego (
    id_trafego INT AUTO_INCREMENT PRIMARY KEY,
    horario TIME NOT NULL,
    nivel INT NOT NULL CHECK (nivel BETWEEN 1 AND 5)
);
