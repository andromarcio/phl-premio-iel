<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-LIS-04
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

# Excluir Lista
> **Nível 3** - Feature Set: Listas do Sistema — Major Feature Set: Configuração da Premiação - `CFG-LIS-04`

## Descrição
Permite ao administrador remover uma lista de valores por exclusão lógica, retirando-a da consulta e da oferta como fonte de opções sem apagá-la do sistema.

Na tela Listas do Sistema, o administrador aciona o ícone de exclusão na linha da lista e confirma no diálogo; a lista deixa de aparecer no resultado da busca.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-012_Listas_do_Sistema`](../../../hus/HU-012_Listas_do_Sistema.docx) | Criação | — RF-04 da HU: confirmação antes de desativar, desativação por exclusão lógica e recarga da listagem |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Lista de Listas do Sistema (`/configuracao-premiacao/listas-sistema`), a partir da ação de exclusão na linha da lista, com confirmação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A exclusão é lógica: a lista passa à situação inativa e não é apagada do sistema.
2. Uma lista inativa deixa de ser elegível como fonte de opções em novas configurações. ⚠️ *(impacto sobre configurações que já referenciam a lista a confirmar com o administrador antes da exclusão)*

---

## Cenários

```gherkin
Feature: Excluir Lista

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Excluir lista após confirmação
    Given que identifico uma lista para excluir
    When aciono a exclusão e confirmo
    Then o sistema remove a lista por exclusão lógica e exibe "Registro excluído com sucesso."
    And a lista deixa de aparecer no resultado da busca

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Pedido de confirmação antes de excluir
    Given que aciono a exclusão de uma lista
    When o sistema pede confirmação
    Then o sistema exibe "Deseja realmente excluir este registro?"

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para excluir
    Given que meu perfil não tem permissão para excluir listas
    When tento excluir uma lista
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Lista | Lista do Sistema | exibido do cadastro | somente leitura | texto | — | lista sobre a qual a exclusão é aplicada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Inativa | Ao confirmar a exclusão lógica |

---

## Comportamento de tela

### Onde fica
Ação disparada da linha da lista na tela de Listas do Sistema (`/configuracao-premiacao/listas-sistema`): ícone de exclusão que abre um diálogo de confirmação antes de remover a lista.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro excluído com sucesso." e atualiza o resultado da busca |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Após confirmação, a lista é removida por exclusão lógica e some do resultado | Critério de aceite RF-04 (HU-012) |
| SC-02 | A exclusão pede confirmação antes de ser efetivada | cenário "Pedido de confirmação antes de excluir" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Excluir Lista | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Excluir Lista do Sistema*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Excluir Lista** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Excluir Lista",
 "alr": ["Listas do Sistema"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Listas do Sistema` — a transação grava a situação inativa da lista (exclusão lógica)

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios da HU na `## Origem` citados pelo RF (a HU-012 agrupa os critérios de aceitação por RF-01 a RF-08, sem numeração `CA-n`; a célula abre com `—`), coluna Entidade em `## Campos`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-012 |

---

*Feature Set: Listas do Sistema · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
