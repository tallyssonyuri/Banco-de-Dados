-- ========================================================
-- Consultas Extras
-- ========================================================

-- 1. Selecionar todos os alunos que utilizam transporte público
SELECT 
  a.nome,
  a.idade,
  t.tipo,
  t.municipio
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos     = tr.alunos_id
JOIN transportes AS t
  ON tr.transportes_id = t.id_transportes;

-- Explicação:
-- Esta query retorna uma lista de alunos (nome e idade) junto com o tipo e município do transporte
-- que utilizam — unindo as tabelas 'alunos', 'trajetos' e 'transportes'.

-- 2. Verificar os gastos totais por aluno em um determinado dia
SELECT 
  a.nome,
  gd.data_gasto      AS data,
  gd.valor_total
FROM alunos AS a
JOIN gastos_diarios AS gd 
  ON a.id_alunos = gd.alunos_id
WHERE gd.data_gasto = '2025-03-07';

-- Explicação:
-- Retorna nome do aluno, data e valor total gasto nesse dia em transporte,
-- consultando 'alunos' e 'gastos_diarios' e filtrando pela data.

-- 3. Listar os alunos e o valor do desconto que recebem em transporte
SELECT
  a.nome,
  t.tipo,
  dt.percentual,
  t.valor * (dt.percentual / 100.0) AS valor_desconto
FROM alunos AS a
JOIN descontos_transportes AS dt 
  ON a.id_alunos = dt.alunos_id
JOIN transportes AS t 
  ON dt.transportes_id = t.id_transportes;

-- Explicação:
-- Exibe alunos, tipo de transporte e percentual de desconto,
-- além de calcular o valor monetário do desconto.

-- 4. Verificar a origem dos alunos que têm um trajeto específico
SELECT
  a.nome,
  oa.local_origem AS origem
FROM alunos AS a
JOIN origens_alunos AS oa 
  ON a.id_alunos = oa.alunos_id
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
WHERE tr.origem = 'Terminal Norte';

-- Explicação:
-- Retorna nome do aluno e seu local de origem quando o trajeto começa em 'Terminal Norte'.

-- 5. Verificar a situação de tráfego em horários específicos
SELECT
  t.horario_registro AS horario,
  t.nivel
FROM trafegos AS t
WHERE t.horario_registro BETWEEN '2025-05-01 06:00:00' AND '2025-05-01 08:00:00';

-- Explicação:
-- Lista registros de tráfego num intervalo de horário definido, usando 'trafegos'.

-- 6. Verificar o tempo estimado de trajeto dos alunos
SELECT
  a.nome,
  tr.origem,
  tr.destino,
  tr.tempo_estimado
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id;

-- Explicação:
-- Exibe duração estimada de cada trajeto por aluno, unindo 'alunos' e 'trajetos'.

-- 7. Selecionar alunos que têm um desconto de 100% em qualquer transporte
SELECT
  a.nome,
  t.tipo,
  dt.percentual
FROM alunos AS a
JOIN descontos_transportes AS dt 
  ON a.id_alunos = dt.alunos_id
JOIN transportes AS t 
  ON dt.transportes_id = t.id_transportes
WHERE dt.percentual = 100;

-- Explicação:
-- Retorna alunos que recebem desconto total, com tipo de transporte e percentual.

-- 8. Encontrar os alunos que têm trajetos com transporte específico
SELECT
  a.nome,
  t.tipo       AS transporte,
  tr.origem,
  tr.destino
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
JOIN transportes AS t 
  ON tr.transportes_id = t.id_transportes
WHERE t.tipo = 'Ônibus';

-- Explicação:
-- Lista alunos, origem e destino dos trajetos que utilizam ‘Ônibus’.

-- 9. Verificar os alunos que moram em 'Casa' e o transporte que utilizam
SELECT
  a.nome,
  oa.local_origem AS local,
  t.tipo
FROM alunos AS a
JOIN origens_alunos AS oa 
  ON a.id_alunos = oa.alunos_id
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
JOIN transportes AS t 
  ON tr.transportes_id = t.id_transportes
WHERE oa.local_origem = 'Casa';

-- Explicação:
-- Retorna alunos cuja origem é 'Casa' e o tipo de transporte usado.

-- 10. Calcular o gasto diário total de todos os alunos em uma data
SELECT
  gd.data_gasto AS data,
  SUM(gd.valor_total) AS gasto_total
FROM gastos_diarios AS gd
WHERE gd.data_gasto = '2025-03-07'
GROUP BY gd.data_gasto;

-- Explicação:
-- Soma os gastos de todos os alunos em um dia específico, agrupando por data.

-- 11. Verificar os horários de tráfego e o nível em que eles ocorrem
SELECT
  t.horario_registro AS horario,
  t.nivel
FROM trafegos AS t
ORDER BY t.horario_registro;

-- Explicação:
-- Retorna todos os registros de tráfego, ordenados por horário.

-- 12. Verificar quais alunos têm trajetos no mesmo horário (overbooking)
SELECT
  a.nome,
  tr.horario_saida,
  COUNT(*) AS numero_trajetos
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
GROUP BY tr.horario_saida, a.nome
HAVING COUNT(*) > 1;

-- Explicação:
-- Identifica horários em que um aluno consta em mais de um trajeto.

-- 13. Calcular o gasto médio diário por aluno
SELECT
  a.nome,
  AVG(gd.valor_total) AS gasto_medio
FROM alunos AS a
JOIN gastos_diarios AS gd 
  ON a.id_alunos = gd.alunos_id
GROUP BY a.id_alunos, a.nome;

-- Explicação:
-- Calcula média diária de gastos por aluno.

-- 14. Encontrar os alunos que utilizam transporte com valor superior a 4,50
SELECT
  a.nome,
  t.tipo,
  t.valor
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
JOIN transportes AS t 
  ON tr.transportes_id = t.id_transportes
WHERE t.valor > 4.50;

-- Explicação:
-- Lista alunos que usam meios de transporte cujo valor é maior que R$4,50.

-- 15. Listar alunos que têm trajetos com o tempo estimado superior a 1 hora
SELECT
  a.nome,
  tr.origem,
  tr.destino,
  tr.tempo_estimado
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
WHERE tr.tempo_estimado > INTERVAL '01:00:00';

-- Explicação:
-- Retorna trajetos cujo tempo estimado excede uma hora.

-- 16. Verificar o tráfego em horários críticos para os alunos
SELECT
  tr.origem,
  tr.destino,
  t.horario_registro AS horario,
  t.nivel
FROM trajetos AS tr
JOIN trafegos AS t 
  ON tr.horario_saida = t.horario_registro
WHERE t.nivel >= 4;

-- Explicação:
-- Lista trajetos que ocorrem em horários com nível de tráfego crítico (≥4).

-- 17. Verificar quais alunos têm trajetos que cruzam em horários de pico (nível = 5)
SELECT
  a.nome,
  tr.origem,
  tr.destino,
  tr.horario_saida
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
JOIN trafegos AS t 
  ON tr.horario_saida = t.horario_registro
WHERE t.nivel = 5;

-- Explicação:
-- Identifica trajetos que coincidem com pico máximo de tráfego.

-- 18. Calcular o valor total dos descontos recebidos por cada aluno
SELECT
  a.nome,
  SUM(t.valor * (dt.percentual / 100.0)) AS total_desconto
FROM alunos AS a
JOIN descontos_transportes AS dt 
  ON a.id_alunos = dt.alunos_id
JOIN transportes AS t 
  ON dt.transportes_id = t.id_transportes
GROUP BY a.id_alunos, a.nome;

-- Explicação:
-- Soma todos os descontos monetários que cada aluno recebeu em transportes.

-- 19. Encontrar os alunos que têm trajetos para a mesma origem e destino
SELECT
  a.nome,
  tr.origem,
  tr.destino,
  COUNT(*) AS numero_trajetos
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
GROUP BY tr.origem, tr.destino, a.nome
HAVING COUNT(*) > 1;

-- Explicação:
-- Verifica origens e destinos repetidos em trajetos de um mesmo aluno.

-- 20. Verificar os alunos que têm trajetos com horários de saída próximos ao pico
SELECT
  a.nome,
  tr.origem,
  tr.destino,
  tr.horario_saida,
  t.horario_registro AS horario_trafego,
  t.nivel
FROM alunos AS a
JOIN trajetos AS tr 
  ON a.id_alunos = tr.alunos_id
JOIN trafegos AS t 
  ON tr.horario_saida = t.horario_registro
WHERE t.nivel >= 4
  AND tr.horario_saida BETWEEN '2025-05-01 06:00:00' AND '2025-05-01 09:00:00';

-- Explicação:
-- Lista trajetos de alunos que coincidem com horários críticos de tráfego (nível ≥4) em um intervalo.

-- 21. Consultar os alunos com maior gasto diário
SELECT
  a.nome,
  MAX(gd.valor_total) AS maior_gasto
FROM alunos AS a
JOIN gastos_diarios AS gd 
  ON a.id_alunos = gd.alunos_id
GROUP BY a.id_alunos, a.nome
ORDER BY maior_gasto DESC
LIMIT 3;

-- Explicação:
-- Retorna os três alunos com maiores despesas em um único dia.

-- 22. Obter a lista de alunos e o valor total gasto por aluno em um período
SELECT
  a.nome,
  SUM(gd.valor_total) AS gasto_total
FROM alunos AS a
JOIN gastos_diarios AS gd 
  ON a.id_alunos = gd.alunos_id
WHERE gd.data_gasto BETWEEN '2025-03-01' AND '2025-03-07'
GROUP BY a.id_alunos, a.nome;

-- Explicação:
-- Soma despesas de cada aluno no período de 1 a 7 de março de 2025.
