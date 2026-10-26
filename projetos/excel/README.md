# Análise do Sistema Financeiro — Excel

## Resumo

Análise exploratória das 1.622 instituições financeiras brasileiras usando dados reais do
IF.data (Banco Central, junho/2026). A planilha organiza a base com dicionário de dados,
calcula indicadores com fórmulas (ROE, índice crédito/ativo, participação de mercado),
compara os grupos por tipo de consolidado bancário (TCB) e por tipo de controle e
fecha com um template de análise estruturado.

## Objetivos

- Organizar a base IF.data no Excel, com dicionário de dados e conferência contra os totais da fonte
- Calcular indicadores: ROE do semestre, índice crédito/ativo, participação no ativo
- Comparar os grupos por TCB (b1, b2, b3S, b3C, b4, n1, n2, n4) e por tipo de controle
- Comunicar os resultados em um template de análise estruturado

## Principais resultados

- O TCB **b1** (bancos comerciais, múltiplos com carteira comercial e Caixa) reúne **7,2%** das instituições e **73,3%** do ativo do sistema
- As **5 maiores instituições** detêm **52,1%** do ativo; o ativo médio é **42,3 vezes** o mediano
- Pela média simples, o ROE do semestre das públicas é **8,0%** contra **1,4%** das privadas nacionais; pelo ROE agregado (lucro ÷ PL) a ordem se inverte: **5,3%** contra **8,5%**
- As **756 instituições sem agência física** (46,6% da base) são todas cooperativas e somam só **6,4%** do ativo: zero agências não significa banco digital

## Arquivos

| Arquivo | Descrição |
|---|---|
| `M3_IFdata_Exercicios.xlsx` | Base IF.data + dicionário + exercícios resolvidos + gráficos + template de análise |

Abas da planilha:

| Aba | Conteúdo |
|---|---|
| `Base_IFData_Original` | Base como veio da fonte |
| `Base_IFData` | Base com colunas calculadas: tipo de controle, crédito/ativo, ROE do semestre, porte e classe de ROE |
| `Totais_Fonte` | Linhas de totais do arquivo original, conferidas contra as somas da base |
| `Dicionário` | Significado de cada coluna e dos códigos TCB, TC e TI |
| `Análises 1` e `Análises 2` | Exercícios resolvidos: medidas de resumo, contagens e somas condicionais, classificação, comparativos |
| `Tabela_TCB` | Comparativo por tipo de consolidado bancário |
| `Cálculos_Apoio` e `Gráficos_Análise` | Cálculos auxiliares e gráficos |
| `ANÁLISE_FINAL` | Template de análise preenchido: pergunta, indicadores, insight e próximos passos |

## Tecnologias

![Excel](https://img.shields.io/badge/Excel-217346?style=flat&logo=microsoft-excel&logoColor=white)

- Microsoft Excel 365
- Funções: SOMA, MÉDIA, MED, MÁXIMO, MÍNIMO, QUARTIL, PERCENTIL, CONT.SE, CONT.SES, SOMASE, MÉDIASE, SE, SES, ÉNÚM, PROCV, MAIOR, ÍNDICE, CORRESP

## Fonte dos dados

IF.data — Portal de Dados do Banco Central do Brasil  
Junho/2026 — Valores em R$ mil  
https://www3.bcb.gov.br/ifdata
