/*
Objetivo:
Gerar frases automáticas (texto) a partir dos dados, útil para relatórios e logs.
*/

SELECT TOP 5
    txt_uf,
    txt_municipio,
    CONCAT(
        'O estado ', txt_uf,
        ' possui um projeto registrado no município de ',
        txt_municipio, '.'
    ) AS Relatorio_Automatico
FROM dbo.Investimentos_Limpos
ORDER BY Data_Carga DESC;
