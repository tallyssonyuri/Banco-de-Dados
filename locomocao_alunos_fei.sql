-- Banco de Dados: Transporte Universitário - Grupo 5

-- Criação do banco de dados
CREATE DATABASE locomocao_alunos_fei;
\c locomocao_alunos_fei;

-- Comentários gerais
COMMENT ON DATABASE locomocao_alunos_fei IS 'Banco de dados para controle de transporte universitário dos alunos da FEI (Grupo 5)';

-- Tabela: alunos
CREATE TABLE alunos (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    ra VARCHAR(20) UNIQUE NOT NULL,
    endereco VARCHAR(200) NOT NULL
);
COMMENT ON TABLE alunos IS 'Cadastro de alunos';
COMMENT ON COLUMN alunos.id_aluno IS 'Chave primária do aluno';
COMMENT ON COLUMN alunos.ra IS 'Registro acadêmico único';

-- Tabela: transportes
CREATE TABLE transportes (
    id_transporte SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    valor DECIMAL(8,2) NOT NULL,
    codigo VARCHAR(20) UNIQUE NOT NULL,
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

-- Índice para consultas por município
CREATE INDEX idx_transportes_municipio ON transportes(municipio);

-- Tabela: trajetos
CREATE TABLE trajetos (
    id_trajeto SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_transporte INT NOT NULL,
    origem VARCHAR(255) NOT NULL,
    destino VARCHAR(255) NOT NULL,
    horario_saida TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    horario_chegada TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    tempo_estimado INTERVAL NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno) ON DELETE CASCADE,
    FOREIGN KEY (id_transporte) REFERENCES transportes(id_transporte) ON DELETE SET NULL
);
COMMENT ON TABLE trajetos IS 'Registro de cada trajeto realizado pelos alunos';
COMMENT ON COLUMN trajetos.horario_saida IS 'Data e hora de saída do trajeto';

-- Tabela: gastos_diarios
CREATE TABLE gastos_diarios (
    id_gasto SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    data DATE NOT NULL,
    valor_total DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno) ON DELETE CASCADE
);
COMMENT ON TABLE gastos_diarios IS 'Controle de gastos diários de transporte por aluno';
COMMENT ON COLUMN gastos_diarios.data IS 'Data dos gastos';

-- Índice para consultas por data de gasto
CREATE INDEX idx_gastos_diarios_data ON gastos_diarios(data);

-- Tabela: origens_alunos
CREATE TABLE origens_alunos (
    id_origem SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    local VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno) ON DELETE CASCADE
);
COMMENT ON TABLE origens_alunos IS 'Locais de origem registrados por aluno';

-- Tabela: descontos_transportes
CREATE TABLE descontos_transportes (
    id_desconto SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_transporte INT NOT NULL,
    percentual INT NOT NULL CHECK (percentual IN (50, 100)),
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno) ON DELETE CASCADE,
    FOREIGN KEY (id_transporte) REFERENCES transportes(id_transporte) ON DELETE CASCADE,
    UNIQUE(id_aluno, id_transporte)
);
COMMENT ON TABLE descontos_transportes IS 'Percentual de desconto concedido a aluno em determinado transporte';

-- Tabela: trafegos
CREATE TABLE trafegos (
    id_trafego SERIAL PRIMARY KEY,
    horario TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    nivel INT NOT NULL CHECK (nivel BETWEEN 1 AND 5)
);
COMMENT ON TABLE trafegos IS 'Registro de fluxo de tráfego em determinado horário';

-- Tabela: participacoes
CREATE TABLE participacoes (
    id_participacao SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_trajeto INT NOT NULL,
    assento VARCHAR(10) NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno) ON DELETE CASCADE,
    FOREIGN KEY (id_trajeto) REFERENCES trajetos(id_trajeto) ON DELETE CASCADE,
    UNIQUE(id_trajeto, assento)
);
COMMENT ON TABLE participacoes IS 'Assentos ocupados por alunos em cada trajeto';
