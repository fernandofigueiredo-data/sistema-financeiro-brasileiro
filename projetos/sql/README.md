# Consultas SQL — Sistema Financeiro Brasileiro (IF.data, junho/2026)

## Resumo

Este projeto usa seis consultas SQL (PostgreSQL) sobre a base FData, extraída do IF.data do Banco Central do Brasil, para descrever o tamanho, a concentração, a composição por tipo de controle e de instituição, a estrutura física e a rentabilidade do sistema financeiro na data-base de junho de 2026. Para cada consulta, o README diz o que ela responde, o resultado principal e como eu o leio, com as ressalvas que encontrei ao conferir se a consulta mede o que o título promete. Depois vêm a pergunta central que estes dados respondem melhor e as limitações da base.

Todos os números citados vêm de um CSV salvo em [resultados/](resultados/). Os arquivos `q1` a `q6` são as seis consultas originais, sem alteração. Os arquivos em [resultados/verificacoes/](resultados/verificacoes/) (`v01` a `v12`) são consultas de conferência que escrevi para testar as ressalvas; o SQL de cada uma está ao lado do CSV. As marcações **[fato]**, **[inferência]**, **[hipótese]** e **[opinião]** aparecem onde a diferença muda a conclusão.

## Objetivos

- Modelar a base IF.data em tabelas relacionais (`instituicoes`, `financeiros`, `estrutura` e tabelas de domínio)
- Praticar SELECT, GROUP BY, JOIN, subconsultas, CTEs (WITH) e window functions
- Calcular indicadores financeiros diretamente em SQL (concentração, ROE, crédito/ativo)
- Conferir cada resultado contra a planilha e documentar as ressalvas

## Principais resultados

- As 5 maiores instituições concentram **52,1%** do ativo do sistema (R$ 19,5 tri); as 100 maiores, **90,8%** ([q2](resultados/q2_concentracao_acumulada.csv))
- Por conglomerado prudencial, as 5 maiores chegam a **58,0%** e o HHI sobe de 637 para 776 ([v05](resultados/verificacoes/v05_concentracao_hhi_conglomerado.csv))
- As **39 instituições públicas** têm **32,8%** do ativo, e 30,3% estão em só três balanços: BB, Caixa e BNDES ([q3](resultados/q3_concentracao_tipo_controle.csv), [v11](resultados/verificacoes/v11_razoes_derivadas.csv))
- O ROE agregado do semestre é **7,52%**, mas a média simples dos ROEs é **0,84%**: muitas instituições pequenas puxam a média para baixo ([v02](resultados/verificacoes/v02_roe_sistema_variantes.csv))
- As **756 instituições sem agência** são todas cooperativas (729 singulares e 27 centrais): "sem agência" não significa "digital" ([v07](resultados/verificacoes/v07_sem_agencia_por_tcb.csv))

## Arquivos

| Arquivo | Descrição |
|---|---|
| [`M4_IFdata_Pratica.sql`](M4_IFdata_Pratica.sql) | Setup das tabelas, carga das 1.622 instituições, exemplos, exercícios, gabarito e análise final |
| [`M4_IFdata_Migracao_View.sql`](M4_IFdata_Migracao_View.sql) | Cria a view `vw_base_fdata` só com as colunas do dataset original |
| [`consultas/q1_a_q6_analise_sistema_bancario.sql`](consultas/q1_a_q6_analise_sistema_bancario.sql) | As seis consultas de análise documentadas neste README |
| [`consultas/analises_exploratorias.sql`](consultas/analises_exploratorias.sql) | Consultas exploratórias feitas durante os exercícios, com os resultados comentados |
| [`dados/`](dados/) | Dados de cada tabela exportados do Supabase (um arquivo `INSERT` por tabela) |
| [`resultados/`](resultados/) | Resultado de cada consulta em CSV (`q1` a `q6`) |
| [`resultados/verificacoes/`](resultados/verificacoes/) | Consultas de conferência `v01` a `v12`: SQL e CSV lado a lado |

## Como executar

1. Crie um banco PostgreSQL 15+ (local ou gratuito no [Supabase](https://supabase.com)) e conecte pelo [DBeaver Community](https://dbeaver.io) ou pelo `psql`
2. Abra `M4_IFdata_Pratica.sql` e execute bloco a bloco:
   - Parte 1: criação das tabelas e da view
   - Parte 2: inserção dos dados
   - Parte 3: verificação (1.622 linhas em cada tabela)
   - Partes 4 a 7: exemplos, exercícios, gabarito e análise final
3. Rode `M4_IFdata_Migracao_View.sql` para deixar a view só com as colunas originais
4. Execute `consultas/q1_a_q6_analise_sistema_bancario.sql` e compare com os CSVs em `resultados/`

## Tecnologias

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=flat&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-025E8C?style=flat)

- PostgreSQL 15+ (Supabase e PostgreSQL 18 local)
- DBeaver Community
- Conceitos: DDL, DML, JOINs, GROUP BY, HAVING, CTEs, window functions, PERCENTILE_CONT

## Como os resultados foram gerados

O banco original fica num projeto Supabase. Para gerar os resultados, recriei o banco num PostgreSQL 18 local: as tabelas vieram do bloco de criação de [`M4_IFdata_Pratica.sql`](M4_IFdata_Pratica.sql), os dados vieram dos arquivos em [dados/](dados/), e a view `vw_base_fdata` veio de [`M4_IFdata_Migracao_View.sql`](M4_IFdata_Migracao_View.sql). A carga bate com o esperado pelo material: 1.622 linhas em `instituicoes`, `financeiros`, `estrutura` e na view, 51 instituições sem valores monetários e uma única data-base ([v01](resultados/verificacoes/v01_qualidade_base.csv)). As somas por tipo de controle diferem da aba Totais_Fonte do Excel em no máximo 16 (R$ mil), o que é compatível com arredondamento na fonte ([v12](resultados/verificacoes/v12_conferencia_totais_fonte_excel.csv)). O Excel foi lido a partir de uma cópia, e o arquivo original não foi alterado.

As seis consultas documentadas abaixo estão em [`consultas/q1_a_q6_analise_sistema_bancario.sql`](consultas/q1_a_q6_analise_sistema_bancario.sql).

## A base em poucas linhas

Cada linha de `instituicoes` é uma instituição individual (chave `id`; `codigo` é a raiz do CNPJ, única). `financeiros` e `estrutura` têm uma linha por instituição e data-base (chave única `inst_id, data_ref`), e só existe a data 2026-06-01, que representa a posição de junho de 2026. Os valores monetários estão em R$ mil, então R$ 1 bilhão aparece como 1.000.000. Os saldos (ativo, crédito, passivo, PL) são de junho de 2026. O lucro líquido é o acumulado do ano até a data-base, ou seja, o primeiro semestre de 2026. As 51 instituições marcadas como "NI" (não informado) na fonte têm todos os valores monetários nulos.

Os códigos estão documentados no Dicionário do Excel e nas tabelas de domínio. `tc` (tipo de controle) vale 1 para Público, 2 para Privado Nacional e 3 para Privado com Controle Estrangeiro. `tcb` (tipo de consolidado bancário) agrupa as instituições em b1 (banco comercial, banco múltiplo com carteira comercial ou caixa econômica), b2 (banco múltiplo sem carteira comercial, banco de investimento ou de câmbio), b3S (cooperativa singular), b3C (central ou confederação de cooperativas), b4 (banco de desenvolvimento), n1 (não bancário de crédito), n2 (não bancário de mercado de capitais) e n4 (instituição de pagamento). `ti` (tipo de instituição) é a classificação detalhada, com 26 códigos. O Dicionário também avisa que holdings e controladas aparecem em linhas separadas, então as somas podem contar o mesmo ativo duas vezes. A documentação não define a data exata dentro do mês, nem o que o campo `num_agencias` conta para instituições sem rede física, nem se o lucro das holdings inclui o resultado das controladas.

## Q1. Visão geral do sistema bancário

**O que responde.** Qual é o tamanho do sistema, quanto ele lucrou no semestre e qual é o porte de uma instituição típica.

**Resultado principal.** A base tem 1.622 instituições, das quais 1.571 têm dados contábeis. Juntas, elas somam ativo de 19.497.752.152 (R$ mil, cerca de R$ 19,5 trilhões), carteira de crédito de 7.386.168.497 e lucro semestral de 153.467.178, com ROE agregado de 7,52% no semestre. O ativo médio (12.411.045) é 42,3 vezes o mediano (293.113), e a carteira de crédito mediana é de 32.400 ([q1](resultados/q1_visao_geral_sistema.csv), [v11](resultados/verificacoes/v11_razoes_derivadas.csv)).

**Leitura e ressalvas.** A distância entre média e mediana é o primeiro sinal de que o sistema é formado por poucos gigantes e muitas instituições pequenas **[fato]**. Por isso a média de ativo descreve quase ninguém **[inferência]**. O rótulo `total_instituicoes` conta as 51 instituições sem dados, enquanto somas, média e medianas usam apenas as 1.571 com dados. Os dois universos são diferentes e precisam ser lidos juntos. O ROE de 7,52% usa lucro de seis meses e não pode ser comparado a referências anuais. Anualizado por composição, ele chegaria a 15,61% ([v02](resultados/verificacoes/v02_roe_sistema_variantes.csv)), mas isso pressupõe um segundo semestre igual ao primeiro **[hipótese]**. O denominador inclui 6 instituições com PL negativo, e retirá-las mantém os mesmos 7,52% ([v02](resultados/verificacoes/v02_roe_sistema_variantes.csv)). Todas as somas carregam dupla contagem entre holdings e controladas: o Itaú Unibanco Holding (ativo de 493.183.395) aparece ao lado do Itaú Unibanco S.A. (2.169.409.565) ([q6](resultados/q6_ranking_roe.csv)). A mediana do crédito também é puxada para baixo pelas 443 instituições com carteira igual a zero ([v01](resultados/verificacoes/v01_qualidade_base.csv)), como corretoras, distribuidoras e boa parte das instituições de pagamento.

## Q2. Concentração: participação acumulada das maiores instituições

**O que responde.** Que fatia do ativo do sistema está nas 1, 5, 10, 20, 50 e 100 maiores instituições.

**Resultado principal.** O Banco do Brasil sozinho tem 12,6% do ativo. As 5 maiores instituições somam 52,1%, as 10 maiores 66,6%, as 20 maiores 75,5% e as 100 maiores 90,8% ([q2](resultados/q2_concentracao_acumulada.csv)). Isso deixa menos de 10% do ativo para as outras 1.471 instituições com dados.

**Leitura e ressalvas.** A concentração no topo é alta e é o resultado mais robusto do conjunto **[fato]**. A consulta trabalha com instituições individuais, e isso corta os grupos econômicos ao meio: o Itaú aparece em mais de uma linha, holding e banco separados. Agrupando pelo conglomerado prudencial, as 5 maiores passam a 58,0% e as 10 maiores a 73,6%, e o índice HHI sobe de 637 para 776 ([v05](resultados/verificacoes/v05_concentracao_hhi_conglomerado.csv)). O agrupamento, porém, não elimina a dupla contagem, só a coloca dentro do mesmo grupo. Por isso os 58,0% tendem a superestimar a fatia consolidada dos grandes grupos **[hipótese]**, e os 52,1% tendem a subestimá-la **[inferência]**. O valor verdadeiro não pode ser calculado com estes dados. Do ponto de vista técnico, a soma acumulada usa a moldura padrão `RANGE`, que juntaria instituições com ativo empatado. Não há empates entre as 100 primeiras, então o resultado não é afetado, mas a consulta seria mais segura com `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`. O percentual é calculado sobre as 1.571 instituições com dados.

## Q3. Concentração por tipo de controle

**O que responde.** Como o ativo se divide entre instituições públicas, privadas nacionais e privadas de controle estrangeiro.

**Resultado principal.** As privadas nacionais são 1.353 instituições e têm 50,1% do ativo. As públicas são 39 e têm 32,8%, e as de controle estrangeiro são 230 com 17,2% ([q3](resultados/q3_concentracao_tipo_controle.csv)).

**Leitura e ressalvas.** O peso do setor público é desproporcional ao número de instituições, e quase todo ele está em três balanços: Banco do Brasil, Caixa e BNDES somam 30,3% do ativo do sistema, o que corresponde a 92,4% do ativo público ([v11](resultados/verificacoes/v11_razoes_derivadas.csv)) **[fato]**. Na prática, "setor público" nesta base quer dizer essas três instituições **[inferência]**. A coluna `qtd` usa `COUNT(*)` e inclui as instituições sem dados, enquanto `ativo_soma` e `pct_ativo` usam só as 1.571 com dados. A junção interna com `tipos_controle` não perde linhas, porque todas as instituições têm `tc` válido. A dupla contagem pesa mais nos grupos privados que têm muitas entidades na base, como Itaú (16 instituições) e Bradesco (18) ([v06](resultados/verificacoes/v06_top10_conglomerados.csv)), então a fatia privada nacional pode estar inflada **[hipótese]**. A consulta não mede rentabilidade, mas cruzar o tipo de controle com o ROE mostra como a escolha da medida inverte a ordem dos grupos ([v03](resultados/verificacoes/v03_roe_por_tipo_controle.csv)). Pela média simples, as públicas são as mais rentáveis (7,99%) e as estrangeiras as menos rentáveis (−3,38%). Pelo ROE agregado, a ordem muda: privadas nacionais com 8,53%, estrangeiras com 7,72% e públicas com 5,35%.

## Q4. Perfil por tipo de instituição (TI)

**O que responde.** Quantas instituições existem de cada tipo detalhado, quanto ativo e lucro cada tipo concentra e quanto do ativo vai para crédito.

**Resultado principal.** Os bancos múltiplos (TI 8) são 128 instituições, têm 9.715.530.676 de ativo, ou 49,8% do sistema ([v11](resultados/verificacoes/v11_razoes_derivadas.csv)), e lucraram 93.564.569 no semestre. As cooperativas de crédito são 756 instituições com ativo de 1.246.899.112 ([q4](resultados/q4_perfil_tipo_instituicao.csv)). Três tipos do domínio (31, 3 e 7) aparecem sem instituições por causa do `LEFT JOIN`, que é o comportamento correto para um catálogo.

**Leitura e ressalvas.** A coluna `credito_ativo_medio_pct` é a média simples das razões de cada instituição. Ela responde "como é a instituição típica do tipo", e não "quanto do ativo do tipo está em crédito". As duas leituras divergem bastante ([v04](resultados/verificacoes/v04_credito_ativo_ponderado_ti.csv)): nos bancos comerciais, a média simples é 28,0% e a razão agregada é 57,5%. Nos bancos múltiplos são 42,4% contra 34,3%, nas cooperativas 50,4% contra 43,1% e nas instituições de pagamento 6,0% contra 12,2%. Para descrever o segmento, a razão agregada é a medida adequada **[opinião]**, e o rótulo "médio" deveria dizer qual das duas é. A contagem também inclui instituições sem dados: no caso das cooperativas, 756 no total e 737 com dados. O lucro é semestral, e os bancos de investimento somam prejuízo (−54.903).

## Q5. Estrutura física: agências e postos por TCB

**O que responde.** Como as instituições de cada TCB se distribuem entre "sem agência", "até 10 agências" e "mais de 10 agências", e quanto ativo e quantos postos cada faixa tem.

**Resultado principal.** A faixa "Sem agência" contém apenas cooperativas: 729 singulares (b3S, ativo de 992.158.870 e 9.928 postos) e 27 centrais (b3C, ativo de 254.740.242) ([q5](resultados/q5_estrutura_fisica_tcb.csv)). No b1, as 21 instituições com mais de 10 agências concentram 12.025.723.022 de ativo. Fora das cooperativas, nenhuma instituição registra zero agências, e as 196 instituições de pagamento registram exatamente uma agência cada ([v07](resultados/verificacoes/v07_sem_agencia_por_tcb.csv), [v01](resultados/verificacoes/v01_qualidade_base.csv)).

**Leitura e ressalvas.** O campo `num_agencias` não mede presença física. O Dicionário registra que cooperativas singulares e centrais informam zero agências na fonte **[fato documentado]**, e a rede de atendimento delas aparece como postos. Já instituições sem rede de rua, como a Nu Pagamentos, registram uma agência ([q6](resultados/q6_ranking_roe.csv)), o que sugere que a sede é contada como agência **[hipótese, não documentada]**. Portanto "sem agência" quer dizer "é cooperativa", e não "é digital". O `CASE` mandaria um `num_agencias` nulo para "Mais de 10 agências". Isso não acontece nesta base, porque o campo tem padrão 0 e não há nulos, mas a consulta é frágil. A coluna `qtd` inclui as instituições sem dados, enquanto `ativo_soma` não as inclui.

## Q6. Ranking completo de rentabilidade (ROE), geral e dentro do TCB

**O que responde.** Como as instituições se ordenam pelo retorno sobre o patrimônio no semestre, no sistema todo e dentro de cada TCB.

**Resultado principal.** As 1.565 instituições com PL positivo foram ranqueadas, e o topo é ocupado por pequenas instituições não bancárias: Greenpass (instituição de pagamento, 168,46%, ativo de 420.288) e BOC Brasil (financeira, 147,12%). Os grandes bancos ficam no meio da tabela: Itaú Unibanco S.A. em 205º (12,13%), Santander em 459º (7,48%), Bradesco em 509º (6,89%), Caixa em 651º (5,56%) e Banco do Brasil em 874º (3,43%) ([q6](resultados/q6_ranking_roe.csv)). O último colocado tem ROE de −1.416,34%.

**Leitura e ressalvas.** O ROE individual é tão disperso que sua média simples (0,84%) fica longe da mediana (4,35%) e do ROE agregado (7,52%) ([v02](resultados/verificacoes/v02_roe_sistema_variantes.csv)). Por porte ([v08](resultados/verificacoes/v08_roe_por_porte.csv)), as 24 instituições com ativo acima de R$ 100 bilhões têm ROE agregado de 8,11% e mediana de 7,15%. As 1.054 instituições com até R$ 1 bilhão têm ROE agregado de 5,19% e mediana de 3,28%, e 294 delas tiveram prejuízo ou lucro zero. Mesmo filtrando acima de R$ 1 bilhão, os cinco primeiros são distribuidoras e financeiras, liderados pela BB Gestão de Recursos com 87,13% ([v09](resultados/verificacoes/v09_top5_roe_acima_1bi.csv)). Isso é coerente com negócios que operam com pouco patrimônio próprio, onde um lucro modesto gera ROE alto **[inferência]**. O ROE é semestral e não anualizado. O filtro `patrimonio_liquido > 0` exclui em silêncio 6 instituições, além das 51 sem dados, então o "ranking completo" cobre 1.565 das 1.622. O ranking não ajusta por risco, e o lucro das holdings pode incluir o resultado das controladas **[hipótese]**, o que mistura retorno operacional com retorno sobre participações.

## Conclusão sobre os dados

Considerei três perguntas candidatas. (A) Quão concentrado está o ativo do sistema e em que instituições e tipos de controle essa concentração se apoia? (B) As instituições maiores são mais rentáveis que as menores? (C) O sistema já opera majoritariamente sem rede física de agências? Antes de comparar as três, fixei quatro critérios. O primeiro é que a pergunta possa ser respondida com uma única data-base e sem dados externos. O segundo é que a resposta resista às distorções conhecidas da base: instituições sem dados, dupla contagem entre holdings e controladas, médias simples de razões e lucro semestral. O terceiro é que a resposta seja sustentada por mais de uma das seis consultas. O quarto é que ela seja útil para quem decide ou analisa o setor.

Escolhi a pergunta A, que formulo assim: **quão concentrado está o ativo do sistema financeiro brasileiro em junho de 2026, e em quais instituições e tipos de controle essa concentração se apoia?** Ela cumpre os quatro critérios. A concentração aparece de forma convergente em cinco das seis consultas. Na q2, as 5 maiores instituições têm 52,1% do ativo e as 100 maiores 90,8%. Na q1, o ativo médio é 42,3 vezes o mediano ([v11](resultados/verificacoes/v11_razoes_derivadas.csv)). Na q3, 39 instituições públicas têm 32,8% do ativo, e 30,3% estão em apenas três balanços ([v11](resultados/verificacoes/v11_razoes_derivadas.csv)). Na q4, os bancos múltiplos detêm 49,8% ([v11](resultados/verificacoes/v11_razoes_derivadas.csv)). Na q5, 21 instituições do b1 com mais de 10 agências somam 12.025.723.022 de ativo. A conclusão também resiste à principal distorção: no nível individual as 5 maiores têm 52,1%, e agregando por conglomerado prudencial têm 58,0% ([v05](resultados/verificacoes/v05_concentracao_hhi_conglomerado.csv)). O nível exato muda, mas o fato de mais da metade do ativo estar em cinco unidades não muda **[inferência]**. A pergunta B cumpre o primeiro e o quarto critérios, mas falha no segundo. O ROE é semestral, a dupla contagem infla lucro e patrimônio ao mesmo tempo, e a ordem dos grupos muda conforme a medida. Ainda assim, ela tem evidência a favor: o ROE agregado cai de 8,11% acima de R$ 100 bilhões para 5,19% abaixo de R$ 1 bilhão ([v08](resultados/verificacoes/v08_roe_por_porte.csv)). A pergunta C falha nos dois primeiros critérios, porque não há série temporal e porque "zero agências" é uma convenção de registro das cooperativas.

Há interpretações concorrentes, e apresento a mais forte de cada lado. A favor de um sistema "pouco concentrado", 1.622 instituições existem, as 756 cooperativas são 46,6% delas ([v11](resultados/verificacoes/v11_razoes_derivadas.csv)), e o HHI de 637 a 776 é um número moderado em termos absolutos. Mas a base não traz nenhum limiar de referência para o HHI, e a fragmentação na contagem convive com a concentração no ativo: as cooperativas têm só 6,4% do ativo ([v11](resultados/verificacoes/v11_razoes_derivadas.csv)). A favor de uma concentração "ainda maior que a medida", o argumento é que os grupos econômicos são a unidade relevante e que a visão individual os fragmenta. A fatia de 58,0% por conglomerado sustenta esse argumento, mas, sem balanços consolidados, ela também carrega dupla contagem. Concluo que o ativo está fortemente concentrado em cinco grandes grupos e que o setor público pesa por causa de três instituições **[inferência]**. Uma consequência prática é que médias simples descrevem a pequena instituição típica e não o sistema: o ROE agregado é 7,52% e a média simples é 0,84% ([v02](resultados/verificacoes/v02_roe_sistema_variantes.csv)).

Estes dados não permitem responder se a concentração está aumentando ou diminuindo, se os bancos digitais estão ganhando participação ou se a rentabilidade está melhorando, porque existe uma única data-base. Também não permitem medir a concentração consolidada sem dupla contagem, já que faltam balanços por conglomerado. Não permitem saber quantas instituições de fato não têm presença física, porque o campo de agências não mede isso, nem comparar o ROE com referências anuais sem a hipótese de anualização. Por fim, não permitem dizer nada sobre poder de mercado, preços, risco de crédito ou inadimplência, porque não há variáveis de taxa, qualidade da carteira ou clientes.

## Limitações

A base é um retrato de uma única data-base (junho de 2026), então qualquer afirmação sobre tendência fica fora do alcance. As 51 instituições sem valores monetários entram nas contagens das consultas, mas ficam fora das somas, médias e medianas. Por isso, "total do sistema" quer dizer o total das 1.571 instituições com dados, e o valor das 1.622 não pode ser determinado.

O grão é a instituição individual, e o Dicionário avisa que holdings e controladas aparecem em linhas separadas. Assim, ativo, patrimônio e lucro somados contêm dupla contagem de tamanho desconhecido. Agrupar pelo conglomerado prudencial muda a unidade de análise, mas não remove a sobreposição.

O lucro é o acumulado do primeiro semestre. Todo ROE deste projeto é semestral, e a anualização (15,61% para o sistema) depende da hipótese de que o segundo semestre repete o primeiro. As instituições com PL zero ou negativo saem do ranking de ROE sem aviso explícito na consulta.

Três das seis consultas usam médias simples ou contagens que misturam universos diferentes: a q4 com a média de razões, e a q3, q4 e q5 com contagens que incluem as instituições sem dados. Elas são válidas para descrever a instituição típica, mas não o segmento, e os rótulos das colunas não deixam isso claro.

O campo de agências reflete convenções de registro da fonte: as cooperativas informam zero, e as instituições de pagamento informam uma. Ele não mede presença física nem digitalização.

Por fim, o banco foi recriado localmente a partir dos arquivos da pasta [dados/](dados/), e não consultado diretamente no Supabase. A carga foi conferida pelas contagens e pelos totais da aba Totais_Fonte ([v01](resultados/verificacoes/v01_qualidade_base.csv), [v12](resultados/verificacoes/v12_conferencia_totais_fonte_excel.csv)), mas, se o banco remoto tiver sido alterado depois da exportação dos dumps, os resultados podem divergir.

## Fonte dos dados

IF.data — Portal de Dados do Banco Central do Brasil
Junho/2026 — Valores em R$ mil
https://www3.bcb.gov.br/ifdata
