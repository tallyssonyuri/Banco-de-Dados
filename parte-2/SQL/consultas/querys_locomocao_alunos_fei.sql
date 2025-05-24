-- ========================================================
-- 1ª CONSULTA
-- Enunciado:
--   Listar todos os alunos que fizeram trajetos, exibindo nome, tipo de transporte e município,
--   filtrando apenas quem usa “Ônibus” e ordenando por nome do aluno.
-- Relevância:
--   Permite saber quais alunos dependem de um modal específico (“Ônibus”) e em que município,
--   facilitando ações de melhoria ou negociação de convênios com transportadoras.
-- ========================================================
SELECT 
  a.nome,
  t.tipo        AS transporte,
  t.municipio
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
JOIN transportes AS t 
  ON tr.transportes_id = t.id_transportes
WHERE t.tipo = 'Ônibus'
ORDER BY a.nome;


-- ========================================================
-- 2ª CONSULTA
-- Enunciado:
--   Para cada aluno, calcular o número de trajetos realizados e o total gasto em transporte,
--   no período de 1 a 7 de maio de 2025.
-- Relevância:
--   Ajuda a comparar o volume de uso (quantidade de viagens) com o impacto financeiro (gastos),
--   identificando perfis de maior demanda e custo.
-- ========================================================
SELECT
  a.nome,
  COUNT(tr.id_trajetos)      AS total_trajetos,
  SUM(gd.valor_total)        AS gasto_total,
  AVG(gd.valor_total)        AS gasto_medio_diario
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
JOIN gastos_diarios AS gd 
  ON a.id_alunos = gd.alunos_id
WHERE gd.data_gasto BETWEEN '2025-05-01' AND '2025-05-07'
GROUP BY a.id_alunos, a.nome;


-- ========================================================
-- 3ª CONSULTA
-- Enunciado:
--   Identificar alunos que fizeram trajetos em horários de pico (nível ≥ 4) e cujo gasto diário
--   em 2 de maio de 2025 superou a média de gastos de todos os alunos naquele dia.
-- Relevância:
--   Combina análise de demanda (horários críticos) com impacto financeiro, permitindo priorizar
--   estudantes que mais sofrem em condições adversas de tráfego e custo.
-- ========================================================
SELECT
  a.nome,
  gd.valor_total       AS gasto_no_dia,
  t.nivel              AS nivel_trafego
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
