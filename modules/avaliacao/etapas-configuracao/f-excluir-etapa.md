<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ETA-04
feature_set: AVL-ETA
dominio: AVL
entidade: Etapa
data_model_ref: data-models/configuracao.md#etapa
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-024_Configurar_Etapas_de_Avaliacao
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

# Excluir Etapa
> **Nível 3** - Feature Set: Etapas e Configuração da Avaliação — Major Feature Set: Avaliação - `AVL-ETA-04`

## Descrição
Permite ao administrador remover uma etapa da premiação quando não há avaliadores alocados nela, preservando o histórico por exclusão lógica.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-024_Configurar_Etapas_de_Avaliacao`](../../../hus/HU-024_Configurar_Etapas_de_Avaliacao.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: os cards de etapa na aba Avaliação & Etapas (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Avaliação & Etapas**)*)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Uma etapa com avaliadores alocados ativos não pode ser excluída enquanto os vínculos existirem. → ver RULES-DICTIONARY: RC-09 — Registro vinculado não pode ser excluído (parâmetro: entidade vinculada = avaliadores alocados; ação alternativa = remover as alocações antes, em Alocação de Avaliadores).
2. A exclusão de etapa é lógica: a etapa deixa de vigorar na premiação, mas o registro é preservado para histórico. ⚠️ *(exclusão lógica inferida do modelo de dados — a etapa possui indicador de ativo no índice `UQ_ETAPA_PREMIACAO_ORDEM_ATIVO`; confirmar se há exclusão física)*
3. A exclusão de uma etapa não renumera as demais etapas automaticamente; a reorganização da sequência é feita por reordenação. ⚠️ *(comportamento da numeração após exclusão a confirmar com a liderança do produto)*

---

## Cenários

```gherkin
Feature: Excluir Etapa

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Excluir etapa sem avaliadores alocados
    Given que a etapa não possui avaliadores alocados
    When aciono a exclusão da etapa e confirmo
    Then o sistema remove a etapa e exibe "Registro excluído com sucesso."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Confirmação antes de excluir
    Given que aciono a exclusão de uma etapa
    When o sistema solicita confirmação
    Then o sistema exibe "Deseja realmente excluir este registro?"

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Excluir etapa com avaliadores alocados
    Given que a etapa possui avaliadores alocados ativos
    When tento excluí-la
    Then o sistema impede a exclusão e exibe "Não é possível excluir: existem avaliadores alocados vinculados a este registro."
    # ← RULES-DICTIONARY: RC-09 — Registro vinculado não pode ser excluído

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de exclusão
    Given que meu perfil não tem permissão para excluir etapas
    When tento acionar a exclusão da etapa
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Etapa | seleção na listagem de etapas | somente leitura | referência → Etapa | sim | etapa alvo da exclusão |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação do registro | Inativo (exclusão lógica) | Na confirmação da exclusão |

---

## Comportamento de tela

### Onde fica
Ação "Remover" no card da etapa, na aba "Avaliação & Etapas" (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Avaliação & Etapas**)*): solicita confirmação antes de desativar a etapa.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa a exclusão |
| Erro de validação | Bloqueia a exclusão quando há avaliadores alocados e explica o motivo |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro excluído com sucesso." e retira a etapa da sequência |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma etapa sem avaliadores alocados é excluída após confirmação | cenário "Excluir etapa sem avaliadores alocados" |
| SC-02 | A exclusão de uma etapa com avaliadores alocados é impedida | cenário "Excluir etapa com avaliadores alocados" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Excluir Etapa | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Excluir Etapa** — ALR (1): Premiação. DER (3): ID · Ação · Mensagem.

```json
{"pe": "Excluir Etapa",
 "alr": ["Premiação"],
 "der": ["ID", "Ação", "Mensagem"]}
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
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-024 |

---

*Feature Set: Etapas e Configuração da Avaliação · Major Feature Set: Avaliação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
