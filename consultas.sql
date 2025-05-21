-- Problema: Listar alunos que usam Ônibus.
-- Relevância: Otimizar planejamento de rotas mais demandadas.

SELECT a.nome, t.tipo
FROM alunos a
JOIN trajetos tr ON a.id_aluno = tr.id_aluno
JOIN transportes t ON tr.id_transporte = t.id_transporte
WHERE t.tipo = 'Ônibus'
ORDER BY a.nome;


-- Problema: Calcular total de trajetos e gastos por aluno.
-- Relevância: Avaliar uso e custos.

SELECT a.nome, COUNT(tr.id_trajeto) AS total_trajetos, SUM(gd.valor_total) AS total_gasto
FROM alunos a
JOIN trajetos tr ON a.id_aluno = tr.id_aluno
JOIN gastos_diarios gd ON a.id_aluno = gd.id_aluno
GROUP BY a.id_aluno;


-- Problema: Alunos com descontos que também tiveram gastos acima de R$8.
-- Relevância: Identificar perfis de maior subsídio.

SELECT a.nome, SUM(t.valor * (dt.percentual / 100)) AS total_desconto
FROM alunos a
JOIN descontos_transportes dt ON a.id_aluno = dt.id_aluno
JOIN transportes t ON dt.id_transporte = t.id_transporte
WHERE a.id_aluno IN (
    SELECT id_aluno FROM gastos_diarios WHERE valor_total > 8
)
GROUP BY a.id_aluno;


