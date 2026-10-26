-- v04. Crédito/ativo por TI: média simples (como na q4) x razão agregada (ponderada pelo ativo)
SELECT ti.ti, ti.descricao,
       COUNT(i.id) AS "qtd_total",
       COUNT(f.ativo_total) AS "qtd_com_dados",
       ROUND(100 * AVG(f.carteira_credito::NUMERIC / NULLIF(f.ativo_total, 0)), 1) AS "credito_ativo_media_simples_pct",
       ROUND(100 * SUM(f.carteira_credito)::NUMERIC / NULLIF(SUM(f.ativo_total), 0), 1) AS "credito_ativo_agregado_pct"
FROM tipos_instituicao ti
LEFT JOIN instituicoes i ON i.ti = ti.ti
LEFT JOIN financeiros f ON f.inst_id = i.id
GROUP BY ti.ti, ti.descricao
HAVING COUNT(i.id) > 0
ORDER BY SUM(f.ativo_total) DESC NULLS LAST;
