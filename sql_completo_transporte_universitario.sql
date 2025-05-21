
-- Banco de Dados: Transporte Universitário - Grupo 5

-- Criar o banco de dados
CREATE DATABASE locomocao_alunos_fei;
\c locomocao_alunos_fei;

-- Tabela: alunos
CREATE TABLE alunos (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    ra VARCHAR(20) UNIQUE NOT NULL,
    endereco TEXT NOT NULL
);

-- Tabela: transportes
CREATE TABLE transportes (
    id_transporte SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    valor DECIMAL(6,2) NOT NULL,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    num_eixos INT,
    num_assentos INT,
    num_portas INT,
    ar_condicionado BOOLEAN,
    tipo_necessidade VARCHAR(100)
);

-- Tabela: trajetos
CREATE TABLE trajetos (
    id_trajeto SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_transporte INT NOT NULL,
    origem VARCHAR(255) NOT NULL,
    destino VARCHAR(255) NOT NULL,
    horario_saida TIME NOT NULL,
    horario_chegada TIME NOT NULL,
    tempo_estimado INTERVAL NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno),
    FOREIGN KEY (id_transporte) REFERENCES transportes(id_transporte)
);

-- Tabela: gastos_diarios
CREATE TABLE gastos_diarios (
    id_gasto SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    data DATE NOT NULL,
    valor_total DECIMAL(6,2) NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno)
);

-- Tabela: origens_alunos
CREATE TABLE origens_alunos (
    id_origem SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    local VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno)
);

-- Tabela: descontos_transportes
CREATE TABLE descontos_transportes (
    id_desconto SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_transporte INT NOT NULL,
    percentual INT NOT NULL CHECK (percentual IN (50, 100)),
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno),
    FOREIGN KEY (id_transporte) REFERENCES transportes(id_transporte)
);

-- Tabela: trafegos
CREATE TABLE trafegos (
    id_trafego SERIAL PRIMARY KEY,
    horario TIME NOT NULL,
    nivel INT NOT NULL CHECK (nivel BETWEEN 1 AND 5)
);

-- Tabela: participacoes
CREATE TABLE participacoes (
    id_participa SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_trajeto INT NOT NULL,
    assento VARCHAR(10),
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno),
    FOREIGN KEY (id_trajeto) REFERENCES trajetos(id_trajeto)
);
