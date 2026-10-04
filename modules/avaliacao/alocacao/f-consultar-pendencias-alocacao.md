<!-- docqui: 2.8.0 | prompt: PROMPT_3A | atualizado: 2026-08-28 -->
---
id: AVL-ALO-06
feature_set: AVL-ALO
dominio: AVL
entidade: Alocação de Avaliadores
prioridade: P2
mvp: false
data_model_ref: data-models/avaliacao.md#alocacao-de-avaliadores
endpoints: []
error_codes: []
depende_de: [AVL-ALO-04, AVL-APU-03]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Consultar Pendências de Alocação
> **Nível 3** - Feature Set: Alocação — Domínio: Avaliação - `AVL-ALO-06`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Avisa o administrador de que existem participantes aprovados numa etapa já encerrada que ainda não têm avaliadores designados na etapa seguinte, e leva direto à tela onde a alocação pendente é resolvida.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: aviso exibido nas telas administrativas da premiação; leva a `/avaliacao-admin/alocacao-participante`

**Fidelidade ao protótipo**: n/a

⚠️ **Parcialmente implementada** (conferência com o código, 2026-08-28): a apuração das pendências e o componente de aviso existem, mas o aviso **ainda não está montado em nenhuma tela** — nenhum template do frontend o utiliza. Ver `global/CONFORMIDADE-CODIGO.md` § 4.

---

</div>

## Regras de negócio

1. Só há pendência entre duas etapas consecutivas da mesma premiação.
2. Só há pendência quando a etapa anterior está encerrada — antes disso o conjunto de aprovados ainda pode mudar.
3. A pendência conta os participantes aprovados na etapa anterior que não têm nenhum avaliador designado na etapa seguinte.
4. O administrador recebe apenas as pendências de etapas que o seu perfil pode operar.
5. Premiação inativa não gera pendência.
6. Premiação com uma única etapa não gera pendência.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Ser avisado de uma etapa sem alocação
  Given que a etapa Regional está encerrada com dez participantes aprovados
  And que nenhum avaliador foi designado a eles na etapa Nacional
  When acesso a área administrativa da premiação
  Then vejo o aviso de que a etapa Nacional precisa de alocações, com a quantidade de aprovados aguardando

Scenario: Ir direto resolver a pendência
  Given que o aviso de pendência está visível
  When seleciono a pendência
  Then sou levado à alocação por inscrição já com a premiação e a etapa pendente aplicadas

# ── Estados especiais ──────────────────────────────────────────

Scenario: Etapa anterior ainda aberta
  Given que a etapa Regional ainda está aberta
  When acesso a área administrativa da premiação
  Then nenhuma pendência é apontada para a etapa Nacional

Scenario: Sem pendências
  Given que todos os aprovados já têm avaliadores designados na etapa seguinte
  When acesso a área administrativa da premiação
  Then nenhum aviso de pendência é exibido

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Pendência de etapa que o perfil não opera
  Given que a etapa pendente é operada apenas pelo Administrador Nacional
  And que estou autenticado como Administrador Regional
  When acesso a área administrativa da premiação
  Then essa pendência não aparece para mim
```

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Premiação | Premiação | padrão ↑ |
| Etapa pendente | Etapa | padrão ↑ |
| Etapa anterior | Etapa | — |
| Aprovados sem avaliador | derivado (aprovados na etapa anterior sem alocação na etapa pendente) | — |

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Pendência selecionada | seleção → linha da lista de pendências | somente leitura | lista | não | apenas pendências de etapas que o perfil do usuário pode operar |

*A consulta não tem preenchimento: a lista é montada a partir do perfil do usuário autenticado e das premiações ativas.*

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Aprovados sem avaliador | quantidade de aprovados da etapa anterior sem avaliador na etapa pendente | Ao carregar as pendências |

---

## Comportamento de tela

### Onde fica
Aviso apresentado nas telas administrativas da premiação, com uma linha por pendência: premiação, ordem e nome da etapa pendente e a quantidade de aprovados da etapa anterior que aguardam avaliadores. Selecionar a linha abre a Alocação por Inscrição (`/avaliacao-admin/alocacao-participante`) com a premiação e a etapa já aplicadas.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | O aviso permanece oculto enquanto as pendências são carregadas |
| Erro de validação | Não se aplica (não há preenchimento) |
| Erro de servidor | O aviso permanece oculto, sem interromper a tela que o hospeda |
| Sucesso | Exibe a lista de pendências, com o título no singular ou no plural conforme a quantidade |
| Empty state | Sem pendências, o aviso não é exibido |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Aprovados sem avaliador na etapa seguinte geram aviso ao administrador que opera aquela etapa | cenário "Ser avisado de uma etapa sem alocação" |
| SC-02 | O aviso leva à alocação já filtrada pela etapa pendente | cenário "Ir direto resolver a pendência" |
| SC-03 | Etapa anterior ainda aberta não gera aviso | cenário "Etapa anterior ainda aberta" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem processo elementar correspondente. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (pendências de alocação entre etapas consecutivas) — capacidade implementada no servidor, com o aviso ainda não montado em tela |

---

*Feature Set: Alocação · Domínio: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
