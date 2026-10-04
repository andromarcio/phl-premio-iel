<!-- docqui: 2.23.0 | prompt: MASTER | atualizado: 2026-10-04 -->
# MASTER.md
> Arquivo de contexto global, independente do módulo ou nível em trabalho.
> No Claude Code é carregado automaticamente a cada sessão via o `CLAUDE.md` da
> instância (ver `global/CLAUDE.md`); no fluxo copy-paste/CLI, cole-o em toda sessão.

---

## Identificação do sistema

- **Sigla**: `PIEL` — no portal corporativo o sistema é registrado com a sigla **PIT** (`configuracoes.json`), que prefixa os códigos de perfil `PIT.1`…`PIT.4`
- **Nome**: Prêmio IEL de Talentos
- **Descrição**: Plataforma que conduz o ciclo completo da premiação — configuração da edição, inscrição, validação regional, avaliação, apuração e devolutiva.
- **Versão atual**: backend `api-premio-iel-talentos` 0.0.1-SNAPSHOT · frontend `premio-iel-talentos-frontend` 18.0.0 *(a numeração do frontend não acompanha a versão do Angular, que é 20.3)*
- **Repositório de docs**: `premio-iel` (este repositório)

> A **sigla do sistema** (5 letras) identifica o produto como um todo e é **distinta** da
> `[SIGLA]` de **domínio** (3 letras, usada nos IDs `[SIGLA]-[SFS]-[NN]`) descrita
> na seção *Identificadores únicos* abaixo.

---

## Arquétipo do produto

<!--
  Declara o TIPO de produto que esta instância documenta. Linha máquina-legível:
  prompts e validadores (validate-doc.mjs) a leem para ligar/desligar exigências.
  Valores aceitos: transacional | ml-dados | cli-biblioteca. Ausente/valor
  desconhecido → transacional (comportamento clássico do framework).
-->

- **Arquétipo**: `transacional`

| Arquétipo | Quando usar | O que muda no framework |
|---|---|---|
| `transacional` | Sistema de negócio com UI + banco relacional (CRM, ERP, portais) | Comportamento clássico — nada muda |
| `ml-dados` | Pipelines de dados/ML: preparação, treino, avaliação, serving | N2: `Telas`/`Permissões por perfil` opcionais · N3: superfície típica `CLI`/`Job/Pipeline` com `## Execução e operação` no lugar de `## Comportamento de tela` · data-model pode usar o fragmento de **artefatos** (dataset/cache/checkpoint) · protótipos e APF opcionais (APF pressupõe transações de negócio) · engenharia reversa pela **Trilha B** do `PROMPT_REVERSE_ENGINEERING` |
| `cli-biblioteca` | Ferramentas de linha de comando, SDKs e bibliotecas | Igual a `ml-dados`, sem a ênfase em artefatos de dados — superfície típica `CLI`/`API` |

> A superfície de **cada feature** continua sendo declarada no `## Superfície` do N3 —
> o arquétipo dá o padrão do produto (e o validador usa a superfície da feature, não o
> arquétipo, para exigir `Comportamento de tela` vs `Execução e operação`). Um produto
> `transacional` pode ter features `Job` (ex.: *gerar cobrança mensal*) e um `ml-dados`
> pode ter uma tela de acompanhamento.

---

## Perfil de escopo

<!--
  Declara ATÉ ONDE na esteira esta instância vai. Linha máquina-legível:
  o PROMPT_MENU e o gates.py a leem para encurtar o fluxo. Valores aceitos:
  completo | requisitos. Ausente/valor desconhecido → completo (esteira inteira).
-->

- **Perfil**: `requisitos`

| Perfil | Quando usar | O que muda no framework |
|---|---|---|
| `completo` | Instância que documenta **e** leva ao código (spec → banco → testes → implementação) | Comportamento clássico — esteira inteira `requisitos → modelo-dados → testes → codigo`, todas as opções do menu |
| `requisitos` | Instância **só de requisitos**: para no negocial + data-model, sem passada técnica nem codificação | Menu só com as opções negociais (esconde 1B/2B/3B/4B, R1/R3/R4, Fase 5 e a exportação spec-kit) · esteira encurta para `requisitos → modelo-dados` (para em `modelo-validado`) · a camada de código (`mapa-codigo`, `valida-artefatos-previstos`, CI de código) fica inerte |

> O corte do perfil `requisitos` é no **3A**: mantém-se todo o lado negocial (N0, N1A, N2A, 3A, CRUD/Wizard, cenários, protótipos, auditoria, APF/NFR) **e o data-model** (`PROMPT_DATA_MODEL_negocio`, gate `modelo-dados`); a especificação técnica (3B) e a implementação ficam de fora. O perfil é ortogonal ao arquétipo: um `transacional` ou um `ml-dados` pode rodar em `completo` ou `requisitos`.

---

## Stack técnica

> ✅ Seção conciliada com o código em 2026-08-28 (`pom.xml`, `package.json`, `application.properties`, `configuracoes.json`).

- **Frontend**: Angular 20.3 (standalone components, rotas com `loadComponent`/`loadChildren`), TypeScript 5.9, design-system **PrimeNG 20.4** + PrimeFlex 3.3 + PrimeIcons; complementos: Quill 1.3 (editor rico), Chart.js 3, FullCalendar 6.1, FontAwesome 6, Croppie (recorte de imagem), Mammoth (leitura de `.docx`), Moment, RxJS 6.6.
- **Backend**: Java 21, Spring Boot 3.5.15 (`spring-boot-starter-web`, `data-jpa`, `validation`, `webflux`, `mail`), Hibernate, Lombok 1.18.30, MapStruct 1.6.3, Apache POI 5.5 (Excel), springdoc-openapi 2.8 (Swagger UI).
- **Banco de dados**: **Microsoft SQL Server** (driver `mssql-jdbc`, dialeto `SQLServer2012Dialect`). O driver Oracle (`ojdbc8`) vem do projeto base e não é usado. Migrações versionadas manualmente em `src/main/resources/db/migration/consolidado/V00001..V00035`, com idempotência controlada pela tabela `TB_MIGRACAO_MANUAL` (não há Flyway/Liquibase).
- **Autenticação**: SSO corporativo do Sistema Indústria — *access token* OAuth2 validado a cada requisição pelo `Interceptor` corporativo; perfis e menus vêm do portal (`configuracoes.json`). Um perfil por usuário: `PIT.1` Administrador (Nacional) · `PIT.2` Participante · `PIT.3` Administrador Regional · `PIT.4` Avaliador.
- **Fila / Jobs**: sem broker. O envio de e-mail é assíncrono por **fila em banco** (`TB_AUDITORIA_EMAIL`, status `AGUARDANDO`) consumida por um `@Scheduled(fixedDelay)` em `TaskServiceImpl` (`premio.email-sync.delay-ms`, default 10 s).
- **Storage**: arquivos em **banco** (`TB_ARQUIVO` + `TB_CONTEUDO_ARQUIVO`, `varbinary(MAX)`); download por UUID não-adivinhável (`TB_INSCRICAO_DOCUMENTO.CD_UUID`). Não há storage de objetos externo.
- **E-mail**: SMTP via `spring-boot-starter-mail` (`JavaMailSender`), remetente default `noreply@cni.org.br`; todo envio fica auditado em `TB_AUDITORIA_EMAIL` + `TB_ANEXO_AUDITORIA_EMAIL`.
- **Integrações externas**:
  - **Diretório/portal corporativo (SSO · BASI/AD)** — configurações, perfis, menus, pesquisa/criação/vínculo de usuário (`URL_AUTENTICACAO`, `URL_CORPORATIVO_CONFIGURACOES`).
  - **Azure OpenAI** — geração da devolutiva consolidada (`AzureOpenAiService`; endpoint, modelo e versão de API por variável de ambiente).
- **CI/CD e execução**: Azure Pipelines (`azure-pipelines-develop|homolog|main.yml` no backend, `-dev|-hml|-prd.yml` no frontend), imagem Docker, análise SonarQube e Snyk. Context path da API: `/api-premio-iel-talentos`.

---

## Technical Context (normalizado para exportação ao spec-kit)

<!--
  Bloco com os MESMOS campos da seção "Technical Context" do plan.md do spec-kit.
  O PROMPT_SPECKIT_EXPORT copia estes valores direto para o plan.md, evitando que
  o /plan precise rederivar a stack. Performance/Constraints derivam do global/NFR.md.
  Campos sem decisão ficam como NEEDS CLARIFICATION (o spec-kit trata isso nativamente).
-->

| Campo (spec-kit) | Valor |
|---|---|
| Language/Version | Java 21 (backend) · TypeScript 5.9 / Angular 20.3 (frontend) |
| Primary Dependencies | Spring Boot 3.5.15, Spring Data JPA, Lombok, MapStruct, Apache POI, springdoc-openapi · PrimeNG 20.4, PrimeFlex, Quill, Chart.js |
| Storage | Microsoft SQL Server (migrações manuais V00001–V00035 com controle em `TB_MIGRACAO_MANUAL`) |
| Testing | JUnit 5 + Mockito + JaCoCo (backend) · Karma + Jasmine, cobertura para SonarQube (frontend) |
| Target Platform | Linux server em container Docker (API) · navegador desktop (SPA) |
| Project Type | web (frontend + backend) |
| Performance Goals | `→ ver NFR: DES-*` |
| Constraints | `→ ver NFR: SEG-*/REST-*` — SSO corporativo do Sistema Indústria, instância única (single-tenant), sem broker de mensageria |
| Scale/Scope | 5 domínios · 21 Feature Sets · 128 features documentadas · 62 entidades · ~294 endpoints REST |

---

## Repositórios do sistema

| Repositório | Responsabilidade |
|---|---|
| `Projeto_Premio_IEL_Talentos_Backend` | API REST (`api-premio-iel-talentos`), regras de negócio, migrações de banco, envio de e-mail e integrações (SSO corporativo, Azure OpenAI) |
| `Projeto_Premio_IEL_Talentos_Frontend` | SPA Angular (`premio-iel-talentos-frontend`) — telas administrativas, do avaliador e a jornada pública de inscrição |
| `premio-iel` | Documentação e especificações (este repo) |

> Inventário detalhado (como rodar, variáveis de ambiente, pipelines) em [`repos/INDEX.md`](../repos/INDEX.md).

---

## Convenções de código

> **Padrões de projeto** (Strategy, Repository, Facade, …) **não** ficam aqui —
> vivem no catálogo `global/PATTERNS.md`. Esta seção cobre *como se escreve/organiza*
> o código (nomes, lint, tipagem, pastas) e as **restrições de renderização/performance**
> (ex.: estratégia de change detection, lazy loading) — que são convenção, não padrão.

> ✅ Seção conciliada com o código em 2026-08-28.

### Nomenclatura
- **Rotas de API**: kebab-case em português, sob o context path `/api-premio-iel-talentos`. Três prefixos de fato: `/administracao/**` (área autenticada — inclui as telas do participante), `/avaliacao/avaliador/**` (área do avaliador) e `/publico/**` (link público, pré-cadastro, normalização de acesso e imagens públicas). ⚠️ O prefixo `/administracao` cobre também endpoints do participante (`/administracao/inscricao/**`, `/administracao/participante/**`) — nome herdado do projeto base, não indica perfil.
- **Tabelas/colunas do banco**: `UPPER_SNAKE_CASE` com **prefixo húngaro** e em português — `TB_` (negócio) / `TL_` (log); colunas `CD_` (código/PK/FK) · `NM_` (nome) · `DS_` (descrição/texto) · `DT_`/`TS_` (data/timestamp) · `NR_` (número) · `QT_` (quantidade) · `VL_` (valor) · `FL_` (flag bit) · `SG_` (sigla) · `LG_` (login) · `BL_` (binário) · `ID_` (código textual). Fonte única: `global/DATA-MODEL.md`.
- **Classes Java**: `<Entidade>Controller` · `<Entidade>Service` (interface) + `<Entidade>ServiceImpl` · `<Entidade>Repository` · `<Entidade>DTO` · `<Entidade>Mapper`. Pacote raiz `br.com.cni.apipremioieltalentos`.
- **Arquivos Angular**: kebab-case (`inscricao-admin-detalhe.component.ts`), um diretório por página/componente; sufixos `.component`, `.service`, `.routes`/`-routing.module`.

### Frontend
- Componentes **standalone** (sem NgModule de feature); rotas carregadas por `loadComponent`/`loadChildren`.
- `strict: true` no `tsconfig.json`; models tipados por feature em `models/`.
- Chamadas à API sempre via um `*.service.ts` da feature (nunca `HttpClient` direto no componente); base URL por `environment`.
- UI exclusivamente com PrimeNG + PrimeFlex; o menu lateral é montado a partir do que o portal corporativo devolve, não é fixo no código.

### Backend
- Camadas `controller → service (interface) → serviceImpl → repository`; DTO nunca vaza entidade JPA (conversão por MapStruct em `mapper/`).
- Entidades herdam `Auditavel` (campos globais `CD_CRIADO_POR`, `DT_CRIADO_EM`, `CD_ATUALIZADO_POR`, `DT_ATUALIZADO_EM`, `FL_ATIVO`) ou `DomainObject<ID>` (tabelas legadas/infra sem os campos globais).
- Consultas dinâmicas por `specification/` (JPA Specifications) e paginação por `Pageable` do Spring Data.
- Validação de entrada por Bean Validation (`@Valid` + `spring-boot-starter-validation`); `XssSanitizationFilter` sanitiza o corpo das requisições.

### Estrutura de pastas
```
Projeto_Premio_IEL_Talentos_Backend/
  src/main/java/br/com/cni/apipremioieltalentos/
    controller/  service/  service/impl/  repository/  specification/
    domain/  dto/  mapper/  enumeration/  config/  util/  support/
    corporativo/           # base CNI: autenticação, interceptor, exception handler
  src/main/resources/
    db/migration/consolidado/V00001..V00035.sql
    application.properties  template/  spring/email.xml

Projeto_Premio_IEL_Talentos_Frontend/
  src/app/
    auth/                  # login, alterar/recuperar senha (base CNI)
    admin/                 # shell autenticado + painel + administração de usuários
    modules/
      configuracao-premiacao/  inscricao-publica/  validacao-inscricao/
      avaliacao/  avaliacao-admin/  administracao/{categorias,modalidades,tipos-participante}
    shared/  service/
```

---

## Identificadores únicos (IDs)

Cada nível da hierarquia de documentação possui um ID único para rastreabilidade
entre ferramentas externas (Jira, Azure DevOps, etc.).

| Nível | Formato | Exemplo |
|---|---|---|
| Demanda de origem (entrada) | chave da **ferramenta de origem** — externa, **não gerada aqui**; é a fonte de verdade da demanda. Tipos suportados: `servicenow` (`STRY…`), `issue` (`ISSUE-…`), `experimento` (`EXP-…`) — ver *Origem da demanda* abaixo | `STRY0012345` · `ISSUE-482` · `EXP-2026-003` |
| Domínio (N1) | `[SIGLA]` — sigla do domínio (sempre 3 letras maiúsculas) definida na criação do domínio | `CRM` |
| Feature Set (N2) | `[SIGLA]-[SFS]` — sigla do domínio + sigla do Feature Set (sempre 3 letras maiúsculas) | `CRM-CLI` |
| Feature (N3) | `[SIGLA]-[SFS]-[NN]` — 2 dígitos sequenciais dentro do Feature Set | `CRM-CLI-01` |

**Regras:**
- A demanda entra pela ferramenta de origem; o framework **referencia** a chave (nunca cria ID próprio para a demanda) e a registra na seção `## Origem` do N3
- A sigla do domínio é definida uma única vez na criação do N1 e nunca alterada
- A sigla do Feature Set é definida **no N1** (ao listar os Feature Sets do domínio) e **reutilizada** pelo N2; é única dentro do domínio e nunca reutilizada após exclusão; deriva do nome do Feature Set (ex.: Usuários → `USR`)
- A numeração de Features é sequencial dentro do Feature Set e não reutilizada após exclusão
- O ID fica no cabeçalho de cada artefato, logo abaixo da linha `**Nível X**`

### Origem da demanda (plugável)

<!--
  A ferramenta de onde vêm as demandas varia por organização: ServiceNow num time de
  produto corporativo, issues (GitHub/GitLab/Jira) num time OSS, registro de
  experimentos num time de pesquisa. Declare aqui a origem padrão desta instância;
  o front-matter de cada N3 registra `origem: { tipo, chave }` (o campo legado
  `servicenow:` de instâncias ≤1.5.x continua aceito pelos scripts).
  Os formatos de chave são fixos por tipo — os scripts de rastreabilidade os
  reconhecem por prefixo: STRY\d+ | ISSUE-\d+ | EXP-<id>.
-->

- **Origem padrão desta instância**: `issue`, em **duas chaves que convivem**. A demanda nasce como **História de Usuário** em `.docx` (`arquivos/HU-0NN_*.docx`), catalogada em `demandas/`, e é planejada e acompanhada como **item de trabalho no Jira**, no board `PDTIC25093`. As duas chaves são registradas: a HU diz **o que** foi pedido e é o elo com a spec; o item do Jira diz **em que sprint** entrou e qual o estado da entrega, e é o elo com a contagem por sprint.
- **Qual usar onde**: nos N3 e no `modules/INDEX.md`, a chave é a **HU** — é ela que carrega os critérios de aceite. Na análise de impacto e na contagem por sprint, aparecem **as duas**, porque a auditoria confere pelo item do Jira. Um item do Jira pode cobrir mais de uma HU, e uma HU pode ser fatiada em mais de um item.
- **Formato da chave do Jira**: `PDTIC25093-` + número (ex.: `PDTIC25093-49`). O título do item costuma trazer a HU correspondente — é o elo mais confiável entre os dois mundos. ⚠️ Nem todo item do Jira nomeia uma HU: itens de melhoria sem documento ("Avisos") existem e ficam sem HU; nesses casos a rastreabilidade é só pela chave do Jira.

| Tipo | Formato da chave | Arquivo em `demandas/` | Exemplo |
|---|---|---|---|
| `servicenow` | `STRY` + dígitos | `stry0012345.md` | `STRY0012345` |
| `issue` | `ISSUE-` + número | `issue-482.md` | `ISSUE-482` |
| `experimento` | `EXP-` + identificador | `exp-2026-003.md` | `EXP-2026-003` |

**Nesta instância**, a chave `issue` é o nome da HU e o item do Jira é a chave de sprint que a acompanha:

| Chave | Formato | Onde é a fonte | Exemplo |
|---|---|---|---|
| História de Usuário | `HU-0NN_Titulo_Com_Underscore` | `arquivos/HU-0NN_*.docx` — traz os critérios de aceite | `HU-018_Analisar_Validar_Inscricao` |
| Item do Jira | `PDTIC25093-` + número | board `PDTIC25093` — traz sprint, estado e responsável | `PDTIC25093-68` |

### Rastreabilidade ponta a ponta (demanda → spec → código)

Todo desenvolvimento começa por uma demanda na ferramenta de origem e é
rastreável até o código pela cadeia de IDs:

```
Demanda ([tipo] [chave] — ex.: ServiceNow STRYxxxxxxx, issue ISSUE-123, experimento EXP-…)
   └─ N3 Feature (SIGLA-SFS-NN)  ← seção "Origem" guarda a chave da demanda
        └─ Código (commit/PR)    ← referencia ambos os IDs
```

- **Demanda → N3**: a chave de origem é registrada na seção `## Origem` de
  cada feature; o elo recíproco fica em `demandas/[chave].md`. Cada
  critério de aceite é analisado e vira uma regra de negócio, um `## Cenário`
  (Gherkin) ou ambos — rastreabilidade semântica, não só por ID.
- **Critério de aceite → N3** *(quando a fonte numera)*: a coluna `Critérios
  cobertos` do `## Origem` abre com as referências `CA-n`, no mesmo número que a
  ferramenta de origem usa. É o elo que a **contagem por sprint** exige: cada
  feature impactada sai com a chave da demanda **e** o número do critério. Quando a
  fonte não numera os critérios, a coluna sai `—` e a rastreabilidade fica só pela
  chave — não se inventa número.
- **N3 → código**: seção `## Implementação` do N3 — a coluna **Repositório** é
  definida já no 3B (nomes do inventário `repos/INDEX.md`), dizendo em qual repo
  (MFE, microsserviço, back, front) cada parte da feature vive; caminho/branch
  entram após o dev — + coluna na tabela `Rastreabilidade` do `modules/INDEX.md`.
- **Convenção de commit/PR** *(fecha a cadeia no git)*:
  `tipo([SIGLA]-[SFS]-[NN]): [resumo] ([origem] [chave])` — ex.:
  `feat(CRM-CLI-01): cadastro de cliente (ServiceNow STRY0012345)`

---

## Nomenclatura de features

Features são nomeadas sempre no **infinitivo**, seguindo o padrão:

**`Verbo + Entidade + Complemento (quando necessário)`**

| Regra | Exemplo |
|---|---|
| Criação | `Cadastrar Cliente` |
| Edição | `Editar Endereço de Entrega` |
| Exclusão | `Excluir Produto` |
| Listagem sem filtro | `Listar Pedidos` |
| Listagem com filtro | `Pesquisar Pedidos` |
| Ação específica | `Aprovar Solicitação de Crédito` |

**Regras:**
- Sempre infinitivo — nunca substantivo (`Cadastro de Cliente` ❌) nem gerúndio (`Cadastrando Cliente` ❌)
- Listagens que exibem apenas a lista, sem opções de filtro → verbo **Listar**
- Listagens que possuem campos de filtro ou busca → verbo **Pesquisar**
- Complemento é opcional — usar apenas quando necessário para distinguir features de mesma entidade

---

## Nomenclatura de entidades e campos

Entidades e campos são nomeados em **português**. A nomenclatura de campos segue
três camadas com responsabilidades distintas.
**A única fonte de verdade para Label Dev e campo banco é o `global/DATA-MODEL.md`.**
Os N3 usam apenas Label PO — nunca duplicam as camadas técnicas.

| Camada | Convenção | Exemplo | Onde aparece |
|---|---|---|---|
| Entidade | PascalCase singular, português | `ModeloEmail` | DATA-MODEL.md, data-models/[dominio].md (cabeçalho) |
| Label PO | Português, title case, sem jargão | `Nome completo` | N3 (tabela de campos), Gherkin, telas |
| Label Dev | camelCase, português, autoexplicativo | `nomeCompleto` | DATA-MODEL.md, código, API |
| Campo banco | snake_case, português ⚠️ | `nome_completo` | DATA-MODEL.md, migrations, ORM |

> ⚠️ Entidades e campos são nomeados em **português**. Confirme apenas a caixa
> dos identificadores do banco (snake_case vs. UPPER_SNAKE_CASE) antes de gerar
> N1/N3. Em engenharia reversa de bases legadas, transcreva os identificadores
> como estão na origem (podem estar em inglês) — não os traduza.

---

## Campos globais obrigatórios em toda tabela

> **Decisões do projeto a confirmar**: multitenancy (sim/não), estratégia de PK
> (sequence / UUID / outra), tipos do SGBD, e exclusão física vs. **lógica** (soft
> delete via `deletedAt`). Ajuste a tabela abaixo conforme as decisões tomadas.

> ✅ Conciliado com a superclasse `Auditavel` do backend (2026-08-28). Tabelas de **referência** (`TB_UF`, `TB_TIPO_CAMPO`, `TB_TIPO_QUESTAO`), de **log** (`TB_AUDITORIA_EMAIL`, `TB_AUTOSAVE_LOG`, `TL_LOG_AUDITORIA`) e de **infra legada** (`TB_ARQUIVO`, `TB_CONTEUDO_ARQUIVO`, `TB_DOWNLOAD_ARQUIVO`, `TB_PESSOA`, `TB_MIGRACAO_MANUAL`) estendem `DomainObject<ID>` e **não** carregam este conjunto.

| Label Dev | Campo banco | Tipo | Notas |
|---|---|---|---|
| id | `CD_<ENTIDADE>` | int IDENTITY(1,1) | PK; gerada automaticamente (ex.: `CD_PREMIACAO`) |
| criadoPor | CD_CRIADO_POR | int | Usuário que criou (identidade externa SSO/AD; sem FK local) |
| criadoEm | DT_CRIADO_EM | datetime2(7) | default `getdate()` |
| atualizadoPor | CD_ATUALIZADO_POR | int | Usuário que atualizou |
| atualizadoEm | DT_ATUALIZADO_EM | datetime2(7) | |
| ativo | FL_ATIVO | bit | default 1; **exclusão lógica** (0 = excluído). Não existe `deleted_at` |

---

## Decisões transversais

> ⚠️ Itens marcados dependem de decisão do projeto.

> ✅ Seção conciliada com o código em 2026-08-28 — o que está escrito abaixo é o comportamento **implementado**, não a intenção.

1. **Exclusão**: **lógica**, via `FL_ATIVO = 0`. Materializada por endpoints `PATCH .../{id}/desativar` (e `.../reativar` onde existe). Não há `deleted_at`.
2. **IDs em URLs**: ⚠️ **o sistema expõe a PK interna nas rotas e nos endpoints** (`/administracao/premiacoes/{id}`, `/validacao-inscricao/inscricoes/{inscricaoId}/detalhe`). A única exceção é o download de anexo, que usa UUID não-adivinhável (`TB_INSCRICAO_DOCUMENTO.CD_UUID`, migração V00030, fechando um IDOR). Divergente do padrão recomendado — decisão a revisar.
3. **Paginação**: **offset**, pelo `Pageable` do Spring Data (`page`, `size`, `sort`); a resposta é o `Page<T>` do Spring (`content`, `totalElements`, `totalPages`, `number`, `size`).
4. **Validação**: no frontend (formulários Angular) e no backend (Bean Validation + regras no `ServiceImpl`). ⚠️ Em alguns pontos a regra vive **só** no frontend — ver `global/CONFORMIDADE-CODIGO.md`.
5. **Auditoria**: por **histórico de domínio**, não por log genérico — `TB_INSCRICAO_HISTORICO` (+ `TB_AJUSTE_ITEM` e `TB_INSCRICAO_SNAPSHOT` antes/depois) e `TB_AVALIACAO_HISTORICO`; todo e-mail fica em `TB_AUDITORIA_EMAIL`. ⚠️ `TL_LOG_AUDITORIA` existe mas **nenhum serviço grava nela**.
6. **Eventos internos**: **chamadas diretas** entre serviços. O único assíncrono é o envio de e-mail, por fila em banco consumida por `@Scheduled`.
7. **Autorização**: por **perfil do portal corporativo**, resolvido no servidor a cada requisição (`PerfilResolverService`) — `PIT.1` Administrador Nacional · `PIT.2` Participante · `PIT.3` Administrador Regional · `PIT.4` Avaliador; um perfil por usuário. O Administrador Regional é ainda limitado às UFs vinculadas (`TB_USUARIO_UF`, via `EscopoUfRegionalService`), e as etapas declaram quais perfis podem operá-las (`TB_ETAPA_PERFIL_ACESSO`, restrito a `PIT.1`/`PIT.3`). ⚠️ **Não** existe o catálogo de funcionalidades por ID de Feature descrito em `global/AUTHZ.md` — aquele documento é o padrão-alvo, não o estado atual.

---

## Padrão de resposta de API

> ⚠️ **Divergência conhecida (conferida em 2026-08-28).** O envelope `{ data, meta, error }` abaixo é o **padrão-alvo** de `global/API-PATTERNS.md`; a API **não** o implementa. O que está no ar é o formato herdado do projeto base CNI:

```jsonc
// Sucesso com dado único → o próprio DTO, sem envelope
{ "premiacaoId": 1, "nome": "Prêmio IEL de Talentos 2026", ... }

// Sucesso com lista paginada → Page<T> do Spring Data
{ "content": [ ... ], "totalElements": 137, "totalPages": 7,
  "number": 0, "size": 20, "first": true, "last": false }

// Erro tratado pelo ExceptionHandle
{ "message": "Apenas inscrições EM_VALIDACAO ... podem ser aprovadas.",
  "statusCode": 400, "statusName": "BAD_REQUEST" }

// Erro de validação de inscrição (422)
{ "message": "...", "statusCode": 422, "statusName": "UNPROCESSABLE_ENTITY",
  "erros": [ { "campo": "...", "mensagem": "..." } ] }
```

⚠️ Vários controllers ainda respondem erro como **texto puro** (`ResponseEntity.internalServerError().body("Erro ao ...")`), fora do `ExceptionHandle` — inconsistência a tratar. Não há código de erro (`ENTIDADE_ERRO`) no contrato atual, o que deixa o `global/ERROR-DICTIONARY.md` sem contrapartida no código.

<details><summary>Padrão-alvo (não implementado)</summary>

```typescript
// Sucesso com dado único
{ "data": { ...objeto }, "meta": null }

// Sucesso com lista
{ "data": [...], "meta": { "total": 0, "nextCursor": null, "prevCursor": null } }

// Erro
{ "data": null, "error": { "code": "ENTIDADE_ERRO", "message": "...", "details": [] } }
```

</details>

---

## O que NUNCA fazer

- ~~Expor o identificador interno (PK) em URLs ou respostas — usar a chave de negócio~~ ⚠️ **regra violada pelo sistema atual** (ver *Decisões transversais*, item 2); mantida como alvo, não como descrição
- Retornar senhas ou tokens em respostas, mesmo hasheados
- Lançar exceções cruas — sempre retornar erro pelo `ExceptionHandle` (nunca `body("Erro ao ...")` em texto puro)
- Duplicar Label Dev ou campo banco nos N3 — essas informações vivem apenas no DATA-MODEL.md
- Remover fisicamente registro de negócio — a exclusão é **lógica** (`FL_ATIVO = 0`)
- `any` no TypeScript do frontend (o `tsconfig` está em `strict`)
- Chamar `HttpClient` direto de um componente Angular — sempre por um `*.service.ts` da feature

---

## Arquivos globais de referência

| Arquivo | Propósito |
|---|---|
| `CLAUDE.md` (raiz) | Índice de contexto carregado a cada sessão no Claude Code |
| `global/MASTER.md` | Stack, convenções globais (este arquivo) |
| `global/DATA-MODEL.md` | Índice de entidades + campos globais + enums |
| `global/SIZING.md` | Convenções de contagem APF e COSMIC |
| `global/RULES-DICTIONARY.md` | Regras de negócio canônicas |
| `global/FIELD-DICTIONARY.md` | Campos canônicos (CPF, CEP, e-mail…) |
| `global/MESSAGE-DICTIONARY.md` | Mensagens de UI genéricas + baseline de validação |
| `global/ERROR-DICTIONARY.md` | Fonte única de códigos de erro |
| `global/API-PATTERNS.md` | Padrões de API |
| `global/AUTHZ.md` | Modelo de autorização **alvo** — controle de acesso por funcionalidade (Feature = átomo de permissão). ⚠️ Não implementado: o sistema autoriza por perfil do portal corporativo (`PIT.1`–`PIT.4`) — ver *Decisões transversais*, item 7 |
| `global/DESIGN-SYSTEM.md` | Padrões de UI |
| `global/PATTERNS.md` | Catálogo de padrões de projeto (design patterns) — como o sistema é construído no nível tático; consumido pelo `PROMPT_SDD` |
| `global/VOCABULARY-OVERRIDES.md` | *(opcional)* Ajustes de vocabulário desta instância (verbos/termos — ver FEATURE-DEFINITION) |
| `global/gates-config.yml` | *(opcional)* Papéis dos checkpoints CP1–CP4 desta instância (ver `scripts/gates.py`) |
| `global/CONFORMIDADE-CODIGO.md` | **Conferência doc × código** (2026-08-28) — divergências entre a especificação e o que está implementado no backend e no frontend, e o que foi corrigido |
