---
id: VAL-ANA-02
feature_set: VAL-ANA
dominio: VAL
entidade: Validação de Inscrição
prioridade: P1
mvp: true
data_model_ref: data-models/validacao.md#validacao-de-inscricao
endpoints: []
error_codes: []
depende_de: [VAL-ANA-01]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Iniciar Validação
> **Nível 3** - Feature Set: Análise e Decisão — Domínio: Validação - `VAL-ANA-02`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao validador iniciar a validação de uma inscrição finalizada, assumindo-a para análise e movendo a sua situação de Finalizada para Em Validação.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`)

**Fidelidade ao protótipo**: referência — `prototypes/validacao/analise-decisao/flow.html`

---

</div>

## Regras de negócio

1. Só é possível iniciar a validação de uma inscrição na situação Finalizada.
2. Ao iniciar a validação, a situação da inscrição passa de Finalizada para Em Validação.
3. A validação é assumida pelo validador vinculado à unidade federativa da inscrição.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Assumir uma inscrição finalizada para análise
  Given que a inscrição está na situação Finalizada
  When inicio a validação
  Then a inscrição passa para a situação Em Validação e fica sob a minha análise

# ── Estados especiais ──────────────────────────────────────────

Scenario: Inscrição já em validação
  Given que a inscrição está na situação Em Validação
  When tento iniciar a validação novamente
  Then o sistema mantém a situação atual e não reinicia a validação

Scenario: Inscrição já decidida
  Given que a inscrição está na situação Validada
  When tento iniciar a validação
  Then o sistema não permite iniciar a validação de uma inscrição já decidida
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Situação | Inscrição | somente leitura, atualizada pela ação | lista (Finalizada → Em Validação) | — | ação disponível apenas na situação Finalizada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Em Validação | Ao iniciar a validação |
| Usuário validador | validador autenticado | Ao iniciar a validação |
| Data da validação | data e hora da ação | Ao iniciar a validação |

---

## Comportamento de tela

### Onde fica
Ação disparada pelo botão "Iniciar Validação" no Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`), visível apenas quando a inscrição está na situação Finalizada. Após a ação, o detalhe passa a exibir as ações de aprovar, rejeitar e solicitar ajuste.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Iniciar Validação" desabilitado com indicador enquanto a situação é atualizada |
| Erro de validação | Não se aplica (ação sem formulário) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a situação para "Em Validação" e habilita as ações de decisão |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma inscrição Finalizada passa para Em Validação ao iniciar a validação | cenário "Assumir uma inscrição finalizada para análise" |
| SC-02 | O início da validação não fica disponível para inscrições fora da situação Finalizada | cenário "Inscrição já decidida" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Iniciar Validação da Inscrição | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Iniciar Validação da Inscrição** — ALR (1): Inscrição. DER (3): Inscrição · Ação · Mensagem.

```json
{"pe": "Iniciar Validação da Inscrição",
 "alr": ["Inscrição"],
 "der": ["Inscrição", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/validacao/analise-decisao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-018 |

---

*Feature Set: Análise e Decisão · Domínio: Validação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
