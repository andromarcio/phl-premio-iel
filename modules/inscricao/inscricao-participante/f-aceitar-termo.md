---
id: INS-PAR-06
feature_set: INS-PAR
dominio: INS
entidade: Inscrição
prioridade: P1
mvp: true
data_model_ref: data-models/inscricao.md#aceite-de-termo-do-participante
endpoints: []
error_codes: []
depende_de: [INS-PAR-01]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Aceitar Termo
> **Nível 3** - Feature Set: Inscrição do Participante — Domínio: Inscrição - `INS-PAR-06`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao participante registrar o aceite dos termos obrigatórios e opcionais da premiação, condição necessária para concluir a inscrição.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: `/inscricao/termos/:inscricaoId` (Termos e Finalização); registra o aceite de cada termo apresentado.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A premiação define, por oferta, os termos obrigatórios e os opcionais apresentados ao participante.
2. Um termo obrigatório precisa ser aceito pelo participante para que a inscrição possa ser finalizada.
3. Um termo opcional pode ser aceito ou não, a critério do participante.
4. Cada aceite registra o termo aceito, o participante, a data e a origem do aceite.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Aceitar termo obrigatório
  Given que a inscrição apresenta um termo obrigatório
  When registro o aceite do termo
  Then o sistema registra o aceite com a data e a origem
  And o termo passa a constar como aceito

Scenario: Aceitar termo opcional
  Given que a inscrição apresenta um termo opcional
  When registro o aceite do termo opcional
  Then o sistema registra o aceite do termo opcional

# ── Estados especiais ──────────────────────────────────────────

Scenario: Termo obrigatório não aceito impede a finalização
  Given que existe um termo obrigatório ainda não aceito
  When consulto a situação da inscrição para finalização
  Then o sistema mantém a finalização indisponível até o aceite do termo
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Termo de aceite | contexto da premiação | somente leitura | referência → Termo de Aceite | sim | termo configurado na premiação |
| Aceito | entrada do usuário | editável | sim/não | sim (para termos obrigatórios) | obrigatório precisa ser aceito para finalizar |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Data do aceite | Data e hora do aceite | No registro do aceite |
| Origem do aceite | Endereço de origem do participante | No registro do aceite |

---

## Comportamento de tela

### Onde fica
Tela de termos e finalização em `/inscricao/termos/:inscricaoId`: cada termo exibe título e conteúdo, com a marcação de aceite dos termos obrigatórios e opcionais antes da finalização.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto recupera os termos da premiação |
| Erro de validação | Indica os termos obrigatórios ainda não aceitos |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Registra o aceite e marca o termo como aceito |
| Empty state | Premiação sem termos configurados: nada a aceitar |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O aceite de um termo é registrado com data e origem, e o termo passa a aceito | cenário "Aceitar termo obrigatório" |
| SC-02 | Enquanto houver termo obrigatório não aceito, a finalização permanece indisponível | cenário "Termo obrigatório não aceito impede a finalização" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Termo de Aceite | CE | 2 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Termo de Aceite** — ALR (2): Premiação · Tipo de Participante. DER (3): Titulo Termo de Aceite · Descrição Termo de Aceite · Ação.

```json
{"pe": "Consultar Termo de Aceite",
 "alr": ["Premiação", "Tipo de Participante"],
 "der": ["Titulo Termo de Aceite", "Descrição Termo de Aceite", "Ação"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-015 |

---

*Feature Set: Inscrição do Participante · Domínio: Inscrição · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
