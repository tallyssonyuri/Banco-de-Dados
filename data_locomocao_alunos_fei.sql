-- População da tabela alunos (5 registros)
INSERT INTO alunos (nome, idade, ra, endereco) VALUES
('João Silva',     20, '20231001', 'Rua A, 123, São Paulo, SP'),
('Maria Oliveira', 22, '20231002', 'Av. B, 456, Santo André, SP'),
('Carlos Santos',  19, '20231003', 'Rua C, 789, São Bernardo, SP'),
('Ana Pereira',    21, '20231004', 'Rua D, 101, Diadema, SP'),
('Pedro Costa',    23, '20231005', 'Av. E, 202, Mauá, SP');

-- População da tabela transportes (5 registros)
INSERT INTO transportes (tipo, valor, codigo, municipio, num_eixos, num_assentos, num_portas, ar_condicionado, tipo_necessidade) VALUES
('Ônibus',  4.50, 'BUS001',   'São Paulo',       2, 40, 2, TRUE,  'cadeirante'),
('Metrô',   5.00, 'MET002',   'São Paulo',       0, 200, 4, TRUE,  NULL),
('Trem',    4.00, 'TRM003',   'Santo André',     4, 300, 6, TRUE,  NULL),
('VLT',     3.50, 'VLT004',   'São Bernardo',    2, 120, 4, FALSE, NULL),
('Van',     6.00, 'VAN005',   'Diadema',         2, 15,  2, FALSE, 'idoso');

-- População da tabela trajetos (5 registros)
INSERT INTO trajetos (alunos_id, transportes_id, origem, destino, horario_saida, horario_chegada, tempo_estimado) VALUES
(1, 1, 'Terminal Norte',      'FEI', '2025-05-01 06:30:00', '2025-05-01 07:15:00', INTERVAL '00:45:00'),
(2, 2, 'Estação Central',     'FEI', '2025-05-01 07:00:00', '2025-05-01 07:45:00', INTERVAL '00:45:00'),
(3, 3, 'Terminal Sul',        'FEI', '2025-05-01 06:45:00', '2025-05-01 07:30:00', INTERVAL '00:45:00'),
(4, 4, 'Estação Rudge Ramos', 'FEI', '2025-05-02 08:00:00', '2025-05-02 08:50:00', INTERVAL '00:50:00'),
(5, 5, 'Rua D, 101',          'FEI', '2025-05-02 07:30:00', '2025-05-02 08:15:00', INTERVAL '00:45:00');

-- População da tabela gastos_diarios (5 registros)
INSERT INTO gastos_diarios (alunos_id, data_gasto, valor_total) VALUES
(1, '2025-05-01',  9.00),
(2, '2025-05-01', 10.00),
(3, '2025-05-01',  8.00),
(4, '2025-05-02',  7.00),
(5, '2025-05-02',  6.00);

-- População da tabela origens_alunos (5 registros)
INSERT INTO origens_alunos (alunos_id, local_origem) VALUES
(1, 'Casa'),
(2, 'Trabalho'),
(3, 'Casa'),
(4, 'Universidade XYZ'),
(5, 'Ponto de Van');

-- População da tabela descontos_transportes (5 registros)
INSERT INTO descontos_transportes (alunos_id, transportes_id, percentual) VALUES
(1, 1,  50),
(2, 2, 100),
(3, 3,  50),
(4, 4, 100),
(5, 5,  50);

-- População da tabela trafegos (5 registros)
INSERT INTO trafegos (horario_registro, nivel) VALUES
('2025-05-01 07:00:00', 4),
('2025-05-01 12:00:00', 2),
('2025-05-01 18:00:00', 5),
('2025-05-02 08:00:00', 3),
('2025-05-02 17:30:00', 5);

-- População da tabela participacoes (5 registros)
INSERT INTO participacoes (alunos_id, trajetos_id, assento) VALUES
(1, 1, 'A1'),
(2, 2, 'B2'),
(3, 3, 'C3'),
(4, 4, 'D4'),
(5, 5, 'E5');
