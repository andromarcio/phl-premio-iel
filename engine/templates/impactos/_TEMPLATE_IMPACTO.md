<!-- doc-template-engine | prompt: PROMPT_IMPACTO -->
---
estado: rascunho          # rascunho → em-análise → escopo-aprovado → em-execução → concluído
origem: [STRYxxxx | ISSUE-nnn]
data: [AAAA-MM-DD]
feature-ancora: [SIGLA-SFS-NN]
avalizado-por:            # preenchido no aval do PO (obrigatório de escopo-aprovado em diante)
---
# AIM-AAAA-NNN — [título da necessidade]

## Necessidade
> [o pedido em linguagem de negócio — o "porquê", não a solução]

## Features-âncora
- [Nome da feature] — `[SIGLA-SFS-NN]` (alteração | inclusão)

## Artefatos impactados

> O **changeset** que o PO aprova ANTES de qualquer artefato ser escrito. Linhas
> `derivado:` nascem dos elos (trace, usado-em, data-model, implementação); linhas
> `elicitar` exigem a passada do `analista-requisitos` (NFR e limiares de teste NF
> não são deriváveis). Só artefatos de **documentação** entram aqui — o resto é
> técnico, derivado destes.
>
> Invariantes (o `validate-impact` cobra): **C1** ao menos uma linha `N3`;
> **C2** toda linha `funcional` tem uma linha `QA`; **C3** toda linha
> `não-funcional` tem `NFR` **e** `QA`.

| Artefato | Tipo | Operação | Seção | Natureza | O quê | Proveniência |
|---|---|---|---|---|---|---|
| `modules/<dom>/<fs>/f-<slug>.md` | N3 | alterar | Campos/Regras/Cenários | funcional | [o que muda] | derivado: âncora |
| `qa/<dom>/<fs>/<slug>.md` | QA | criar | — | funcional | plano E2E | derivado: espelho do N3 |
| `global/data-models/<dom>.md` | DATA-MODEL | alterar | — | dados | [coluna/entidade] | derivado: ## Campos |
| `global/NFR.md` | NFR | alterar | [SEG/DES/…] | não-funcional | [qualidade a garantir] | elicitar |

> Tipos: `N3 · QA · DATA-MODEL · FIELD-DICT · RULES-DICT · MESSAGE-DICT ·
> ERROR-DICT · NFR · PATTERNS · API-PATTERNS · MÉTRICA · PROTÓTIPO · REPOSITÓRIO`.
> Operação: `criar | alterar | deprecar`.

## Dimensionamento (APF)
> Delta de PF do changeset (ver `global/CONTAGEM-PF.md`). Preenchido no 3B das
> features-âncora.

## Reconciliação
> Preenchida no fechamento (estado `concluído`): artefatos **declarados** acima ×
> artefatos **efetivamente tocados** no diff/PR. Rodar:
> `node scripts/validate-impact.mjs impactos/AIM-….md --git-base <base>`.
> Declarado-e-não-tocado = escopo não cumprido; tocado-e-não-declarado = desvio.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| [AAAA-MM-DD] | [autor] | AIM criada | rascunho derivado de `[SIGLA-SFS-NN]` |
