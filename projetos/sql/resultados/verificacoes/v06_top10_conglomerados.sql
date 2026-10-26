-- v06. Dez maiores conglomerados prudenciais pela soma do ativo das instituições individuais
SELECT COALESCE(i.conglomerado_prudencial, i.nome) AS "grupo",
       COUNT(*) AS "instituicoes_no_grupo",
       SUM(f.ativo_total) AS "ativo_soma",
       ROUND(100.0 * SUM(f.ativo_total) / (SELECT SUM(ativo_total) FROM financeiros), 1) AS "pct_ativo"
FROM instituicoes i JOIN financeiros f ON f.inst_id = i.id
WHERE f.ativo_total IS NOT NULL
GROUP BY COALESCE(i.cod_conglomerado_prudencial, 'IND' || i.id), COALESCE(i.conglomerado_prudencial, i.nome)
ORDER BY SUM(f.ativo_total) DESC
LIMIT 10;
