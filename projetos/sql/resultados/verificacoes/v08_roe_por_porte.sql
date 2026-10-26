-- v08. ROE do semestre por faixa de porte (ativo em R$ mil; só PL > 0)
SELECT CASE WHEN f.ativo_total > 100000000 THEN '1. > R$ 100 bi'
            WHEN f.ativo_total > 1000000   THEN '2. R$ 1 bi a R$ 100 bi'
            ELSE '3. até R$ 1 bi' END AS "faixa_porte",
       COUNT(*) AS "n",
       ROUND(100.0 * SUM(f.ativo_total) / SUM(SUM(f.ativo_total)) OVER (), 1) AS "pct_ativo_pl_positivo",
       ROUND(100 * AVG(f.lucro_liquido::NUMERIC / f.patrimonio_liquido), 2) AS "roe_media_simples_pct",
       ROUND(100 * (PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY f.lucro_liquido::FLOAT8 / f.patrimonio_liquido))::NUMERIC, 2) AS "roe_mediana_pct",
       ROUND(100 * SUM(f.lucro_liquido)::NUMERIC / SUM(f.patrimonio_liquido), 2) AS "roe_agregado_pct",
       COUNT(*) FILTER (WHERE f.lucro_liquido <= 0) AS "n_prejuizo_ou_zero"
FROM financeiros f
WHERE f.patrimonio_liquido > 0
GROUP BY 1
ORDER BY 1;
