/*
======================================================================
  MIGRAÇÃO | FData: retirar do schema as colunas criadas na planilha
  Projeto Supabase: FData Junho 2026

  Remove da view vw_base_fdata todas as colunas que não pertencem ao
  dataset original do IF.data:
    U Tipo de Controle | V Índice Crédito/Ativo | W ROE do semestre
    X Porte | Y Classe ROE
  e o campo tipos_controle.rotulo, que existia só para a coluna U.

  Não toca nos dados: as 1.622 linhas de cada tabela continuam iguais.
  Funciona tanto no banco original quanto num banco onde a versão
  anterior desta migração já foi rodada.
  Rode uma única vez, inteiro, no SQL Editor. Se algo falhar, nada é
  alterado (BEGIN/COMMIT).
======================================================================
*/

BEGIN;

DROP VIEW IF EXISTS vw_base_fdata;

ALTER TABLE tipos_controle DROP COLUMN IF EXISTS rotulo;

CREATE VIEW vw_base_fdata AS
SELECT
    i.id,
    i.nome,
    i.codigo,
    i.conglomerado_prudencial,
    i.cod_conglomerado_financeiro,
    i.cod_conglomerado_prudencial,
    i.tcb,
    i.tc,
    i.ti,
    i.cidade,
    i.uf,
    f.data_ref,
    f.ativo_total,
    f.carteira_credito,
    f.tvm,
    f.passivo_exigivel,
    f.captacoes,
    f.patrimonio_liquido,
    f.lucro_liquido,
    e.num_agencias,
    e.num_postos
FROM instituicoes i
JOIN financeiros f ON f.inst_id = i.id
JOIN estrutura e   ON e.inst_id = i.id AND e.data_ref = f.data_ref;

COMMIT;


-- Conferência (rode depois do COMMIT)
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'vw_base_fdata'
ORDER BY ordinal_position;
-- Esperado: 21 colunas, de id até num_postos

SELECT COUNT(*) AS linhas FROM vw_base_fdata;
-- Esperado: 1622
