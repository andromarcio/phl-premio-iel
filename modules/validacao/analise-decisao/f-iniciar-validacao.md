<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-ANA-02
feature_set: VAL-ANA
dominio: VAL
entidade: Validação de Inscrição
data_model_ref: data-models/validacao.md#validacao-de-inscricao
endpoints: []
error_codes: []
depende_de: [VAL-ANA-01]
origem:
  tipo: issue
  chave: HU-018_Analisar_Validar_Inscricao
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

# Iniciar Validação
> **Nível 3** - Feature Set: Análise e Decisão — Major Feature Set: Validação - `VAL-ANA-02`

## Descrição
Permite ao validador iniciar a validação de uma inscrição finalizada, assumindo-a para análise e movendo a sua situação de Finalizada para Em Validação.

No Detalhe da Inscrição finalizada, o validador aciona "Iniciar Validação"; a inscrição passa a Em Validação e o detalhe passa a oferecer as ações de aprovar, rejeitar e solicitar ajuste.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-018_Analisar_Validar_Inscricao`](../../../hus/HU-018_Analisar_Validar_Inscricao.docx) | Criação | — botão "Iniciar Validação", disponível só para a inscrição Finalizada, que passa a situação a Em Validação |

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
Feature: Iniciar Validação

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

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Situação | Inscrição | exibido do cadastro | somente leitura, atualizada pela ação | lista (Finalizada → Em Validação) | — | ação disponível apenas na situação Finalizada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Em Validação | Ao iniciar a validação |
| Usuário validador | validador autenticado | Ao iniciar a validação |
| Data da validação | data e hora da ação | Ao iniciar a validação |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Validação de Inscrição | grava | Registra o validador que assumiu a análise e a data do início (campos automáticos Usuário validador e Data da validação) |

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

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Iniciar Validação | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Iniciar Validação da Inscrição*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Iniciar Validação** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Iniciar Validação",
 "alr": ["Inscrição"],
 "der": ["Inscrição", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Inscrição` — a transação confere a situação Finalizada e grava a situação Em Validação

⚠️ Os campos automáticos (validador e data do início) apontam para a Validação de Inscrição, declarada em `## Dados lidos e gravados`, que a planilha não enumera; o data-model registra que o código só grava esse arquivo na aprovação e na rejeição. Ficou o número da planilha; a divergência vai à equipe de métricas.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios da HU na `## Origem` (a HU não numera critérios: `—` e a prosa do que a feature realiza), coluna Entidade em `## Campos` (o Preenchimento, que trazia o nome da entidade, passa a `exibido do cadastro`), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature (no baseline, *Iniciar Validação da Inscrição*) e o porquê de cada ALR. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/validacao/analise-decisao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-018 |

---

*Feature Set: Análise e Decisão · Major Feature Set: Validação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
