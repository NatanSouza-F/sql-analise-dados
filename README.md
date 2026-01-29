📊 Análises em SQL Server

🕵️‍♂️ Detecção de Fraudes em Dados Públicos (SQL Server)

📌 O Problema de Negócio
Como Analista de Riscos, o objetivo deste projeto foi auditar uma base pública de repasses governamentais para identificar inconsistências financeiras e padrões suspeitos que indicariam fraudes ou erros operacionais.

**Principais perguntas respondidas:**
* Onde estão os maiores volumes financeiros?
* Existem projetos milionários sem repasse efetivado (anomalia)?
* Quais regiões concentram os maiores riscos?

🛠️ Tecnologias Utilizadas
* **SQL Server & SSMS:** Banco de dados e IDE.
* **ETL (Extract, Transform, Load):** Limpeza de dados brutos (conversão de tipos `VARCHAR` para `DECIMAL`, tratamento de datas `111`).
* **Análise Exploratória:** Agrupamentos (`GROUP BY`), Filtros de Média (`HAVING`) e Ranking (`TOP`).
* **Regras de Negócio:** Criação de faixas de risco com `CASE WHEN`.

## 🚀 Principais Resultados
Através das queries desenvolvidas, foi possível:
1.  **Sanear** uma base de dados com erros de formatação (pt-BR).
2.  **Identificar** automaticamente projetos acima de R$ 1 Milhão classificados como "Grande Porte".
3.  **Isolar** transações suspeitas (Alto Valor de Investimento vs. Repasse Zerado) para auditoria humana.

*Este projeto faz parte do meu portfólio de migração para Análise de Dados, unindo minha experiência em Fraudes com Engenharia de Dados.*
