<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-LIS-03
feature_set: CFG-LIS
dominio: CFG
entidade: Lista do Sistema
data_model_ref: data-models/configuracao.md#lista-do-sistema
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-012_Listas_do_Sistema
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

# Editar Lista
> **Nível 3** - Feature Set: Listas do Sistema — Major Feature Set: Configuração da Premiação - `CFG-LIS-03`

## Descrição
Permite ao administrador alterar o nome ou o código de uma lista já cadastrada, mantendo a fonte de opções dos formulários atualizada.

Na tela Listas do Sistema, o administrador aciona "Editar" na linha da lista, altera o nome ou o código na aba "Dados da Lista" e aciona "Salvar Lista"; a aba "Itens", ao lado, abre com os itens ativos na ordem definida.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-012_Listas_do_Sistema`](../../../hus/HU-012_Listas_do_Sistema.docx) | Criação | — RF-03 e RF-05 da HU: "Editar" abre o formulário com os dados básicos e os itens ativos ordenados; Nome e Código continuam obrigatórios ao salvar |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/listas-sistema/:listaSistemaId/editar` (Formulário da Lista, aba Dados da Lista)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O código da lista é único em todo o sistema.
2. O nome e o código continuam obrigatórios ao salvar a edição.
3. Ao abrir a lista para edição, apenas os itens ativos são carregados.

---

## Cenários

```gherkin
Feature: Editar Lista

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Editar nome e código
    Given que selecionei uma lista existente
    When altero o nome e o código e clico em "Salvar Lista"
    Then o sistema grava as alterações e exibe "Registro salvo com sucesso."

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome ou código apagado na edição
    Given que estou editando uma lista
    When apago o campo Nome ou o campo Código e clico em "Salvar Lista"
    Then o sistema não grava e exibe "Campo obrigatório."

  # ── Conflitos com dados existentes ─────────────────────────────

  # ← MESSAGE-DICTIONARY: CFG_LISTA_CODIGO_DUPLICADO
  Scenario: Alterar o código para um já usado por outra lista
    Given que já existe outra lista com o código "UF_BRASIL"
    When altero o código da lista atual para "UF_BRASIL"
    Then o sistema não grava e exibe "Já existe uma lista com este código."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome | Lista do Sistema | entrada do usuário | editável | texto | sim | máximo de 200 caracteres |
| Código | Lista do Sistema | entrada do usuário | editável | texto | sim | único em todo o sistema; máximo de 50 caracteres |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Item da Lista do Sistema | lê | Ao abrir a lista para edição, os itens ativos são carregados na ordem definida (regra 3) |

---

## Comportamento de tela

### Onde fica
Formulário da lista em `/configuracao-premiacao/listas-sistema/:listaSistemaId/editar`, aba "Dados da Lista" (nome e código); a aba "Itens" fica disponível ao lado para a configuração dos valores.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar Lista" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo obrigatório com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de nome e código de uma lista são persistidas | cenário "Editar nome e código" |
| SC-02 | A tentativa de alterar o código para um já usado é rejeitada | cenário "Alterar o código para um já usado por outra lista" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Lista do Sisetma (implícita) | acessório | CE | 1 | 6 | Simples | 3 | 2026-02-28 |
| Editar Lista | principal | EE | 1 | 7 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar principal se chama *Editar Lista do Sistema*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline. O acessório mantém o nome da planilha, inclusive a grafia *Sisetma*.

### Memória de cálculo

**Consultar Lista do Sisetma (implícita)** — CE · ALR 1 · DER 6 · Simples · 3 PF

```json
{"pe": "Consultar Lista do Sisetma (implícita)",
 "alr": ["Listas do Sistema"],
 "der": ["Nome", "Código", "Valor", "Texto", "Ordem", "Ação"]}
```

Por que cada ALR:
1. `Listas do Sistema` — o formulário abre com o nome e o código da lista e com os itens ativos (valor, texto e ordem), que a pesquisa não mostrava

**Editar Lista** — EE · ALR 1 · DER 7 · Simples · 3 PF

```json
{"pe": "Editar Lista",
 "alr": ["Listas do Sistema"],
 "der": ["Nome", "Código", "Valor", "Texto", "Ordem", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Listas do Sistema` — a transação grava o nome e o código alterados

⚠️ A planilha conta *Valor*, *Texto* e *Ordem* também nesta transação; pelo N3, os itens são gravados por "Salvar Itens", em `CFG-LIS-05` — Configurar Itens da Lista, e "Salvar Lista" grava só o nome e o código. Ficou o número da planilha; a divergência vai à equipe de métricas junto com o questionamento do baseline.

**Total: 6 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios da HU na `## Origem` citados pelo RF (a HU-012 agrupa os critérios de aceitação por RF-01 a RF-08, sem numeração `CA-n`; a célula abre com `—`), coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-012 |

---

*Feature Set: Listas do Sistema · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
