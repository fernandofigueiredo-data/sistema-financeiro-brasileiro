-- Visão geral do sistema bancário

SELECT
    COUNT(*) AS "total_instituicoes",
    COUNT("financeiros"."ativo_total") AS "com_dados",
    SUM("financeiros"."ativo_total") AS "ativo_total_sistema",
    SUM("financeiros"."carteira_credito") AS "credito_total",
    SUM("financeiros"."lucro_liquido") AS "lucro_total",
    ROUND(
        100.0 * SUM("financeiros"."lucro_liquido")
        / SUM("financeiros"."patrimonio_liquido"),
        2
    ) AS "roe_agregado_pct",
    ROUND(AVG("financeiros"."ativo_total")) AS "ativo_medio",
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY "financeiros"."ativo_total") AS "ativo_mediano",
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY "financeiros"."carteira_credito") AS "credito_mediano"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id";

-- Concentração: participação acumulada das maiores instituições

WITH "ranking" AS (
    SELECT
        "instituicoes"."nome",
        "financeiros"."ativo_total",
        ROW_NUMBER() OVER (
            ORDER BY "financeiros"."ativo_total" DESC
        ) AS "posicao",
        SUM("financeiros"."ativo_total") OVER (
            ORDER BY "financeiros"."ativo_total" DESC
        ) / SUM("financeiros"."ativo_total") OVER () * 100 AS "pct_acumulado"
    FROM "instituicoes"
    JOIN "financeiros"
        ON "financeiros"."inst_id" = "instituicoes"."id"
      WHERE "financeiros"."ativo_total" IS NOT NULL
)
SELECT
    "ranking"."posicao",
    "ranking"."nome",
    "ranking"."ativo_total",
    ROUND("ranking"."pct_acumulado", 1) AS "pct_acumulado"
FROM "ranking"
WHERE "ranking"."posicao" IN (1, 5, 10, 20, 50, 100)
ORDER BY "ranking"."posicao";

-- Concentração por tipo de controle

SELECT
    "instituicoes"."tc",
    "tipos_controle"."descricao" AS "tipo",
    COUNT(*) AS "qtd",
    SUM("financeiros"."ativo_total") AS "ativo_soma",
    ROUND(
        100.0 * SUM("financeiros"."ativo_total")
        / SUM(SUM("financeiros"."ativo_total")) OVER (),
        1
    ) AS "pct_ativo"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
JOIN "tipos_controle"
    ON "tipos_controle"."tc" = "instituicoes"."tc"
GROUP BY "instituicoes"."tc", "tipos_controle"."descricao"
ORDER BY "ativo_soma" DESC;

-- Perfil por tipo de instituição (TI)

SELECT
    "tipos_instituicao"."ti",
    "tipos_instituicao"."descricao",
    COUNT("instituicoes"."id") AS "qtd",
    SUM("financeiros"."ativo_total") AS "ativo_soma",
    ROUND(
        100 * AVG(
            "financeiros"."carteira_credito"::NUMERIC
            / NULLIF("financeiros"."ativo_total", 0)
        ),
        1
    ) AS "credito_ativo_medio_pct",
    SUM("financeiros"."lucro_liquido") AS "lucro_soma"
FROM "tipos_instituicao"
LEFT JOIN "instituicoes"
    ON "instituicoes"."ti" = "tipos_instituicao"."ti"
LEFT JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
GROUP BY "tipos_instituicao"."ti", "tipos_instituicao"."descricao"
ORDER BY "ativo_soma" DESC NULLS LAST;

-- Estrutura física: agências e postos por TCB

SELECT
    "instituicoes"."tcb",
    CASE
        WHEN "estrutura"."num_agencias" = 0 THEN 'Sem agência'
        WHEN "estrutura"."num_agencias" <= 10 THEN 'Até 10 agências'
        ELSE 'Mais de 10 agências'
    END AS "faixa_agencias",
    COUNT(*) AS "qtd",
    SUM("financeiros"."ativo_total") AS "ativo_soma",
    SUM("estrutura"."num_postos") AS "postos"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
JOIN "estrutura"
    ON "estrutura"."inst_id" = "instituicoes"."id"
GROUP BY "instituicoes"."tcb", "faixa_agencias"
ORDER BY "instituicoes"."tcb", "faixa_agencias";

-- Ranking completo de rentabilidade (ROE), geral e dentro do TCB

WITH "roe" AS (
    SELECT
        "vw_base_fdata"."nome",
        "vw_base_fdata"."tcb",
        "vw_base_fdata"."tc",
        "vw_base_fdata"."ativo_total",
        "vw_base_fdata"."num_agencias",
        "vw_base_fdata"."lucro_liquido"::NUMERIC
            / "vw_base_fdata"."patrimonio_liquido" AS "roe"
    FROM "vw_base_fdata"
    WHERE "vw_base_fdata"."patrimonio_liquido" > 0
)
SELECT
    "roe"."nome",
    "roe"."tcb",
    "tipos_controle"."descricao" AS "tipo_controle",
    "roe"."ativo_total",
    ROUND("roe"."roe" * 100, 2) AS "roe_pct",
    "roe"."num_agencias",
    RANK() OVER (ORDER BY "roe"."roe" DESC) AS "posicao_geral",
    RANK() OVER (
        PARTITION BY "roe"."tcb"
        ORDER BY "roe"."roe" DESC
    ) AS "posicao_no_tcb"
FROM "roe"
JOIN "tipos_controle"
    ON "tipos_controle"."tc" = "roe"."tc"
ORDER BY "posicao_geral";
