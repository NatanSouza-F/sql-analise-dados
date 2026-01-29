# 📊 Análises em SQL Server  
## 🔎 Detecção de Riscos e Fraudes em Dados Públicos

### 🧠 Contexto do Projeto
Este projeto tem como objetivo aplicar **análise de dados com SQL Server** sobre uma base pública de **repasses governamentais**, simulando cenários reais de **auditoria, risco operacional e prevenção a fraudes**.

A proposta é transformar dados brutos em **informações estratégicas**, apoiando a tomada de decisão baseada em dados (*data-driven*).

---

### 🎯 Problema de Negócio
Como Analista de Riscos, o desafio central foi responder perguntas como:
- Onde estão concentrados os **maiores volumes financeiros**?
- Existem **projetos de alto valor sem repasse efetivado** (anomalias)?
- Quais **regiões e estados** concentram maior exposição a risco financeiro?

---

### 🛠️ Tecnologias Utilizadas
- **SQL Server & SSMS** – Banco de dados e ambiente de desenvolvimento  
- **ETL (Extract, Transform, Load)** – Limpeza e padronização de dados brutos  
  - Conversão de tipos (`VARCHAR` → `DECIMAL`)  
  - Tratamento de datas (padrão `yyyy/mm/dd`)  
- **Análise Exploratória** –  
  - Agrupamentos (`GROUP BY`)  
  - Filtros por média (`HAVING`)  
  - Rankings (`TOP`)  
- **Regras de Negócio** –  
  - Classificação de risco com `CASE WHEN`

---

### 📈 Principais Resultados
A partir das queries desenvolvidas, foi possível:

1. **Sanear** uma base pública com inconsistências de formatação numérica (pt-BR).  
2. **Identificar automaticamente** projetos acima de R$ 1 milhão classificados como *Grande Porte*.  
3. **Isolar transações suspeitas**, como investimentos de alto valor sem repasse efetivado, para análise e auditoria humana.  
4. Criar **rankings regionais** por UF com base em volume total, média de investimento e concentração de risco.

---

### 📌 Estrutura do Projeto
Os scripts SQL estão organizados de forma incremental, refletindo um fluxo analítico real:
- Limpeza e padronização dos dados  
- Análises exploratórias  
- Classificação de risco  
- Criação de *views* para reutilização analítica  

---

### 🚀 Considerações Finais
Este projeto faz parte do meu **portfólio de migração para Análise de Dados**, unindo minha experiência prática em **Prevenção a Fraudes e Riscos** com **engenharia e análise de dados em SQL Server**.

