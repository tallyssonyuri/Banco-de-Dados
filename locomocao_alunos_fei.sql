-- Banco de Dados: Transporte Universitário - Grupo 5

-- Criação do banco de dados
CREATE DATABASE locomocao_alunos_fei;
\c locomocao_alunos_fei;

-- Comentários gerais
COMMENT ON DATABASE locomocao_alunos_fei IS 'Banco de dados para controle de transporte universitário dos alunos da FEI (Grupo 5)';

-- Tabela: alunos
CREATE TABLE alunos (
    id_alunos SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    ra VARCHAR(20) NOT NULL UNIQUE,
    endereco VARCHAR(200) NOT NULL
);
COMMENT ON TABLE alunos IS 'Cadastro de alunos';
COMMENT ON COLUMN alunos.id_alunos IS 'Chave primária da tabela alunos';
COMMENT ON COLUMN alunos.ra IS 'Registro acadêmico único';

-- Tabela: transportes
CREATE TABLE transportes (
    id_transportes SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    valor DECIMAL(8,2) NOT NULL,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    municipio VARCHAR(100) NOT NULL,
    num_eixos INT NOT NULL,
    num_assentos INT NOT NULL,
    num_portas INT NOT NULL,
    ar_condicionado BOOLEAN NOT NULL DEFAULT FALSE,
    tipo_necessidade VARCHAR(100)
);
COMMENT ON TABLE transportes IS 'Cadastro de veículos de transporte';
COMMENT ON COLUMN transportes.valor IS 'Valor da tarifa';
COMMENT ON COLUMN transportes.tipo_necessidade IS 'Tipo de necessidade especial atendida pelo veículo (se aplicável)';

-- Índice: consultas por município
CREATE INDEX idx_transportes_municipio ON transportes(municipio);

-- Tabela: trajetos
CREATE TABLE trajetos (
    id_trajetos SERIAL PRIMARY KEY,
    alunos_id INT NOT NULL,
    transportes_id INT,
    origem VARCHAR(255) NOT NULL,
    destino VARCHAR(255) NOT NULL,
    horario_saida TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    horario_chegada TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    tempo_estimado INTERVAL NOT NULL,
    CONSTRAINT fk_trajetos_alunos FOREIGN KEY (alunos_id) REFERENCES alunos(id_alunos) ON DELETE CASCADE,
    CONSTRAINT fk_trajetos_transportes FOREIGN KEY (transportes_id) REFERENCES transportes(id_transportes) ON DELETE SET NULL
);
COMMENT ON TABLE trajetos IS 'Registro de cada trajeto realizado pelos alunos';
COMMENT ON COLUMN trajetos.horario_saida IS 'Data e hora de saída do trajeto';

-- Tabela: gastos_diarios
CREATE TABLE gastos_diarios (
    id_gastos_diarios SERIAL PRIMARY KEY,
    alunos_id INT NOT NULL,
    data_gasto DATE NOT NULL,
    valor_total DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_gastos_alunos FOREIGN KEY (alunos_id) REFERENCES alunos(id_alunos) ON DELETE CASCADE
);
COMMENT ON TABLE gastos_diarios IS 'Controle de gastos diários de transporte por aluno';
COMMENT ON COLUMN gastos_diarios.data_gasto IS 'Data dos gastos';

-- Índice: consultas por data de gasto
CREATE INDEX idx_gastos_diarios_data ON gastos_diarios(data_gasto);

-- Tabela: origens_alunos
CREATE TABLE origens_alunos (
    id_origens_alunos SERIAL PRIMARY KEY,
    alunos_id INT NOT NULL,
    local_origem VARCHAR(255) NOT NULL,
    CONSTRAINT fk_origens_alunos FOREIGN KEY (alunos_id) REFERENCES alunos(id_alunos) ON DELETE CASCADE
);
COMMENT ON TABLE origens_alunos IS 'Locais de origem registrados por aluno';

-- Tabela: descontos_transportes
CREATE TABLE descontos_transportes (
    id_descontos_transportes SERIAL PRIMARY KEY,
    alunos_id INT NOT NULL,
    transportes_id INT NOT NULL,
    percentual INT NOT NULL CHECK (percentual IN (50, 100)),
    CONSTRAINT fk_descontos_alunos FOREIGN KEY (alunos_id) REFERENCES alunos(id_alunos) ON DELETE CASCADE,
    CONSTRAINT fk_descontos_transportes FOREIGN KEY (transportes_id) REFERENCES transportes(id_transportes) ON DELETE CASCADE,
    UNIQUE(alunos_id, transportes_id)
);
COMMENT ON TABLE descontos_transportes IS 'Percentual de desconto concedido a aluno em determinado transporte';

-- Tabela: trafegos
CREATE TABLE trafegos (
    id_trafegos SERIAL PRIMARY KEY,
    horario_registro TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    nivel INT NOT NULL CHECK (nivel BETWEEN 1 AND 5)
);
COMMENT ON TABLE trafegos IS 'Registro de fluxo de tráfego em determinado horário';
COMMENT ON COLUMN trafegos.horario_registro IS 'Data e hora do registro de tráfego';

-- Tabela: participacoes
CREATE TABLE participacoes (
    id_participacoes SERIAL PRIMARY KEY,
    alunos_id INT NOT NULL,
    trajetos_id INT NOT NULL,
    assento VARCHAR(10) NOT NULL,
    CONSTRAINT fk_participacoes_alunos FOREIGN KEY (alunos_id) REFERENCES alunos(id_alunos) ON DELETE CASCADE,
    CONSTRAINT fk_participacoes_trajetos FOREIGN KEY (trajetos_id) REFERENCES trajetos(id_trajetos) ON DELETE CASCADE,
    UNIQUE(trajetos_id, assento)
);
COMMENT ON TABLE participacoes IS 'Assentos ocupados por alunos em cada trajeto';
