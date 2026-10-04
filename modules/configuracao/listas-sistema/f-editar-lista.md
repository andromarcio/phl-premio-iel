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

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-012_Listas_do_Sistema`](../../../hus/HU-012_Listas_do_Sistema.docx) | Criação | — |

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | sim | máximo de 200 caracteres |
| Código | entrada do usuário | editável | texto | sim | único em todo o sistema; máximo de 50 caracteres |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Lista do Sisetma (implícita) | CE | 1 | 6 | Simples | 3 | 2026-02-28 |
| Editar Lista do Sistema | EE | 1 | 7 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Lista do Sisetma (implícita)** — ALR (1): Listas do Sistema. DER (6): Nome · Código · Valor · Texto · Ordem · Ação.

```json
{"pe": "Consultar Lista do Sisetma (implícita)",
 "alr": ["Listas do Sistema"],
 "der": ["Nome", "Código", "Valor", "Texto", "Ordem", "Ação"]}
```
- **Editar Lista do Sistema** — ALR (1): Listas do Sistema. DER (7): Nome · Código · Valor · Texto · Ordem · Ação · Mensagem.

```json
{"pe": "Editar Lista do Sistema",
 "alr": ["Listas do Sistema"],
 "der": ["Nome", "Código", "Valor", "Texto", "Ordem", "Ação", "Mensagem"]}
```

**Total: 6 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-012 |

---

*Feature Set: Listas do Sistema · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
