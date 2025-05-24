-- Inserir alunos
INSERT INTO aluno (nome, idade, RA, endereco) VALUES
('João Silva', 20, '20231001', 'Rua A, 123'),
('Maria Oliveira', 22, '20231002', 'Rua B, 456'),
('Carlos Santos', 19, '20231003', 'Rua C, 789');

-- Inserir transportes
INSERT INTO transporte (tipo, valor, codigo, municipio) VALUES
('Ônibus', 4.50, 'BUS001', 'São Paulo'),
('Metrô', 5.00, 'METRO002', 'São Paulo'),
('Trem', 4.00, 'TREM003', 'São Paulo');

-- Inserir trajetos
INSERT INTO trajeto (id_aluno, id_transporte, origem, destino, horario_saida, horario_chegada, tempo_estimado) VALUES
(1, 1, 'Terminal Norte', 'FEI', '06:30:00', '07:15:00', '00:45:00'),
(2, 2, 'Estação Central', 'FEI', '07:00:00', '07:45:00', '00:45:00'),
(3, 3, 'Terminal Sul', 'FEI', '06:45:00', '07:30:00', '00:45:00');

-- Inserir gastos diários
INSERT INTO gasto_diario (id_aluno, data, valor_total) VALUES
(1, '2025-03-07', 9.00),
(2, '2025-03-07', 10.00),
(3, '2025-03-07', 8.00);

-- Inserir origens dos alunos
INSERT INTO origem_aluno (id_aluno, local) VALUES
(1, 'Casa'),
(2, 'Trabalho'),
(3, 'Casa');

-- Inserir descontos no transporte
INSERT INTO desconto_transporte (id_aluno, id_transporte, percentual) VALUES
(1, 1, 50),
(2, 2, 100),
(3, 3, 50);

-- Inserir níveis de tráfego
INSERT INTO trafego (horario, nivel) VALUES
('07:00:00', 4),
('18:00:00', 5),
('12:00:00', 2);