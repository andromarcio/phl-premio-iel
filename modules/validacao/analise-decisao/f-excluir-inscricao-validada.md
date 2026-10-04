<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-ANA-06
feature_set: VAL-ANA
dominio: VAL
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: [VAL-ANA-01, VAL-ANA-03]
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

# Excluir Inscrição Validada
> **Nível 3** - Feature Set: Análise e Decisão — Major Feature Set: Validação - `VAL-ANA-06`

## Descrição
Permite ao administrador nacional retirar da premiação uma inscrição já validada, mediante justificativa, mantendo os dados preservados para consulta e auditoria.

No Detalhe da Inscrição validada, o administrador nacional aciona a exclusão, informa a justificativa no diálogo de confirmação e confirma; a inscrição deixa de constar nas listagens da premiação.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`), diálogo de confirmação com justificativa

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Somente a inscrição na situação Validada pode ser excluída por esta ação.
2. A exclusão exige justificativa preenchida.
3. A exclusão é lógica: os dados da inscrição permanecem preservados e recuperáveis.
4. A inscrição excluída deixa de constar nas listagens, nas alocações e na apuração da premiação.
5. A exclusão é registrada com o responsável, a data e a justificativa.

---

## Cenários

```gherkin
Feature: Excluir Inscrição Validada

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Excluir uma inscrição validada
    Given que a inscrição está na situação Validada
    When confirmo a exclusão informando a justificativa
    Then a inscrição deixa de constar na fila de validação e no ranking da etapa
    And o histórico registra a exclusão com o responsável e a justificativa

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Excluir sem justificativa
    Given que a inscrição está na situação Validada
    When tento confirmar a exclusão sem preencher a justificativa
    Then o sistema não conclui a exclusão e informa que a justificativa é obrigatória

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Excluir inscrição ainda não validada
    Given que a inscrição está na situação Em Validação
    When tento excluí-la por esta ação
    Then o sistema informa que apenas inscrições validadas podem ser excluídas por aqui

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Administrador regional tenta excluir
    Given que estou autenticado como Administrador Regional
    When tento excluir uma inscrição validada
    Then o sistema nega a operação
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Justificativa | Histórico da Inscrição | entrada do usuário | editável | texto longo | sim | não pode ficar em branco |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação do registro | Inativo | Ao confirmar a exclusão |
| Responsável pela exclusão | administrador autenticado | Ao confirmar a exclusão |
| Data da exclusão | data e hora da confirmação | Ao confirmar a exclusão |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Inscrição | lê e grava | Só a inscrição Validada pode ser excluída, e a exclusão lógica a passa à situação de registro Inativo, com os dados preservados (regras 1 e 3; campo automático Situação do registro) |

---

## Comportamento de tela

### Onde fica
Diálogo de confirmação aberto pela ação de exclusão no Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`), disponível apenas quando a inscrição está Validada. O diálogo apresenta a identificação da inscrição, o campo de justificativa e o aviso de que a exclusão retira a inscrição da premiação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão de confirmar desabilitado com indicador enquanto a exclusão é registrada |
| Erro de validação | Destaca a justificativa vazia |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Fecha o diálogo e retorna à lista de inscrições, já sem o registro excluído |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma inscrição Validada excluída deixa de aparecer nas listagens e na apuração | cenário "Excluir uma inscrição validada" |
| SC-02 | Toda exclusão tem justificativa registrada no histórico | cenário "Excluir sem justificativa" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem processo elementar correspondente. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com o bloco `contagem`; sem `origem`, porque o N3 não registra HU nem ticket de origem), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel em `## Métricas de tamanho` (linha ainda não medida). Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (exclusão lógica de inscrição validada com justificativa) — capacidade implementada e até então não especificada |

---

*Feature Set: Análise e Decisão · Major Feature Set: Validação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
