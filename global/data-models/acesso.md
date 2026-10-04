<!-- docqui: 2.8.0 | prompt: PROMPT_REVERSE_ENGINEERING | atualizado: 2026-08-28 -->
# Data Model: Acesso e Gestão
> Fragmento do DATA-MODEL.md — cole apenas este arquivo nas sessões que envolvam o domínio Acesso e Gestão.
>
> **ALIs deste domínio**: Usuário · (entidades técnicas fora do baseline APF: Log de Auditoria, Controle de Migração ⚠️)
> ✅ **Label Dev conciliado com o código** (2026-08-28): cada Label Dev abaixo é o nome do atributo Java da entidade JPA correspondente em `br.com.cni.apipremioieltalentos.domain`. Onde o atributo é uma associação (`@ManyToOne`), o Label Dev é o nome da referência (ex.: `premiacao`), não `premiacaoId`. O **campo banco** é o `@Column(name=…)` transcrito exatamente.
> ⚠️ **Identidade externa**: a identidade central do usuário é EXTERNA (SSO/AD corporativo) — não há `TB_USUARIO` no schema; `CD_USUARIO` é `bigint` referenciando o diretório externo. Usuário é classificado como ALI no baseline APF pelos dados locais de vínculo por UF; a identidade em si é externa (SSO/AD) — candidata a AIE, confirmar.

---

## Usuário (vínculo por UF)
> **ALI: Usuário** · entidade principal (vínculo usuário↔UF; escopo dos administradores regionais; e-mail local)
> ⚠️ `CD_USUARIO` é a chave da identidade externa (SSO/AD) — não há tabela local de usuário; o vínculo por UF é o único dado de usuário persistido neste schema.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Usuário | codigoUsuario | CD_USUARIO | bigint | sim | Identidade externa (SSO/AD); não há TB_USUARIO no schema ⚠️ candidata a AIE; único por (Usuário, UF) |
| Unidade Federativa | uf | CD_UF | int | sim | FK → TB_UF; único por (Usuário, UF) |
| E-mail | email | VL_EMAIL | nvarchar(255) | não | E-mail local do vínculo; → ver FIELD-DICTIONARY: E-mail |

---

## Unidade Federativa
> **ALI: Usuário** · entidade de suporte (tabela de referência de UFs — siglas e nomes)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Sigla da UF | sigla | SG_UF | char(2) | sim | único |
| Nome da UF | nome | NM_UF | nvarchar(50) | sim | |

---

## Log de Auditoria
> **ALI: Log de Auditoria** · entidade técnica (append-only)
> ⚠️ ALI técnico não dimensionado no baseline APF (não consta nas 12 ALIs do baseline) — não soma PF.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Entidade auditada ⚠️ | entidade | NM_ENTIDADE | nvarchar(100) | sim | Nome da entidade/tabela auditada; parte do índice (Entidade auditada, Registro auditado) |
| Registro auditado ⚠️ | entidadeId | CD_ENTIDADE | int | sim | Id do registro auditado (polimórfico via Entidade auditada); sem FK ⚠️ |
| Ação | acao | DS_ACAO | varchar(20) | sim | Tipo de ação auditada — texto livre. ⚠️ **Tabela sem escrita no código** (2026-08-28): há `LogAuditoriaRepository`, mas nenhum serviço grava em `TL_LOG_AUDITORIA`; a trilha de auditoria efetiva do produto é `TB_INSCRICAO_HISTORICO` + `TB_AVALIACAO_HISTORICO` + `TB_INSCRICAO_SNAPSHOT` |
| Dados anteriores | dadosAnteriores | DS_DADOS_ANTERIORES | nvarchar(MAX) | não | Snapshot anterior (JSON/texto) |
| Dados novos | dadosNovos | DS_DADOS_NOVOS | nvarchar(MAX) | não | Snapshot posterior (JSON/texto) |
| Usuário | usuarioId | CD_USUARIO | int | sim | Usuário que executou a ação (identidade externa SSO/AD); ⚠️ aqui `int`, diverge do `bigint` usado em TB_USUARIO_UF |
| Data e hora | dataHora | DT_DATA_HORA | datetime2(7) | automático | Data/hora do evento (default `getdate()`) |

---

## Controle de Migração
> **ALI: Controle de Migração** · entidade técnica (infra de controle de migração)
> ⚠️ Infra de controle de migração — não é ALI de negócio e não consta no baseline APF; não soma PF.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Nome do script | nomeScript | NM_SCRIPT | nvarchar(50) | sim | PK natural (nome do script de migração); único |
| Data de execução | dataExecucao | DT_EXECUCAO | datetime2(7) | automático | default `sysutcdatetime()` |
| Executor | nomeExecutor | NM_EXECUTOR | nvarchar(100) | automático | default `suser_name()` (login do banco) |

---

## Pessoa (cadastro legado da base CNI)
> **ALI: — (não contado)** · entidade técnica herdada do projeto base CNI (`tb_pessoa`), com CRUD exposto em `/administracao/pessoas`. Não participa do fluxo da premiação (nenhuma entidade de negócio a referencia) e não consta no baseline APF.
> ✅ Entidade **descoberta na conferência com o código** (2026-08-28) — não constava no schema de origem (`arquivos/modelo_dados.sql`) nem neste fragmento. ⚠️ Confirmar se o cadastro deve permanecer no produto ou ser removido como resíduo do projeto base.

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Código CRM | crm | CD_CRM | varchar | não | Identificador no CRM corporativo |
| Nome completo | nomeCompleto | NM_COMPLETO | varchar | não | → ver FIELD-DICTIONARY: Nome de pessoa |
| Codinome | codinome | NM_CODINOME | varchar | não | |
| Sexo | sexo | NM_SEXO | varchar | não | enum `SexoEnum`: MASCULINO · FEMININO · NAO_INFORMADO |
| Cargo | cargo | NM_CARGO | varchar | não | |
| Cargo no cartão | cargoCartao | NM_CARGO_CARTAO | varchar | não | |
| CPF | cpf | NR_CPF | varchar | não | → ver FIELD-DICTIONARY: CPF |
| E-mail | email | NM_EMAIL | varchar | não | → ver FIELD-DICTIONARY: E-mail |
| Telefone principal | telefonePrincipal | NR_TELEFONE_PRINCIPAL | varchar | não | → ver FIELD-DICTIONARY: Telefone |
| Celular | celular | NR_CELULAR | varchar | não | → ver FIELD-DICTIONARY: Telefone |
| Estado | estado | NM_ESTADO | varchar | não | |
| Estado da empresa | estadoEmpresa | NM_ESTADO_EMPRESA | varchar | não | |
| Razão social | razaoSocial | NM_RAZAO_SOCIAL | varchar | não | |
| Nome fantasia | nomeFantasia | NM_FANTASIA | varchar | não | |
| CNPJ | cnpj | NR_CNPJ | varchar | não | → ver FIELD-DICTIONARY: CNPJ |
| Tipo de cadastro | tipoCadastro | IND_TIPO_CADASTRO | varchar | não | enum `TipoCadastroEnum`: CARGA · RECEPCAO · CADASTRO |
| Data de criação | dataCriacao | DT_CRIACAO | datetime | não | |
| Data de alteração | dataAlteracao | DT_ALTERACAO | datetime | não | |
| Foto | foto | CD_FOTO | int | não | Referência a TB_ARQUIVO |

---

## Arquivos Lógicos deste domínio

> Contagem do baseline APF do sistema (PIEL_BASELINE_PF_CD — elaborador: equipe de métricas). RLR/DER conforme o baseline; o agrupamento físico é o mapeamento reverso. Log de Auditoria, Controle de Migração e Pessoa são entidades técnicas ⚠️ fora do baseline — não somam PF.

| ALI / AIE | Tipo | Entidades constituintes | RLR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Usuário | ALI | Usuário (vínculo por UF) (principal) · Unidade Federativa (referência) | 3 | 8 | Baixa | 7 | 2026-02-28 |
| Log de Auditoria | técnico ⚠️ | Log de Auditoria (TL_LOG_AUDITORIA) | — | — | — | — (fora do baseline) | — |
| Controle de Migração | técnico ⚠️ | Controle de Migração (TB_MIGRACAO_MANUAL) | — | — | — | — (fora do baseline) | — |
| Pessoa | técnico ⚠️ | Pessoa (TB_PESSOA — cadastro legado da base CNI) | — | — | — | — (fora do baseline) | — |

**Total deste domínio: 7 PF**

<details><summary>Memória de cálculo</summary>

**ALI: Usuário** — RLR 3 · DER 8 · Baixa · 7 PF (baseline APF)
- Constituintes físicos (engenharia reversa): TB_USUARIO_UF (principal: vínculo usuário↔UF, e-mail local), TB_UF (suporte: referência de UFs).
- ⚠️ Identidade externa: a identidade central do usuário é EXTERNA (SSO/AD); `CD_USUARIO` é `bigint` referenciando o diretório — não há TB_USUARIO. Usuário é ALI no baseline pelos dados locais de vínculo por UF; a identidade em si é candidata a AIE (SSO/AD) — confirmar.
- ⚠️ RLR/DER são do baseline APF (autoritativo); a granularidade de RET/DER do mapeamento físico pode diferir — o DER 8 do baseline supera as 3 colunas de negócio físicas de TB_USUARIO_UF.

**Entidades técnicas (não dimensionadas no baseline APF)** ⚠️
- Log de Auditoria (TL_LOG_AUDITORIA): audit log append-only; não consta nas 12 ALIs do baseline — não soma PF.
- Controle de Migração (TB_MIGRACAO_MANUAL): infra de controle de migração de banco; não é entidade de negócio — não soma PF.
- Pessoa (TB_PESSOA): cadastro legado herdado do projeto base CNI, com CRUD em `/administracao/pessoas`; nenhuma entidade de negócio da premiação o referencia — não soma PF. ⚠️ Confirmar se permanece no produto.

</details>
