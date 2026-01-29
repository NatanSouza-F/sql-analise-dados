/*
Objetivo:
Criar a tabela analítica Investimentos_Limpos a partir da tabela bruta, padronizando valores
monetários (pt-BR -> decimal) e convertendo a data de carga.

Pré-requisito:
Tabela fonte: carteira_investimento_mcid
*/

USE DadosPublicos;
GO

IF OBJECT_ID('dbo.Investimentos_Limpos', 'U') IS NOT NULL
    DROP TABLE dbo.Investimentos_Limpos;
GO

SELECT
    cod_proposta,
    txt_municipio,
    txt_uf,

    CAST(REPLACE(REPLACE(vlr_investimento, '.', ''), ',', '.') AS DECIMAL(18,2)) AS Valor_Investimento,
    CAST(REPLACE(REPLACE(vlr_repasse,      '.', ''), ',', '.') AS DECIMAL(18,2)) AS Valor_Repasse,

    TRY_CONVERT(DATE, LEFT(dte_carga, 10), 111) AS Data_Carga,

    txt_origem
INTO dbo.Investimentos_Limpos
FROM dbo.carteira_investimento_mcid;
GO

-- Amostra de verificação
SELECT TOP 100 *
FROM dbo.Investimentos_Limpos
ORDER BY Data_Carga DESC;
GO
