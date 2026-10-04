<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-PAR-07
feature_set: INS-PAR
dominio: INS
entidade: Inscrição
data_model_ref: data-models/inscricao.md#rascunho-autossalvo
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

# Retomar Inscrição
> **Nível 3** - Feature Set: Inscrição do Participante — Major Feature Set: Inscrição - `INS-PAR-07`

## Descrição
Permite ao participante reabrir um rascunho salvo e retomar o preenchimento da inscrição do ponto em que havia parado.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-015_Inscricao_Participante`](../../../hus/HU-015_Inscricao_Participante.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: `/participante/dashboard` (Dashboard do Participante); reabre a inscrição no formulário em `/inscricao/formulario/:inscricaoId`.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A retomada aplica-se a inscrições em estado editável pelo participante: rascunho, em andamento ou aguardando ajuste.
2. A retomada recupera o último conteúdo salvo automaticamente da inscrição, sem perda do trabalho anterior.
3. Cada participante só retoma as próprias inscrições.
4. A retomada não altera o estado da inscrição; apenas devolve o participante ao preenchimento.

---

## Cenários

```gherkin
Feature: Retomar Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Retomar rascunho salvo
    Given que tenho uma inscrição em rascunho salva automaticamente
    When retomo a inscrição
    Then o sistema recupera o último conteúdo salvo
    And o participante continua o preenchimento do ponto em que parou

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Retomar inscrição em ajuste
    Given que minha inscrição está aguardando ajuste
    When retomo a inscrição
    Then o sistema recupera o conteúdo para correção dos itens apontados

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Inscrição de outro participante
    Given que a inscrição pertence a outro participante
    When tento retomá-la
    Then o sistema não permite o acesso à inscrição
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Inscrição | seleção → Inscrição | somente leitura | referência | sim | inscrição em estado editável do próprio participante |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
A retomada parte do dashboard do participante em `/participante/dashboard`, onde cada inscrição editável oferece a continuidade, reabrindo o formulário de inscrição no último ponto salvo.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto recupera o conteúdo salvo |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Reabre a inscrição com o conteúdo recuperado |
| Empty state | Sem inscrições editáveis: nada a retomar |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um rascunho salvo é reaberto com o último conteúdo recuperado, sem perda de trabalho | cenário "Retomar rascunho salvo" |
| SC-02 | Um participante não retoma inscrições de outro participante | cenário "Inscrição de outro participante" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — passo dentro de cadastrar inscrição (retomar rascunho). Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

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
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-015 |

---

*Feature Set: Inscrição do Participante · Major Feature Set: Inscrição · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
