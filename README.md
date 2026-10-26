# Análise de Dados completa do Sistema Financeiro Brasileiro - Portfólio

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/fernandofigueiredoalves/)
[![Email](https://img.shields.io/badge/Email-D14836?style=flat&logo=gmail&logoColor=white)](mailto:fernandofigueiredo123@gmail.com)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/fernandofigueiredo-data)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-222222?style=flat&logo=github)](https://fernandofigueiredo-data.github.io/sistema-financeiro-brasileiro)

> Analista de dados com foco em Business Intelligence e Data Storytelling.
> Este portfólio reúne projetos reais construídos com dados públicos do Banco Central do Brasil.

---

## Sobre este portfólio

Trabalhei mais de dez anos com Comunicação e Storytelling antes de ir para a área de dados. Nesse tempo vi muito número bom ser ignorado porque ninguém conseguia dizer o que ele significava. Hoje, utilizando as técnicas em análise de dados, a parte de que mais gosto continua sendo pensar em como comunicar (e mostrar) os números para que virem decisões de negócio.

O relatório de Junho de 2026 do IF.data - Banco Central do Brasil me obrigou a fazer os números baterem de uma ferramenta para outra, e foi nas conferências que apareceram as descobertas de que mais gosto. As 756 instituições “sem agência” não são bancos digitais, são cooperativas que registram zero agências. E a média simples do ROE (0,8% no semestre) conta uma história bem diferente da do sistema como um todo (7,5%).

---

## Projetos

### 📊 Análise Exploratória com Excel — IF.data Banco Central
**Ferramentas:** Excel (fórmulas condicionais, PROCV, ÍNDICE/CORRESP, gráficos)  
**Dados:** IF.data — Junho/2026 — 1.622 instituições financeiras  
**Resultado principal:** o TCB b1 (bancos comerciais e múltiplos) reúne 7,2% das instituições e 73,3% do ativo do sistema  
📁 [Ver projeto](projetos/excel/)

---

### 🗄️ Consultas SQL — IF.data Banco Central
**Ferramentas:** PostgreSQL, DBeaver, Supabase  
**Dados:** IF.data estruturado em 3 tabelas relacionais + tabelas de domínio  
**Resultado principal:** as 5 maiores instituições detêm 52,1% do ativo (58,0% agregando por conglomerado prudencial)  
📁 [Ver projeto](projetos/sql/)

---

### 📈 Dashboard Power BI — IF.data Banco Central
**Ferramentas:** Power BI Desktop, DAX, Power Query  
**Dados:** IF.data — Junho/2026  
**Resultado principal:** R$ 19,5 tri em ativos; a média simples do ROE (0,8%) esconde um ROE agregado de 7,52% no semestre  
📁 [Ver projeto](projetos/powerbi/) | 📄 [Ver dashboard em PDF](projetos/powerbi/M5_Dashboard_IFdata.pdf)

---

### 🐍 Análise Python — IF.data Banco Central com Pandas e Seaborn
**Ferramentas:** Python, Pandas, Matplotlib, Seaborn, SciPy  
**Dados:** IF.data — Junho/2026  
**Resultado principal:** o ativo médio é 42,3 vezes o mediano; as 737 instituições sem agência são cooperativas, não bancos digitais. Inclui estudo de estatística inferencial (IC, teste t de Welch, bootstrap)  
📁 [Ver projeto](projetos/python/)

---

## Stack tecnológica

| Categoria | Ferramentas |
|---|---|
| Linguagens | Python 3.11+, SQL (PostgreSQL) |
| Análise de dados | Pandas, NumPy, SciPy |
| Visualização | Seaborn, Matplotlib, Power BI |
| Planilhas | Excel (fórmulas condicionais, tabelas e gráficos) |
| Versionamento | Git, GitHub |
| Ambiente | VS Code, Jupyter Notebook, DBeaver |

---

## Estrutura do repositório

```
sistema-financeiro-brasileiro/
├── README.md
├── .gitignore
└── projetos/
    ├── excel/      M3 — planilha de análise
    ├── sql/        M4 — modelagem, consultas e resultados em CSV
    ├── powerbi/    M5 — dashboard, medidas DAX e Power Query
    └── python/     M6 — notebook de EDA + estatística inferencial (M2)
```

Padrão de nomes: os arquivos principais de cada projeto levam o número do módulo
(`M3_`, `M4_`, `M5_`, `M6_`, `M2_`) e os demais seguem `snake_case`, sem acentos e sem espaços.

---

## Contato

- 💼 LinkedIn: [linkedin.com/in/fernandofigueiredoalves](https://www.linkedin.com/in/fernandofigueiredoalves/)
- 📧 E-mail: [fernandofigueiredo123@gmail.com](mailto:fernandofigueiredo123@gmail.com)
- 🐙 GitHub: [github.com/fernandofigueiredo-data](https://github.com/fernandofigueiredo-data)
- 🌐 GitHub Pages: [fernandofigueiredo-data.github.io/sistema-financeiro-brasileiro](https://fernandofigueiredo-data.github.io/sistema-financeiro-brasileiro)

---

*Dados: IF.data — Banco Central do Brasil — https://www3.bcb.gov.br/ifdata*
