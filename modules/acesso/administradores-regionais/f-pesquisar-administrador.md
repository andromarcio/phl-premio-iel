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

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-020_Cadastrar_Admin_Regionais`](../../../hus/HU-020_Cadastrar_Admin_Regionais.docx) | Criação | — |

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | não | filtro por correspondência parcial; nome vindo do login corporativo ⚠️ |
| UF | entrada do usuário | editável | seleção → Unidade Federativa | não | filtro pela UF vinculada ao administrador |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Pesquisar Usuários | CE | 1 | 10 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Pesquisar Usuários** — ALR (1): Usuário. DER (10): Entidade · Perfil · Nome · Login · Email · Situação · Data Cadastro · Data Atualização · Ação · Mensagem.

```json
{"pe": "Pesquisar Usuários",
 "alr": ["Usuário"],
 "der": ["Entidade", "Perfil", "Nome", "Login", "Email", "Situação", "Data Cadastro", "Data Atualização", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-020 e do inventário APF (módulo Usuário) |

---

*Feature Set: Administradores Regionais · Major Feature Set: Acesso e Gestão · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
