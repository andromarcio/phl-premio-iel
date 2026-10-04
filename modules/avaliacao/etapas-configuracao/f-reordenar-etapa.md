<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ETA-05
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

# Reordenar Etapas
> **Nível 3** - Feature Set: Etapas e Configuração da Avaliação — Major Feature Set: Avaliação - `AVL-ETA-05`

## Descrição
Permite ao administrador alterar a ordem relativa das etapas da premiação enquanto nenhuma delas estiver fechada, mantendo a numeração sequencial sem lacunas.

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

1. A ordem relativa das etapas só pode ser alterada enquanto nenhuma etapa da premiação estiver na situação Fechada, preservando a estabilidade da cascata de aprovações já oficializada.
2. A reordenação mantém a numeração sequencial de 1 a N, sem lacunas nem posições repetidas.
3. A reordenação altera apenas a posição das etapas; nome, período, perfis autorizados e situação de cada etapa permanecem inalterados.

---

## Cenários

```gherkin
Feature: Reordenar Etapas

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Mover uma etapa para outra posição
    Given que nenhuma etapa da premiação está fechada
    When movo a etapa da posição 3 para a posição 2
    Then o sistema atualiza a sequência e renumera as etapas de 1 a N sem lacunas

  # ── Estados especiais ──────────────────────────────────────────

  # ← MESSAGE-DICTIONARY: AVL_REORDENACAO_BLOQUEADA
  Scenario: Reordenação bloqueada por etapa fechada
    Given que ao menos uma etapa da premiação está na situação Fechada
    When tento reordenar as etapas
    Then o sistema impede a reordenação e exibe "Há etapas já fechadas nesta premiação. Reordenar etapas agora invalidaria a cadeia de aprovações dos participantes."

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de reordenação
    Given que meu perfil não tem permissão para reordenar etapas
    When tento reordenar as etapas
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Ordem | derivado (posição na sequência) | editável por reordenação | número inteiro | sim | sequência de 1 a N, sem lacunas nem repetições |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Ordem das etapas | Renumeração de 1 a N conforme a nova sequência | Ao confirmar a reordenação |

---

## Comportamento de tela

### Onde fica
Ações de subir e descer no card de cada etapa, na aba "Avaliação & Etapas" (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Avaliação & Etapas**)*); quando há etapa fechada, um aviso explica por que a reordenação está indisponível.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ações de mover desabilitadas com indicador enquanto grava a nova ordem |
| Erro de validação | Não se aplica (a nova posição é sempre válida na faixa da sequência) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Reflete a nova ordem no fluxo visual e nos cards das etapas |
| Empty state | Ações de mover indisponíveis quando há etapa fechada na premiação |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Mover uma etapa reordena a sequência e mantém a numeração de 1 a N sem lacunas | cenário "Mover uma etapa para outra posição" |
| SC-02 | A reordenação é impedida quando há ao menos uma etapa fechada | cenário "Reordenação bloqueada por etapa fechada" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Alterar ordem das etapas | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Alterar ordem das etapas** — ALR (1): Premiação. DER (4): ID · Ordem · Ação · Mensagem.

```json
{"pe": "Alterar ordem das etapas",
 "alr": ["Premiação"],
 "der": ["ID", "Ordem", "Ação", "Mensagem"]}
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
