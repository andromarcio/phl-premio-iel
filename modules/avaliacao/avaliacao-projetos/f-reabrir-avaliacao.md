<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-AVA-05
feature_set: AVL-AVA
dominio: AVL
entidade: Avaliação de Inscrição
data_model_ref: data-models/avaliacao.md#avaliação-de-inscrição
endpoints: []
error_codes: []
depende_de: ["AVL-AVA-04"]
origem:
  tipo: issue
  chave: HU-025_Alocar_Avaliadores
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

# Reabrir Avaliação
> **Nível 3** - Feature Set: Avaliação de Projetos — Major Feature Set: Avaliação - `AVL-AVA-05`

## Descrição
Permite ao Administrador Nacional reabrir uma avaliação já finalizada, revertendo-a para Em andamento e preservando as notas registradas, para devolver o trabalho ao avaliador.

Na tela Alocação por Inscrição, o Administrador Nacional aciona o comando de desfinalizar na avaliação finalizada da inscrição e confirma a reabertura.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-025_Alocar_Avaliadores`](../../../hus/HU-025_Alocar_Avaliadores.docx) | Criação | — ação *Desfinalizar Alocação* da HU: devolve a avaliação finalizada para Em andamento preservando as notas, só com a etapa Aberta e só pelo Administrador Nacional |

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
Feature: Reabrir Avaliação

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

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Confirmação de reabertura | Avaliação de Inscrição | entrada do usuário | editável | confirmação | sim | reconhece que a avaliação volta para Em andamento, preservando as notas |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Status da avaliação | Em andamento | Na confirmação da reabertura |
| Histórico da avaliação | Transição do status e responsável | Na confirmação da reabertura |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Etapa | lê | A reabertura só é possível com a etapa da inscrição aberta (regra 3) |
| Histórico de Avaliação | grava | Recebe a transição de status e o responsável pela reabertura (regra 4 e campo automático *Histórico da avaliação*) |

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

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Reabrir Avaliação | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

**Reabrir Avaliação** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Reabrir Avaliação",
 "alr": ["Avaliação de Inscrição"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Avaliação de Inscrição` — a transação devolve a avaliação a Em andamento e registra a transição e o responsável no histórico, subgrupo do mesmo arquivo lógico

⚠️ A planilha conta ALR 1, mas a reabertura confere antes a situação da etapa da inscrição (regra 3), leitura do arquivo lógico *Premiação* que a enumeração não traz. Ficou o número da planilha; a divergência vai à equipe de métricas.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); HU de origem corrigida na `## Origem` — sai a HU-028, que só cita a reabertura numa regra, e fica a HU-025, que traz a ação de desfinalizar — e critérios em prosa, porque a HU não numera critérios; coluna Entidade em `## Campos`; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-025 |

---

*Feature Set: Avaliação de Projetos · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
