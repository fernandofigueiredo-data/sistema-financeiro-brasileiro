-- v02. ROE do sistema no semestre por método (lucro acumulado jan-jun/2026, não anualizado)
WITH b AS (
    SELECT f.lucro_liquido::NUMERIC AS ll, f.patrimonio_liquido::NUMERIC AS pl
    FROM financeiros f WHERE f.ativo_total IS NOT NULL
)
SELECT 'agregado_todos_com_dados (= q1)' AS "metodo", COUNT(*) AS "n",
       ROUND(100 * SUM(ll) / SUM(pl), 2) AS "roe_semestre_pct" FROM b
UNION ALL
SELECT 'agregado_so_pl_positivo', COUNT(*), ROUND(100 * SUM(ll) / SUM(pl), 2) FROM b WHERE pl > 0
UNION ALL
SELECT 'media_simples_pl_positivo', COUNT(*), ROUND(100 * AVG(ll / pl), 2) FROM b WHERE pl > 0
UNION ALL
SELECT 'mediana_pl_positivo', COUNT(*),
       ROUND(100 * (PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (ll / pl)::FLOAT8))::NUMERIC, 2) FROM b WHERE pl > 0
UNION ALL
SELECT 'agregado_todos_anualizado_composto ((1+r)^2-1)', COUNT(*),
       ROUND(100 * ((1 + SUM(ll) / SUM(pl)) ^ 2 - 1), 2) FROM b;
