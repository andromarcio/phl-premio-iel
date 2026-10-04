<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-NOT-02
feature_set: INS-NOT
dominio: INS
entidade: Notificação Participante
data_model_ref: data-models/inscricao.md#notificacao-participante
endpoints: []
error_codes: []
depende_de: [INS-NOT-01]
origem:
  tipo: issue
  chave: HU-022_Notificacoes_InApp
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

# Marcar Notificação como Lida
> **Nível 3** - Feature Set: Notificações — Major Feature Set: Inscrição - `INS-NOT-02`

## Descrição
Permite ao participante marcar uma notificação como lida, atualizando a contagem de avisos ainda não lidos.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-022_Notificacoes_InApp`](../../../hus/HU-022_Notificacoes_InApp.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: *(sem rota própria — painel lateral aberto pelo sino no cabeçalho da área do participante)* (Sino e Painel de Notificações); marca uma notificação como lida.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Só o destinatário da notificação pode marcá-la como lida.
2. Marcar uma notificação altera a sua condição de não lida para lida.
3. Ao marcar como lida uma notificação que estava não lida, a contagem de não lidas do participante diminui em uma unidade.
4. Uma notificação já lida permanece lida, e marcá-la de novo não altera a contagem de não lidas.

---

## Cenários

```gherkin
Feature: Marcar Notificação como Lida

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Marcar notificação não lida
    Given que tenho uma notificação não lida
    When marco a notificação como lida
    Then o sistema registra a notificação como lida
    And a contagem de não lidas diminui em uma unidade

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Marcar notificação já lida
    Given que a notificação já está lida
    When marco a notificação como lida novamente
    Then o sistema mantém a notificação como lida e não altera a contagem de não lidas

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Notificação de outro participante
    Given que a notificação pertence a outro participante
    When tento marcá-la como lida
    Then o sistema não permite a ação sobre a notificação
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Notificação | seleção → Notificação Participante | somente leitura | referência | sim | notificação do próprio participante |
| Lida | entrada do usuário | editável | sim/não | — | passa a lida ao marcar |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Contagem de não lidas | Recalculada após a marcação | Ao marcar a notificação como lida |

---

## Comportamento de tela

### Onde fica
A marcação parte do painel de notificações em *(sem rota própria — painel lateral aberto pelo sino no cabeçalho da área do participante)*: ao selecionar uma notificação não lida, ela passa a lida e a contagem de não lidas no sino é atualizada.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Indicador breve enquanto registra a marcação |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Marca a notificação como lida e atualiza a contagem de não lidas |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Marcar uma notificação não lida a torna lida e reduz a contagem de não lidas | cenário "Marcar notificação não lida" |
| SC-02 | Marcar uma notificação já lida não altera a contagem de não lidas | cenário "Marcar notificação já lida" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Marcar Notificação como Lida | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Marcar Notificação como Lida** — ALR (1): Notificação Participante. DER (3): Notificação · Ação · Mensagem.

```json
{"pe": "Marcar Notificação como Lida",
 "alr": ["Notificação Participante"],
 "der": ["Notificação", "Ação", "Mensagem"]}
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
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-022 |

---

*Feature Set: Notificações · Major Feature Set: Inscrição · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
