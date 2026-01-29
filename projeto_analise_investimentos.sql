/*
PROJETO: Análise de Dados Públicos - Investimentos do Governo
AUTOR: Natan Souza
DATA: Janeiro/2026
FERRAMENTA: SQL Server

DESCRIÇÃO:
Este script realiza o processo completo de ETL (Extração, Transformação e Carga)
de uma base de dados pública, tratando erros de formatação (pt-BR),
convertendo tipos de dados e gerando relatórios gerenciais e de auditoria.
*/

-- =================================================================
-- 1. ETL E LIMPEZA DE DADOS
-- =================================================================

-- Verifica se a tabela já existe para evitar duplicidade
IF OBJECT_ID('Investimentos_Limpos', 'U') IS NOT NULL
DROP TABLE Investimentos_Limpos;

-- Criação da tabela saneada (Limpeza de R$, Datas e Texto)
SELECT 
    cod_proposta,
    txt_municipio,
    txt_uf,
    txt_objeto,
    -- Tratamento de moeda: Remove ponto de milhar, troca vírgula por ponto
    CAST(REPLACE(REPLACE(vlr_investimento, '.', ''), ',', '.') AS DECIMAL(18,2)) AS Valor_Investimento,
    CAST(REPLACE(REPLACE(vlr_repasse, '.', ''), ',', '.') AS DECIMAL(18,2)) AS Valor_Repasse,
    -- Tratamento de data: Pega apenas os 10 primeiros caracteres e converte
    TRY_CONVERT(DATE, LEFT(dte_carga, 10), 111) AS Data_Carga
INTO Investimentos_Limpos
FROM carteira_investimento_mcid;

GO -- Separação de lote para execução

-- =================================================================
-- 2. CRIAÇÃO DE VIEWS (Automação)
-- =================================================================

-- View para Ranking dos Estados (Tabela Virtual)
CREATE VIEW Ranking_Estados AS
SELECT 
    txt_uf,
    COUNT(*) AS Qtd_Projetos,
    SUM(Valor_Investimento) AS Total_Investido
FROM Investimentos_Limpos
GROUP BY txt_uf;

GO

-- =================================================================
-- 3. CONSULTAS ANALÍTICAS (Relatórios)
-- =================================================================

-- 3.1. TOP 10 Maiores Investimentos
SELECT TOP 10
    txt_municipio,
    txt_uf,
    Valor_Investimento,
    -- Categorização de Risco (KPI)
    CASE 
        WHEN Valor_Investimento > 1000000 THEN 'Alto Valor'
        WHEN Valor_Investimento < 100000 THEN 'Baixo Valor'
        ELSE 'Médio Valor'
    END AS Classificacao_Porte
FROM Investimentos_Limpos
ORDER BY Valor_Investimento DESC;

-- 3.2. Auditoria de Risco (Projetos Caros sem Repasse)
SELECT 
    txt_municipio, 
    Valor_Investimento, 
    Valor_Repasse
FROM Investimentos_Limpos
WHERE Valor_Investimento > 500000 
  AND Valor_Repasse = 0
ORDER BY Valor_Investimento DESC;

-- 3.3. Filtro Agregado (Apenas estados com média > 500k)
SELECT 
    txt_uf,
    AVG(Valor_Investimento) AS Media_Investimento
FROM Investimentos_Limpos
GROUP BY txt_uf
HAVING AVG(Valor_Investimento) > 500000
ORDER BY Media_Investimento DESC;
