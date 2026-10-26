-- v05. Concentração do ativo: HHI e participação dos 5 maiores, por instituição individual
--      e agrupando pelo conglomerado prudencial (instituição sem conglomerado conta sozinha).
--      Agrupar NÃO elimina a dupla contagem holding/controlada; só a realoca dentro do grupo.
WITH ind AS (
    SELECT i.id::TEXT AS chave, f.ativo_total::NUMERIC AS at
    FROM instituicoes i JOIN financeiros f ON f.inst_id = i.id
    WHERE f.ativo_total IS NOT NULL
), grp AS (
    SELECT COALESCE(i.cod_conglomerado_prudencial, 'IND' || i.id) AS chave, SUM(f.ativo_total)::NUMERIC AS at
    FROM instituicoes i JOIN financeiros f ON f.inst_id = i.id
    WHERE f.ativo_total IS NOT NULL
    GROUP BY 1
), calc AS (
    SELECT 'instituicao_individual' AS nivel, chave, at,
           at / SUM(at) OVER () AS s, ROW_NUMBER() OVER (ORDER BY at DESC) AS pos FROM ind
    UNION ALL
    SELECT 'conglomerado_prudencial', chave, at,
           at / SUM(at) OVER (), ROW_NUMBER() OVER (ORDER BY at DESC) FROM grp
)
SELECT nivel AS "nivel",
       COUNT(*) AS "unidades",
       ROUND(10000 * SUM(s * s)) AS "hhi",
       ROUND(100 * SUM(s) FILTER (WHERE pos <= 5), 1) AS "pct_top5",
       ROUND(100 * SUM(s) FILTER (WHERE pos <= 10), 1) AS "pct_top10"
FROM calc
GROUP BY nivel
ORDER BY nivel DESC;
