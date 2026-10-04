<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: ACS-ADM-01
feature_set: ACS-ADM
dominio: ACS
entidade: Usuário
data_model_ref: data-models/acesso.md#usuario-vinculo-por-uf
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-020_Cadastrar_Admin_Regionais
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
contagem:
  pendente: true
  revisada_em: ""
  revisada_ate: ""
---

# Pesquisar Administradores
> **Nível 3** - Feature Set: Administradores Regionais — Major Feature Set: Acesso e Gestão - `ACS-ADM-01`

## Descrição
Permite ao administrador nacional localizar administradores regionais por nome e por UF vinculada, listando-os para consulta, edição ou atribuição de escopo.

Na Lista de Administradores, o administrador nacional digita parte do nome, escolhe, se quiser, a UF vinculada e vê a lista paginada com nome, e-mail e UFs de cada administrador regional, de onde abre a edição ou a configuração de UFs.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-020_Cadastrar_Admin_Regionais`](../../../hus/HU-020_Cadastrar_Admin_Regionais.docx) | Criação | — a HU não numera critérios de aceite; da funcionalidade *Visualizar UFs do Administrador*, a lista mostra as UFs atribuídas a cada administrador regional e filtra por UF |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/administracao-usuarios` (Lista de Administradores)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A busca abrange os usuários com perfil de administrador regional. ⚠️ *(a identidade vem do login corporativo/SSO; confirmar como o conjunto de administradores regionais é identificado)*
2. Um administrador regional possui uma ou mais UFs vinculadas, que definem o seu escopo de validação.
3. A busca por nome é por correspondência parcial (não exige o nome exato).

---

## Cenários

```gherkin
Feature: Pesquisar Administradores

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Listar administradores ao abrir a tela
    Given que existem administradores regionais cadastrados
    When acesso a tela de Administradores
    Then o sistema exibe a lista de administradores com nome, e-mail e UFs vinculadas

  Scenario: Buscar administrador por parte do nome
    Given que existe o administrador "Maria Souza"
    When informo "maria" no campo de busca por nome
    Then o sistema exibe o administrador "Maria Souza" no resultado

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Filtrar por UF vinculada
    Given que existem administradores vinculados a UFs diferentes
    When seleciono a UF "SP"
    Then o sistema exibe apenas os administradores vinculados à UF "SP"

  Scenario: Busca sem resultados
    Given que nenhum administrador corresponde ao termo buscado
    When realizo a busca
    Then o sistema exibe "Nenhum resultado para a busca."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome | externo: Portal corporativo | entrada do usuário | editável | texto | não | filtro por correspondência parcial; nome vindo do login corporativo ⚠️ |
| UF | Unidade Federativa | entrada do usuário | editável | seleção → Unidade Federativa | não | filtro pela UF vinculada ao administrador |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Nome | Usuário | padrão ↑ |
| E-mail | Usuário | — |
| UFs vinculadas | derivado (vínculo por UF) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Usuário | lê | O vínculo de cada administrador regional com as UFs alimenta a coluna *UFs vinculadas* e o filtro por UF (regra 2; ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Página própria em `/administracao-usuarios` (Lista de Administradores): campo de busca por nome, filtro por UF e a lista paginada de administradores regionais.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a lista é recuperada |
| Erro de validação | Não se aplica (filtros são opcionais) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a lista de administradores correspondentes |
| Empty state | Sem administradores cadastrados: "Nenhum registro encontrado."; busca sem resultado: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A tela lista os administradores regionais com filtro por nome e por UF vinculada | cenário "Listar administradores ao abrir a tela" |
| SC-02 | A busca por parte do nome retorna os administradores cujo nome contém o termo | cenário "Buscar administrador por parte do nome" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Pesquisar Administradores | principal | CE | 1 | 10 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Pesquisar Usuários*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Pesquisar Administradores** — CE · ALR 1 · DER 10 · Simples · 3 PF

```json
{"pe": "Pesquisar Administradores",
 "alr": ["Usuário"],
 "der": ["Entidade", "Perfil", "Nome", "Login", "Email", "Situação", "Data Cadastro", "Data Atualização", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Usuário` — a lista traz os administradores regionais e as UFs vinculadas a cada um, guardadas no vínculo usuário↔UF

⚠️ Nome, login e e-mail dos administradores vêm do portal corporativo, que a planilha não conta como arquivo lógico (a identidade é candidata a AIE — ver a nota de identidade externa em `global/data-models/acesso.md`). Ficou o número da planilha; a questão vai à equipe de métricas junto com o questionamento do baseline.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), prosa da HU na `## Origem` (a HU não numera critérios), coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-020 e do inventário APF (módulo Usuário) |

---

*Feature Set: Administradores Regionais · Major Feature Set: Acesso e Gestão · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
