<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-PAR-06
feature_set: INS-PAR
dominio: INS
entidade: Inscrição
data_model_ref: data-models/inscricao.md#aceite-de-termo-do-participante
endpoints: []
error_codes: []
depende_de: [INS-PAR-01]
origem:
  tipo: issue
  chave: HU-015_Inscricao_Participante
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

# Aceitar Termo
> **Nível 3** - Feature Set: Inscrição do Participante — Major Feature Set: Inscrição - `INS-PAR-06`

## Descrição
Permite ao participante registrar o aceite dos termos obrigatórios e opcionais da premiação, condição necessária para concluir a inscrição.

Na tela de termos e finalização, o participante lê o título e o conteúdo de cada termo e marca o aceite dos obrigatórios e, se quiser, dos opcionais; com todos os obrigatórios aceitos, a finalização fica disponível.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-015_Inscricao_Participante`](../../../hus/HU-015_Inscricao_Participante.docx) | Criação | — a HU não numera critérios; realiza "Aceitar Termos de Inscrição": termos obrigatórios e opcionais com título e conteúdo, aceite marcado termo a termo e finalização liberada só com todos os obrigatórios aceitos |

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
Feature: Aceitar Termo

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

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Termo de aceite | Termo de Aceite | exibido do cadastro | somente leitura | referência → Termo de Aceite | sim | termo configurado na premiação |
| Aceito | Aceite de Termo do Participante | entrada do usuário | editável | sim/não | sim (para termos obrigatórios) | obrigatório precisa ser aceito para finalizar |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Data do aceite | Data e hora do aceite | No registro do aceite |
| Origem do aceite | Endereço de origem do participante | No registro do aceite |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Oferta | lê | Os termos apresentados são os definidos para a oferta da inscrição (regra 1; ALR Tipo de Participante do baseline) |

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

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Termo de Aceite | acessório | CE | 2 | 3 | Simples | 3 | 2026-02-28 |

> ⚠️ **Feature sem processo elementar principal.** O PE contado aqui consulta os termos para apresentá-los — intenção própria, por isso `acessório`; o registro do aceite, que é o que esta feature realiza, não tem PE no baseline: ele viaja com a finalização, e a planilha conta o DER *Termo de Aceite* em *Finalizar Inscrição* (`INS-PAR-03` — Finalizar Inscrição). O acessório não foi promovido a principal; a lacuna vai à equipe de métricas.

### Memória de cálculo

**Consultar Termo de Aceite** — CE · ALR 2 · DER 3 · Simples · 3 PF

```json
{"pe": "Consultar Termo de Aceite",
 "alr": ["Premiação", "Tipo de Participante"],
 "der": ["Titulo Termo de Aceite", "Descrição Termo de Aceite", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — o título e o conteúdo dos termos de aceite da premiação
2. `Tipo de Participante` — a oferta da inscrição, que decide quais termos são apresentados

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios cobertos da HU (sem numeração na fonte) na `## Origem`, coluna Entidade em `## Campos` (com o Preenchimento normalizado), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON — o único PE contado é `acessório` e a falta de principal fica registrada com ⚠️. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-015 |

---

*Feature Set: Inscrição do Participante · Major Feature Set: Inscrição · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
