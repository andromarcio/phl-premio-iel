<!-- docqui: 4.1.0 | prompt: PROMPT_REVERSE_ENGINEERING | atualizado: 2026-10-04 -->
# Data Model: Validação
> Fragmento do DATA-MODEL.md — cole apenas este arquivo nas sessões que envolvam o domínio Validação.
>
> **ALIs deste domínio**: Validação Inscrição · Auditoria de E-mails
> ✅ **Label Dev conciliado com o código** (2026-08-28): cada Label Dev abaixo é o nome do atributo Java da entidade JPA correspondente em `br.com.cni.apipremioieltalentos.domain`. Onde o atributo é uma associação (`@ManyToOne`), o Label Dev é o nome da referência (ex.: `premiacao`), não `premiacaoId`. O **campo banco** é o `@Column(name=…)` transcrito exatamente.

---

## Validação de Inscrição
> **ALI: Validação Inscrição** · entidade principal

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Inscrição | inscricao | CD_INSCRICAO | int | sim | FK → TB_INSCRICAO |
| Usuário validador | usuarioValidadorId | CD_USUARIO_VALIDADOR | bigint | não | Identidade externa (SSO/AD) — sem FK local no schema ⚠️ |
| Status da validação | statusValidacao | DS_STATUS_VALIDACAO | nvarchar(50) | sim | texto com o nome do `StatusInscricaoEnum` resultante — o código grava apenas VALIDADA ou REJEITADA |
| Parecer | parecer | DS_PARECER | nvarchar(MAX) | não | Texto longo |
| Data da validação | dataValidacao | DT_VALIDACAO | datetime2(7) | automático | default `getdate()` |

---

## Auditoria de E-mail
> **ALI: Auditoria de E-mails** · entidade principal

Tabela de log de envio de e-mails: registra remetente, destinatários, conteúdo e situação de cada disparo. Não possui os 6 campos globais padrão do sistema (criado/atualizado por/em, ativo) — é log próprio. Desde a **V00034** o registro também diz **a que** o e-mail se refere: até então a auditoria guardava o e-mail e não o ligava à inscrição, de modo que não havia como saber se um participante já tinha recebido o feedback de uma etapa.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Remetente | from | VL_FROM | varchar(255) | não | Endereço de e-mail do remetente (From) ⚠️ → ver FIELD-DICTIONARY: E-mail |
| Destinatários | to | VL_TO | varchar(MAX) | não | Endereço(s) de e-mail (To) ⚠️ → ver FIELD-DICTIONARY: E-mail |
| Com cópia (Cc) | cc | VL_CC | varchar(MAX) | não | Endereço(s) em cópia ⚠️ → ver FIELD-DICTIONARY: E-mail |
| Cópia oculta (Cco) | bcc | VL_BCC | varchar(MAX) | não | Endereço(s) em cópia oculta ⚠️ → ver FIELD-DICTIONARY: E-mail |
| Assunto | subject | VL_SUBJECT | varchar(500) | não | |
| Corpo | body | VL_BODY | text | não | Corpo da mensagem |
| Corpo em HTML | html | FL_HTML | bit | automático | default 1 (verdadeiro); indica corpo em HTML ⚠️ |
| Data/hora da solicitação | tsSolicitacao | TS_SOLICITACAO | datetime2(7) | sim | Timestamp da solicitação de envio |
| Data/hora do envio | tsEnvio | TS_ENVIO | datetime2(7) | não | Timestamp do envio efetivo (nulo enquanto não enviado) |
| Login do solicitante | login | NM_LOGIN | varchar(255) | não | Login de quem solicitou o envio ⚠️ |
| Status do envio | status | STATUS | varchar(50) | sim | enum `StatusAuditoriaEmail`: AGUARDANDO · ENVIADO · FALHA · SUSPENSO |
| Mensagem de erro | erro | ERRO | varchar(MAX) | não | Detalhe do erro de envio, quando houver |
| Tipo do e-mail | tipoEmail | DS_TIPO_EMAIL | varchar(50) | não | V00034 · enum `TipoEmailEnum` → ver `global/data-models/configuracao.md`, *Configuração de E-mail da Premiação* · índice `IX_AUD_EMAIL_INSC_TIPO` (inscrição + tipo) |
| Inscrição | inscricao | CD_INSCRICAO | int | não | V00034 · FK → TB_INSCRICAO · inscrição destinatária |
| Etapa | etapa | CD_ETAPA | int | não | V00034 · FK → TB_ETAPA · etapa a que o e-mail se refere |
| Disparo de feedback | disparoFeedback | CD_DISPARO_FEEDBACK | int | não | V00034 · FK → TB_DISPARO_FEEDBACK → ver `global/data-models/avaliacao.md`, *Disparo de Feedback* · índice `IX_AUD_EMAIL_DISPARO` |

Os e-mails registrados antes da V00034 ficam com as quatro colunas vazias.

---

## Anexo de Auditoria de E-mail
> **ALI: Auditoria de E-mails** · entidade de suporte (anexos do e-mail)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| E-mail auditado | auditoriaEmail | CD_AUDITORIA_EMAIL | bigint | sim | FK → TB_AUDITORIA_EMAIL |
| Nome do arquivo | name | VL_NAME | varchar(255) | sim | |
| Conteúdo do arquivo | data | BL_DATA | varbinary(MAX) | não | Bytes do anexo |
| Tipo MIME | mimeType | VL_MIME_TYPE | varchar(255) | não | |
| Tamanho (bytes) | length | VL_LENGTH | bigint | não | Tamanho do anexo em bytes |
| Anexo inline | inline | FL_INLINE | bit | automático | default 0 (falso); indica anexo embutido no corpo ⚠️ |

---

## Arquivos Lógicos deste domínio

> Contagem do baseline APF do sistema (PIEL_BASELINE_PF_CD — elaborador: equipe de métricas). RLR/DER conforme o baseline; o agrupamento físico é o mapeamento reverso.

| ALI / AIE | Tipo | Entidades constituintes | RLR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Validação Inscrição | ALI | Validação de Inscrição (principal) | 3 | 23 | Média | 10 | 2026-02-28 |
| Auditoria de E-mails | ALI | Auditoria de E-mail (principal) · Anexo de Auditoria de E-mail, Disparo de Feedback (subgrupos) | 3 | 36 | Média | 10 | 2026-10-04 |

**Total deste domínio: 20 PF**

<details><summary>Memória de cálculo</summary>

**ALI: Validação Inscrição** — RLR 3 · DER 23 · Média · 10 PF (baseline APF)
- Constituintes físicos (engenharia reversa): TB_VALIDACAO_INSCRICAO (principal).
- ⚠️ RLR 3 do baseline inclui subgrupos referenciados (itens de ajuste e histórico de status) que fisicamente vivem no domínio INS (TB_AJUSTE_ITEM, TB_INSCRICAO_HISTORICO) — apenas TB_VALIDACAO_INSCRICAO reside neste domínio.
- ⚠️ RLR/DER são do baseline APF (autoritativo); a granularidade de RET do mapeamento físico pode diferir.

**ALI: Auditoria de E-mails** — RLR 3 · DER 36 · Média · 10 PF (baseline APF de 2026-02-28, revisto em 2026-10-04)
- A **V00034** levou o RLR de 2 a 3 e o DER de 20 a 36, **sem mover o PF**: entraram as quatro colunas de ligação em `TB_AUDITORIA_EMAIL` (tipo, inscrição, etapa, disparo) e o subgrupo **Disparo de Feedback** (`TB_DISPARO_FEEDBACK`, 11 DER + auditoria), cuja definição vive em `global/data-models/avaliacao.md` por ser do domínio Avaliação. RLR 3 × DER 36 segue na faixa de 20 a 50 DET, Média. ⚠️ A classificação do Disparo de Feedback como subgrupo deste ALI, e não como ALI próprio, está pendente de confirmação da métrica — ver `arquivos/demandas/ANALISE_IMPACTO_SP06.md`, seção 5.
- Constituintes físicos (engenharia reversa): TB_AUDITORIA_EMAIL (principal), TB_ANEXO_AUDITORIA_EMAIL (suporte: anexos do e-mail).
- ⚠️ RLR/DER são do baseline APF (autoritativo); a granularidade de RET do mapeamento físico pode diferir.

</details>
