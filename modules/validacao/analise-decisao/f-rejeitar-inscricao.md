<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-ANA-04
feature_set: VAL-ANA
dominio: VAL
entidade: Validação de Inscrição
data_model_ref: data-models/validacao.md#validacao-de-inscricao
endpoints: []
error_codes: []
depende_de: [VAL-ANA-01, VAL-ANA-02]
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

# Rejeitar Inscrição
> **Nível 3** - Feature Set: Análise e Decisão — Major Feature Set: Validação - `VAL-ANA-04`

## Descrição
Permite ao validador concluir a validação rejeitando a inscrição, mediante parecer obrigatório, de modo que ela passe à situação Rejeitada e seja encerrada.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-018_Analisar_Validar_Inscricao`](../../../hus/HU-018_Analisar_Validar_Inscricao.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Diálogo de Validação, a partir do Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`)

**Fidelidade ao protótipo**: referência — `prototypes/validacao/analise-decisao/flow.html`

---

</div>

## Regras de negócio

1. A rejeição está disponível para inscrições nas situações Em Validação, Aguardando Ajuste e Ajustes Concluídos.
2. Ao rejeitar, a situação da inscrição passa para Rejeitada.
3. O parecer é obrigatório na rejeição e deve ter no mínimo 10 caracteres. ⚠️ *(a exigência está apenas na tela — o servidor aceita a rejeição sem parecer; ver `global/CONFORMIDADE-CODIGO.md` § 3.1.)*
4. A rejeição é registrada com o responsável, a data e o parecer.
5. A inscrição só pode ser rejeitada pelo validador vinculado à unidade federativa da inscrição.

---

## Cenários

```gherkin
Feature: Rejeitar Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Rejeitar a inscrição com parecer
    Given que a inscrição está na situação Em Validação
    When rejeito a inscrição informando o parecer
    Then a inscrição passa para a situação Rejeitada

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Rejeitar sem parecer
    Given que a inscrição está na situação Em Validação
    When confirmo a rejeição sem preencher o parecer
    Then o sistema não conclui a rejeição e exibe "Campo obrigatório."

  Scenario: Parecer abaixo do mínimo
    Given que informo um parecer com menos de 10 caracteres
    When confirmo a rejeição
    Then o sistema não conclui a rejeição e exibe "Mínimo de 10 caracteres."

  # ── Restrições de situação ─────────────────────────────────────

  Scenario: Rejeitar inscrição ainda não assumida
    Given que a inscrição está na situação Finalizada
    When tento rejeitar a inscrição
    Then o sistema não permite rejeitar antes de iniciar a validação
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Parecer | entrada do usuário | editável | texto longo | sim | obrigatório na rejeição; mínimo de 10 caracteres |
| Situação | Inscrição | somente leitura, atualizada pela ação | lista (Em Validação → Rejeitada) | — | ação disponível apenas na situação Em Validação |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Rejeitada | Ao rejeitar a inscrição |
| Usuário validador | validador autenticado | Ao rejeitar a inscrição |
| Data da validação | data e hora da decisão | Ao rejeitar a inscrição |

---

## Comportamento de tela

### Onde fica
Ação disparada pelo botão "Rejeitar" no Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`), que abre o Diálogo de Validação com o campo de parecer obrigatório. O botão fica disponível apenas quando a inscrição está na situação Em Validação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Rejeitar" desabilitado com indicador enquanto a decisão é registrada |
| Erro de validação | Destaca o campo Parecer com "Campo obrigatório." quando vazio |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a situação para "Rejeitada" e retorna ao detalhe com o veredito |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma inscrição Em Validação passa para Rejeitada ao ser rejeitada com parecer | cenário "Rejeitar a inscrição com parecer" |
| SC-02 | A rejeição sem parecer é impedida | cenário "Rejeitar sem parecer" |
| SC-03 | O parecer de rejeição exige no mínimo 10 caracteres | cenário "Parecer abaixo do mínimo" |

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
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/validacao/analise-decisao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-018 |

---

*Feature Set: Análise e Decisão · Major Feature Set: Validação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
