<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-AVA-06
feature_set: AVL-AVA
dominio: AVL
entidade: Avaliação de Inscrição
data_model_ref: data-models/avaliacao.md#avaliacao-de-inscricao
endpoints: []
error_codes: []
depende_de: [AVL-AVA-02, AVL-AVA-03]
origem:
  tipo: issue
  chave: HU-028_Avaliar_Inscricao
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

# Consultar Outros Avaliadores
> **Nível 3** - Feature Set: Avaliação de Projetos — Major Feature Set: Avaliação - `AVL-AVA-06`

## Descrição
Mostra ao avaliador quantas outras pessoas avaliam o mesmo projeto na mesma etapa e em que pé está cada uma, sem revelar quem são nem que notas atribuíram.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-028_Avaliar_Inscricao`](../../../hus/HU-028_Avaliar_Inscricao.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Avaliação do Projeto (`/avaliacao/:alocacaoId`)

**Fidelidade ao protótipo**: n/a *(o protótipo de Avaliação de Projetos declara “Outros avaliadores” como não representado)*

---

</div>

## Regras de negócio

1. O avaliador só consulta os demais avaliadores dos projetos que ele próprio avalia.
2. A consulta exige que o avaliador já tenha aceitado o termo de confidencialidade da premiação. → ver `AVL-AVA-02` (Aceitar Termo de Confidencialidade)
3. Os demais avaliadores aparecem sob apelido numerado, nunca pelo nome.
4. A numeração dos apelidos é estável: o mesmo avaliador recebe sempre o mesmo apelido nas consultas seguintes.
5. O próprio avaliador aparece na lista com o seu nome real e identificado como tal.
6. A consulta não revela nota nem parecer de nenhum avaliador.
7. Só entram na consulta as avaliações ativas da mesma inscrição e da mesma etapa.

---

## Cenários

```gherkin
Feature: Consultar Outros Avaliadores

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Ver o andamento dos demais avaliadores do projeto
    Given que estou avaliando um projeto com mais dois avaliadores designados
    When consulto os demais avaliadores
    Then vejo três linhas: a minha, com o meu nome, e as outras duas como "Avaliador 1" e "Avaliador 2"
    And cada linha traz a situação da avaliação e as datas de início e de finalização

  Scenario: Numeração estável entre consultas
    Given que já consultei os demais avaliadores deste projeto
    When consulto novamente
    Then cada avaliador aparece com o mesmo apelido da consulta anterior

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Consultar sem ter aceitado o termo
    Given que ainda não aceitei o termo de confidencialidade da premiação
    When tento consultar os demais avaliadores
    Then o sistema nega a consulta e me leva ao aceite do termo

  Scenario: Consultar avaliação de outro avaliador
    Given que a avaliação consultada não é minha
    When tento consultar os demais avaliadores por ela
    Then o sistema nega a consulta

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Único avaliador do projeto
    Given que sou o único avaliador designado ao projeto nesta etapa
    When consulto os demais avaliadores
    Then vejo apenas a minha própria linha
```

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Avaliador | derivado (nome próprio ou apelido numerado) | padrão ↑ |
| Situação da avaliação | Avaliação de Inscrição | — |
| Início da avaliação | Avaliação de Inscrição | — |
| Finalização da avaliação | Avaliação de Inscrição | — |

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Avaliação de origem | Avaliação de Inscrição | somente leitura | identificação | sim | precisa ser uma avaliação do próprio avaliador |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Apelido do avaliador | "Avaliador" seguido de um número sequencial estável | Ao montar a consulta, para todo avaliador que não seja o próprio |
| Marca "você" | indicação na linha do próprio avaliador | Ao montar a consulta |

---

## Comportamento de tela

### Onde fica
Bloco dentro da Avaliação do Projeto (`/avaliacao/:alocacaoId`), ao lado do questionário, listando uma linha por avaliador designado ao mesmo projeto na etapa. A linha do próprio avaliador fica destacada.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe indicador no lugar da lista enquanto a consulta é recuperada |
| Erro de validação | Não se aplica (não há preenchimento) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Apresenta a lista com apelidos, situação e datas |
| Empty state | Sendo o único avaliador, exibe apenas a própria linha |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O avaliador acompanha o andamento dos colegas sem descobrir quem são | cenário "Ver o andamento dos demais avaliadores do projeto" |
| SC-02 | Nenhuma nota de outro avaliador é revelada na consulta | regra de negócio 6 |
| SC-03 | A consulta é negada a quem ainda não aceitou o termo de confidencialidade | cenário "Consultar sem ter aceitado o termo" |

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
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (consulta aos demais avaliadores do projeto, com apelido numerado e sem notas) — capacidade implementada e até então não especificada; a HU-028 a mencionava sem detalhamento |

---

*Feature Set: Avaliação de Projetos · Major Feature Set: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
