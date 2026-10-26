-- v03. ROE do semestre por tipo de controle: média simples x agregado (só PL > 0)
SELECT i.tc, tc.descricao AS "tipo",
       COUNT(*) AS "n_pl_positivo",
       ROUND(100 * AVG(f.lucro_liquido::NUMERIC / f.patrimonio_liquido), 2) AS "roe_media_simples_pct",
       ROUND(100 * SUM(f.lucro_liquido)::NUMERIC / SUM(f.patrimonio_liquido), 2) AS "roe_agregado_pct",
       SUM(f.lucro_liquido) AS "lucro_soma",
       SUM(f.patrimonio_liquido) AS "pl_soma"
FROM instituicoes i
JOIN financeiros f ON f.inst_id = i.id
JOIN tipos_controle tc ON tc.tc = i.tc
WHERE f.patrimonio_liquido > 0
GROUP BY i.tc, tc.descricao
ORDER BY i.tc;
