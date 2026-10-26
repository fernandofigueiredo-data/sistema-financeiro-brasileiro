// Power Query (Transformar dados > Editor Avançado) | Consulta: ifdata
// Troque o caminho do arquivo. PIB_mil é o PIB nominal em R$ mil (premissa, ajuste).
let
    PIB_mil = 13000000000,
    Fonte = Excel.Workbook(File.Contents("C:\CAMINHO\M3_IFdata_Exercicios.xlsx"), null, true),
    Aba = Fonte{[Item = "Base_IFData_Original", Kind = "Sheet"]}[Data],
    SemTitulo = Table.Skip(Aba, 3),
    Cabecalho = Table.PromoteHeaders(SemTitulo, [PromoteAllScalars = true]),
    Nomes = {"instituicao","codigo","conglomerado_prud_nome","conglomerado_fin_cod","conglomerado_prud_cod",
             "tcb","tc","ti","cidade","uf","data_base","ativo_total","carteira_credito","tvm",
             "passivo_exigivel","captacoes","patrimonio_liquido","lucro_liquido","num_agencias","postos_atendimento"},
    Renomeado = Table.RenameColumns(Cabecalho, List.Zip({Table.ColumnNames(Cabecalho), Nomes})),
    Monetarias = {"ativo_total","carteira_credito","tvm","passivo_exigivel","captacoes","patrimonio_liquido","lucro_liquido"},
    NI_Nulo = Table.ReplaceValue(Renomeado, "NI", null, Replacer.ReplaceValue, Monetarias),
    Tipado = Table.TransformColumnTypes(NI_Nulo,
        List.Transform(Monetarias, each {_, type number}) &
        {{"codigo", Int64.Type}, {"tc", Int64.Type}, {"ti", Int64.Type},
         {"num_agencias", Int64.Type}, {"postos_atendimento", Int64.Type},
         {"instituicao", type text}, {"tcb", type text}, {"uf", type text}}),
    TipoControle = Table.AddColumn(Tipado, "tipo_controle", each
        if [tc] = 1 then "Público" else if [tc] = 2 then "Privado Nacional"
        else if [tc] = 3 then "Privado Estrangeiro" else "Não classificado", type text),
    Segmento = Table.AddColumn(TipoControle, "segmento", each
        if [ativo_total] = null then "NI"
        else if [ativo_total] >= PIB_mil * 0.10 then "S1"
        else if [ativo_total] >= PIB_mil * 0.01 then "S2"
        else if [ativo_total] >= PIB_mil * 0.001 then "S3"
        else if [tcb] = "b3S" then "S5" else "S4", type text)
in
    Segmento
