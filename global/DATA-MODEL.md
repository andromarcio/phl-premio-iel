<!-- docqui: 4.1.0 | prompt: PROMPT_REVERSE_ENGINEERING | atualizado: 2026-10-05 -->
# DATA-MODEL.md
> **Índice e fonte de verdade** para nomenclatura e mapeamento de campos. Os modelos detalhados estão fragmentados por domínio em `global/data-models/` — cole apenas o fragmento do domínio em trabalho, não o arquivo inteiro.
>
> **Origem**: engenharia reversa do schema físico (`arquivos/modelo_dados.sql`, SQL Server, 59 tabelas) cruzada com o baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`) e **conciliada com o código-fonte** em 2026-08-28 — entidades JPA de `Projeto_Premio_IEL_Talentos_Backend` (`br.com.cni.apipremioieltalentos.domain`, 60 entidades mapeadas) e migrações `src/main/resources/db/migration/consolidado/V00001..V00033`. Toda definição física — entidade/tabela, Label Dev, campo banco, tipo SQL, FK, índice, unicidade e enum — vive **exclusivamente** aqui e nos fragmentos. Qualquer outro artefato (N0–N3, protótipo, contagem) **referencia**, nunca redefine: `→ ver DATA-MODEL.md: Entidade [Nome]`.

---

## Convenção de nomenclatura

| Camada | Convenção | Exemplo | Onde aparece |
|---|---|---|---|
| Entidade | PascalCase singular, português | `Premiacao` | fragmento (cabeçalho), "Modelos por domínio" |
| Label PO | Português, title case, sem jargão | `Nome da premiação` | N3 (campos), Gherkin, telas |
| Label Dev | camelCase, português — **nome do atributo Java da entidade JPA** | `nome` (em `Premiacao`) | fragmento — apenas aqui |
| Campo banco | **UPPER_SNAKE_CASE com prefixo húngaro** | `NM_PREMIACAO` | fragmento — apenas aqui |

> ✅ **Label Dev conciliado com o código** (2026-08-28): as 144 divergências entre o Label Dev inferido na extração do schema e o atributo real da entidade JPA foram corrigidas nos fragmentos. Convenção observada no código: atributo de associação `@ManyToOne` recebe o nome da entidade referenciada (`premiacao`, `etapa`, `inscricao`), **não** o sufixo `Id`; campos `NM_`/`DS_` da própria entidade recebem `nome`/`descricao` sem repetir o nome da entidade. O **campo banco** é transcrito exatamente como está no schema (não traduzido).

**Legenda dos prefixos do banco** (padrão desta base): `CD_`=código/identificador (PK ou FK) · `NM_`=nome · `DS_`=descrição/texto · `DT_`=data · `TS_`=timestamp · `NR_`=número · `QT_`=quantidade · `VL_`=valor/texto de valor · `FL_`=flag booleano (bit) · `SG_`=sigla · `LG_`=login · `BL_`=binário · `ID_`=código textual. Prefixo de tabela: `TB_` (negócio) · `TL_` (log). O modelo usa `int IDENTITY` como PK e **exclusão lógica** via `FL_ATIVO` (não há timestamp de exclusão).

---

## Campos globais (presentes em todas as tabelas)

Implícitos — **não** são listados nos fragmentos de domínio (só aqui). A contagem de DER (APF) exclui os campos globais técnicos (criado/atualizado por/em, `FL_ATIVO`); o **Identificador conta 1 DER por ALI**, não por tabela — ver `global/SIZING.md`.

| Label PO | Label Dev | Campo banco | Tipo SQL | Notas |
|---|---|---|---|---|
| Identificador | id | `CD_<ENTIDADE>` | int IDENTITY(1,1) | PK; gerada automaticamente (ex.: `CD_PREMIACAO`) |
| Criado por | criadoPor | CD_CRIADO_POR | int | Usuário que criou (identidade externa SSO/AD; sem FK local) |
| Criado em | criadoEm | DT_CRIADO_EM | datetime2(7) | default `getdate()` |
| Atualizado por | atualizadoPor | CD_ATUALIZADO_POR | int | Usuário que atualizou |
| Atualizado em | atualizadoEm | DT_ATUALIZADO_EM | datetime2(7) | |
| Ativo | ativo | FL_ATIVO | bit | default 1; **exclusão lógica** (0 = excluído) |

> ⚠️ **Sistema mononstância (single-tenant)** — não há `organization_id`. A **exclusão é lógica** via `FL_ATIVO` (não há `deleted_at`). Nem toda tabela carrega os 6 campos: tabelas de **referência** (`TB_UF`, `TB_TIPO_CAMPO`, `TB_TIPO_QUESTAO`), de **log** (`TB_AUDITORIA_EMAIL`, `TB_AUTOSAVE_LOG`, `TL_LOG_AUDITORIA`) e de **infra** (`TB_ARQUIVO`, `TB_CONTEUDO_ARQUIVO`, `TB_MIGRACAO_MANUAL`) têm subconjuntos próprios — registrado em cada fragmento.

---

## Modelos por domínio

| Domínio | Arquivo | Tipo | ALIs (entidades principais) |
|---|---|---|---|
| Configuração da Premiação | [data-models/configuracao.md](./data-models/configuracao.md) | entidades | Premiação · Categoria · Modalidade · Tipo de Participante · Listas do Sistema (28 entidades) |
| Inscrição | [data-models/inscricao.md](./data-models/inscricao.md) | entidades | Inscrição · Notificação Participante (+ Arquivo/Conteúdo/Download, infra) (14 entidades) |
| Validação | [data-models/validacao.md](./data-models/validacao.md) | entidades | Validação de Inscrição · Auditoria de E-mail (3 entidades) |
| Avaliação | [data-models/avaliacao.md](./data-models/avaliacao.md) | entidades | Avaliação de Inscrição · Alocação de Avaliadores (12 entidades) |
| Acesso e Gestão | [data-models/acesso.md](./data-models/acesso.md) | entidades | Usuário (+ UF, Log de Auditoria, Controle de Migração, Pessoa) (5 entidades) |

**62 entidades** em 5 fragmentos: as 59 tabelas do schema de origem, **mais** duas descobertas na conferência com o código — `TB_PESSOA` (cadastro legado da base CNI, em Acesso e Gestão) e `TB_DOWNLOAD_ARQUIVO` (infra de download temporário, em Inscrição) — **mais** `TB_DISPARO_FEEDBACK`, criada pela migração **V00034** na Sprint 6 (entidade *Disparo de Feedback*, no fragmento de Avaliação). Nenhuma tabela ficou sem mapeamento; nenhuma coluna de entidade JPA ficou sem linha no fragmento correspondente.

> ✅ **Migrações da Sprint 6 conciliadas em 2026-10-04.** A **V00034** criou `TB_DISPARO_FEEDBACK`, acrescentou quatro colunas de ligação a `TB_AUDITORIA_EMAIL` (tipo, inscrição, etapa, disparo) e inseriu o modelo de e-mail `FEEDBACK_ETAPA_DISPONIVEL` nas premiações ativas; a **V00035** acrescentou as cinco colunas da desclassificação manual a `TB_APROVACAO_ETAPA_PARTICIPANTE`, com a constraint `CK_APROV_ETAPA_PART_DESCLASSIF`. **Nenhuma das duas move PF**: os dois ALIs alcançados seguem Média, 10 PF cada. Detalhe em `analise-impacto/AIM-SP06.md`, *Funções de dados alteradas*.

---

## Enums do sistema

> Este schema **não** usa `CREATE TYPE`/enum nativo: os enums são **implícitos** em colunas `varchar`/`nvarchar` de status/situação/tipo. ✅ **Valores conciliados com o código** (2026-08-28) — cada linha aponta o `enum` Java de `br.com.cni.apipremioieltalentos.enumeration` que o backend persiste (`@Enumerated(EnumType.STRING)`) ou, quando a coluna é `String` livre, os literais efetivamente gravados.

| Enum (campo banco) | Entidade | Enum Java | Valores |
|---|---|---|---|
| DS_STATUS | Inscrição | `StatusInscricaoEnum` | RASCUNHO (default) · EM_ANDAMENTO · FINALIZADA · EM_VALIDACAO · VALIDADA · REJEITADA · AGUARDANDO_AJUSTE · AJUSTES_CONCLUIDOS |
| DS_SITUACAO | Etapa | `SituacaoEtapaEnum` | ABERTA (default) · FECHADA |
| DS_SITUACAO | Alocação de Avaliadores · Avaliação de Inscrição | `SituacaoAlocacaoAvaliacaoEnum` | ATIVA (default) · REMOVIDA |
| DS_STATUS_AVALIACAO · DS_STATUS_ANTERIOR · DS_STATUS_NOVO | Avaliação de Inscrição · Histórico de Avaliação | `StatusAvaliacaoEnum` | A_INICIAR (default) · EM_ANDAMENTO · FINALIZADA |
| DS_TIPO_CORTE | Decisão de Desempate | `TipoCorteEnum` | CLASSIFICACAO (default — quem avança) · PREMIACAO (quem entra no pódio) |
| DS_ABRANGENCIA | Tipo de Participante | *(String com `CHECK`)* | NACIONAL (default) · REGIONAL |
| DS_STATUS_VALIDACAO | Validação de Inscrição | *(String com nome de `StatusInscricaoEnum`)* | VALIDADA · REJEITADA — únicos valores gravados pelo código |
| STATUS | Auditoria de E-mail | `StatusAuditoriaEmail` | AGUARDANDO · ENVIADO · FALHA · SUSPENSO |
| DS_STATUS | Apuração por Etapa | `StatusAprovacaoEtapaEnum` | APROVADO · REPROVADO (derivado do corte `NR_CLASSIFICADOS`) |
| DS_STATUS_DECIDIDO | Inscrição da Decisão de Desempate | `StatusAprovacaoEtapaEnum` | APROVADO · REPROVADO |
| DS_ACAO | Log de Auditoria | *(String livre)* | ⚠️ nenhum — **nenhum serviço grava em `TL_LOG_AUDITORIA`** |
| DS_TIPO | Snapshot da Inscrição | `TipoSnapshotEnum` | ANTES_AJUSTE · DEPOIS_AJUSTE · ANTES_EDICAO_ADMIN · DEPOIS_EDICAO_ADMIN |
| DS_TIPO | Termo de Confidencialidade | `TipoTermoConfidencialidadeEnum` | TEXTO (HTML inline) · ANEXO (arquivo) |
| DS_TIPO | Notificação Participante | *(String livre)* | BOAS_VINDAS · CONFIRMACAO · LEMBRETE · INSCRICAO_APROVADA · INSCRICAO_REJEITADA · AJUSTE_SOLICITADO |
| DS_TIPO_EMAIL | Configuração de E-mail | `TipoEmailEnum` | AJUSTE_SOLICITADO · INSCRICAO_APROVADA · INSCRICAO_REJEITADA · DEVOLUCAO_ADMIN · NOVA_ALOCACAO_AVALIADOR · ETAPA_FECHADA_PARA_AVALIADOR · TODOS_AVALIADORES_FINALIZARAM_PARA_ADMIN |
| CD_PERFIL | Perfil de Acesso à Etapa | *(String com `CHECK`)* | PIT.1 (Administrador Nacional) · PIT.3 (Administrador Regional) — `CK_ETAPA_PERFIL_VALIDO` |
| nm_sexo | Pessoa *(legado)* | `SexoEnum` | MASCULINO · FEMININO · NAO_INFORMADO |
| ind_tipo_cadastro | Pessoa *(legado)* | `TipoCadastroEnum` | CARGA · RECEPCAO · CADASTRO |

> **Enums declarados e não usados** (nenhuma coluna os persiste, conferido em 2026-08-28): `StatusEdicaoEnum`, `TipoCampoInscricaoEnum`, `TipoMesaEnum`, `ComposicaoMesaEnum`. `AbrangenciaCorteEnum` (REGIONAL · NACIONAL) e `DirecaoMovimentoEtapa` (ACIMA · ABAIXO) existem mas **não são persistidos** — o primeiro é derivado das capabilities da etapa (`TB_ETAPA_PERFIL_ACESSO`), o segundo é parâmetro do `PATCH /etapas/{id}/mover`.

---

## Arquivos Lógicos (APF)

> Registro central de funções de dados (ALI/AIE) do sistema. Números do **baseline APF** (`PIEL_BASELINE_PF_CD` — elaborador: equipe de métricas; data 2026-02-28). Fonte de cálculo: seção `## Arquivos Lógicos deste domínio` de cada fragmento. **RLR** = Registro Lógico Referenciado (IFPUG RET) · **DER** = Dado Elementar Referenciado (IFPUG DET) — ver `global/SIZING.md`.

> ⚠️ **DER a revisar — nova regra do identificador (2026-08-29).** O `global/SIZING.md` passou a contar o `id` como **1 DER por ALI** (antes ele era excluído junto com os campos automáticos do sistema). Os DER das tabelas abaixo foram apurados **antes** dessa mudança — reconcilie-os pelo `PROMPT_CONTAGEM` antes de usar estes números em medição contratual.

### ALIs — Arquivos Lógicos Internos

| ALI | Domínio | Entidade principal | RLR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Premiação | Configuração da Premiação | Premiação (+7 suportes) | 9 | 71 | Alta | 15 | 2026-02-28 |
| Categoria | Configuração da Premiação | Categoria (+1) | 2 | 13 | Baixa | 7 | 2026-02-28 |
| Modalidade | Configuração da Premiação | Modalidade (+1) | 2 | 19 | Baixa | 7 | 2026-02-28 |
| Tipo de Participante | Configuração da Premiação | Tipo de Participante (+13) | 12 | 89 | Alta | 15 | 2026-02-28 |
| Listas do Sistema | Configuração da Premiação | Lista do Sistema (+1) | 2 | 14 | Baixa | 7 | 2026-02-28 |
| Inscrição | Inscrição | Inscrição (+9) | 11 | 85 | Alta | 15 | 2026-02-28 |
| Notificação Participante | Inscrição | Notificação Participante | 1 | 13 | Baixa | 7 | 2026-02-28 |
| Validação Inscrição | Validação | Validação de Inscrição | 3 | 23 | Média | 10 | 2026-02-28 |
| Auditoria de E-mails | Validação | Auditoria de E-mail (+2) | 3 | 36 | Média | 10 | 2026-10-04 |
| Avaliação de Inscrição | Avaliação | Avaliação de Inscrição (+7) | 3 | 43 | Média | 10 | 2026-10-04 |
| Alocação Avaliadores | Avaliação | Alocação de Avaliadores | 1 | 12 | Baixa | 7 | 2026-02-28 |
| Usuário | Acesso e Gestão | Usuário (vínculo por UF) (+UF) | 3 | 8 | Baixa | 7 | 2026-02-28 |
| **Total ALIs** | | | | | | **117 PF** | |

> ℹ️ **A coluna PF é o PF Bruto (PFB) do baseline** — é ela que soma os 117 PF. A planilha traz uma segunda coluna, *PF Fábrica de Software* (PFL), que a **equipe de métricas confirmou ser falha de preenchimento** e mandou desconsiderar (resposta à Q1 do questionamento, 2026-08-28). Nenhum valor deste documento vem dela — as antigas ressalvas de "PF deduzido" e "zerado na coluna de faturamento" caíram junto.

### AIEs — Arquivos de Interface Externa

| AIE | Sistema externo | Estrutura usada | PF | Data |
|---|---|---|---|---|
| (nenhuma dimensionada no baseline) | — | — | 0 | 2026-02-28 |

> ⚠️ **Identidade de usuário (SSO/AD corporativo)** — não existe `TB_USUARIO` no schema; `CD_USUARIO` (`bigint`) referencia o diretório corporativo externo. O baseline classifica **Usuário como ALI** (pelos dados locais de vínculo por UF em `TB_USUARIO_UF`); a **identidade em si** é externa e **candidata a AIE** — confirmar com a equipe de métricas.
>
> ✅ **Conferência com o código (2026-08-28) — a integração é real e bidirecional.** O backend não apenas lê o diretório: ele **consulta, cria e vincula usuários** no corporativo (BASI/AD) por API REST, com as URLs vindas do serviço de configuração corporativo (`urlPesquisaUsuarioLogin`, `urlPesquisaUsuarioSistemaCodigoUsuario`, `urlNovoUsuarioSistema`, `urlPerfisSistema`). Pontos de integração:
> - `PreCadastroServiceImpl.registrar` — o pré-cadastro público cria a conta corporativa do participante (com senha temporária por e-mail) quando ela ainda não existe;
> - `PreCadastroServiceImpl.normalizarAcessoSistema` — vincula ao sistema, com perfil Participante, quem já existe no corporativo mas recebeu `acesso_nao_permitido` no login;
> - `PerfilResolverService` — resolve o código numérico do perfil para o ID textual (`PIT.1`…`PIT.4`) consultando a API corporativa de perfis;
> - `UsuarioRegionalServiceImpl` — consulta e mantém os usuários do sistema no corporativo (administradores regionais e avaliadores).
>
> Isso reforça a classificação de **AIE — Diretório Corporativo (SSO/BASI)**; a estrutura lida (código, login, nome, e-mail, perfil) precisa ser dimensionada com a equipe de métricas. ⚠️

### Entidades técnicas (fora do baseline APF) ⚠️

| Entidade | Tabela | Papel | Domínio |
|---|---|---|---|
| Log de Auditoria | TL_LOG_AUDITORIA | Auditoria append-only de alterações — ⚠️ **sem escrita no código** | Acesso e Gestão |
| Controle de Migração | TB_MIGRACAO_MANUAL | Controle de scripts de migração | Acesso e Gestão |
| Pessoa | TB_PESSOA | Cadastro legado da base CNI — ⚠️ sem uso pelo negócio da premiação | Acesso e Gestão |
| Arquivo / Conteúdo do Arquivo / Download | TB_ARQUIVO · TB_CONTEUDO_ARQUIVO · TB_DOWNLOAD_ARQUIVO | Armazenamento e download de arquivos (infra compartilhada) | Inscrição |

> Contexto do baseline APF completo (aba *AFP - Detalhada*, coluna PFB): funções de **dados** ALI 117 · AIE 0; funções de **transação** EE 248 · SE 143 · CE 139 (contadas nos N3, ver `global/SIZING.md`). **Total do baseline: 647 PF.**

---

## Achados da engenharia reversa (a reconciliar) ⚠️

Pontos levantados na extração do schema que pedem confirmação de negócio/métrica antes de virar fato. Estado após a conferência com o código-fonte (2026-08-28):

- ~~**Label Dev inferido** — reconciliar com o código.~~ ✅ **Resolvido (2026-08-28)**: 144 Label Dev corrigidos nos fragmentos a partir das entidades JPA; nenhuma divergência remanescente.
- ~~**Enums implícitos sem `CREATE TYPE`** — conjuntos de valores a confirmar.~~ ✅ **Resolvido (2026-08-28)**: valores extraídos dos `enum` Java e das `CHECK constraints` (ver *Enums do sistema*).
- ~~**`FL_STORED` (char(1))** em `TB_ARQUIVO` — provável S/N, não bit; confirmar semântica.~~ ✅ **Resolvido (2026-08-28)**: coluna legada da base CNI — **nenhum ponto do código a escreve ou lê**; o conteúdo vive sempre em `TB_CONTEUDO_ARQUIVO`.
- ~~**Premiação 7,5 PF** vs. 15 PF (IFPUG Alta) — metade; reconciliar.~~ ✅ **Resolvido (2026-08-28)**: era falha de preenchimento da coluna *PF Fábrica de Software*; vale o PF Bruto de 15.
- ~~**Módulo Avaliação com PF 0** no baseline — contagem pendente/OS separada.~~ ✅ **Resolvido (2026-08-28)**: mesma falha de preenchimento; os dois ALIs valem 10 e 7 PF.
- **Identidade externa (SSO/AD)** — sem `TB_USUARIO`; `CD_USUARIO` é `bigint`. Divergência de tipo confirmada no código: `Long` em `UsuarioUf.codigoUsuario` vs. `Integer` em `LogAuditoria.usuarioId` e nos campos `CD_CRIADO_POR` de `Auditavel`. ⚠️ Permanece aberto para decisão técnica.
- **AIE do diretório corporativo** — a integração de leitura *e escrita* com o BASI/AD está confirmada no código (ver *AIEs*), mas não foi dimensionada no baseline. ⚠️ Reabrir com a equipe de métricas.
- **RLR do baseline ≠ nº de tabelas físicas** em Premiação (9 vs. 8), Tipo de Participante (12 vs. 14) e Inscrição (11 vs. 10) — granularidade de RET difere do mapeamento físico. ⚠️ Permanece aberto.
- **Referências sem FK declarada** — confirmado no código: `TB_INSCRICAO_DOCUMENTO.CD_ARQUIVO` → `TB_ARQUIVO`, `TB_DOWNLOAD_ARQUIVO.CD_ARQUIVO` → `TB_ARQUIVO` e `TB_FORMULARIO_CAMPO.ID_ETAPA` (nvarchar(36), mapeado como `etapaId` textual) não têm FK. ⚠️ Permanece aberto.
- **`TL_LOG_AUDITORIA` sem escrita** — a tabela e o `LogAuditoriaRepository` existem, mas **nenhum serviço grava nela**. A trilha efetiva do produto é `TB_INSCRICAO_HISTORICO`, `TB_AVALIACAO_HISTORICO` e `TB_INSCRICAO_SNAPSHOT`. ⚠️ Impacta a NFR **AUD-01** e a feature `ACS-AUD-01`.
- **`TB_PESSOA` (cadastro legado da base CNI)** — entidade, repositório, serviço, mapper e CRUD em `/administracao/pessoas` existem, mas nenhuma entidade de negócio da premiação a referencia. ⚠️ Confirmar se permanece no produto ou sai como resíduo do projeto base.

---

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-05 | Especificação Funcional SP06 (docqui) | Referência corrigida | Três remissões ao relatório `arquivos/demandas/ANALISE_IMPACTO_SP06.md`, que a migração de 2026-10-04 transformou em `analise-impacto/AIM-SP06.md`, passam a apontar para a AIM: o detalhe das migrações da Sprint 6 (aqui), a pendência da métrica sobre a Auditoria de E-mails (`data-models/validacao.md`) e a do Disparo de Feedback (`data-models/avaliacao.md`). As antigas seções 3 e 5 viraram *Funções de dados alteradas* e *Decisões de produto pendentes* |
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Índice e fragmentos carimbados com o engine 4.1.0 e conferidos pelo `validate-doc`. ⚠️ Mantido o formato **técnico** (Label Dev, campo banco, tipo SQL e contagem de ALI/AIE): no perfil `requisitos` a 4.1.0 prevê o modelo negocial, sem camada física, mas converter apagaria o mapeamento conciliado com o código e a contagem das funções de dados — decisão do PO/arquitetura |
| 2026-10-04 | Migrações da Sprint 6 (docqui) | Conciliação com as migrações | **V00034** e **V00035** registradas: nova entidade *Disparo de Feedback* (`TB_DISPARO_FEEDBACK`), quatro colunas de ligação em `TB_AUDITORIA_EMAIL`, cinco colunas da desclassificação em *Apuração por Etapa* com a constraint `CK_APROV_ETAPA_PART_DESCLASSIF`, e o valor `FEEDBACK_ETAPA_DISPONIVEL` no enum `TipoEmailEnum`. 61 → 62 entidades. Os ALIs **Auditoria de E-mails** (RLR 2→3, DER 20→36) e **Avaliação de Inscrição** (DER 38→43) seguem Média, **10 PF cada — sem Δ PF** |
| 2026-08-28 | Conferência doc × código (docqui) | Conciliação com o código | 144 Label Dev corrigidos a partir das entidades JPA; valores reais de 18 enums; 2 entidades acrescentadas (`TB_PESSOA`, `TB_DOWNLOAD_ARQUIVO`); achados de `FL_STORED`, `TL_LOG_AUDITORIA` e AIE do diretório corporativo registrados. Ver `global/CONFORMIDADE-CODIGO.md` |
| 2026-08-28 | Revisão da contagem (docqui) | PF corrigido | Coluna PF passa a reproduzir o PF Bruto do baseline: a equipe de métricas confirmou que a coluna PF Fábrica de Software estava com falha de preenchimento (Q1). Total dos ALIs de 92,5 para 117 PF |
| 2026-08-25 | Engenharia reversa (docqui) | DATA-MODEL criado | 59 tabelas → 59 entidades em 5 domínios; registro ALI (92,5 PF) do baseline APF |
