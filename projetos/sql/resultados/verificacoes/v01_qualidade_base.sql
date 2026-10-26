-- v01. Qualidade e cobertura da base: universo, NI, PL não positivo, crédito zero, agências zero, datas
SELECT
    COUNT(*)                                                         AS "instituicoes",
    COUNT(*) FILTER (WHERE f.ativo_total IS NULL)                    AS "com_ni",
    COUNT(*) FILTER (WHERE f.ativo_total IS NOT NULL)                AS "com_dados",
    COUNT(*) FILTER (WHERE f.patrimonio_liquido <= 0)                AS "pl_nao_positivo",
    COUNT(*) FILTER (WHERE f.patrimonio_liquido > 0)                 AS "pl_positivo",
    COUNT(*) FILTER (WHERE f.carteira_credito = 0)                   AS "credito_zero",
    COUNT(*) FILTER (WHERE e.num_agencias = 0)                       AS "agencias_zero",
    COUNT(*) FILTER (WHERE e.num_agencias = 0 AND i.tcb NOT IN ('b3S','b3C')) AS "agencias_zero_fora_cooperativas",
    COUNT(DISTINCT f.data_ref)                                       AS "datas_base_distintas",
    MIN(f.data_ref)                                                  AS "data_ref"
FROM instituicoes i
JOIN financeiros f ON f.inst_id = i.id
JOIN estrutura  e ON e.inst_id = i.id;
