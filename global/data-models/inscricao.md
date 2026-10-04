<!-- docqui: 4.1.0 | prompt: PROMPT_REVERSE_ENGINEERING | atualizado: 2026-10-04 -->
# Data Model: Inscrição
> Fragmento do DATA-MODEL.md — cole apenas este arquivo nas sessões que envolvam o domínio Inscrição.
>
> **ALIs deste domínio**: Inscrição · Notificação Participante
> ✅ **Label Dev conciliado com o código** (2026-08-28): cada Label Dev abaixo é o nome do atributo Java da entidade JPA correspondente em `br.com.cni.apipremioieltalentos.domain`. Onde o atributo é uma associação (`@ManyToOne`), o Label Dev é o nome da referência (ex.: `premiacao`), não `premiacaoId`. O **campo banco** é o `@Column(name=…)` transcrito exatamente.
>
> ⚠️ Colunas `CD_USUARIO` / `CD_USUARIO_RESPONSAVEL` são `bigint` que referenciam a identidade externa (SSO/AD corporativo) — não existe `TB_USUARIO` no schema e não há FK local para elas (ver domínio Acesso).

---

## Inscrição
> **ALI: Inscrição** · entidade principal

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Usuário participante | usuarioId | CD_USUARIO | bigint | não | usuário externo (SSO/AD); sem FK local ⚠️ |
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO |
| Categoria | categoria | CD_CATEGORIA | int | não | FK → TB_CATEGORIA |
| Modalidade | modalidade | CD_MODALIDADE | int | não | FK → TB_MODALIDADE |
| Tipo de participante | tipoParticipante | CD_TIPO_PARTICIPANTE | int | não | FK → TB_TIPO_PARTICIPANTE |
| Oferta (tipo × modalidade × categoria) ⚠️ | tipoParticipanteModCat | CD_TIPO_PART_MOD_CAT | int | não | FK → TB_TIPO_PART_MOD_CAT |
| Enquadramento | enquadramento | CD_ENQUADRAMENTO | int | não | FK → TB_ENQUADRAMENTO |
| Status | status | DS_STATUS | nvarchar(50) | automático | enum `StatusInscricaoEnum`: RASCUNHO (default) · EM_ANDAMENTO · FINALIZADA · EM_VALIDACAO · VALIDADA · REJEITADA · AGUARDANDO_AJUSTE · AJUSTES_CONCLUIDOS |
| Data de início | dataInicio | DT_INICIO | datetime2(7) | automático | default getdate() |
| Data de finalização | dataFinalizacao | DT_FINALIZACAO | datetime2(7) | não | |
| Percentual de preenchimento | percentualPreenchimento | NR_PERCENTUAL_PREENCHIMENTO | decimal(5,2) | automático | default 0.00; progresso 0–100 |
| Número de protocolo | numeroProtocolo | DS_NUMERO_PROTOCOLO | nvarchar(50) | não | indexado (não único) |
| Unidade federativa | uf | CD_UF | int | não | FK → TB_UF |
| E-mail | email | VL_EMAIL | nvarchar(255) | não | → ver FIELD-DICTIONARY: E-mail |
| Identificação do participante ⚠️ | nomeIdentificacaoParticipante | NM_IDENTIFICACAO_PARTICIPANTE | nvarchar(200) | não | rótulo de identificação exibido ⚠️ |

---

## Resposta de Formulário
> **ALI: Inscrição** · entidade de suporte (respostas do formulário dinâmico da inscrição)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO |
| Campo do formulário | campoFormulario | CD_FORMULARIO_CAMPO | int | sim | FK → TB_FORMULARIO_CAMPO; único por CD_INSCRICAO+CD_FORMULARIO_CAMPO |
| Valor (texto) | valorTexto | DS_VALOR_TEXTO | nvarchar(MAX) | não | Texto longo |
| Valor (numérico) | valorNumerico | NR_VALOR_NUMERICO | decimal(18,4) | não | |
| Valor (data) | valorData | DT_VALOR_DATA | datetime2(7) | não | |
| Valor (booleano) | valorBooleano | FL_VALOR_BOOLEANO | bit | não | |
| Data da última alteração | dataUltimaAlteracao | DT_ULTIMA_ALTERACAO | datetime2(7) | não | |

---

## Resposta de Questão
> **ALI: Inscrição** · entidade de suporte (respostas do questionário de avaliação preenchidas na inscrição)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO; único por CD_INSCRICAO+CD_QUESTAO_AVALIACAO |
| Questão de avaliação | questaoAvaliacao | CD_QUESTAO_AVALIACAO | int | sim | FK → TB_QUESTAO_AVALIACAO |
| Alternativa escolhida | alternativaSelecionada | CD_QUESTAO_ALTERNATIVA | int | não | FK → TB_QUESTAO_ALTERNATIVA |
| Resposta (texto) | respostaTexto | DS_RESPOSTA_TEXTO | nvarchar(MAX) | não | Texto longo |
| Data da última alteração | dataUltimaAlteracao | DT_ULTIMA_ALTERACAO | datetime2(7) | não | |

---

## Documento da Inscrição
> **ALI: Inscrição** · entidade de suporte (documentos anexados à inscrição)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO |
| Campo do formulário | campoFormulario | CD_FORMULARIO_CAMPO | int | não | FK → TB_FORMULARIO_CAMPO |
| Configuração de anexo | anexoConfiguracao | CD_ANEXO_CONFIGURACAO | int | não | FK → TB_ANEXO_CONFIGURACAO |
| Arquivo | arquivo | CD_ARQUIVO | int | não | referência a TB_ARQUIVO (sem FK declarada) ⚠️ |
| Nome do arquivo | nomeArquivo | NM_ARQUIVO | nvarchar(500) | sim | |
| Tipo MIME | tipoMime | DS_TIPO_MIME | nvarchar(100) | não | |
| Tamanho (bytes) | tamanhoBytes | NR_TAMANHO_BYTES | bigint | não | |
| Data do upload | dataUpload | DT_UPLOAD | datetime2(7) | automático | default getdate() |
| UUID do documento | uuid | CD_UUID | nvarchar(36) | sim | identificador público; único |

---

## Membro de Equipe da Inscrição
> **ALI: Inscrição** · entidade de suporte (membros da equipe inscrita)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO |
| Tipo de vínculo do membro | tipoVinculoMembro | CD_TIPO_VINCULO_MEMBRO | int | sim | FK → TB_TIPO_VINCULO_MEMBRO |
| Nome completo | nomeCompleto | NM_NOME_COMPLETO | nvarchar(300) | sim | → ver FIELD-DICTIONARY: Nome de pessoa |
| CPF | cpf | NR_CPF | nvarchar(14) | sim | → ver FIELD-DICTIONARY: CPF |
| E-mail | email | DS_EMAIL | nvarchar(200) | sim | → ver FIELD-DICTIONARY: E-mail |
| Telefone | telefone | NR_TELEFONE | nvarchar(20) | não | → ver FIELD-DICTIONARY: Telefone |
| Gênero | genero | DS_GENERO | nvarchar(50) | não | |
| Ordem | ordem | NR_ORDEM | int | automático | default 0 |

---

## Aceite de Termo do Participante
> **ALI: Inscrição** · entidade de suporte (aceites de termos vinculados à inscrição)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO |
| Termo de aceite | termoAceite | CD_TERMO_ACEITE | int | sim | FK → TB_TERMO_ACEITE |
| Aceito | aceito | FL_ACEITO | bit | automático | default 0 |
| Data do aceite | dataAceite | DT_ACEITE | datetime2(7) | não | |
| IP de origem | ipOrigem | DS_IP_ORIGEM | nvarchar(50) | não | |

---

## Histórico da Inscrição
> **ALI: Inscrição** · entidade de suporte (histórico de mudanças de status da inscrição)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO |
| Status anterior | statusAnterior | DS_STATUS_ANTERIOR | nvarchar(50) | não | texto com o nome do `StatusInscricaoEnum` anterior |
| Status novo | statusNovo | DS_STATUS_NOVO | nvarchar(50) | sim | texto com o nome do `StatusInscricaoEnum` novo |
| Usuário responsável | usuarioResponsavelId | CD_USUARIO_RESPONSAVEL | bigint | não | usuário externo (SSO/AD); sem FK local ⚠️ |
| Data da alteração | dataAlteracao | DT_ALTERACAO | datetime2(7) | automático | default getdate() |
| Observação | observacao | DS_OBSERVACAO | nvarchar(MAX) | não | Texto longo |
| Nome do responsável | nomeUsuarioResponsavel | NM_USUARIO_RESPONSAVEL | nvarchar(200) | não | desnormalizado |

---

## Item de Ajuste
> **ALI: Inscrição** · entidade de suporte (itens de ajuste solicitado ⚠️ — vinculados ao histórico; consumidos pela Validação)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Histórico da inscrição | inscricaoHistorico | CD_INSCRICAO_HISTORICO | int | sim | FK → TB_INSCRICAO_HISTORICO |
| Sequência | nrSequencia | NR_SEQUENCIA | int | sim | |
| Texto do ajuste ⚠️ | texto | DS_TEXTO | nvarchar(500) | sim | |
| Atendido | atendido | FL_ATENDIDO | bit | automático | default 0 |
| Data de atendimento | dataAtendido | DT_ATENDIDO | datetime2(7) | não | |
| Responsável pelo atendimento ⚠️ | nomeUsuarioResponsavel | NM_USUARIO_RESPONSAVEL | nvarchar(200) | não | desnormalizado |

---

## Rascunho Autossalvo
> **ALI: Inscrição** · entidade de suporte (log de autosave; sem os 6 campos globais — tabela de log)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO |
| Usuário | usuarioId | CD_USUARIO | bigint | não | usuário externo (SSO/AD); sem FK local ⚠️ |
| Snapshot (JSON) ⚠️ | jsonSnapshot | DS_JSON_SNAPSHOT | nvarchar(MAX) | não | Texto longo (JSON) |
| Data do autosave | dataAutosave | DT_AUTOSAVE | datetime2(7) | automático | default getdate() |
| IP de origem | ipOrigem | DS_IP_ORIGEM | nvarchar(50) | não | |

---

## Snapshot da Inscrição
> **ALI: Inscrição** · entidade de suporte (snapshots de estado da inscrição por rodada/etapa)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO |
| Histórico da inscrição | inscricaoHistorico | CD_INSCRICAO_HISTORICO | int | sim | FK → TB_INSCRICAO_HISTORICO; único por CD_INSCRICAO_HISTORICO+DS_TIPO |
| Tipo de snapshot | tipo | DS_TIPO | varchar(20) | sim | enum `TipoSnapshotEnum`: ANTES_AJUSTE · DEPOIS_AJUSTE · ANTES_EDICAO_ADMIN · DEPOIS_EDICAO_ADMIN |
| Rodada | rodada | NR_RODADA | int | sim | |
| Data de captura | dataCaptura | DT_CAPTURA | datetime2(7) | sim | |
| Estado (JSON) ⚠️ | jsonEstado | DS_JSON_ESTADO | nvarchar(MAX) | sim | Texto longo (JSON) |
| Usuário responsável | usuarioResponsavelId | CD_USUARIO_RESPONSAVEL | bigint | não | usuário externo (SSO/AD); sem FK local ⚠️ |

---

## Notificação Participante
> **ALI: Notificação Participante** · entidade principal

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | não | FK → TB_INSCRICAO |
| Usuário | usuarioId | CD_USUARIO | bigint | não | usuário externo (SSO/AD); sem FK local ⚠️ |
| Tipo de notificação | tipo | DS_TIPO | nvarchar(50) | não | texto livre; valores emitidos pelo código: BOAS_VINDAS · CONFIRMACAO · LEMBRETE · INSCRICAO_APROVADA · INSCRICAO_REJEITADA · AJUSTE_SOLICITADO |
| Título | titulo | NM_TITULO | nvarchar(500) | sim | |
| Mensagem | mensagem | DS_MENSAGEM | nvarchar(MAX) | não | Texto longo |
| Lida | lida | FL_LIDA | bit | automático | default 0 |
| Data de envio | dataEnvio | DT_ENVIO | datetime2(7) | automático | default getdate() |

---

## Arquivo (metadados)
> **ALI: — (não contado)** · suporte técnico ⚠️ — infra de arquivos sem ALI/PF próprio; storage compartilhado (documentos de inscrição, termos) e também usado pela Avaliação (AVL). Tabela sem os 6 campos globais.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Nome do arquivo | nome | NM_ARQUIVO | varchar(255) | não | |
| Tipo MIME | mime | NM_MIME | varchar(255) | não | |
| Tamanho (bytes) | tamanho | NR_TAMANHO | bigint | não | |
| Armazenado | stored | FL_STORED | char(1) | não | Coluna legada da base CNI — **nenhum ponto do código a escreve ou lê** (conferido em 2026-08-28); o conteúdo do arquivo vive sempre em TB_CONTEUDO_ARQUIVO |

---

## Conteúdo do Arquivo
> **ALI: — (não contado)** · suporte técnico ⚠️ — bytes do arquivo, 1:1 com Arquivo; sem ALI/PF próprio.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Arquivo | id | CD_ARQUIVO | int | sim | PK = FK → TB_ARQUIVO (relação 1:1) |
| Conteúdo (binário) | conteudo | BL_CONTEUDO | varbinary(MAX) | não | bytes do arquivo |

---

## Download de Arquivo
> **ALI: — (não contado)** · suporte técnico — infra de download temporário herdada da base CNI (`tb_download_arquivo`); emite um identificador não-adivinhável com validade para baixar um Arquivo. Tabela sem os 6 campos globais.
> ✅ Entidade **descoberta na conferência com o código** (2026-08-28) — não constava no schema de origem (`arquivos/modelo_dados.sql`) nem neste fragmento.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Identificador do download | uuid | CD_UUID | nvarchar(256) | não | Token não-adivinhável do link de download |
| Arquivo | arquivoId | CD_ARQUIVO | int | não | Referência a TB_ARQUIVO (sem FK declarada) ⚠️ |
| Data de criação | dataCriacao | DT_CRIACAO | datetime | não | Quando o link foi emitido |
| Data de expiração | dataExpiracao | DT_EXPIRACAO | datetime | não | Validade do link |
| Data do download | dataDownload | DT_DOWNLOAD | datetime | não | Quando o arquivo foi efetivamente baixado |

---

## Arquivos Lógicos deste domínio

> Contagem do baseline APF do sistema (PIEL_BASELINE_PF_CD — elaborador: equipe de métricas). RLR/DER conforme o baseline; o agrupamento físico é o mapeamento reverso.

| ALI / AIE | Tipo | Entidades constituintes | RLR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Inscrição | ALI | Inscrição (principal) · Resposta de Formulário · Resposta de Questão · Documento da Inscrição · Membro de Equipe · Aceite de Termo · Histórico · Item de Ajuste · Rascunho Autossalvo · Snapshot (subgrupos) | 11 | 85 | Alta | 15 | 2026-02-28 |
| Notificação Participante | ALI | Notificação Participante (principal) | 1 | 13 | Baixa | 7 | 2026-02-28 |

**Total deste domínio: 22 PF**

> ⚠️ **Arquivo** (TB_ARQUIVO + TB_CONTEUDO_ARQUIVO + TB_DOWNLOAD_ARQUIVO) é infra de arquivos compartilhada (documentos de inscrição, termos; também usada pela Avaliação) — **não é ALI contado** no baseline e entra sem PF próprio. `TB_DOWNLOAD_ARQUIVO` foi acrescentada na conferência com o código (2026-08-28) e segue o mesmo tratamento.

<details><summary>Memória de cálculo</summary>

**ALI: Inscrição** — RLR 11 · DER 85 · Alta · 15 PF (baseline APF)
- Constituintes físicos (engenharia reversa): TB_INSCRICAO (principal), TB_INSCRICAO_RESPOSTA (suporte: respostas do formulário dinâmico), TB_INSCRICAO_RESPOSTA_QUESTAO (suporte: respostas do questionário), TB_INSCRICAO_DOCUMENTO (suporte: documentos anexados), TB_MEMBRO_EQUIPE_INSCRICAO (suporte: membros da equipe), TB_ACEITE_PARTICIPANTE (suporte: aceites de termos), TB_INSCRICAO_HISTORICO (suporte: histórico de status), TB_AJUSTE_ITEM (suporte: itens de ajuste), TB_AUTOSAVE_LOG (suporte: rascunhos autosalvos), TB_INSCRICAO_SNAPSHOT (suporte: snapshots de estado).
- ⚠️ São 10 tabelas físicas para RLR 11 do baseline — RLR/DER são do baseline APF (autoritativo); a granularidade de RET do mapeamento físico pode diferir (ex.: um subgrupo lógico adicional referenciado).

**ALI: Notificação Participante** — RLR 1 · DER 13 · Baixa · 7 PF (baseline APF)
- Constituintes físicos (engenharia reversa): TB_NOTIFICACAO_PARTICIPANTE (principal).
- ⚠️ RLR/DER são do baseline APF (autoritativo); a granularidade de RET do mapeamento físico pode diferir.

**Suporte técnico (sem ALI/PF)** — TB_ARQUIVO (metadados) + TB_CONTEUDO_ARQUIVO (bytes)
- ⚠️ Infra de arquivos compartilhada com o módulo Avaliação (AVL); não dimensionada como ALI no baseline.

</details>
