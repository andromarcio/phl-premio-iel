<!-- docqui: 4.1.0 | prompt: PROMPT_REVERSE_ENGINEERING | atualizado: 2026-10-05 -->
# Data Model: Avaliação
> Fragmento do DATA-MODEL.md — cole apenas este arquivo nas sessões que envolvam o domínio Avaliação.
>
> **ALIs deste domínio**: Alocação Avaliadores · Avaliação de Inscrição
> ✅ **Label Dev conciliado com o código** (2026-08-28): cada Label Dev abaixo é o nome do atributo Java da entidade JPA correspondente em `br.com.cni.apipremioieltalentos.domain`. Onde o atributo é uma associação (`@ManyToOne`), o Label Dev é o nome da referência (ex.: `premiacao`), não `premiacaoId`. O **campo banco** é o `@Column(name=…)` transcrito exatamente.
> ✅ **Conciliado com as migrações da Sprint 6** (2026-10-04): a **V00035** acrescentou as cinco colunas da desclassificação manual em `TB_APROVACAO_ETAPA_PARTICIPANTE` (entidade *Apuração por Etapa*) e a **V00034** criou `TB_DISPARO_FEEDBACK` (entidade *Disparo de Feedback*, nova abaixo). As duas são scripts manuais idempotentes, controlados por `TB_MIGRACAO_MANUAL`, e nenhuma apaga ou altera dado existente.
> **PF no baseline APF**: os dois ALIs deste domínio somam **17 PF** (Avaliação de Inscrição 10 · Alocação Avaliadores 7). Apareciam zerados na coluna *PF Fábrica de Software* da planilha — coluna que a equipe de métricas confirmou ser falha de preenchimento e mandou desconsiderar (2026-08-28). Ver `## Arquivos Lógicos deste domínio`.

---

## Alocação de Avaliadores
> **ALI: Alocação Avaliadores** · entidade principal

Alocação de um avaliador a um grupo de avaliação (etapa × oferta tipo×modalidade×categoria). Define quem avalia qual conjunto de inscrições dentro de uma etapa.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Etapa | etapa | CD_ETAPA | int | sim | FK → TB_ETAPA · único por etapa+oferta+avaliador |
| Oferta (tipo × modalidade × categoria) | tipoParticipanteModCat | CD_TIPO_PART_MOD_CAT | int | sim | FK → TB_TIPO_PART_MOD_CAT · oferta tipo×modalidade×categoria ⚠️ · único por etapa+oferta+avaliador |
| Avaliador | usuarioAvaliadorId | CD_USUARIO_AVALIADOR | bigint | sim | Identidade externa (SSO/AD) — sem FK local no schema ⚠️ · único por etapa+oferta+avaliador |
| Situação | situacao | DS_SITUACAO | varchar(20) | automático | enum `SituacaoAlocacaoAvaliacaoEnum`: ATIVA (default) · REMOVIDA |
| Nome do avaliador | nomeAvaliador | NM_AVALIADOR | nvarchar(200) | não | Nome desnormalizado do avaliador |
| Login do avaliador | loginAvaliador | LG_AVALIADOR | nvarchar(200) | não | Login desnormalizado do avaliador |

---

## Avaliação de Inscrição
> **ALI: Avaliação de Inscrição** · entidade principal

Alocação e avaliação de uma inscrição por um avaliador (etapa × inscrição × avaliador). Guarda a situação, o status do fluxo de avaliação e o feedback do avaliador.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Etapa | etapa | CD_ETAPA | int | sim | FK → TB_ETAPA · único por etapa+inscrição+avaliador |
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO · único por etapa+inscrição+avaliador |
| Avaliador | usuarioAvaliadorId | CD_USUARIO_AVALIADOR | bigint | sim | Identidade externa (SSO/AD) — sem FK local no schema ⚠️ · único por etapa+inscrição+avaliador |
| Situação | situacao | DS_SITUACAO | varchar(20) | automático | enum `SituacaoAlocacaoAvaliacaoEnum`: ATIVA (default) · REMOVIDA |
| Status da avaliação | statusAvaliacao | DS_STATUS_AVALIACAO | varchar(30) | automático | enum `StatusAvaliacaoEnum`: A_INICIAR (default) · EM_ANDAMENTO · FINALIZADA |
| Início da avaliação | dataInicio | DT_INICIO | datetime2(7) | não | |
| Finalização da avaliação | dataFinalizacao | DT_FINALIZACAO | datetime2(7) | não | |
| Nome do avaliador | nomeAvaliador | NM_AVALIADOR | nvarchar(200) | não | Nome desnormalizado do avaliador |
| Login do avaliador | loginAvaliador | LG_AVALIADOR | nvarchar(200) | não | Login desnormalizado do avaliador |
| Feedback do avaliador | feedbackAvaliador | DS_FEEDBACK_AVALIADOR | nvarchar(MAX) | não | Texto longo |

---

## Nota de Avaliação
> **ALI: Avaliação de Inscrição** · entidade de suporte (notas por questão)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Avaliação da inscrição | alocacao | CD_ALOCACAO_AVALIADOR_PARTICIPANTE | int | sim | FK → TB_ALOCACAO_AVALIADOR_PARTICIPANTE ⚠️ (registro de avaliação da inscrição) · único por avaliação+questão |
| Questão de avaliação | questaoAvaliacao | CD_QUESTAO_AVALIACAO | int | sim | FK → TB_QUESTAO_AVALIACAO · único por avaliação+questão |
| Valor da nota | valor | NR_VALOR | int | sim | Nota atribuída à questão ⚠️ |

---

## Histórico de Avaliação
> **ALI: Avaliação de Inscrição** · entidade de suporte (histórico de status da avaliação)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Avaliação da inscrição | alocacao | CD_ALOCACAO_AVALIADOR_PARTICIPANTE | int | sim | FK → TB_ALOCACAO_AVALIADOR_PARTICIPANTE ⚠️ (registro de avaliação da inscrição) |
| Status anterior | statusAnterior | DS_STATUS_ANTERIOR | varchar(30) | não | enum `StatusAvaliacaoEnum`: A_INICIAR · EM_ANDAMENTO · FINALIZADA |
| Status novo | statusNovo | DS_STATUS_NOVO | varchar(30) | sim | enum `StatusAvaliacaoEnum`: A_INICIAR · EM_ANDAMENTO · FINALIZADA |
| Usuário responsável | usuarioResponsavelId | CD_USUARIO_RESPONSAVEL | bigint | não | Identidade externa (SSO/AD) — sem FK local no schema ⚠️ |
| Nome do responsável | nomeUsuarioResponsavel | NM_USUARIO_RESPONSAVEL | nvarchar(200) | não | |
| Data da alteração | dataAlteracao | DT_ALTERACAO | datetime2(7) | automático | default `getdate()` |
| Observação | observacao | DS_OBSERVACAO | nvarchar(MAX) | não | Texto longo |

---

## Apuração por Etapa
> **ALI: Avaliação de Inscrição** · entidade de suporte (apuração da inscrição por etapa: média, premiado, feedback consolidado, desclassificação)

Consolida o resultado de uma inscrição em uma etapa: média calculada, contagem de avaliadores, feedback consolidado (com marcação de geração por IA), indicação de premiado e, desde a V00035, a desclassificação manual decidida pelo Administrador Nacional.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO · único por inscrição+etapa |
| Etapa | etapa | CD_ETAPA | int | sim | FK → TB_ETAPA · único por inscrição+etapa |
| Status | status | DS_STATUS | varchar(30) | não | enum `StatusAprovacaoEtapaEnum`: APROVADO · REPROVADO (derivado do corte `NR_CLASSIFICADOS` no fechamento da etapa) |
| Usuário responsável | usuarioResponsavelId | CD_USUARIO_RESPONSAVEL | bigint | não | Identidade externa (SSO/AD) — sem FK local no schema ⚠️ |
| Nome do responsável | nomeUsuarioResponsavel | NM_USUARIO_RESPONSAVEL | nvarchar(200) | não | |
| Data da decisão | dataDecisao | DT_DECISAO | datetime2(7) | não | |
| Observação | observacao | DS_OBSERVACAO | nvarchar(MAX) | não | Texto longo |
| Média calculada | mediaCalculada | VL_MEDIA_CALCULADA | decimal(5,2) | não | Média das notas dos avaliadores |
| Avaliadores finalizados | qtdAvaliadoresFinalizados | QT_AVALIADORES_FINALIZADOS | int | automático | default 0 |
| Avaliadores alocados | qtdAvaliadoresAlocados | QT_AVALIADORES_ALOCADOS | int | automático | default 0 |
| Feedback consolidado | feedbackConsolidado | DS_FEEDBACK_CONSOLIDADO | nvarchar(MAX) | não | Texto longo |
| Feedback consolidado em | feedbackConsolidadoEm | DT_FEEDBACK_CONSOLIDADO_EM | datetime2(7) | não | |
| Feedback consolidado por | feedbackConsolidadoPorId | CD_FEEDBACK_CONSOLIDADO_POR | bigint | não | Identidade externa (SSO/AD) — sem FK local no schema ⚠️ |
| Nome de quem consolidou | feedbackConsolidadoPorNome | NM_FEEDBACK_CONSOLIDADO_POR | nvarchar(200) | não | |
| Feedback gerado por IA | feedbackGeradoPorIa | FL_FEEDBACK_GERADO_POR_IA | bit | automático | default 0 (falso) |
| Premiado | premiado | FL_PREMIADO | bit | automático | default 0 (falso) |
| Desclassificado | desclassificado | FL_DESCLASSIFICADO | bit | automático | default 0 (falso) — V00035 |
| Justificativa da desclassificação | justificativaDesclassificacao | DS_JUSTIFICATIVA_DESCLASSIFICACAO | nvarchar(100) | não | V00035 · obrigatória quando `FL_DESCLASSIFICADO = 1`, garantido pela constraint `CK_APROV_ETAPA_PART_DESCLASSIF` |
| Data da desclassificação | dataDesclassificacao | DT_DESCLASSIFICACAO | datetime2(7) | não | V00035 |
| Usuário da desclassificação | usuarioDesclassificacaoId | CD_USUARIO_DESCLASSIFICACAO | bigint | não | V00035 · Identidade externa (SSO/AD) — sem FK local no schema ⚠️ |
| Nome de quem desclassificou | nomeUsuarioDesclassificacao | NM_USUARIO_DESCLASSIFICACAO | nvarchar(200) | não | V00035 |

**Restrição de banco** — `CK_APROV_ETAPA_PART_DESCLASSIF`: impede gravar a inscrição como desclassificada sem justificativa preenchida. Os registros anteriores à V00035 recebem `FL_DESCLASSIFICADO = 0` e as demais colunas vazias.

---

## Critério de Desempate
> **ALI: Avaliação de Inscrição** · entidade de suporte (critérios de desempate da premiação)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO · único por premiação+ordem e por premiação+questão |
| Questão de avaliação | questaoAvaliacao | CD_QUESTAO_AVALIACAO | int | sim | FK → TB_QUESTAO_AVALIACAO · único por premiação+questão |
| Ordem do critério | ordem | NR_ORDEM | int | sim | Ordem de aplicação do desempate · único por premiação+ordem |

---

## Decisão de Desempate
> **ALI: Avaliação de Inscrição** · entidade de suporte (decisões de desempate por etapa)

Não possui os campos globais de criação/atualização (criado/atualizado por/em); mantém apenas `FL_ATIVO` além dos campos de negócio.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Etapa | etapa | CD_ETAPA | int | sim | FK → TB_ETAPA |
| Justificativa | justificativa | DS_JUSTIFICATIVA | nvarchar(1000) | sim | |
| Usuário responsável | usuarioResponsavelId | CD_USUARIO_RESPONSAVEL | bigint | sim | Identidade externa (SSO/AD) — sem FK local no schema ⚠️ |
| Nome do responsável | nomeUsuarioResponsavel | NM_USUARIO_RESPONSAVEL | nvarchar(200) | sim | |
| Data da decisão | dataDecisao | DT_DECISAO | datetime2(7) | automático | default `getdate()` |
| Tipo de corte | tipoCorte | DS_TIPO_CORTE | varchar(15) | automático | enum `TipoCorteEnum`: CLASSIFICACAO (default — quem avança) · PREMIACAO (quem entra no pódio da etapa) |

---

## Inscrição da Decisão de Desempate
> **ALI: Avaliação de Inscrição** · entidade de suporte (inscrições abrangidas por cada decisão de desempate)

Tabela de vínculo entre a decisão de desempate e as inscrições afetadas; contém apenas a PK e os campos de negócio (sem os campos globais do sistema).

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Decisão de desempate | decisao | CD_DESEMPATE_DECISAO | int | sim | FK → TB_DESEMPATE_DECISAO · único por decisão+inscrição |
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO · único por decisão+inscrição |
| Status decidido | statusDecidido | DS_STATUS_DECIDIDO | varchar(15) | sim | enum `StatusAprovacaoEtapaEnum`: APROVADO · REPROVADO |

---

## Fechamento de Etapa por UF
> **ALI: Avaliação de Inscrição** · entidade de suporte (fechamento de etapa por UF)

> **Reabertura apaga o registro** *(decidido em 2026-09-01)*: reabrir um estado **remove a linha** desta entidade, em vez de marcá-la com uma situação. Por isso não há coluna de situação (`FECHADA`/`REABERTA`) nem data/responsável de reabertura — e, como consequência aceita, **não fica trilha dos fechamentos anteriores** de um mesmo estado. → ver `AVL-APU-03` (Encerrar Etapa por UF), regra 11.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Etapa | etapa | CD_ETAPA | int | sim | FK → TB_ETAPA · único por etapa+UF |
| UF | uf | CD_UF | int | não | FK → TB_UF · único por etapa+UF (nulo = fechamento nacional) ⚠️ |
| Data do fechamento | dataFechamento | DT_FECHAMENTO | datetime2(7) | sim | |
| Usuário responsável | usuarioResponsavelId | CD_USUARIO_RESPONSAVEL | bigint | sim | Identidade externa (SSO/AD) — sem FK local no schema ⚠️ |
| Nome do responsável | nomeUsuarioResponsavel | NM_USUARIO_RESPONSAVEL | varchar(200) | sim | |
| Observação | observacao | DS_OBSERVACAO | varchar(500) | não | |

---

## Termo de Confidencialidade
> **ALI: Avaliação de Inscrição** · entidade de suporte (termo de confidencialidade do avaliador)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO · único por premiação (termo ativo) |
| Título | titulo | NM_TITULO | nvarchar(500) | não | |
| Tipo | tipo | DS_TIPO | varchar(10) | sim | enum `TipoTermoConfidencialidadeEnum`: TEXTO (HTML rico exibido inline) · ANEXO (arquivo baixado antes do aceite) |
| Texto (HTML) | textoHtml | DS_TEXTO_HTML | nvarchar(MAX) | não | Texto longo |
| Arquivo do termo | arquivo | CD_ARQUIVO | int | não | FK → TB_ARQUIVO |

---

## Aceite do Termo de Confidencialidade
> **ALI: Avaliação de Inscrição** · entidade de suporte (aceites do termo pelos avaliadores)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Termo de confidencialidade | termo | CD_TERMO_CONFIDENCIALIDADE | int | sim | FK → TB_TERMO_CONFIDENCIALIDADE |
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO · único por avaliador+premiação |
| Avaliador | usuarioAvaliadorId | CD_USUARIO_AVALIADOR | bigint | sim | Identidade externa (SSO/AD) — sem FK local no schema ⚠️ · único por avaliador+premiação |
| Nome do avaliador | nomeAvaliador | NM_AVALIADOR | nvarchar(200) | não | |
| Login do avaliador | loginAvaliador | LG_AVALIADOR | nvarchar(200) | não | |
| Data do aceite | dataAceite | DT_ACEITE | datetime2(7) | não | |
| IP de origem | ipOrigem | DS_IP_ORIGEM | nvarchar(50) | não | Endereço IP registrado no aceite |

---

## Disparo de Feedback
> **ALI: Auditoria de E-mails** · entidade de suporte (lotes de envio do feedback da etapa) — o ALI é do domínio Validação; ver `global/data-models/validacao.md`

Registra cada disparo de feedback que o Administrador Nacional faz para os participantes de uma etapa: quem disparou, quando, o recorte escolhido e quantos e-mails o lote gerou. Um registro por disparo; os e-mails que ele produziu ficam em `TB_AUDITORIA_EMAIL`, ligados por `CD_DISPARO_FEEDBACK`. Criada pela **V00034**.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Disparo de feedback | id | CD_DISPARO_FEEDBACK | int IDENTITY(1,1) | automático | PK |
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO |
| Etapa | etapa | CD_ETAPA | int | sim | FK → TB_ETAPA · índice `IX_DISP_FEEDBACK_ETAPA` |
| Unidade federativa | uf | CD_UF | int | não | FK → TB_UF · preenchida apenas quando o disparo foi recortado por estado |
| Data do disparo | dataDisparo | DT_DISPARO | datetime2(7) | sim | |
| Usuário responsável | usuarioResponsavelId | CD_USUARIO_RESPONSAVEL | bigint | sim | Identidade externa (SSO/AD) — sem FK local no schema ⚠️ |
| Nome do responsável | nomeUsuarioResponsavel | NM_USUARIO_RESPONSAVEL | varchar(200) | sim | |
| Selecionados | qtdSelecionados | QT_SELECIONADOS | int | sim | Participantes selecionados no disparo |
| Enfileirados | qtdEnfileirados | QT_ENFILEIRADOS | int | sim | E-mails colocados na fila |
| Sem e-mail | qtdSemEmail | QT_SEM_EMAIL | int | sim | Participantes sem e-mail cadastrado |
| Observação | observacao | DS_OBSERVACAO | varchar(500) | não | |

Campos globais: estende `Auditavel` — `CD_CRIADO_POR`, `DT_CRIADO_EM`, `CD_ATUALIZADO_POR`, `DT_ATUALIZADO_EM`, `FL_ATIVO`. → ver `global/MASTER.md`, *Campos globais obrigatórios em toda tabela*.

⚠️ **Classificação a confirmar com a métrica.** A entidade está registrada como **subgrupo do ALI Auditoria de E-mails**, porque o dado que ela guarda é o lote dos e-mails enviados e a ligação é direta (`TB_AUDITORIA_EMAIL.CD_DISPARO_FEEDBACK`). A leitura alternativa — grupo lógico próprio, mantido por transação própria e consultado como registro de negócio — a tornaria um **ALI novo** de RLR 1 × DER 11, **Baixa**, 7 PF. A opção adotada é a conservadora: não cria função de dados nova. Ver `analise-impacto/AIM-SP06.md`, *Decisões de produto pendentes*.

---

## Arquivos Lógicos deste domínio

> Contagem do baseline APF do sistema (PIEL_BASELINE_PF_CD — elaborador: equipe de métricas). RLR/DER conforme o baseline; o agrupamento físico é o mapeamento reverso.
> A coluna **PF** reproduz o **PF Bruto (PFB)** do baseline — a mesma base do `DATA-MODEL.md`, cujos 12 ALIs somam 117 PF. A coluna *PF Fábrica de Software*, que zerava estes dois ALIs, foi descartada pela equipe de métricas como falha de preenchimento (2026-08-28).

| ALI / AIE | Tipo | Entidades constituintes | RLR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Avaliação de Inscrição | ALI | Avaliação de Inscrição (principal) · Nota de Avaliação, Histórico de Avaliação, Apuração por Etapa, Critério/Decisão de Desempate + Inscrição da Decisão, Fechamento de Etapa por UF, Termo de Confidencialidade + Aceite (subgrupos) | 3 | 43 | Média | 10 | 2026-10-04 |
| Alocação Avaliadores | ALI | Alocação de Avaliadores (principal) | 1 | 12 | Baixa | 7 | 2026-02-28 |

**Total deste domínio: 17 PF**

<details><summary>Memória de cálculo</summary>

**ALI: Avaliação de Inscrição** — RLR 3 · DER 43 · Média · **10 PF** (baseline APF de 2026-02-28, revisto em 2026-10-04)
- Constituintes físicos (engenharia reversa): TB_ALOCACAO_AVALIADOR_PARTICIPANTE (principal), TB_AVALIACAO_NOTA (notas por questão), TB_AVALIACAO_HISTORICO (histórico de status), TB_APROVACAO_ETAPA_PARTICIPANTE (apuração por etapa: média/premiado/feedback consolidado + IA), TB_DESEMPATE_CRITERIO / TB_DESEMPATE_DECISAO / TB_DESEMPATE_DECISAO_INSCRICAO (desempate), TB_FECHAMENTO_ETAPA_UF (fechamento por UF), TB_TERMO_CONFIDENCIALIDADE e TB_ACEITE_TERMO_CONFIDENCIALIDADE (termo de confidencialidade e aceites).
- A **V00035** levou o DER de 38 a 43 (as cinco colunas da desclassificação em *Apuração por Etapa*), **sem mover o PF**: RLR 3 × DER 43 segue na faixa de 20 a 50 DET, Média. Os 10 PF conferem com a Tabela 1 do CPM para RLR 3 × DER 43 (Média). Aparecia zerado na coluna *PF Fábrica de Software*, descartada como falha de preenchimento (Q1 do questionamento à métrica, respondida em 2026-08-28).
- ⚠️ RLR/DER são do baseline APF (autoritativo); a granularidade de RET do mapeamento físico pode diferir.

**ALI: Alocação Avaliadores** — RLR 1 · DER 12 · Baixa · **7 PF** (baseline APF)
- Constituintes físicos (engenharia reversa): TB_ALOCACAO_AVALIADOR_GRUPO (principal — alocação por grupo etapa×oferta tipo×modalidade×categoria).
- Os 7 PF conferem com a Tabela 1 do CPM para RLR 1 × DER 12 (Baixa). Aparecia zerado na coluna *PF Fábrica de Software*, descartada como falha de preenchimento (Q1 do questionamento à métrica, respondida em 2026-08-28).
- ⚠️ RLR/DER são do baseline APF (autoritativo); a granularidade de RET do mapeamento físico pode diferir.

</details>
