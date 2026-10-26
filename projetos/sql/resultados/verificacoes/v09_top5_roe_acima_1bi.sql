-- v09. Cinco maiores ROE do semestre entre instituições com ativo > R$ 1 bi (1.000.000 em R$ mil)
SELECT i.nome, i.tcb, f.ativo_total,
       ROUND(100 * f.lucro_liquido::NUMERIC / f.patrimonio_liquido, 2) AS "roe_pct"
FROM instituicoes i JOIN financeiros f ON f.inst_id = i.id
WHERE f.patrimonio_liquido > 0 AND f.ativo_total > 1000000
ORDER BY f.lucro_liquido::NUMERIC / f.patrimonio_liquido DESC
LIMIT 5;
