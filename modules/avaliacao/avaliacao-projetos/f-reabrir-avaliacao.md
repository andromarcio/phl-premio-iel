---
id: AVL-AVA-05
feature_set: AVL-AVA
dominio: AVL
entidade: Avaliação de Inscrição
prioridade: P2
mvp: false
data_model_ref: data-models/avaliacao.md#avaliação-de-inscrição
endpoints: []
error_codes: []
depende_de: ["AVL-AVA-04"]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Reabrir Avaliação
> **Nível 3** - Feature Set: Avaliação de Projetos — Domínio: Avaliação - `AVL-AVA-05`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Permite ao Administrador Nacional reabrir uma avaliação já finalizada, revertendo-a para Em andamento e preservando as notas registradas, para devolver o trabalho ao avaliador.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: a tela Alocação por Inscrição (`/avaliacao-admin/alocacao-participante`), pelo comando de desfinalizar a avaliação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A reabertura atua sobre uma avaliação já finalizada, revertendo o seu status para Em andamento.
2. A reabertura preserva as notas já registradas pelo avaliador.
3. A reabertura só é possível quando a etapa da inscrição está aberta.
4. A reabertura registra a transição de status e o responsável no histórico da avaliação.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Reabrir avaliação finalizada
  Given que uma avaliação está finalizada e a etapa da inscrição está aberta
  When confirmo a reabertura da avaliação
  Then o sistema reverte a avaliação para Em andamento e preserva as notas registradas

# ── Estados especiais ──────────────────────────────────────────

Scenario: Retomar a pontuação após a reabertura
  Given que reabri uma avaliação finalizada
  When o avaliador acessa a inscrição
  Then o sistema permite novamente a pontuação da inscrição pelo avaliador

# ── Erros de validação ─────────────────────────────────────────

Scenario: Etapa não está aberta
  Given que a etapa da inscrição não está aberta
  When tento reabrir a avaliação
  Then o sistema não reabre e exibe "A etapa precisa estar aberta para reabrir a avaliação."
  # ← MESSAGE-DICTIONARY: AVL_REABERTURA_ETAPA_FECHADA
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Confirmação de reabertura | entrada do usuário | editável | confirmação | sim | reconhece que a avaliação volta para Em andamento, preservando as notas |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Status da avaliação | Em andamento | Na confirmação da reabertura |
| Histórico da avaliação | Transição do status e responsável | Na confirmação da reabertura |

---

## Comportamento de tela

### Onde fica
Na tela Alocação por Inscrição (`/avaliacao-admin/alocacao-participante`), o comando de desfinalizar fica disponível ao Administrador Nacional para avaliações finalizadas cuja etapa esteja aberta.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Comando de reabertura desabilitado com indicador enquanto processa |
| Erro de validação | Reabertura indisponível quando a etapa da inscrição não está aberta |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Reverte a avaliação para Em andamento e preserva as notas |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma avaliação finalizada volta para Em andamento com as notas preservadas | cenário "Reabrir avaliação finalizada" |
| SC-02 | A reabertura é impedida quando a etapa da inscrição não está aberta | cenário "Etapa não está aberta" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Reabrir Avaliação | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Reabrir Avaliação** — ALR (1): Avaliação de Inscrição. DER (3): ID · Ação · Mensagem.

```json
{"pe": "Reabrir Avaliação",
 "alr": ["Avaliação de Inscrição"],
 "der": ["ID", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-025 |

---

*Feature Set: Avaliação de Projetos · Domínio: Avaliação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
