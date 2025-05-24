-- 1. Selecionar todos os alunos que utilizam transporte público
SELECT a.nome, a.idade, t.tipo, t.municipio
FROM aluno a
JOIN trajeto tr ON a.id_aluno = tr.id_aluno
JOIN transporte t ON tr.id_transporte = t.id_transporte;

-- Explicação:
-- Esta query retorna uma lista de alunos com seu nome, idade, tipo de transporte e município,
-- associando a tabela 'aluno', 'trajeto' e 'transporte'.

-- 2. Verificar os gastos totais por aluno em um determinado dia
SELECT a.nome, gd.data, gd.valor_total
FROM aluno a
JOIN gasto_diario gd ON a.id_aluno = gd.id_aluno
WHERE gd.data = '2025-03-07';

-- Explicação:
-- Retorna o nome do aluno, data e valor gasto no dia '2025-03-07'.
-- Esta consulta ajuda a verificar o gasto diário de cada aluno.

-- 3. Listar os alunos e o valor do desconto que recebem em transporte
SELECT a.nome, t.tipo, dt.percentual, t.valor * (dt.percentual / 100) AS valor_desconto
FROM aluno a
JOIN desconto_transporte dt ON a.id_aluno = dt.id_aluno
JOIN transporte t ON dt.id_transporte = t.id_transporte;

-- Explicação:
-- Esta consulta exibe os alunos, o tipo de transporte e o valor do desconto recebido,
-- baseado no percentual registrado na tabela 'desconto_transporte'.

-- 4. Verificar a origem dos alunos que têm um trajeto específico
SELECT a.nome, oa.local AS origem
FROM aluno a
JOIN origem_aluno oa ON a.id_aluno = oa.id_aluno
JOIN trajeto tr ON a.id_aluno = tr.id_aluno
WHERE tr.origem = 'Terminal Norte';

-- Explicação:
-- Esta consulta retorna os alunos que possuem um trajeto com origem no 'Terminal Norte',
-- mostrando o nome do aluno e o local de origem.

-- 5. Verificar a situação de tráfego em horários específicos
SELECT t.horario, t.nivel
FROM trafego t
WHERE t.horario BETWEEN '06:00:00' AND '08:00:00';

-- Explicação:
-- Esta consulta retorna o nível de tráfego para horários específicos,
-- no intervalo entre '06:00:00' e '08:00:00'. Pode ser útil para avaliar o tráfego
-- durante o horário de pico.

-- 6. Verificar o tempo estimado de trajeto dos alunos
SELECT a.nome, tr.origem, tr.destino, tr.tempo_estimado
FROM aluno a
JOIN trajeto tr ON a.id_aluno = tr.id_aluno;

-- Explicação:
-- Retorna o nome do aluno, origem, destino e o tempo estimado de trajeto,
-- que é útil para avaliar a duração do trajeto de cada aluno.

-- 7. Selecionar alunos que têm um desconto de 100% em qualquer transporte
SELECT a.nome, t.tipo, dt.percentual
FROM aluno a
JOIN desconto_transporte dt ON a.id_aluno = dt.id_aluno
JOIN transporte t ON dt.id_transporte = t.id_transporte
WHERE dt.percentual = 100;

-- Explicação:
-- Esta consulta retorna os alunos que recebem 100% de desconto em algum transporte,
-- juntamente com o tipo de transporte e o percentual de desconto.

-- 8. Encontrar os alunos que têm trajetos com transporte específico
SELECT a.nome, t.tipo AS transporte, tr.origem, tr.destino
FROM aluno a
JOIN trajeto tr ON a.id_aluno = tr.id_aluno
JOIN transporte t ON tr.id_transporte = t.id_transporte
WHERE t.tipo = 'Ônibus';

-- Explicação:
-- Esta consulta retorna os alunos que utilizam 'Ônibus' como meio de transporte,
-- mostrando também a origem e destino dos seus trajetos.

-- 9. Verificar os alunos que moram em 'Casa' e o transporte que utilizam
SELECT a.nome, oa.local, t.tipo
FROM aluno a
JOIN origem_aluno oa ON a.id_aluno = oa.id_aluno
JOIN trajeto tr ON a.id_aluno = tr.id_aluno
JOIN transporte t ON tr.id_transporte = t.id_transporte
WHERE oa.local = 'Casa';

-- Explicação:
-- Essa consulta retorna os alunos que têm como origem 'Casa', com o tipo de transporte
-- que utilizam para o trajeto até o destino.

-- 10. Calcular o gasto diário total de todos os alunos em uma data
SELECT gd.data, SUM(gd.valor_total) AS gasto_total
FROM gasto_diario gd
WHERE gd.data = '2025-03-07'
GROUP BY gd.data;

-- Explicação:
-- Calcula o gasto total de todos os alunos no dia específico, agrupando pela data
-- para obter o total de despesas desse dia.

-- 11. Verificar os horários de tráfego e o nível em que eles ocorrem
SELECT t.horario, t.nivel
FROM trafego t
ORDER BY t.horario;

-- Explicação:
-- Retorna todos os registros de tráfego, ordenados pelo horário, mostrando o nível
-- de tráfego para cada horário registrado.

-- 12. Verificar quais alunos têm trajetos no mesmo horário (possível análise de overbooking)
SELECT a.nome, tr.horario_saida, COUNT(*) AS numero_trajetos
FROM aluno a
JOIN trajeto tr ON a.id_aluno = tr.id_aluno
GROUP BY tr.horario_saida
HAVING COUNT(*) > 1;

-- Explicação:
-- Esta consulta retorna o nome dos alunos e os horários de saída que são compartilhados por mais de um aluno.
-- Isso pode ser útil para identificar horários em que o número de trajetos é alto (possível overbooking).

-- 13. Calcular o gasto médio diário por aluno
SELECT a.nome, AVG(gd.valor_total) AS gasto_medio
FROM aluno a
JOIN gasto_diario gd ON a.id_aluno = gd.id_aluno
GROUP BY a.id_aluno;

-- Explicação:
-- Esta consulta calcula o gasto médio diário de cada aluno, agrupando por aluno. Pode ser útil para analisar os hábitos de consumo de cada aluno.

-- 14. Encontrar os alunos que utilizam transporte com valor superior a 4,50
SELECT a.nome, t.tipo, t.valor
FROM aluno a
JOIN trajeto tr ON a.id_aluno = tr.id_aluno
JOIN transporte t ON tr.id_transporte = t.id_transporte
WHERE t.valor > 4.50;

-- Explicação:
-- Esta consulta retorna os alunos que utilizam transporte cujo valor é superior a 4,50. Pode ser útil para identificar alunos que estão usando transportes mais caros.

-- 15. Listar alunos que têm trajetos com o tempo estimado superior a 1 hora
SELECT a.nome, tr.origem, tr.destino, tr.tempo_estimado
FROM aluno a
JOIN trajeto tr ON a.id_aluno = tr.id_aluno
WHERE tr.tempo_estimado > '01:00:00';

-- Explicação:
-- Esta consulta retorna os alunos que têm trajetos com tempo estimado superior a uma hora, ajudando a identificar trajetos mais longos.

-- 16. Verificar o tráfego em horários críticos para os alunos
SELECT tr.origem, tr.destino, t.horario, t.nivel
FROM trajeto tr
JOIN trafego t ON tr.horario_saida = t.horario
WHERE t.nivel >= 4;

-- Explicação:
-- Esta consulta lista os trajetos de alunos que ocorrem em horários de tráfego com nível de 4 ou mais (horários críticos),
-- considerando o impacto do tráfego nos trajetos.

-- 17. Verificar quais alunos têm trajetos que cruzam em horários de pico (nível de tráfego 5)
SELECT a.nome, tr.origem, tr.destino, tr.horario_saida
FROM aluno a
JOIN trajeto tr ON a.id_aluno = tr.id_aluno
JOIN trafego t ON tr.horario_saida = t.horario
WHERE t.nivel = 5;

-- Explicação:
-- Esta consulta encontra os alunos que têm trajetos com horários coincidentes em que o nível de tráfego é 5 (pico de tráfego),
-- ajudando a verificar os trajetos em horários de maior congestionamento.

-- 18. Calcular o valor total dos descontos recebidos por cada aluno
SELECT a.nome, SUM(t.valor * (dt.percentual / 100)) AS total_desconto
FROM aluno a
JOIN desconto_transporte dt ON a.id_aluno = dt.id_aluno
JOIN transporte t ON dt.id_transporte = t.id_transporte
GROUP BY a.id_aluno;

-- Explicação:
-- Esta consulta retorna o valor total dos descontos que cada aluno recebe em transportes,
-- agrupado por aluno. Pode ser útil para calcular o impacto financeiro dos descontos.

-- 19. Encontrar os alunos que têm trajetos para a mesma origem e destino
SELECT a.nome, tr.origem, tr.destino, COUNT(*) AS numero_trajetos
FROM aluno a
JOIN trajeto tr ON a.id_aluno = tr.id_aluno
GROUP BY tr.origem, tr.destino
HAVING COUNT(*) > 1;

-- Explicação:
-- Esta consulta retorna os trajetos com origem e destino compartilhados por mais de um aluno, o que pode ser útil para análise de tráfego e demanda por certos trajetos.

-- 20. Verificar os alunos que têm trajetos com horários de saída próximos ao horário de pico de tráfego
SELECT a.nome, tr.origem, tr.destino, tr.horario_saida, t.horario AS horario_trafego, t.nivel
FROM aluno a
JOIN trajeto tr ON a.id_aluno = tr.id_aluno
JOIN trafego t ON tr.horario_saida = t.horario
WHERE t.nivel >= 4 AND (tr.horario_saida BETWEEN '06:00:00' AND '09:00:00');

-- Explicação:
-- Esta consulta encontra os alunos cujos trajetos coincidem com horários de tráfego mais intenso (nível 4 ou 5),
-- no intervalo de horários críticos entre 06:00:00 e 09:00:00.

-- 21. Consultar os alunos com maior gasto diário
SELECT a.nome, MAX(gd.valor_total) AS maior_gasto
FROM aluno a
JOIN gasto_diario gd ON a.id_aluno = gd.id_aluno
GROUP BY a.id_aluno
ORDER BY maior_gasto DESC
LIMIT 3;

-- Explicação:
-- Esta consulta retorna os três alunos que tiveram o maior gasto diário em todas as datas registradas.
-- O uso de `LIMIT 3` limita o resultado aos 3 maiores valores.

-- 22. Obter a lista de alunos e o valor total gasto por aluno em um determinado período de tempo
SELECT a.nome, SUM(gd.valor_total) AS gasto_total
FROM aluno a
JOIN gasto_diario gd ON a.id_aluno = gd.id_aluno
WHERE gd.data BETWEEN '2025-03-01' AND '2025-03-07'
GROUP BY a.id_aluno;

-- Explicação:
-- Esta consulta retorna o valor total gasto por cada aluno no período de '2025-03-01' a '2025-03-07', agrupando pelos alunos.