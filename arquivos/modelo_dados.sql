
Table "dbo"."TB_ACEITE_PARTICIPANTE" {
  "CD_ACEITE_PARTICIPANTE" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int [not null]
  "CD_TERMO_ACEITE" int [not null]
  "FL_ACEITO" bit [not null, default: 0]
  "DT_ACEITE" datetime2(7)
  "DS_IP_ORIGEM" nvarchar(50)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_ACEITE_PARTICIPANTE [pk, name: "PK_ACEITE_PARTICIPANTE"]
    CD_INSCRICAO [name: "IX_ACEITE_CD_INSCRICAO"]
  }
}

Table "dbo"."TB_ACEITE_TERMO_CONFIDENCIALIDADE" {
  "CD_ACEITE_TERMO_CONFIDENCIALIDADE" "int IDENTITY(1,1)" [not null]
  "CD_TERMO_CONFIDENCIALIDADE" int [not null]
  "CD_PREMIACAO" int [not null]
  "CD_USUARIO_AVALIADOR" bigint [not null]
  "NM_AVALIADOR" nvarchar(200)
  "LG_AVALIADOR" nvarchar(200)
  "DT_ACEITE" datetime2(7)
  "DS_IP_ORIGEM" nvarchar(50)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_ACEITE_TERMO_CONFIDENCIALIDADE [pk, name: "PK_ACEITE_TERMO_CONF"]
    (CD_USUARIO_AVALIADOR, CD_PREMIACAO) [unique, name: "UQ_ACEITE_TC_AVAL_PREM"]
    CD_USUARIO_AVALIADOR [name: "IX_ACEITE_TC_USUARIO"]
  }
}

Table "dbo"."TB_AJUSTE_ITEM" {
  "CD_AJUSTE_ITEM" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO_HISTORICO" int [not null]
  "NR_SEQUENCIA" int [not null]
  "DS_TEXTO" nvarchar(500) [not null]
  "FL_ATENDIDO" bit [not null, default: 0]
  "DT_ATENDIDO" datetime2(7)
  "NM_USUARIO_RESPONSAVEL" nvarchar(200)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_AJUSTE_ITEM [pk, name: "PK_AJUSTE_ITEM"]
    CD_INSCRICAO_HISTORICO [name: "IX_AJUSTE_ITEM_CD_HISTORICO"]
  }
}

Table "dbo"."TB_ALOCACAO_AVALIADOR_GRUPO" {
  "CD_ALOCACAO_AVALIADOR_GRUPO" "int IDENTITY(1,1)" [not null]
  "CD_ETAPA" int [not null]
  "CD_TIPO_PART_MOD_CAT" int [not null]
  "CD_USUARIO_AVALIADOR" bigint [not null]
  "DS_SITUACAO" varchar(20) [not null, default: 'ATIVA']
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "NM_AVALIADOR" nvarchar(200)
  "LG_AVALIADOR" nvarchar(200)

  Indexes {
    CD_ALOCACAO_AVALIADOR_GRUPO [pk, name: "PK_ALOC_AVAL_GRUPO"]
    (CD_ETAPA, CD_TIPO_PART_MOD_CAT, CD_USUARIO_AVALIADOR) [unique, name: "UQ_ALOC_AVAL_GRUPO"]
    (CD_ETAPA, CD_TIPO_PART_MOD_CAT) [name: "IX_ALOC_AVAL_GRUPO_ETAPA_TPMC"]
    NM_AVALIADOR [name: "IX_ALOC_AVAL_GRUPO_NM_AVALIADOR"]
    CD_USUARIO_AVALIADOR [name: "IX_ALOC_AVAL_GRUPO_USUARIO"]
  }
}

Table "dbo"."TB_ALOCACAO_AVALIADOR_PARTICIPANTE" {
  "CD_ALOCACAO_AVALIADOR_PARTICIPANTE" "int IDENTITY(1,1)" [not null]
  "CD_ETAPA" int [not null]
  "CD_INSCRICAO" int [not null]
  "CD_USUARIO_AVALIADOR" bigint [not null]
  "DS_SITUACAO" varchar(20) [not null, default: 'ATIVA']
  "DS_STATUS_AVALIACAO" varchar(30) [not null, default: 'A_INICIAR']
  "DT_INICIO" datetime2(7)
  "DT_FINALIZACAO" datetime2(7)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "NM_AVALIADOR" nvarchar(200)
  "LG_AVALIADOR" nvarchar(200)
  "DS_FEEDBACK_AVALIADOR" nvarchar(MAX)

  Indexes {
    CD_ALOCACAO_AVALIADOR_PARTICIPANTE [pk, name: "PK_ALOC_AVAL_PART"]
    (CD_ETAPA, CD_INSCRICAO, CD_USUARIO_AVALIADOR) [unique, name: "UQ_ALOC_AVAL_PART"]
    (CD_USUARIO_AVALIADOR, DS_STATUS_AVALIACAO) [name: "IX_ALOC_AVAL_PART_AVALIADOR"]
    (CD_ETAPA, CD_INSCRICAO) [name: "IX_ALOC_AVAL_PART_ETAPA_INSCRICAO"]
    NM_AVALIADOR [name: "IX_ALOC_AVAL_PART_NM_AVALIADOR"]
  }
}

Table "dbo"."TB_ANEXO_AUDITORIA_EMAIL" {
  "CD_ANEXO_AUDITORIA_EMAIL" "bigint IDENTITY(1,1)" [not null]
  "CD_AUDITORIA_EMAIL" bigint [not null]
  "VL_NAME" varchar(255) [not null]
  "BL_DATA" varbinary(MAX)
  "VL_MIME_TYPE" varchar(255)
  "VL_LENGTH" bigint
  "FL_INLINE" bit [not null, default: 0]

  Indexes {
    CD_ANEXO_AUDITORIA_EMAIL [pk, name: "PK_TB_ANEXO_AUDITORIA_EMAIL"]
  }
}

Table "dbo"."TB_ANEXO_CONFIGURACAO" {
  "CD_ANEXO_CONFIGURACAO" "int IDENTITY(1,1)" [not null]
  "CD_TIPO_PARTICIPANTE" int [not null]
  "NM_ANEXO_CONFIGURACAO" nvarchar(300) [not null]
  "DS_ANEXO_CONFIGURACAO" nvarchar(MAX)
  "FL_OBRIGATORIO" bit [not null, default: 0]
  "DS_EXTENSAO_PERMITIDA" nvarchar(200) [not null]
  "NR_TAMANHO_MAXIMO_MB" int [not null, default: 10]
  "NR_ORDEM" int
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_ANEXO_CONFIGURACAO [pk, name: "PK_ANEXO_CONFIGURACAO"]
    CD_TIPO_PARTICIPANTE [name: "IX_ANEXO_CFG_CD_TIPO_PART"]
  }
}

Table "dbo"."TB_APROVACAO_ETAPA_PARTICIPANTE" {
  "CD_APROVACAO_ETAPA_PARTICIPANTE" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int [not null]
  "CD_ETAPA" int [not null]
  "DS_STATUS" varchar(30)
  "CD_USUARIO_RESPONSAVEL" bigint
  "NM_USUARIO_RESPONSAVEL" nvarchar(200)
  "DT_DECISAO" datetime2(7)
  "DS_OBSERVACAO" nvarchar(MAX)
  "VL_MEDIA_CALCULADA" decimal(5,2)
  "QT_AVALIADORES_FINALIZADOS" int [not null, default: 0]
  "QT_AVALIADORES_ALOCADOS" int [not null, default: 0]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "DS_FEEDBACK_CONSOLIDADO" nvarchar(MAX)
  "DT_FEEDBACK_CONSOLIDADO_EM" datetime2(7)
  "CD_FEEDBACK_CONSOLIDADO_POR" bigint
  "NM_FEEDBACK_CONSOLIDADO_POR" nvarchar(200)
  "FL_FEEDBACK_GERADO_POR_IA" bit [not null, default: 0]
  "FL_PREMIADO" bit [not null, default: 0]

  Indexes {
    CD_APROVACAO_ETAPA_PARTICIPANTE [pk, name: "PK_APROV_ETAPA_PART"]
    (CD_INSCRICAO, CD_ETAPA) [unique, name: "UQ_APROV_ETAPA_PART_INSC_ETAPA"]
    (CD_ETAPA, DS_STATUS) [name: "IX_APROV_ETAPA_PART_ETAPA"]
    (CD_INSCRICAO, CD_ETAPA) [name: "IX_APROV_ETAPA_PART_FEEDBACK_INSC"]
  }
}

Table "dbo"."TB_ARQUIVO" {
  "CD_ARQUIVO" "int IDENTITY(1,1)" [not null]
  "NM_ARQUIVO" varchar(255)
  "NM_MIME" varchar(255)
  "NR_TAMANHO" bigint
  "FL_STORED" char(1)

  Indexes {
    CD_ARQUIVO [pk]
  }
}

Table "dbo"."TB_AUDITORIA_EMAIL" {
  "CD_AUDITORIA_EMAIL" "bigint IDENTITY(1,1)" [not null]
  "VL_FROM" varchar(255)
  "VL_TO" varchar(MAX)
  "VL_CC" varchar(MAX)
  "VL_BCC" varchar(MAX)
  "VL_SUBJECT" varchar(500)
  "VL_BODY" text
  "FL_HTML" bit [not null, default: 1]
  "TS_SOLICITACAO" datetime2(7) [not null]
  "TS_ENVIO" datetime2(7)
  "NM_LOGIN" varchar(255)
  "STATUS" varchar(50) [not null]
  "ERRO" varchar(MAX)

  Indexes {
    CD_AUDITORIA_EMAIL [pk, name: "PK_TB_AUDITORIA_EMAIL"]
    STATUS [name: "IDX_AUDITORIA_EMAIL_STATUS"]
    TS_SOLICITACAO [name: "IDX_AUDITORIA_EMAIL_TS_SOLICITACAO"]
  }
}

Table "dbo"."TB_AUTOSAVE_LOG" {
  "CD_AUTOSAVE_LOG" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int [not null]
  "CD_USUARIO" bigint
  "DS_JSON_SNAPSHOT" nvarchar(MAX)
  "DT_AUTOSAVE" datetime2(7) [not null, default: `getdate()`]
  "DS_IP_ORIGEM" nvarchar(50)

  Indexes {
    CD_AUTOSAVE_LOG [pk, name: "PK_AUTOSAVE_LOG"]
    CD_INSCRICAO [name: "IX_AUTOSAVE_CD_INSCRICAO"]
  }
}

Table "dbo"."TB_AVALIACAO_HISTORICO" {
  "CD_AVALIACAO_HISTORICO" "int IDENTITY(1,1)" [not null]
  "CD_ALOCACAO_AVALIADOR_PARTICIPANTE" int [not null]
  "DS_STATUS_ANTERIOR" varchar(30)
  "DS_STATUS_NOVO" varchar(30) [not null]
  "CD_USUARIO_RESPONSAVEL" bigint
  "NM_USUARIO_RESPONSAVEL" nvarchar(200)
  "DT_ALTERACAO" datetime2(7) [not null, default: `getdate()`]
  "DS_OBSERVACAO" nvarchar(MAX)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_AVALIACAO_HISTORICO [pk, name: "PK_AVAL_HIST"]
    CD_ALOCACAO_AVALIADOR_PARTICIPANTE [name: "IX_AVAL_HIST_ALOCACAO"]
  }
}

Table "dbo"."TB_AVALIACAO_NOTA" {
  "CD_AVALIACAO_NOTA" "int IDENTITY(1,1)" [not null]
  "CD_ALOCACAO_AVALIADOR_PARTICIPANTE" int [not null]
  "CD_QUESTAO_AVALIACAO" int [not null]
  "NR_VALOR" int [not null]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_AVALIACAO_NOTA [pk, name: "PK_AVAL_NOTA"]
    (CD_ALOCACAO_AVALIADOR_PARTICIPANTE, CD_QUESTAO_AVALIACAO) [unique, name: "UQ_AVAL_NOTA_ALOCACAO_QUESTAO"]
    CD_ALOCACAO_AVALIADOR_PARTICIPANTE [name: "IX_AVAL_NOTA_ALOCACAO"]
  }
}

Table "dbo"."TB_BRANDING_PREMIO" {
  "CD_BRANDING_PREMIO" "int IDENTITY(1,1)" [not null]
  "CD_PREMIACAO" int [not null]
  "DS_LOGO_URL" nvarchar(500)
  "DS_COR_PRIMARIA" nvarchar(20)
  "DS_COR_SECUNDARIA" nvarchar(20)
  "DS_COR_FUNDO" nvarchar(20)
  "DS_BANNER_URL" nvarchar(500)
  "DS_FAVICON_URL" nvarchar(500)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_BRANDING_PREMIO [pk, name: "PK_BRANDING_PREMIO"]
    CD_PREMIACAO [name: "IX_BRANDING_CD_PREMIACAO"]
  }
}

Table "dbo"."TB_CATEGORIA" {
  "CD_CATEGORIA" "int IDENTITY(1,1)" [not null]
  "NM_CATEGORIA" nvarchar(200) [not null]
  "DS_CATEGORIA" nvarchar(MAX)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_CATEGORIA [pk, name: "PK_CATEGORIA"]
  }
}

Table "dbo"."TB_CONFIGURACAO_EMAIL_PREMIO" {
  "CD_CONFIGURACAO_EMAIL_PREMIO" "int IDENTITY(1,1)" [not null]
  "CD_PREMIACAO" int [not null]
  "DS_TIPO_EMAIL" nvarchar(50) [not null]
  "DS_ASSUNTO" nvarchar(500) [not null]
  "DS_CORPO_HTML" nvarchar(MAX)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_CONFIGURACAO_EMAIL_PREMIO [pk, name: "PK_CONFIG_EMAIL_PREMIO"]
    CD_PREMIACAO [name: "IX_CONFIG_EMAIL_CD_PREMIACAO"]
  }
}

Table "dbo"."TB_CONTEUDO_ARQUIVO" {
  "CD_ARQUIVO" int [not null]
  "BL_CONTEUDO" varbinary(MAX)

  Indexes {
    CD_ARQUIVO [pk]
  }
}

Table "dbo"."TB_CRITERIO_AVALIACAO" {
  "CD_CRITERIO_AVALIACAO" "int IDENTITY(1,1)" [not null]
  "CD_PREMIACAO" int [not null]
  "CD_CATEGORIA" int
  "NM_CRITERIO_AVALIACAO" nvarchar(300) [not null]
  "DS_CRITERIO_AVALIACAO" nvarchar(MAX)
  "NR_PESO" decimal(5,2) [not null, default: 1.00]
  "NR_ORDEM" int [not null, default: 0]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_CRITERIO_AVALIACAO [pk, name: "PK_CRITERIO_AVALIACAO"]
    CD_PREMIACAO [name: "IX_CRITERIO_CD_PREMIACAO"]
  }
}

Table "dbo"."TB_DESEMPATE_CRITERIO" {
  "CD_DESEMPATE_CRITERIO" "int IDENTITY(1,1)" [not null]
  "CD_PREMIACAO" int [not null]
  "CD_QUESTAO_AVALIACAO" int [not null]
  "NR_ORDEM" int [not null]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_DESEMPATE_CRITERIO [pk, name: "PK_DESEMPATE_CRITERIO"]
    (CD_PREMIACAO, NR_ORDEM) [name: "IX_DESEMPATE_CRITERIO_PREMIACAO"]
    (CD_PREMIACAO, NR_ORDEM) [unique, name: "UX_DESEMPATE_CRITERIO_PREMIACAO_ORDEM"]
    (CD_PREMIACAO, CD_QUESTAO_AVALIACAO) [unique, name: "UX_DESEMPATE_CRITERIO_PREMIACAO_QUESTAO"]
  }
}

Table "dbo"."TB_DESEMPATE_DECISAO" {
  "CD_DESEMPATE_DECISAO" "int IDENTITY(1,1)" [not null]
  "CD_ETAPA" int [not null]
  "DS_JUSTIFICATIVA" nvarchar(1000) [not null]
  "CD_USUARIO_RESPONSAVEL" bigint [not null]
  "NM_USUARIO_RESPONSAVEL" nvarchar(200) [not null]
  "DT_DECISAO" datetime2(7) [not null, default: `getdate()`]
  "FL_ATIVO" bit [not null, default: 1]
  "DS_TIPO_CORTE" varchar(15) [not null, default: 'CLASSIFICACAO']

  Indexes {
    CD_DESEMPATE_DECISAO [pk, name: "PK_DESEMPATE_DECISAO"]
    (CD_ETAPA, DT_DECISAO) [name: "IX_DESEMPATE_DECISAO_ETAPA"]
  }
}

Table "dbo"."TB_DESEMPATE_DECISAO_INSCRICAO" {
  "CD_DESEMPATE_DECISAO_INSCRICAO" "int IDENTITY(1,1)" [not null]
  "CD_DESEMPATE_DECISAO" int [not null]
  "CD_INSCRICAO" int [not null]
  "DS_STATUS_DECIDIDO" varchar(15) [not null]

  Indexes {
    CD_DESEMPATE_DECISAO_INSCRICAO [pk, name: "PK_DESEMPATE_DECISAO_INSCRICAO"]
    (CD_DESEMPATE_DECISAO, CD_INSCRICAO) [unique, name: "UQ_DESEMPATE_DEC_INS"]
    CD_INSCRICAO [name: "IX_DESEMPATE_DEC_INS_INSCRICAO"]
  }
}

Table "dbo"."TB_ENQUADRAMENTO" {
  "CD_ENQUADRAMENTO" "int IDENTITY(1,1)" [not null]
  "CD_TIPO_PARTICIPANTE" int [not null]
  "NM_ENQUADRAMENTO" nvarchar(200) [not null]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "DS_DESCRICAO" nvarchar(MAX)

  Indexes {
    CD_ENQUADRAMENTO [pk, name: "PK_ENQUADRAMENTO"]
    CD_TIPO_PARTICIPANTE [name: "IX_ENQUADRAMENTO_CD_TIPO_PART"]
  }
}

Table "dbo"."TB_ETAPA" {
  "CD_ETAPA" "int IDENTITY(1,1)" [not null]
  "CD_PREMIACAO" int [not null]
  "NM_ETAPA" nvarchar(200) [not null]
  "NR_ORDEM" int [not null]
  "DT_INICIO" date [not null]
  "DT_FIM" date [not null]
  "DS_SITUACAO" varchar(30) [not null, default: 'ABERTA']
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "DT_LIBERACAO_FEEDBACK" date
  "NR_CLASSIFICADOS" int [not null, default: 1]
  "NR_PREMIADOS" int

  Indexes {
    CD_ETAPA [pk, name: "PK_ETAPA"]
    CD_PREMIACAO [name: "IX_ETAPA_PREMIACAO"]
    DS_SITUACAO [name: "IX_ETAPA_SITUACAO"]
    (CD_PREMIACAO, NR_ORDEM) [unique, name: "UQ_ETAPA_PREMIACAO_ORDEM_ATIVO"]
  }
}

Table "dbo"."TB_ETAPA_PERFIL_ACESSO" {
  "CD_ETAPA_PERFIL_ACESSO" "int IDENTITY(1,1)" [not null]
  "CD_ETAPA" int [not null]
  "CD_PERFIL" varchar(10) [not null]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_ETAPA_PERFIL_ACESSO [pk, name: "PK_ETAPA_PERFIL_ACESSO"]
    (CD_ETAPA, CD_PERFIL) [unique, name: "UQ_ETAPA_PERFIL"]
    CD_ETAPA [name: "IX_ETAPA_PERFIL_ETAPA"]
  }
}

Table "dbo"."TB_FECHAMENTO_ETAPA_UF" {
  "CD_FECHAMENTO_ETAPA_UF" "int IDENTITY(1,1)" [not null]
  "CD_ETAPA" int [not null]
  "CD_UF" int
  "DT_FECHAMENTO" datetime2(7) [not null]
  "CD_USUARIO_RESPONSAVEL" bigint [not null]
  "NM_USUARIO_RESPONSAVEL" varchar(200) [not null]
  "DS_OBSERVACAO" varchar(500)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_FECHAMENTO_ETAPA_UF [pk, name: "PK_TB_FECHAMENTO_ETAPA_UF"]
    (CD_ETAPA, CD_UF) [unique, name: "UQ_FECH_ETAPA_UF"]
    CD_ETAPA [name: "IX_FECH_ETAPA_UF_ETAPA"]
  }
}

Table "dbo"."TB_FORMULARIO_CAMPO" {
  "CD_FORMULARIO_CAMPO" "int IDENTITY(1,1)" [not null]
  "CD_FORMULARIO_DINAMICO" int [not null]
  "CD_TIPO_CAMPO" int [not null]
  "CD_SECAO_FORMULARIO" int
  "NM_ROTULO" nvarchar(300) [not null]
  "DS_FORMULARIO_CAMPO" nvarchar(500)
  "DS_PLACEHOLDER" nvarchar(500)
  "DS_DICA_PREENCHIMENTO" nvarchar(1000)
  "DS_VALIDACAO_REGEX" nvarchar(500)
  "DS_OPCOES_JSON" nvarchar(MAX)
  "DS_CONFIGURACAO_JSON" nvarchar(MAX)
  "DS_PERSONALIZACAO_JSON" nvarchar(MAX)
  "FL_OBRIGATORIO" bit [not null, default: 0]
  "NR_COLUNA_GRID" int [not null, default: 12]
  "NR_ORDEM" int [not null]
  "NR_TAMANHO_MAXIMO" int
  "ID_ETAPA" nvarchar(36)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "FL_IDENTIFICADOR" bit [not null, default: 0]

  Indexes {
    CD_FORMULARIO_CAMPO [pk, name: "PK_FORMULARIO_CAMPO"]
    CD_FORMULARIO_DINAMICO [name: "IX_CAMPO_CD_FORMULARIO"]
    (CD_FORMULARIO_DINAMICO, NR_ORDEM) [name: "IX_CAMPO_ORDEM"]
    CD_FORMULARIO_DINAMICO [unique, name: "UQ_FORM_CAMPO_IDENTIFICADOR"]
  }
}

Table "dbo"."TB_FORMULARIO_DINAMICO" {
  "CD_FORMULARIO_DINAMICO" "int IDENTITY(1,1)" [not null]
  "CD_TIPO_PARTICIPANTE" int [not null]
  "NM_FORMULARIO_DINAMICO" nvarchar(200)
  "DS_TITULO" nvarchar(300)
  "DS_FORMULARIO_DINAMICO" nvarchar(MAX)
  "NR_VERSAO" int [not null, default: 1]
  "DS_CONFIGURACAO_JSON" nvarchar(MAX)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_FORMULARIO_DINAMICO [pk, name: "PK_FORMULARIO_DINAMICO"]
    CD_TIPO_PARTICIPANTE [unique, name: "UQ_FORMULARIO_TIPO_PART"]
  }
}

Table "dbo"."TB_INSCRICAO" {
  "CD_INSCRICAO" "int IDENTITY(1,1)" [not null]
  "CD_USUARIO" bigint
  "CD_PREMIACAO" int [not null]
  "CD_CATEGORIA" int
  "CD_MODALIDADE" int
  "CD_TIPO_PARTICIPANTE" int
  "CD_TIPO_PART_MOD_CAT" int
  "CD_ENQUADRAMENTO" int
  "DS_STATUS" nvarchar(50) [not null, default: 'RASCUNHO']
  "DT_INICIO" datetime2(7) [not null, default: `getdate()`]
  "DT_FINALIZACAO" datetime2(7)
  "NR_PERCENTUAL_PREENCHIMENTO" decimal(5,2) [not null, default: 0.00]
  "DS_NUMERO_PROTOCOLO" nvarchar(50)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "CD_UF" int
  "VL_EMAIL" nvarchar(255)
  "NM_IDENTIFICACAO_PARTICIPANTE" nvarchar(200)

  Indexes {
    CD_INSCRICAO [pk, name: "PK_INSCRICAO"]
    CD_USUARIO [name: "IX_INSCRICAO_CD_USUARIO"]
    DS_NUMERO_PROTOCOLO [name: "IX_INSCRICAO_PROTOCOLO"]
    DS_STATUS [name: "IX_INSCRICAO_STATUS"]
  }
}

Table "dbo"."TB_INSCRICAO_DOCUMENTO" {
  "CD_INSCRICAO_DOCUMENTO" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int [not null]
  "CD_FORMULARIO_CAMPO" int
  "CD_ANEXO_CONFIGURACAO" int
  "CD_ARQUIVO" int
  "NM_ARQUIVO" nvarchar(500) [not null]
  "DS_TIPO_MIME" nvarchar(100)
  "NR_TAMANHO_BYTES" bigint
  "DT_UPLOAD" datetime2(7) [not null, default: `getdate()`]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "CD_UUID" nvarchar(36) [not null]

  Indexes {
    CD_INSCRICAO_DOCUMENTO [pk, name: "PK_INSCRICAO_DOCUMENTO"]
    CD_ANEXO_CONFIGURACAO [name: "IX_DOCUMENTO_ANEXO_CFG"]
    CD_INSCRICAO [name: "IX_DOCUMENTO_CD_INSCRICAO"]
    CD_UUID [unique, name: "UQ_TB_INSCRICAO_DOCUMENTO_UUID"]
  }
}

Table "dbo"."TB_INSCRICAO_HISTORICO" {
  "CD_INSCRICAO_HISTORICO" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int [not null]
  "DS_STATUS_ANTERIOR" nvarchar(50)
  "DS_STATUS_NOVO" nvarchar(50) [not null]
  "CD_USUARIO_RESPONSAVEL" bigint
  "DT_ALTERACAO" datetime2(7) [not null, default: `getdate()`]
  "DS_OBSERVACAO" nvarchar(MAX)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "NM_USUARIO_RESPONSAVEL" nvarchar(200)

  Indexes {
    CD_INSCRICAO_HISTORICO [pk, name: "PK_INSCRICAO_HISTORICO"]
    CD_INSCRICAO [name: "IX_HISTORICO_CD_INSCRICAO"]
  }
}

Table "dbo"."TB_INSCRICAO_RESPOSTA" {
  "CD_INSCRICAO_RESPOSTA" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int [not null]
  "CD_FORMULARIO_CAMPO" int [not null]
  "DS_VALOR_TEXTO" nvarchar(MAX)
  "NR_VALOR_NUMERICO" decimal(18,4)
  "DT_VALOR_DATA" datetime2(7)
  "FL_VALOR_BOOLEANO" bit
  "DT_ULTIMA_ALTERACAO" datetime2(7)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_INSCRICAO_RESPOSTA [pk, name: "PK_INSCRICAO_RESPOSTA"]
    (CD_INSCRICAO, CD_FORMULARIO_CAMPO) [unique, name: "UQ_INSCRICAO_RESPOSTA_CAMPO"]
    CD_INSCRICAO [name: "IX_RESPOSTA_CD_INSCRICAO"]
  }
}

Table "dbo"."TB_INSCRICAO_RESPOSTA_QUESTAO" {
  "CD_INSCRICAO_RESPOSTA_QUESTAO" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int [not null]
  "CD_QUESTAO_AVALIACAO" int [not null]
  "CD_QUESTAO_ALTERNATIVA" int
  "DS_RESPOSTA_TEXTO" nvarchar(MAX)
  "DT_ULTIMA_ALTERACAO" datetime2(7)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_INSCRICAO_RESPOSTA_QUESTAO [pk, name: "PK_INSCRICAO_RESPOSTA_QUESTAO"]
    CD_INSCRICAO [name: "IX_IRQ_CD_INSCRICAO"]
    (CD_INSCRICAO, CD_QUESTAO_AVALIACAO) [unique, name: "IX_IRQ_INSCRICAO_QUESTAO_ATIVO"]
  }
}

Table "dbo"."TB_INSCRICAO_SNAPSHOT" {
  "CD_SNAPSHOT" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int [not null]
  "CD_INSCRICAO_HISTORICO" int [not null]
  "DS_TIPO" varchar(20) [not null]
  "NR_RODADA" int [not null]
  "DT_CAPTURA" datetime2(7) [not null]
  "DS_JSON_ESTADO" nvarchar(MAX) [not null]
  "CD_USUARIO_RESPONSAVEL" bigint
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_SNAPSHOT [pk, name: "PK_INSCRICAO_SNAPSHOT"]
    (CD_INSCRICAO_HISTORICO, DS_TIPO) [unique, name: "UQ_INSCRICAO_SNAPSHOT_RODADA"]
    CD_INSCRICAO_HISTORICO [name: "IX_INSCRICAO_SNAPSHOT_HISTORICO"]
    (CD_INSCRICAO, NR_RODADA, DS_TIPO) [name: "IX_INSCRICAO_SNAPSHOT_INSCRICAO"]
  }
}

Table "dbo"."TB_LINK_PUBLICO" {
  "CD_LINK_PUBLICO" "int IDENTITY(1,1)" [not null]
  "CD_PREMIACAO" int [not null]
  "CD_TIPO_PARTICIPANTE" int
  "CD_TIPO_PART_MOD_CAT" int
  "DS_TOKEN_UNICO" nvarchar(255) [not null]
  "DS_URL_SLUG" nvarchar(255)
  "DT_CRIACAO" datetime2(7) [not null, default: `getdate()`]
  "DT_EXPIRACAO" datetime2(7)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_LINK_PUBLICO [pk, name: "PK_LINK_PUBLICO"]
    DS_TOKEN_UNICO [unique, name: "UQ_LINK_TOKEN"]
    CD_PREMIACAO [name: "IX_LINK_CD_PREMIACAO"]
    CD_TIPO_PART_MOD_CAT [name: "IX_LINK_TPMC"]
  }
}

Table "dbo"."TB_LISTA_SISTEMA" {
  "CD_LISTA_SISTEMA" "int IDENTITY(1,1)" [not null]
  "ID_CODIGO" varchar(50) [not null]
  "NM_LISTA_SISTEMA" nvarchar(200) [not null]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_LISTA_SISTEMA [pk, name: "PK_LISTA_SISTEMA"]
    ID_CODIGO [unique, name: "UQ_LISTA_SISTEMA_CODIGO"]
  }
}

Table "dbo"."TB_LISTA_SISTEMA_ITEM" {
  "CD_LISTA_SISTEMA_ITEM" "int IDENTITY(1,1)" [not null]
  "CD_LISTA_SISTEMA" int [not null]
  "VL_ITEM" nvarchar(200) [not null]
  "DS_TEXTO" nvarchar(300) [not null]
  "NR_ORDEM" int
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_LISTA_SISTEMA_ITEM [pk, name: "PK_LISTA_SISTEMA_ITEM"]
    CD_LISTA_SISTEMA [name: "IX_LISTA_ITEM_CD_LISTA"]
  }
}

Table "dbo"."TB_MEMBRO_EQUIPE_CONFIG" {
  "CD_MEMBRO_EQUIPE_CONFIG" "int IDENTITY(1,1)" [not null]
  "CD_TIPO_PARTICIPANTE" int [not null]
  "NM_CAMPO_EXTRA" nvarchar(200)
  "FL_OBRIGATORIO" bit [not null, default: 0]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_MEMBRO_EQUIPE_CONFIG [pk, name: "PK_MEMBRO_EQUIPE_CONFIG"]
    CD_TIPO_PARTICIPANTE [name: "IX_MEMBRO_EQP_CD_TIPO_PART"]
  }
}

Table "dbo"."TB_MEMBRO_EQUIPE_INSCRICAO" {
  "CD_MEMBRO_EQUIPE_INSCRICAO" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int [not null]
  "CD_TIPO_VINCULO_MEMBRO" int [not null]
  "NM_NOME_COMPLETO" nvarchar(300) [not null]
  "NR_CPF" nvarchar(14) [not null]
  "DS_EMAIL" nvarchar(200) [not null]
  "NR_TELEFONE" nvarchar(20)
  "DS_GENERO" nvarchar(50)
  "NR_ORDEM" int [not null, default: 0]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_MEMBRO_EQUIPE_INSCRICAO [pk]
    (CD_INSCRICAO, FL_ATIVO) [name: "IX_MEMBRO_EQUIPE_INSCRICAO_CD_INSCRICAO"]
  }
}

Table "dbo"."TB_MIGRACAO_MANUAL" {
  "NM_SCRIPT" nvarchar(50) [not null]
  "DT_EXECUCAO" datetime2(7) [not null, default: `sysutcdatetime()`]
  "NM_EXECUTOR" nvarchar(100) [not null, default: `suser_name()`]

  Indexes {
    NM_SCRIPT [pk]
  }
}

Table "dbo"."TB_MODALIDADE" {
  "CD_MODALIDADE" "int IDENTITY(1,1)" [not null]
  "NM_MODALIDADE" nvarchar(200) [not null]
  "DS_MODALIDADE" nvarchar(MAX)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_MODALIDADE [pk, name: "PK_MODALIDADE"]
  }
}

Table "dbo"."TB_MODALIDADE_CATEGORIA" {
  "CD_MODALIDADE_CATEGORIA" "int IDENTITY(1,1)" [not null]
  "CD_MODALIDADE" int [not null]
  "CD_PREMIACAO_CATEGORIA" int [not null]
  "DS_REGULAMENTO_LINK" nvarchar(500)
  "DT_INSCRICAO_INICIO" datetime2(7)
  "DT_INSCRICAO_FIM" datetime2(7)
  "NR_ORDEM" int [not null, default: 0]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_MODALIDADE_CATEGORIA [pk, name: "PK_MODALIDADE_CATEGORIA"]
    (CD_MODALIDADE, CD_PREMIACAO_CATEGORIA) [unique, name: "UQ_MOD_CAT"]
    CD_MODALIDADE [name: "IX_MOD_CAT_MODALIDADE"]
    CD_PREMIACAO_CATEGORIA [name: "IX_MOD_CAT_PREM_CAT"]
  }
}

Table "dbo"."TB_NOTIFICACAO_PARTICIPANTE" {
  "CD_NOTIFICACAO_PARTICIPANTE" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int
  "CD_USUARIO" bigint
  "DS_TIPO" nvarchar(50)
  "NM_TITULO" nvarchar(500) [not null]
  "DS_MENSAGEM" nvarchar(MAX)
  "FL_LIDA" bit [not null, default: 0]
  "DT_ENVIO" datetime2(7) [not null, default: `getdate()`]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_NOTIFICACAO_PARTICIPANTE [pk, name: "PK_NOTIFICACAO_PART"]
    CD_INSCRICAO [name: "IX_NOTIFICACAO_CD_INSCRICAO"]
    CD_USUARIO [name: "IX_NOTIFICACAO_CD_USUARIO"]
  }
}

Table "dbo"."TB_PREMIACAO" {
  "CD_PREMIACAO" "int IDENTITY(1,1)" [not null]
  "NM_PREMIACAO" nvarchar(200) [not null]
  "DS_PREMIACAO" nvarchar(MAX)
  "DT_INICIO" date [not null]
  "DT_FIM" date [not null]
  "DS_IMAGEM_BANNER" nvarchar(500)
  "DS_REGULAMENTO_URL" nvarchar(500)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "FL_CONFIDENCIAL_AVALIADOR" bit [not null, default: 0]
  "FL_MOSTRAR_NOTA_ETAPA_ANTERIOR" bit [not null, default: 0]
  "QT_AVALIADORES_POR_INSCRICAO" int
  "VL_FATOR_PONTUACAO" decimal(5,2) [not null, default: 20.00]

  Indexes {
    CD_PREMIACAO [pk, name: "PK_PREMIACAO"]
    NM_PREMIACAO [name: "IX_PREMIACAO_NM"]
  }
}

Table "dbo"."TB_PREMIACAO_CATEGORIA" {
  "CD_PREMIACAO_CATEGORIA" "int IDENTITY(1,1)" [not null]
  "CD_PREMIACAO" int [not null]
  "CD_CATEGORIA" int [not null]
  "NR_ORDEM" int [not null, default: 0]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_PREMIACAO_CATEGORIA [pk, name: "PK_PREMIACAO_CATEGORIA"]
    (CD_PREMIACAO, CD_CATEGORIA) [unique, name: "UQ_PREM_CAT"]
    CD_CATEGORIA [name: "IX_PREM_CAT_CATEGORIA"]
    CD_PREMIACAO [name: "IX_PREM_CAT_PREMIACAO"]
  }
}

Table "dbo"."TB_QUESTAO_ALTERNATIVA" {
  "CD_QUESTAO_ALTERNATIVA" "int IDENTITY(1,1)" [not null]
  "CD_QUESTAO_AVALIACAO" int [not null]
  "DS_TEXTO" nvarchar(500) [not null]
  "NR_ORDEM" int
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_QUESTAO_ALTERNATIVA [pk, name: "PK_QUESTAO_ALTERNATIVA"]
    CD_QUESTAO_AVALIACAO [name: "IX_ALTERNATIVA_CD_QUESTAO"]
  }
}

Table "dbo"."TB_QUESTAO_AVALIACAO" {
  "CD_QUESTAO_AVALIACAO" "int IDENTITY(1,1)" [not null]
  "CD_QUESTIONARIO" int [not null]
  "CD_TIPO_QUESTAO" int [not null]
  "DS_ENUNCIADO" nvarchar(MAX) [not null]
  "NR_LIMITE_CARACTERES" int
  "NR_ORDEM" int [not null]
  "FL_OBRIGATORIO" bit [not null, default: 1]
  "VL_PESO_NOTA" decimal(5,2) [not null, default: 1.00]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "DS_TITULO" nvarchar(500)
  "DS_DESCRICAO" nvarchar(MAX)

  Indexes {
    CD_QUESTAO_AVALIACAO [pk, name: "PK_QUESTAO_AVALIACAO"]
    CD_QUESTIONARIO [name: "IX_QUESTAO_CD_QUESTIONARIO"]
    (CD_QUESTIONARIO, NR_ORDEM) [name: "IX_QUESTAO_ORDEM"]
  }
}

Table "dbo"."TB_QUESTIONARIO" {
  "CD_QUESTIONARIO" "int IDENTITY(1,1)" [not null]
  "CD_TIPO_PARTICIPANTE" int [not null]
  "NM_QUESTIONARIO" nvarchar(200)
  "DS_QUESTIONARIO" nvarchar(MAX)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_QUESTIONARIO [pk, name: "PK_QUESTIONARIO"]
    CD_TIPO_PARTICIPANTE [unique, name: "UQ_QUESTIONARIO_TIPO_PART"]
  }
}

Table "dbo"."TB_SECAO_FORMULARIO" {
  "CD_SECAO_FORMULARIO" "int IDENTITY(1,1)" [not null]
  "CD_FORMULARIO_DINAMICO" int [not null]
  "NM_SECAO_FORMULARIO" nvarchar(300) [not null]
  "DS_SECAO_FORMULARIO" nvarchar(MAX)
  "NR_ORDEM" int [not null, default: 0]
  "FL_OBRIGATORIA" bit [not null, default: 1]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_SECAO_FORMULARIO [pk, name: "PK_SECAO_FORMULARIO"]
    CD_FORMULARIO_DINAMICO [name: "IX_SECAO_FORM_CD_FORMULARIO"]
  }
}

Table "dbo"."TB_TERMO_ACEITE" {
  "CD_TERMO_ACEITE" "int IDENTITY(1,1)" [not null]
  "CD_PREMIACAO" int [not null]
  "NM_TITULO" nvarchar(500) [not null]
  "DS_TEXTO_HTML" nvarchar(MAX)
  "NR_VERSAO" int [not null, default: 1]
  "FL_OBRIGATORIO" bit [not null, default: 1]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_TERMO_ACEITE [pk, name: "PK_TERMO_ACEITE"]
    CD_PREMIACAO [name: "IX_TERMO_ACEITE_CD_PREMIACAO"]
  }
}

Table "dbo"."TB_TERMO_CONFIDENCIALIDADE" {
  "CD_TERMO_CONFIDENCIALIDADE" "int IDENTITY(1,1)" [not null]
  "CD_PREMIACAO" int [not null]
  "NM_TITULO" nvarchar(500)
  "DS_TIPO" varchar(10) [not null]
  "DS_TEXTO_HTML" nvarchar(MAX)
  "CD_ARQUIVO" int
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_TERMO_CONFIDENCIALIDADE [pk, name: "PK_TERMO_CONFIDENCIALIDADE"]
    CD_PREMIACAO [unique, name: "UQ_TERMO_CONF_PREMIACAO_ATIVO"]
  }
}

Table "dbo"."TB_TIPO_CAMPO" {
  "CD_TIPO_CAMPO" "int IDENTITY(1,1)" [not null]
  "ID_CODIGO" varchar(50) [not null]
  "NM_TIPO_CAMPO" nvarchar(100) [not null]
  "DS_ICONE" nvarchar(100)

  Indexes {
    CD_TIPO_CAMPO [pk, name: "PK_TIPO_CAMPO"]
    ID_CODIGO [unique, name: "UQ_TIPO_CAMPO_CODIGO"]
  }
}

Table "dbo"."TB_TIPO_PART_MOD_CAT" {
  "CD_TIPO_PART_MOD_CAT" "int IDENTITY(1,1)" [not null]
  "CD_TIPO_PARTICIPANTE" int [not null]
  "CD_MODALIDADE_CATEGORIA" int [not null]
  "FL_PERMITE_EQUIPE" bit [not null, default: 0]
  "QT_EQUIPE_MINIMO" int
  "QT_EQUIPE_MAXIMO" int
  "DS_SLUG_URL" nvarchar(200)
  "NR_ORDEM" int [not null, default: 0]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_TIPO_PART_MOD_CAT [pk, name: "PK_TIPO_PART_MOD_CAT"]
    (CD_TIPO_PARTICIPANTE, CD_MODALIDADE_CATEGORIA) [unique, name: "UQ_TPMC"]
    CD_MODALIDADE_CATEGORIA [name: "IX_TPMC_MOD_CAT"]
    CD_TIPO_PARTICIPANTE [name: "IX_TPMC_TIPO_PART"]
  }
}

Table "dbo"."TB_TIPO_PARTICIPANTE" {
  "CD_TIPO_PARTICIPANTE" "int IDENTITY(1,1)" [not null]
  "NM_TIPO_PARTICIPANTE" nvarchar(200) [not null]
  "DS_TIPO_PARTICIPANTE" nvarchar(MAX)
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]
  "DS_ABRANGENCIA" varchar(10) [not null, default: 'NACIONAL']

  Indexes {
    CD_TIPO_PARTICIPANTE [pk, name: "PK_TIPO_PARTICIPANTE"]
  }
}

Table "dbo"."TB_TIPO_QUESTAO" {
  "CD_TIPO_QUESTAO" "int IDENTITY(1,1)" [not null]
  "ID_CODIGO" varchar(50) [not null]
  "NM_TIPO_QUESTAO" nvarchar(100) [not null]

  Indexes {
    CD_TIPO_QUESTAO [pk, name: "PK_TIPO_QUESTAO"]
    ID_CODIGO [unique, name: "UQ_TIPO_QUESTAO_CODIGO"]
  }
}

Table "dbo"."TB_TIPO_VINCULO_MEMBRO" {
  "CD_TIPO_VINCULO_MEMBRO" "int IDENTITY(1,1)" [not null]
  "CD_TIPO_PARTICIPANTE" int [not null]
  "NM_TIPO_VINCULO_MEMBRO" nvarchar(200) [not null]
  "NR_ORDEM" int
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_TIPO_VINCULO_MEMBRO [pk, name: "PK_TIPO_VINCULO_MEMBRO"]
    CD_TIPO_PARTICIPANTE [name: "IX_TIPO_VINCULO_CD_TIPO_PART"]
  }
}

Table "dbo"."TB_UF" {
  "CD_UF" "int IDENTITY(1,1)" [not null]
  "SG_UF" char(2) [not null]
  "NM_UF" nvarchar(50) [not null]

  Indexes {
    CD_UF [pk]
    SG_UF [unique, name: "UQ_TB_UF_SG"]
  }
}

Table "dbo"."TB_USUARIO_UF" {
  "CD_USUARIO_UF" "int IDENTITY(1,1)" [not null]
  "CD_USUARIO" bigint [not null]
  "CD_UF" int [not null]
  "DT_CRIADO_EM" datetime2(7) [not null, default: `getdate()`]
  "FL_ATIVO" bit [not null, default: 1]
  "VL_EMAIL" nvarchar(255)

  Indexes {
    CD_USUARIO_UF [pk]
    (CD_USUARIO, CD_UF) [unique, name: "UQ_USUARIO_UF"]
  }
}

Table "dbo"."TB_VALIDACAO_INSCRICAO" {
  "CD_VALIDACAO_INSCRICAO" "int IDENTITY(1,1)" [not null]
  "CD_INSCRICAO" int [not null]
  "CD_USUARIO_VALIDADOR" bigint
  "DS_STATUS_VALIDACAO" nvarchar(50) [not null]
  "DS_PARECER" nvarchar(MAX)
  "DT_VALIDACAO" datetime2(7) [not null, default: `getdate()`]
  "CD_CRIADO_POR" int
  "DT_CRIADO_EM" datetime2(7)
  "CD_ATUALIZADO_POR" int
  "DT_ATUALIZADO_EM" datetime2(7)
  "FL_ATIVO" bit [not null, default: 1]

  Indexes {
    CD_VALIDACAO_INSCRICAO [pk, name: "PK_VALIDACAO_INSCRICAO"]
    (CD_INSCRICAO, DT_VALIDACAO) [name: "IX_VALIDACAO_CD_INSCRICAO"]
  }
}

Table "dbo"."TL_LOG_AUDITORIA" {
  "CD_LOG_AUDITORIA" "int IDENTITY(1,1)" [not null]
  "NM_ENTIDADE" nvarchar(100) [not null]
  "CD_ENTIDADE" int [not null]
  "DS_ACAO" varchar(20) [not null]
  "DS_DADOS_ANTERIORES" nvarchar(MAX)
  "DS_DADOS_NOVOS" nvarchar(MAX)
  "CD_USUARIO" int [not null]
  "DT_DATA_HORA" datetime2(7) [not null, default: `getdate()`]

  Indexes {
    CD_LOG_AUDITORIA [pk, name: "PK_LOG_AUDITORIA"]
    CD_USUARIO [name: "IX_LOG_CD_USUARIO"]
    DT_DATA_HORA [name: "IX_LOG_DT_DATA_HORA"]
    (NM_ENTIDADE, CD_ENTIDADE) [name: "IX_LOG_ENTIDADE"]
  }
}

Ref "FK_ACEITE_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_ACEITE_PARTICIPANTE"."CD_INSCRICAO"

Ref "FK_ACEITE_TERMO":"dbo"."TB_TERMO_ACEITE"."CD_TERMO_ACEITE" < "dbo"."TB_ACEITE_PARTICIPANTE"."CD_TERMO_ACEITE"

Ref "FK_ACEITE_TC_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_ACEITE_TERMO_CONFIDENCIALIDADE"."CD_PREMIACAO"

Ref "FK_ACEITE_TC_TERMO":"dbo"."TB_TERMO_CONFIDENCIALIDADE"."CD_TERMO_CONFIDENCIALIDADE" < "dbo"."TB_ACEITE_TERMO_CONFIDENCIALIDADE"."CD_TERMO_CONFIDENCIALIDADE"

Ref "FK_AJUSTE_ITEM_HISTORICO":"dbo"."TB_INSCRICAO_HISTORICO"."CD_INSCRICAO_HISTORICO" < "dbo"."TB_AJUSTE_ITEM"."CD_INSCRICAO_HISTORICO"

Ref "FK_ALOC_AVAL_GRUPO_ETAPA":"dbo"."TB_ETAPA"."CD_ETAPA" < "dbo"."TB_ALOCACAO_AVALIADOR_GRUPO"."CD_ETAPA"

Ref "FK_ALOC_AVAL_GRUPO_TPMC":"dbo"."TB_TIPO_PART_MOD_CAT"."CD_TIPO_PART_MOD_CAT" < "dbo"."TB_ALOCACAO_AVALIADOR_GRUPO"."CD_TIPO_PART_MOD_CAT"

Ref "FK_ALOC_AVAL_PART_ETAPA":"dbo"."TB_ETAPA"."CD_ETAPA" < "dbo"."TB_ALOCACAO_AVALIADOR_PARTICIPANTE"."CD_ETAPA"

Ref "FK_ALOC_AVAL_PART_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_ALOCACAO_AVALIADOR_PARTICIPANTE"."CD_INSCRICAO"

Ref "FK_ANEXO_EMAIL_AUDITORIA":"dbo"."TB_AUDITORIA_EMAIL"."CD_AUDITORIA_EMAIL" < "dbo"."TB_ANEXO_AUDITORIA_EMAIL"."CD_AUDITORIA_EMAIL"

Ref "FK_ANEXO_CFG_TIPO_PART":"dbo"."TB_TIPO_PARTICIPANTE"."CD_TIPO_PARTICIPANTE" < "dbo"."TB_ANEXO_CONFIGURACAO"."CD_TIPO_PARTICIPANTE"

Ref "FK_APROV_ETAPA_PART_ETAPA":"dbo"."TB_ETAPA"."CD_ETAPA" < "dbo"."TB_APROVACAO_ETAPA_PARTICIPANTE"."CD_ETAPA"

Ref "FK_APROV_ETAPA_PART_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_APROVACAO_ETAPA_PARTICIPANTE"."CD_INSCRICAO"

Ref "FK_AUTOSAVE_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_AUTOSAVE_LOG"."CD_INSCRICAO"

Ref "FK_AVAL_HIST_ALOCACAO":"dbo"."TB_ALOCACAO_AVALIADOR_PARTICIPANTE"."CD_ALOCACAO_AVALIADOR_PARTICIPANTE" < "dbo"."TB_AVALIACAO_HISTORICO"."CD_ALOCACAO_AVALIADOR_PARTICIPANTE"

Ref "FK_AVAL_NOTA_ALOCACAO":"dbo"."TB_ALOCACAO_AVALIADOR_PARTICIPANTE"."CD_ALOCACAO_AVALIADOR_PARTICIPANTE" < "dbo"."TB_AVALIACAO_NOTA"."CD_ALOCACAO_AVALIADOR_PARTICIPANTE"

Ref "FK_AVAL_NOTA_QUESTAO":"dbo"."TB_QUESTAO_AVALIACAO"."CD_QUESTAO_AVALIACAO" < "dbo"."TB_AVALIACAO_NOTA"."CD_QUESTAO_AVALIACAO"

Ref "FK_BRANDING_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_BRANDING_PREMIO"."CD_PREMIACAO"

Ref "FK_CONFIG_EMAIL_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_CONFIGURACAO_EMAIL_PREMIO"."CD_PREMIACAO"

Ref "FK_CONTEUDO_ARQUIVO_ARQUIVO":"dbo"."TB_ARQUIVO"."CD_ARQUIVO" < "dbo"."TB_CONTEUDO_ARQUIVO"."CD_ARQUIVO"

Ref "FK_CRITERIO_CATEGORIA":"dbo"."TB_CATEGORIA"."CD_CATEGORIA" < "dbo"."TB_CRITERIO_AVALIACAO"."CD_CATEGORIA"

Ref "FK_CRITERIO_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_CRITERIO_AVALIACAO"."CD_PREMIACAO"

Ref "FK_DESEMPATE_CRITERIO_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_DESEMPATE_CRITERIO"."CD_PREMIACAO"

Ref "FK_DESEMPATE_CRITERIO_QUESTAO":"dbo"."TB_QUESTAO_AVALIACAO"."CD_QUESTAO_AVALIACAO" < "dbo"."TB_DESEMPATE_CRITERIO"."CD_QUESTAO_AVALIACAO"

Ref "FK_DESEMPATE_DECISAO_ETAPA":"dbo"."TB_ETAPA"."CD_ETAPA" < "dbo"."TB_DESEMPATE_DECISAO"."CD_ETAPA"

Ref "FK_DESEMPATE_DEC_INS_DECISAO":"dbo"."TB_DESEMPATE_DECISAO"."CD_DESEMPATE_DECISAO" < "dbo"."TB_DESEMPATE_DECISAO_INSCRICAO"."CD_DESEMPATE_DECISAO"

Ref "FK_DESEMPATE_DEC_INS_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_DESEMPATE_DECISAO_INSCRICAO"."CD_INSCRICAO"

Ref "FK_ENQUADRAMENTO_TIPO_PART":"dbo"."TB_TIPO_PARTICIPANTE"."CD_TIPO_PARTICIPANTE" < "dbo"."TB_ENQUADRAMENTO"."CD_TIPO_PARTICIPANTE"

Ref "FK_ETAPA_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_ETAPA"."CD_PREMIACAO"

Ref "FK_ETAPA_PERFIL_ETAPA":"dbo"."TB_ETAPA"."CD_ETAPA" < "dbo"."TB_ETAPA_PERFIL_ACESSO"."CD_ETAPA"

Ref "FK_FECH_ETAPA_UF_ETAPA":"dbo"."TB_ETAPA"."CD_ETAPA" < "dbo"."TB_FECHAMENTO_ETAPA_UF"."CD_ETAPA"

Ref "FK_FECH_ETAPA_UF_UF":"dbo"."TB_UF"."CD_UF" < "dbo"."TB_FECHAMENTO_ETAPA_UF"."CD_UF"

Ref "FK_CAMPO_FORMULARIO":"dbo"."TB_FORMULARIO_DINAMICO"."CD_FORMULARIO_DINAMICO" < "dbo"."TB_FORMULARIO_CAMPO"."CD_FORMULARIO_DINAMICO"

Ref "FK_CAMPO_SECAO":"dbo"."TB_SECAO_FORMULARIO"."CD_SECAO_FORMULARIO" < "dbo"."TB_FORMULARIO_CAMPO"."CD_SECAO_FORMULARIO"

Ref "FK_CAMPO_TIPO_CAMPO":"dbo"."TB_TIPO_CAMPO"."CD_TIPO_CAMPO" < "dbo"."TB_FORMULARIO_CAMPO"."CD_TIPO_CAMPO"

Ref "FK_FORMULARIO_TIPO_PART":"dbo"."TB_TIPO_PARTICIPANTE"."CD_TIPO_PARTICIPANTE" < "dbo"."TB_FORMULARIO_DINAMICO"."CD_TIPO_PARTICIPANTE"

Ref "FK_INSCRICAO_CATEGORIA":"dbo"."TB_CATEGORIA"."CD_CATEGORIA" < "dbo"."TB_INSCRICAO"."CD_CATEGORIA"

Ref "FK_INSCRICAO_ENQUADRAMENTO":"dbo"."TB_ENQUADRAMENTO"."CD_ENQUADRAMENTO" < "dbo"."TB_INSCRICAO"."CD_ENQUADRAMENTO"

Ref "FK_INSCRICAO_MODALIDADE":"dbo"."TB_MODALIDADE"."CD_MODALIDADE" < "dbo"."TB_INSCRICAO"."CD_MODALIDADE"

Ref "FK_INSCRICAO_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_INSCRICAO"."CD_PREMIACAO"

Ref "FK_INSCRICAO_TIPO_PART":"dbo"."TB_TIPO_PARTICIPANTE"."CD_TIPO_PARTICIPANTE" < "dbo"."TB_INSCRICAO"."CD_TIPO_PARTICIPANTE"

Ref "FK_INSCRICAO_TPMC":"dbo"."TB_TIPO_PART_MOD_CAT"."CD_TIPO_PART_MOD_CAT" < "dbo"."TB_INSCRICAO"."CD_TIPO_PART_MOD_CAT"

Ref "FK_INSCRICAO_UF":"dbo"."TB_UF"."CD_UF" < "dbo"."TB_INSCRICAO"."CD_UF"

Ref "FK_DOCUMENTO_ANEXO_CFG":"dbo"."TB_ANEXO_CONFIGURACAO"."CD_ANEXO_CONFIGURACAO" < "dbo"."TB_INSCRICAO_DOCUMENTO"."CD_ANEXO_CONFIGURACAO"

Ref "FK_DOCUMENTO_CAMPO":"dbo"."TB_FORMULARIO_CAMPO"."CD_FORMULARIO_CAMPO" < "dbo"."TB_INSCRICAO_DOCUMENTO"."CD_FORMULARIO_CAMPO"

Ref "FK_DOCUMENTO_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_INSCRICAO_DOCUMENTO"."CD_INSCRICAO"

Ref "FK_HISTORICO_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_INSCRICAO_HISTORICO"."CD_INSCRICAO"

Ref "FK_RESPOSTA_CAMPO":"dbo"."TB_FORMULARIO_CAMPO"."CD_FORMULARIO_CAMPO" < "dbo"."TB_INSCRICAO_RESPOSTA"."CD_FORMULARIO_CAMPO"

Ref "FK_RESPOSTA_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_INSCRICAO_RESPOSTA"."CD_INSCRICAO"

Ref "FK_IRQ_ALTERNATIVA":"dbo"."TB_QUESTAO_ALTERNATIVA"."CD_QUESTAO_ALTERNATIVA" < "dbo"."TB_INSCRICAO_RESPOSTA_QUESTAO"."CD_QUESTAO_ALTERNATIVA"

Ref "FK_IRQ_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_INSCRICAO_RESPOSTA_QUESTAO"."CD_INSCRICAO"

Ref "FK_IRQ_QUESTAO":"dbo"."TB_QUESTAO_AVALIACAO"."CD_QUESTAO_AVALIACAO" < "dbo"."TB_INSCRICAO_RESPOSTA_QUESTAO"."CD_QUESTAO_AVALIACAO"

Ref "FK_INSCRICAO_SNAPSHOT_HISTORICO":"dbo"."TB_INSCRICAO_HISTORICO"."CD_INSCRICAO_HISTORICO" < "dbo"."TB_INSCRICAO_SNAPSHOT"."CD_INSCRICAO_HISTORICO"

Ref "FK_INSCRICAO_SNAPSHOT_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_INSCRICAO_SNAPSHOT"."CD_INSCRICAO"

Ref "FK_LINK_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_LINK_PUBLICO"."CD_PREMIACAO"

Ref "FK_LINK_TIPO_PART":"dbo"."TB_TIPO_PARTICIPANTE"."CD_TIPO_PARTICIPANTE" < "dbo"."TB_LINK_PUBLICO"."CD_TIPO_PARTICIPANTE"

Ref "FK_LINK_TPMC":"dbo"."TB_TIPO_PART_MOD_CAT"."CD_TIPO_PART_MOD_CAT" < "dbo"."TB_LINK_PUBLICO"."CD_TIPO_PART_MOD_CAT"

Ref "FK_LISTA_ITEM_LISTA":"dbo"."TB_LISTA_SISTEMA"."CD_LISTA_SISTEMA" < "dbo"."TB_LISTA_SISTEMA_ITEM"."CD_LISTA_SISTEMA"

Ref "FK_MEMBRO_EQP_TIPO_PART":"dbo"."TB_TIPO_PARTICIPANTE"."CD_TIPO_PARTICIPANTE" < "dbo"."TB_MEMBRO_EQUIPE_CONFIG"."CD_TIPO_PARTICIPANTE"

Ref "FK_MEMBRO_EQUIPE_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_MEMBRO_EQUIPE_INSCRICAO"."CD_INSCRICAO"

Ref "FK_MEMBRO_EQUIPE_VINCULO":"dbo"."TB_TIPO_VINCULO_MEMBRO"."CD_TIPO_VINCULO_MEMBRO" < "dbo"."TB_MEMBRO_EQUIPE_INSCRICAO"."CD_TIPO_VINCULO_MEMBRO"

Ref "FK_MOD_CAT_MODALIDADE":"dbo"."TB_MODALIDADE"."CD_MODALIDADE" < "dbo"."TB_MODALIDADE_CATEGORIA"."CD_MODALIDADE"

Ref "FK_MOD_CAT_PREM_CAT":"dbo"."TB_PREMIACAO_CATEGORIA"."CD_PREMIACAO_CATEGORIA" < "dbo"."TB_MODALIDADE_CATEGORIA"."CD_PREMIACAO_CATEGORIA"

Ref "FK_NOTIFICACAO_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_NOTIFICACAO_PARTICIPANTE"."CD_INSCRICAO"

Ref "FK_PREM_CAT_CATEGORIA":"dbo"."TB_CATEGORIA"."CD_CATEGORIA" < "dbo"."TB_PREMIACAO_CATEGORIA"."CD_CATEGORIA"

Ref "FK_PREM_CAT_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_PREMIACAO_CATEGORIA"."CD_PREMIACAO"

Ref "FK_ALTERNATIVA_QUESTAO":"dbo"."TB_QUESTAO_AVALIACAO"."CD_QUESTAO_AVALIACAO" < "dbo"."TB_QUESTAO_ALTERNATIVA"."CD_QUESTAO_AVALIACAO"

Ref "FK_QUESTAO_QUESTIONARIO":"dbo"."TB_QUESTIONARIO"."CD_QUESTIONARIO" < "dbo"."TB_QUESTAO_AVALIACAO"."CD_QUESTIONARIO"

Ref "FK_QUESTAO_TIPO_QUESTAO":"dbo"."TB_TIPO_QUESTAO"."CD_TIPO_QUESTAO" < "dbo"."TB_QUESTAO_AVALIACAO"."CD_TIPO_QUESTAO"

Ref "FK_QUESTIONARIO_TIPO_PART":"dbo"."TB_TIPO_PARTICIPANTE"."CD_TIPO_PARTICIPANTE" < "dbo"."TB_QUESTIONARIO"."CD_TIPO_PARTICIPANTE"

Ref "FK_SECAO_FORMULARIO_DINAMICO":"dbo"."TB_FORMULARIO_DINAMICO"."CD_FORMULARIO_DINAMICO" < "dbo"."TB_SECAO_FORMULARIO"."CD_FORMULARIO_DINAMICO"

Ref "FK_TERMO_ACEITE_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_TERMO_ACEITE"."CD_PREMIACAO"

Ref "FK_TERMO_CONF_ARQUIVO":"dbo"."TB_ARQUIVO"."CD_ARQUIVO" < "dbo"."TB_TERMO_CONFIDENCIALIDADE"."CD_ARQUIVO"

Ref "FK_TERMO_CONF_PREMIACAO":"dbo"."TB_PREMIACAO"."CD_PREMIACAO" < "dbo"."TB_TERMO_CONFIDENCIALIDADE"."CD_PREMIACAO"

Ref "FK_TPMC_MOD_CAT":"dbo"."TB_MODALIDADE_CATEGORIA"."CD_MODALIDADE_CATEGORIA" < "dbo"."TB_TIPO_PART_MOD_CAT"."CD_MODALIDADE_CATEGORIA"

Ref "FK_TPMC_TIPO_PART":"dbo"."TB_TIPO_PARTICIPANTE"."CD_TIPO_PARTICIPANTE" < "dbo"."TB_TIPO_PART_MOD_CAT"."CD_TIPO_PARTICIPANTE"

Ref "FK_TIPO_VINCULO_TIPO_PART":"dbo"."TB_TIPO_PARTICIPANTE"."CD_TIPO_PARTICIPANTE" < "dbo"."TB_TIPO_VINCULO_MEMBRO"."CD_TIPO_PARTICIPANTE"

Ref "FK_USUARIO_UF_UF":"dbo"."TB_UF"."CD_UF" < "dbo"."TB_USUARIO_UF"."CD_UF"

Ref "FK_VALIDACAO_INSCRICAO":"dbo"."TB_INSCRICAO"."CD_INSCRICAO" < "dbo"."TB_VALIDACAO_INSCRICAO"."CD_INSCRICAO"

