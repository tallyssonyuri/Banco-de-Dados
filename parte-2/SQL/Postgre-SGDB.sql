-- ========================================================
-- Banco de Dados: Transporte Universitário - Grupo 5
-- Arquivo único: DDL + INSERTs + Consultas
-- ========================================================

-- --------------------------------------------------------
-- 1) Criação do banco de dados e seleção
-- --------------------------------------------------------
CREATE DATABASE locomocao_alunos_fei;
\c locomocao_alunos_fei;

-- Comentário do banco
COMMENT ON DATABASE locomocao_alunos_fei 
  IS 'Banco de dados para controle de transporte universitário dos alunos da FEI (Grupo 5)';

-- --------------------------------------------------------
-- 2) DDL: criação de tabelas, constraints, índices
-- --------------------------------------------------------

-- Tabela: alunos
CREATE TABLE alunos (
    id_alunos       SERIAL    PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL,
    idade           INT          NOT NULL,
    ra              VARCHAR(20)  NOT NULL UNIQUE,
    endereco        VARCHAR(200) NOT NULL
);
COMMENT ON TABLE alunos       IS 'Cadastro de alunos';
COMMENT ON COLUMN alunos.id_alunos IS 'Chave primária da tabela alunos';
COMMENT ON COLUMN alunos.ra       IS 'Registro acadêmico único';

-- Tabela: transportes
CREATE TABLE transportes (
    id_transportes    SERIAL      PRIMARY KEY,
    tipo              VARCHAR(50) NOT NULL,
    valor             DECIMAL(8,2) NOT NULL,
    codigo            VARCHAR(20) NOT NULL UNIQUE,
    municipio         VARCHAR(100) NOT NULL,
    num_eixos         INT          NOT NULL,
    num_assentos      INT          NOT NULL,
    num_portas        INT          NOT NULL,
    ar_condicionado   BOOLEAN      NOT NULL DEFAULT FALSE,
    tipo_necessidade  VARCHAR(100)
);
COMMENT ON TABLE transportes         IS 'Cadastro de veículos de transporte';
COMMENT ON COLUMN transportes.valor  IS 'Valor da tarifa';
COMMENT ON COLUMN transportes.tipo_necessidade 
  IS 'Tipo de necessidade especial atendida pelo veículo (se aplicável)';

-- Índice de apoio
CREATE INDEX idx_transportes_municipio ON transportes(municipio);

-- Tabela: trajetos
CREATE TABLE trajetos (
    id_trajetos       SERIAL    PRIMARY KEY,
    alunos_id         INT       NOT NULL,
    transportes_id    INT,
    origem            VARCHAR(255) NOT NULL,
    destino           VARCHAR(255) NOT NULL,
    horario_saida     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    horario_chegada   TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    tempo_estimado    INTERVAL  NOT NULL,
    CONSTRAINT fk_trajetos_alunos      FOREIGN KEY (alunos_id)      REFERENCES alunos(id_alunos)      ON DELETE CASCADE,
    CONSTRAINT fk_trajetos_transportes FOREIGN KEY (transportes_id) REFERENCES transportes(id_transportes) ON DELETE SET NULL
);
COMMENT ON TABLE trajetos          IS 'Registro de cada trajeto realizado pelos alunos';
COMMENT ON COLUMN trajetos.horario_saida 
  IS 'Data e hora de saída do trajeto';

-- Tabela: gastos_diarios
CREATE TABLE gastos_diarios (
    id_gastos_diarios SERIAL    PRIMARY KEY,
    alunos_id         INT       NOT NULL,
    data_gasto        DATE      NOT NULL,
    valor_total       DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_gastos_alunos FOREIGN KEY (alunos_id) REFERENCES alunos(id_alunos) ON DELETE CASCADE
);
COMMENT ON TABLE gastos_diarios      IS 'Controle de gastos diários de transporte por aluno';
COMMENT ON COLUMN gastos_diarios.data_gasto 
  IS 'Data dos gastos';

CREATE INDEX idx_gastos_diarios_data ON gastos_diarios(data_gasto);

-- Tabela: origens_alunos
CREATE TABLE origens_alunos (
    id_origens_alunos SERIAL  PRIMARY KEY,
    alunos_id         INT     NOT NULL,
    local_origem      VARCHAR(255) NOT NULL,
    CONSTRAINT fk_origens_alunos FOREIGN KEY (alunos_id) REFERENCES alunos(id_alunos) ON DELETE CASCADE
);
COMMENT ON TABLE origens_alunos      IS 'Locais de origem registrados por aluno';

-- Tabela: descontos_transportes
CREATE TABLE descontos_transportes (
    id_descontos_transportes SERIAL    PRIMARY KEY,
    alunos_id                INT       NOT NULL,
    transportes_id           INT       NOT NULL,
    percentual               INT       NOT NULL CHECK (percentual IN (50,100)),
    CONSTRAINT fk_descontos_alunos      FOREIGN KEY (alunos_id)      REFERENCES alunos(id_alunos)      ON DELETE CASCADE,
    CONSTRAINT fk_descontos_transportes FOREIGN KEY (transportes_id) REFERENCES transportes(id_transportes) ON DELETE CASCADE,
    UNIQUE(alunos_id, transportes_id)
);
COMMENT ON TABLE descontos_transportes 
  IS 'Percentual de desconto concedido a aluno em determinado transporte';

-- Tabela: trafegos
CREATE TABLE trafegos (
    id_trafegos      SERIAL    PRIMARY KEY,
    horario_registro TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    nivel            INT       NOT NULL CHECK (nivel BETWEEN 1 AND 5)
);
COMMENT ON TABLE trafegos 
  IS 'Registro de fluxo de tráfego em determinado horário';
COMMENT ON COLUMN trafegos.horario_registro 
  IS 'Data e hora do registro de tráfego';

-- Tabela: participacoes
CREATE TABLE participacoes (
    id_participacoes SERIAL    PRIMARY KEY,
    alunos_id        INT       NOT NULL,
    trajetos_id      INT       NOT NULL,
    assento          VARCHAR(10) NOT NULL,
    CONSTRAINT fk_participacoes_alunos  FOREIGN KEY (alunos_id)   REFERENCES alunos(id_alunos)    ON DELETE CASCADE,
    CONSTRAINT fk_participacoes_trajetos FOREIGN KEY (trajetos_id) REFERENCES trajetos(id_trajetos) ON DELETE CASCADE,
    UNIQUE(trajetos_id, assento)
);
COMMENT ON TABLE participacoes 
  IS 'Assentos ocupados por alunos em cada trajeto';

-- ========================================================
-- 3) POPULAÇÃO DE DADOS (mín. 5 registros cada tabela)
-- ========================================================

-- alunos
INSERT INTO alunos (nome, idade, ra, endereco) VALUES
  ('João Silva',     20, '20231001', 'Rua A, 123, São Paulo, SP'),
  ('Maria Oliveira', 22, '20231002', 'Av. B, 456, Santo André, SP'),
  ('Carlos Santos',  19, '20231003', 'Rua C, 789, São Bernardo, SP'),
  ('Ana Pereira',    21, '20231004', 'Rua D, 101, Diadema, SP'),
  ('Pedro Costa',    23, '20231005', 'Av. E, 202, Mauá, SP');

-- transportes
INSERT INTO transportes (tipo, valor, codigo, municipio, num_eixos, num_assentos, num_portas, ar_condicionado, tipo_necessidade) VALUES
  ('Ônibus',  4.50, 'BUS001', 'São Paulo',       2,  40, 2, TRUE,  'cadeirante'),
  ('Metrô',   5.00, 'MET002', 'São Paulo',       0, 200, 4, TRUE,  NULL),
  ('Trem',    4.00, 'TRM003', 'Santo André',     4, 300, 6, TRUE,  NULL),
  ('VLT',     3.50, 'VLT004', 'São Bernardo',    2, 120, 4, FALSE, NULL),
  ('Van',     6.00, 'VAN005', 'Diadema',         2,  15, 2, FALSE, 'idoso');

-- trajetos
INSERT INTO trajetos (alunos_id, transportes_id, origem, destino, horario_saida, horario_chegada, tempo_estimado) VALUES
  (1, 1, 'Terminal Norte',      'FEI', '2025-05-01 06:30:00', '2025-05-01 07:15:00', INTERVAL '00:45:00'),
  (2, 2, 'Estação Central',     'FEI', '2025-05-01 07:00:00', '2025-05-01 07:45:00', INTERVAL '00:45:00'),
  (3, 3, 'Terminal Sul',        'FEI', '2025-05-01 06:45:00', '2025-05-01 07:30:00', INTERVAL '00:45:00'),
  (4, 4, 'Estação Rudge Ramos', 'FEI', '2025-05-02 08:00:00', '2025-05-02 08:50:00', INTERVAL '00:50:00'),
  (5, 5, 'Rua D, 101',          'FEI', '2025-05-02 07:30:00', '2025-05-02 08:15:00', INTERVAL '00:45:00');

-- gastos_diarios
INSERT INTO gastos_diarios (alunos_id, data_gasto, valor_total) VALUES
  (1, '2025-05-01',  9.00),
  (2, '2025-05-01', 10.00),
  (3, '2025-05-01',  8.00),
  (4, '2025-05-02',  7.00),
  (5, '2025-05-02',  6.00);

-- origens_alunos
INSERT INTO origens_alunos (alunos_id, local_origem) VALUES
  (1, 'Casa'),
  (2, 'Trabalho'),
  (3, 'Casa'),
  (4, 'Universidade XYZ'),
  (5, 'Ponto de Van');

-- descontos_transportes
INSERT INTO descontos_transportes (alunos_id, transportes_id, percentual) VALUES
  (1, 1,  50),
  (2, 2, 100),
  (3, 3,  50),
  (4, 4, 100),
  (5, 5,  50);

-- trafegos
INSERT INTO trafegos (horario_registro, nivel) VALUES
  ('2025-05-01 07:00:00', 4),
  ('2025-05-01 12:00:00', 2),
  ('2025-05-01 18:00:00', 5),
  ('2025-05-02 08:00:00', 3),
  ('2025-05-02 17:30:00', 5);

-- participacoes
INSERT INTO participacoes (alunos_id, trajetos_id, assento) VALUES
  (1, 1, 'A1'),
  (2, 2, 'B2'),
  (3, 3, 'C3'),
  (4, 4, 'D4'),
  (5, 5, 'E5');

-- ========================================================
-- 4) CONSULTAS SQL
-- ========================================================

-- 1ª CONSULTA
-- Enunciado:
--   Listar todos os alunos que fizeram trajetos, exibindo nome, tipo de transporte e município,
--   filtrando apenas quem usa “Ônibus” e ordenando por nome do aluno.
-- Relevância:
--   Permite saber quais alunos dependem de um modal específico (“Ônibus”) e em que município,
--   facilitando ações de melhoria ou negociação de convênios com transportadoras.
SELECT 
  a.nome,
  t.tipo   AS transporte,
  t.municipio
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
JOIN transportes AS t 
  ON tr.transportes_id = t.id_transportes
WHERE t.tipo = 'Ônibus'
ORDER BY a.nome;


-- 2ª CONSULTA
-- Enunciado:
--   Para cada aluno, calcular o número de trajetos realizados e o total gasto em transporte,
--   no período de 1 a 7 de maio de 2025.
-- Relevância:
--   Ajuda a comparar o volume de uso (quantidade de viagens) com o impacto financeiro (gastos),
--   identificando perfis de maior demanda e custo.
SELECT
  a.nome,
  COUNT(tr.id_trajetos)   AS total_trajetos,
  SUM(gd.valor_total)     AS gasto_total,
  AVG(gd.valor_total)     AS gasto_medio_diario
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
JOIN gastos_diarios AS gd 
  ON a.id_alunos = gd.alunos_id
WHERE gd.data_gasto BETWEEN '2025-05-01' AND '2025-05-07'
GROUP BY a.id_alunos, a.nome;


-- 3ª CONSULTA
-- Enunciado:
--   Identificar alunos que fizeram trajetos em horários de pico (nível ≥ 4) e cujo gasto diário
--   em 2 de maio de 2025 superou a média de gastos de todos os alunos naquele dia.
-- Relevância:
--   Combina análise de demanda (horários críticos) com impacto financeiro, permitindo priorizar
--   estudantes que mais sofrem em condições adversas de tráfego e custo.
SELECT
  a.nome,
  gd.valor_total   AS gasto_no_dia,
  t.nivel          AS nivel_trafego
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
JOIN trafegos AS t 
  ON tr.horario_saida = t.horario_registro
JOIN gastos_diarios AS gd 
  ON a.id_alunos = gd.alunos_id
WHERE
  gd.data_gasto = '2025-05-02'
  AND t.nivel >= 4
  AND gd.valor_total > (
    SELECT AVG(valor_total)
    FROM gastos_diarios
    WHERE data_gasto = '2025-05-02'
  );
