SELECT 'instituicoes' AS tabela, COUNT(*) AS registros FROM instituicoes
UNION ALL
SELECT 'financeiros',  COUNT(*) FROM financeiros
UNION ALL
SELECT 'estrutura',    COUNT(*) FROM estrutura
UNION ALL
SELECT 'vw_base_fdata', COUNT(*) FROM vw_base_fdata;

-- Resultado: 1622 em todas as ocorrências (Verificação está correta!)

-- Cálculo do ATIVO TOTAL MÉDIO das instituições da base.

SELECT ROUND(AVG("ativo_total"), 2) as "Ativo Total Médio"
FROM "financeiros";

-- Resultado: 12411045.29

-- Cálculo da MEDIANA do Ativo Total.
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "ativo_total") AS "Ativo Mediano"
FROM "financeiros";

-- Resultado: 293113.0

SELECT
    ((12411045.29 - 293113.0) / 293113.0) * 100 AS "Diferença percentual de ativo";

-- Resultado: 4.134%

SELECT
    "instituicoes"."nome",
    "financeiros"."ativo_total"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
WHERE "financeiros"."ativo_total" IS NOT NULL
ORDER BY "financeiros"."ativo_total" DESC
LIMIT 10;

SELECT
    "instituicoes"."nome",
    "financeiros"."ativo_total"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
WHERE "financeiros"."ativo_total" IS NOT NULL
ORDER BY "financeiros"."ativo_total" ASC
LIMIT 10;

-- Análise: Existem instituições com ativos na casa de bilhões, e esses valores muito altos elevam fortemente a média.

-- Cálculo do MAIOR e do MENOR Ativo Total. Quantas vezes o maior supera o menor?

SELECT MAX("ativo_total") AS "Máximo Ativo"
from "financeiros";

-- Resultado: 2.461.086.914

SELECT MIN("ativo_total") AS "Máximo Ativo"
FROM "financeiros";

-- Resultado: 365

SELECT
    MAX("ativo_total") AS "Máximo Ativo",
    MIN("ativo_total") AS "Mínimo Ativo",
    MAX("ativo_total") / MIN("ativo_total") AS "Vezes Maior"
FROM "financeiros";

-- Resultado: 6.742.703 vezes maior

-- Quais são Q1, Q2 e Q3 da Carteira de Crédito?

SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY "carteira_credito") AS "Q1",
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "carteira_credito") AS "Q2",
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY "carteira_credito") AS "Q3"
FROM "financeiros";

-- Resultado: Q1 (0), Q2 (32.400), Q3 (537.951,5)

-- 25% das observações possuem carteira de crédito igual a zero.
-- 50% das observações possuem carteira de crédito de até R$ 32.400.
-- 75% das observações possuem carteira de crédito de até R$ 537.951,50.
-- 25% maiores valores estão acima de R$ 537.951,50.

-- Qual é o PERCENTIL 90 do Patrimônio Líquido?

SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY "patrimonio_liquido") AS "pl_p90"
FROM "financeiros";

-- Resultado: 1.114.820

-- 90% do patrimônio líquido ≤ R$ 1.114.820
-- 10% do patrimônio líquido > R$ 1.114.820

SELECT
    COUNT(*) AS "Quantidade de Instituições"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
WHERE "financeiros"."patrimonio_liquido" > 1114820;

-- Resultado: 157 instituições possuem patrimônio líquido > R$ 1.114.820

-- Quantas agências existem no total? Qual é a média e a mediana por instituição?

SELECT
    SUM(num_agencias) AS "Total de agências",
    ROUND(AVG(num_agencias), 2) AS "Média_Agências",            
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_agencias) AS "Mediana_Agências"
FROM "estrutura";

-- Resultado: Total de agências: 14.922 / Média_Agências: 9,2 / Mediana_Agências: 1

-- Quantas instituições são de CONTROLE PÚBLICO (tc = 1)?

SELECT COUNT("nome") AS "Qauntidade_Controle_Público"
FROM "instituicoes"
WHERE "tc" = 1;

-- Resultado: 39

-- Quantas instituições são do TCB b1?

SELECT COUNT("nome") AS "Quantidade_TCB_b1"
FROM "instituicoes"
WHERE "tcb" = 'b1';

-- Resultado: 116

-- Qual é a SOMA do Ativo Total das instituições PÚBLICAS?
-- Que percentual do ativo do sistema isso representa?

SELECT SUM("financeiros"."ativo_total") AS "Total de ativos de instituições públicas"
FROM "financeiros"
JOIN "instituicoes" 
ON "instituicoes"."id" = "financeiros"."inst_id"
WHERE "instituicoes"."tc" = 1;

-- Resultado: 6.391.175.337 (32,8%)

-- Qual é a MÉDIA da Carteira de Crédito das instituições PRIVADAS NACIONAIS (tc = 2)?

SELECT SUM("carteira_credito") AS "Média da Cateira de Crédito (Privadas Nacionais)"
FROM "financeiros"
JOIN "instituicoes" ON
"instituicoes"."id" = "financeiros"."inst_id"
WHERE "instituicoes"."tc" = 2;

-- Resultado: 3.260.463.210

-- Quantas instituições com sede em SP têm Lucro Líquido POSITIVO?

SELECT COUNT("nome") AS "Quantidade de Instituições em SP com LL Positivo"
FROM "instituicoes"
JOIN "financeiros" ON
"financeiros"."inst_id" = "instituicoes"."id"
WHERE "financeiros"."lucro_liquido" > 0
AND "instituicoes"."uf" = 'SP';

-- Resultado: 495

-- Qual é a SOMA do Lucro Líquido das instituições de CONTROLE ESTRANGEIRO (tc = 3)?

SELECT SUM("lucro_liquido") AS "Soma do LL de Instituições de Controle Estrangeiro"
FROM "financeiros"
JOIN "instituicoes" ON
"instituicoes"."id" = "financeiros"."inst_id"
WHERE "instituicoes"."tc" = 3;

-- Resultado: 27.091.361

-- Classificação de cada instituição: 'Grande' se o Ativo Total for maior que R$ 100 bilhões (100000000 em R$ mil), senão 'Média/Pequena';
-- sem dado, 'Sem dado'. Quantas são Grandes e qual o percentual do ativo total que representam?

WITH "Porte" AS (
    SELECT
        "financeiros"."ativo_total",
        CASE
            WHEN "financeiros"."ativo_total" IS NULL
                THEN 'Sem dado'
            WHEN "financeiros"."ativo_total" > 100000000
                THEN 'Grande'
            ELSE 'Média/Pequena'
        END AS "Porte"
    FROM "financeiros"
)
SELECT
    "Porte",
    COUNT(*) AS "Quantidade de Instituições",
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS "Percentual"
FROM "Porte"
GROUP BY "Porte"
ORDER BY "Quantidade de Instituições" DESC;

-- Resultado:

-- Grande: 24 (1,48%)
-- Média/Pequena: 1.547 (95,38%)
-- Sem dado: 51 (3,14%)

-- Classificação do ROE do semestre: 'Excelente' se > 7,5%, 'Bom' se > 4%, 'Fraco' se > 0%, 'Prejuízo' se <= 0%. NI e PL <= 0 ficam 'Sem dado'.
-- Quantas instituições há em cada classe?

WITH "ROE" AS (
    SELECT
        CASE WHEN "financeiros"."patrimonio_liquido" > 0
             THEN "financeiros"."lucro_liquido"::NUMERIC / "financeiros"."patrimonio_liquido"
        END AS "ROE"
    FROM "financeiros"
)
SELECT
    CASE
        WHEN "ROE" IS NULL THEN 'Sem dado'
        WHEN "ROE" > 0.075 THEN 'Excelente'
        WHEN "ROE" > 0.04 THEN 'Bom'
        WHEN "ROE" > 0 THEN 'Fraco'
        ELSE 'Prejuízo'
    END AS "classe_roe",
    COUNT(*) AS "qtd"
FROM "ROE"
GROUP BY 1;

-- Resultado: Excelente 458 | Fraco 384 | Prejuízo 367 | Bom 356 | Sem dado 57

-- Qual é o Ativo Total, Patrimônio Líquido e Lucro Líquido do NuBank?

SELECT
    "instituicoes"."nome",
    "financeiros"."ativo_total",
    "financeiros"."patrimonio_liquido",
    "financeiros"."lucro_liquido"
FROM "instituicoes"
JOIN "financeiros" ON
"financeiros"."inst_id" = "instituicoes"."id"
WHERE "instituicoes"."nome" LIKE 'NU FINANCEIRA%';

-- Resultado: Ativo 267.624.695 | Patrimônio 15.018.583 | Lucro 4.194.823

-- Análise comparativa por TCB:
-- qtd. de instituições, soma do Ativo, média da Carteira de Crédito, soma do Lucro e o % de cada TCB nas instituições, no ativo e no lucro.

SELECT
    "instituicoes"."tcb",
    COUNT(*) AS "qtd",
    SUM("financeiros"."ativo_total") AS "ativo_soma",
    ROUND(AVG("financeiros"."carteira_credito"), 2) AS "credito_medio",
    SUM("financeiros"."lucro_liquido") AS "lucro_soma",
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS "pct_instituicoes",
    ROUND(100.0 * SUM("financeiros"."ativo_total") / SUM(SUM("financeiros"."ativo_total")) OVER (), 1) AS "pct_ativo",
    ROUND(100.0 * SUM("financeiros"."lucro_liquido") / SUM(SUM("financeiros"."lucro_liquido")) OVER (), 1) AS "pct_lucro"
FROM "instituicoes"
JOIN "financeiros" ON "financeiros"."inst_id" = "instituicoes"."id"
GROUP BY "instituicoes"."tcb"
ORDER BY "ativo_soma" DESC;

-- Resultado: b1 = 116 inst. | 73,3% do ativo | 52,5% do lucro.

-- Comparação de ROE por tipo de controle:
--     a) média simples dos ROEs individuais
--     b) ROE agregado = SUM(lucro) / SUM(PL)
-- As duas medidas apontam o mesmo grupo como mais rentável?

SELECT
    "tipos_controle"."descricao" AS "tipo_controle",
    ROUND(100 * AVG(
        CASE WHEN "financeiros"."patrimonio_liquido" > 0
             THEN "financeiros"."lucro_liquido"::NUMERIC / "financeiros"."patrimonio_liquido" END
    ), 1) AS "roe_medio_simples_pct",
    ROUND(100.0 * SUM("financeiros"."lucro_liquido") / NULLIF(SUM("financeiros"."patrimonio_liquido"), 0), 1) AS "roe_agregado_pct"
FROM "instituicoes"
JOIN "financeiros" ON "financeiros"."inst_id" = "instituicoes"."id"
JOIN "tipos_controle" ON "tipos_controle"."tc" = "instituicoes"."tc"
GROUP BY "tipos_controle"."tc", "tipos_controle"."descricao"
ORDER BY "tipos_controle"."tc";

-- Resultado: Público           8,0 | 5,3
--            Privado Nacional  1,4 | 8,5
--            Estrangeiro      -3,4 | 7,7
-- A média simples dá o mesmo peso a uma cooperativa minúscula e a um grande banco; o ROE agregado pondera pelo capital. Por isso os rankings se invertem.

-- Cálculo da participação de cada tipo de controle no Ativo Total e no número de instituições.

SELECT
    "tipos_controle"."descricao" AS "tipo_controle",
    COUNT(*) AS "qtd",
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS "pct_instituicoes",
    SUM("financeiros"."ativo_total") AS "ativo_soma",
    ROUND(100.0 * SUM("financeiros"."ativo_total") / SUM(SUM("financeiros"."ativo_total")) OVER (), 1) AS "pct_ativo"
FROM "instituicoes"
JOIN "financeiros" ON "financeiros"."inst_id" = "instituicoes"."id"
JOIN "tipos_controle" ON "tipos_controle"."tc" = "instituicoes"."tc"
GROUP BY "tipos_controle"."tc", "tipos_controle"."descricao"
ORDER BY "tipos_controle"."tc";

-- Resultado: Público 39 (2,4%) | 32,8% do ativo
--           Privado Nacional 1353 (83,4%) | 50,1% do ativo
--           Estrangeiro 230 (14,2%) | 17,2% do ativo

-- As 5 instituições com MAIOR ROE do semestre:
--    a) em toda a base
--    b) só entre as que têm Ativo Total acima de R$ 1 bilhão (1000000)

-- a)

SELECT
    "instituicoes"."nome",
    ROUND(
        100.0 * "financeiros"."lucro_liquido"::NUMERIC
        / "financeiros"."patrimonio_liquido",
        2
    ) AS "ROE_pct"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
WHERE "financeiros"."patrimonio_liquido" > 0
    AND "financeiros"."lucro_liquido" IS NOT NULL
ORDER BY
    "financeiros"."lucro_liquido"::NUMERIC
    / "financeiros"."patrimonio_liquido" DESC
LIMIT 5;

-- Resultado: GREENPASS (168,5%), BOC BRASIL (147,1%), CAIXA DTVM (90,7%),
--            BB GESTÃO DE RECURSOS DTVM (87,1%), EFEX IP (82,1%)

-- b)

SELECT
    "instituicoes"."nome",
    ROUND(
        100.0 * "financeiros"."lucro_liquido"::NUMERIC
        / "financeiros"."patrimonio_liquido",
        2
    ) AS "ROE_pct"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
WHERE "financeiros"."patrimonio_liquido" > 0
    AND "financeiros"."lucro_liquido" IS NOT NULL
    AND "financeiros"."ativo_total" > 1000000
ORDER BY
    "financeiros"."lucro_liquido"::NUMERIC
    / "financeiros"."patrimonio_liquido" DESC
LIMIT 5;

-- Resultado: BB GESTÃO DE RECURSOS DTVM (87,1%), CITIBANK DTVM (63,3%),
--            DAYCOVAL LEASING (56,0%), BTG PACTUAL SERVIÇOS FINANCEIROS DTVM (46,9%),
--            CLOUDWALK FINANCEIRA (44,5%)

-- Índice de Alavancagem (Passivo Exigível / PL) das instituições com PL > 0.
-- Quantas entram no cálculo? Qual a mediana?
-- Quem tem a maior alavancagem?

WITH "alav" AS (
    SELECT
        "instituicoes"."nome",
        "instituicoes"."tcb",
        "financeiros"."passivo_exigivel"::NUMERIC
            / "financeiros"."patrimonio_liquido" AS "alavancagem"
    FROM "instituicoes"
    JOIN "financeiros"
        ON "financeiros"."inst_id" = "instituicoes"."id"
    WHERE "financeiros"."patrimonio_liquido" > 0
)
SELECT
    COUNT(*) AS "qtd_calculadas",
    ROUND(
        PERCENTILE_CONT(0.5)
            WITHIN GROUP (ORDER BY "alav"."alavancagem")::NUMERIC,
        2
    ) AS "mediana",
    ROUND(MAX("alav"."alavancagem"), 1) AS "maior",
    (
        SELECT "alav"."nome"
        FROM "alav"
        ORDER BY "alav"."alavancagem" DESC
        LIMIT 1
    ) AS "mais_alavancada"
FROM "alav";

-- Resultado: 1565 | 3.55 | 505.2 | BANCO DIGIO S.A. (TCB b2)

-- Instituições (com PL > 0) têm Carteira de Crédito igual ou maior que 10 vezes o PL?
-- Em quais TCBs elas se concentram?

SELECT
    "instituicoes"."tcb",
    COUNT(*) AS "qtd"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
WHERE "financeiros"."patrimonio_liquido" > 0
  AND "financeiros"."carteira_credito" >= 10 * "financeiros"."patrimonio_liquido"
GROUP BY ("instituicoes"."tcb")
ORDER BY "qtd" DESC;

-- Resultado: b1 11 | n1 5 | n4 3 | b2 2

-- Quantas instituições com sede em SP têm Ativo Total acima de R$ 1 bilhão?
-- Quantas há no país? Qual o percentual de SP?

SELECT
    COUNT(*) FILTER (WHERE "instituicoes"."uf" = 'SP') AS "sp_acima_1bi",
    COUNT(*) AS "brasil_acima_1bi",
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE "instituicoes"."uf" = 'SP') / COUNT(*),
        1
    ) AS "pct_sp"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
WHERE "financeiros"."ativo_total" > 1000000;

-- Resultado: 207 | 511 | 40.5

-- Cálculo da soma do Ativo Total das instituições SEM AGÊNCIAS FÍSICAS.
-- Que parcela do ativo do sistema isso representa? Em quais TCBs estão?

SELECT
    "instituicoes"."tcb",
    COUNT(*) AS "qtd_sem_agencia",
    SUM("financeiros"."ativo_total") AS "ativo_soma",
    ROUND(
        100.0 * SUM("financeiros"."ativo_total")
        / (
            SELECT SUM("financeiros"."ativo_total")
            FROM "financeiros"
        ),
        1
    ) AS "pct_ativo_sistema"
FROM "instituicoes"
JOIN "financeiros"
    ON "financeiros"."inst_id" = "instituicoes"."id"
JOIN "estrutura"
    ON "estrutura"."inst_id" = "instituicoes"."id"
  WHERE "estrutura"."num_agencias" = 0
GROUP by ROLLUP ("instituicoes"."tcb")
ORDER BY "qtd_sem_agencia" DESC;

-- Resultado: 
              -- tcb   qtd_sem_agencia   ativo_soma               pct_ativo_sistema
              -- NULL  756               1.246.899.112            6,4
              -- b3S   729               992.158.870              5,1
              -- b3C   27                254.740.242              1,3

-- Quantas instituições de cada UF estão na base, e que percentual do total cada UF representa?

SELECT
    "instituicoes"."uf",
    COUNT(*) AS "qtd",
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS "pct"
FROM "instituicoes"
GROUP BY "instituicoes"."uf"
ORDER BY "qtd" DESC;

-- Esperado: SP 684 (42,2%) | MG 210 (12,9%) | RS 145 (8,9%)
--           PR 121 (7,5%)  | SC 118 (7,3%)  | demais 344 (21,2%)

-- __________________________________________________________________
-- ANÁLISE FINAL
-- __________________________________________________________________

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
