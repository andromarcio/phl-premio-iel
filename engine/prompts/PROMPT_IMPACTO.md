# PROMPT IMPACTO — Análise de Impacto de uma evolução

> **Quem participa**: Analista de Requisitos + PO (dá o aval do escopo)
> **Insumo necessário**: a necessidade (linguagem de negócio) + a(s) feature(s)
> existente(s) que ela toca
> **Entrega**: uma **Análise de Impacto (AIM)** em `impactos/AIM-AAAA-NNN.md` — o
> changeset de artefatos de documentação que a evolução vai criar/alterar
> **Onde salvar**: `impactos/AIM-AAAA-NNN.md`

---

## Por que este artefato

Uma necessidade **nunca é 1:1 com uma feature**: ela atravessa artefatos de
naturezas diferentes (a feature muda um campo — *funcional* — e ao mesmo tempo
exige um SLA de resposta — *não-funcional*, que evolui o NFR). A AIM torna esse
escopo **explícito e avalizável**: o PO aprova a lista de artefatos ANTES de
qualquer spec ser escrito, e no fim a lista é **reconciliada** contra o que
realmente mudou (registro de auditoria da evolução).

Só entram na AIM os artefatos que o **PO aprova** — documentação:
`N3 · QA · DATA-MODEL · dicionários · NFR · PATTERNS · API-PATTERNS · MÉTRICA ·
PROTÓTIPO`. O código (repositórios) e artefatos técnicos (SDD, migração, runbook)
são **derivados** destes e ficam fora do escopo de aval.

---

## PASSO 1 — Rascunho derivado (determinístico)

Rode o derivador — ele lê os elos que já vivem nos artefatos e monta as linhas
computáveis do changeset:

```bash
node scripts/generate-impact-draft.mjs --root . \
  --feature <SIGLA-SFS-NN|caminho-do-N3> \
  --need "<necessidade em uma frase>" \
  --id AIM-AAAA-NNN \
  --out impactos/AIM-AAAA-NNN.md
```

Cada linha nasce de um elo, **rotulado na coluna Proveniência**:

| Linha | Elo |
|---|---|
| N3 âncora | cabeçalho `Nível 3` |
| QA (plano E2E) | espelho de path `qa/<dom>/<fs>/<feature>.md` |
| DATA-MODEL + MÉTRICA | seção `## Campos` toca coluna → data-model do domínio → recontagem APF |
| dicionários | refs `→ ver/← *-DICTIONARY` no N3 |
| PROTÓTIPO | `## Superfície` (Tela própria) |
| API-PATTERNS | `## API` (rotas) |
| REPOSITÓRIO | `## Implementação` |
| regressão (QA) | **usado-em reverso**: quem mais usa a mesma regra canônica |

---

## PASSO 2 — Elicitação (o que nenhum elo revela)

O derivador **não adivinha NFR**. Conduza a passada dimensional com o PO/analista
e complete/ajuste a tabela:

1. **Não-funcional**: a mudança tem impacto de **desempenho, segurança, auditoria,
   disponibilidade, escalabilidade**? Se sim, adicione/ajuste a linha `NFR` e
   torne o limiar **mensurável** (ex.: "rápido" → "p95 < 2 s sob carga X").
2. **Teste não-funcional**: todo NFR novo/alterado exige a linha `QA` que o
   **verifique** (teste de desempenho/segurança) — não basta afirmar a qualidade.
3. **Ripples que o elo não pega**: integrações entre domínios, migração de dados
   existentes, mudança de contrato de evento. Registre como linha com a natureza
   correta.
4. **Poda**: remova linhas `candidato` que a análise concluiu que **não** mudam.

Marque as linhas acrescentadas com Proveniência `elicitado`.

---

## PASSO 3 — Validação e aval

```bash
node scripts/validate-impact.mjs impactos/AIM-AAAA-NNN.md --root .
```

O validador cobra as invariantes: **C1** ao menos um `N3`; **C2** todo `funcional`
tem `QA`; **C3** todo `não-funcional` tem `NFR` **e** `QA`; existência dos
caminhos; e o portão de estado.

Com a tabela verde, **apresente a AIM ao PO**. No aval:
- mude `estado:` para `escopo-aprovado` e preencha `avalizado-por:`;
- só então dispare as passadas de execução (`PROMPT_4A/4B` por N3, `PROMPT_NFR`,
  `PROMPT_QA`, recontagem APF) — **uma por linha do changeset**.

---

## PASSO 4 — Fechamento (reconciliação)

Quando os artefatos estiverem implementados e avalizados, feche a AIM:

```bash
node scripts/validate-impact.mjs impactos/AIM-AAAA-NNN.md --git-base <base-da-evolução>
```

Preencha `## Reconciliação` com o resultado e mude `estado:` para `concluído`.
Qualquer **declarado-e-não-tocado** (escopo não cumprido) ou **tocado-e-não-declarado**
(desvio de escopo) precisa de justificativa antes do merge — é o registro de
auditoria de que a evolução fez exatamente o que foi aprovado.

---

## Regra de uso (modo PO × modo DEV)

- **Modo PO**: fale de necessidade e de features por nome; a AIM é a tela de
  aprovação — o PO vê *o que* muda e *de que natureza*, não o MD inteiro.
- **Modo DEV**: a AIM é o plano de trabalho e o escopo do PR — cada linha é uma
  tarefa com operação e gate próprios.
