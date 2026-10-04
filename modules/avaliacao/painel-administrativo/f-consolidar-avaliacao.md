<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-PAI-03
feature_set: AVL-PAI
dominio: AVL
entidade: Apuração por Etapa
data_model_ref: data-models/avaliacao.md#apuracao-por-etapa
endpoints: []
error_codes: []
depende_de: [AVL-PAI-02]
origem:
  tipo: issue
  chave: HU-027_Painel_Administrativo_Avaliacoes
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

# Consolidar Avaliação
> **Nível 3** - Feature Set: Painel Administrativo de Avaliações — Major Feature Set: Avaliação - `AVL-PAI-03`

## Descrição
Permite ao administrador consolidar os pareceres dos avaliadores de uma inscrição em uma etapa num único texto oficial da banca, que passa a ser divulgado ao participante e se torna definitivo quando o estado da inscrição é fechado na etapa.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-027_Painel_Administrativo_Avaliacoes`](../../../hus/HU-027_Painel_Administrativo_Avaliacoes.docx) | Criação | — |
| [`HU-031_Consolidar_Feedback`](../../../hus/HU-031_Consolidar_Feedback.docx) | Criação | — |
| [`PDTIC25093-49`](../../../analise-impacto/AIM-PDTIC25093-49.md) | Alteração | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/avaliacoes/:inscricaoId/etapa/:etapaId` (editor de consolidação, aba Consolidação)

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/painel-administrativo/flow.html`

---

</div>

## Regras de negócio

1. A consolidação exige um texto com no mínimo 100 caracteres não-brancos e no máximo 6.000 caracteres. ⚠️ *(mínimo de 100 por HU-027; máximo de 6.000 por HU-031 — confirmar o mínimo definitivo)*
2. A consolidação só é permitida quando todos os avaliadores alocados para a inscrição na etapa concluíram a avaliação.
3. O feedback consolidado é único por inscrição e etapa; enquanto o estado da inscrição estiver aberto na etapa, uma nova consolidação substitui o texto anterior e atualiza a data e o autor, sem manter histórico de versões.
4. A marcação "Gerado com apoio de IA" acompanha o feedback consolidado para rastreabilidade da origem do texto.
5. O feedback consolidado torna-se visível ao participante depois de salvo, respeitada a data de liberação configurada na etapa. ⚠️ *(HU-027 indica visibilidade imediata; HU-031 condiciona à data de liberação — adotada a condição da data)*
6. O feedback consolidado das inscrições de um estado é imutável a partir do fechamento daquele estado na etapa; a reabertura do estado devolve o texto à condição alterável, preservando o conteúdo já consolidado. ⚠️ *(a reabertura por estado é feature nova prevista na SP05, ainda não especificada)*
7. A inscrição sem estado definido consolida no escopo Nacional, sujeito à mesma imutabilidade a partir do fechamento desse escopo. ⚠️ *(agrupamento "Nacional" adotado do fechamento por UF — a confirmar)*
8. O feedback consolidado de todas as inscrições de um estado na etapa é pré-requisito do fechamento daquele estado — pré-condição verificada em Encerrar Etapa por UF (`AVL-APU-03`).

---

## Cenários

```gherkin
Feature: Consolidar Avaliação

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Consolidar o feedback da etapa
    Given que todos os avaliadores alocados finalizaram a avaliação
    When escrevo um texto com 100 caracteres ou mais e confirmo a consolidação
    Then o sistema registra o feedback consolidado com a data e o autor e o disponibiliza ao participante conforme a data de liberação da etapa

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Texto abaixo do mínimo
    Given que estou consolidando o feedback
    When informo um texto com menos de 100 caracteres e confirmo
    Then o sistema não conclui a consolidação enquanto o texto não atingir o mínimo de 100 caracteres

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Avaliadores ainda não finalizaram
    Given que há avaliadores alocados com avaliação pendente
    When acesso a consolidação da etapa
    Then o sistema mantém a consolidação indisponível até que todos os avaliadores finalizem

  Scenario: Re-consolidar substituindo o texto
    Given que já existe um feedback consolidado para a inscrição na etapa e o estado da inscrição continua aberto
    When altero o texto e confirmo novamente a consolidação
    Then o sistema substitui o texto anterior e atualiza a data e o autor da consolidação

  Scenario: Consolidar a última inscrição pendente do estado
    Given que resta uma única inscrição sem feedback consolidado no estado
    When consolido o feedback dessa inscrição
    Then o sistema registra o feedback e o estado passa a ter todas as inscrições consolidadas, atendendo ao pré-requisito do seu fechamento na etapa

  Scenario: Reabertura do estado devolve a consolidação à edição
    Given que o estado da inscrição foi reaberto na etapa depois de fechado
    When altero o texto e confirmo novamente a consolidação
    Then o sistema substitui o texto anterior e atualiza a data e o autor da consolidação

  Scenario: Marcar geração com apoio de IA
    Given que produzi o texto com auxílio de IA
    When assinalo "Gerado com apoio de IA" e confirmo a consolidação
    Then o sistema registra o feedback consolidado com a marcação de geração por IA

  # ── Conflitos com dados existentes ─────────────────────────────

  # ← MESSAGE-DICTIONARY: AVL_CONSOLIDACAO_ESTADO_FECHADO
  Scenario: Alterar a consolidação com o estado já fechado
    Given que o estado da inscrição já foi fechado na etapa
    When altero o texto e confirmo novamente a consolidação
    Then o sistema mantém o texto consolidado anterior e exibe "O estado já foi fechado; o feedback consolidado não pode mais ser alterado."

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de consolidação
    Given que meu perfil não tem permissão para consolidar avaliações
    When tento consolidar o feedback
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Tipo | Obrigatório | Validação |
|---|---|---|---|---|
| Feedback consolidado | entrada do usuário | texto longo | sim | mínimo de 100 caracteres não-brancos; máximo de 6.000 caracteres; alterável somente enquanto o estado da inscrição estiver aberto na etapa |
| Gerado com apoio de IA | entrada do usuário | booleano | não | marcação de rastreabilidade da origem do texto |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Feedback consolidado em | Data e hora do salvamento | Ao salvar a consolidação |
| Feedback consolidado por | Autor da consolidação | Ao salvar a consolidação |
| Status de consolidação | Consolidada | Ao salvar a consolidação |

---

## Comportamento de tela

### Onde fica
Aba "Consolidação" do detalhe da avaliação em `/avaliacao-admin/avaliacoes/:inscricaoId/etapa/:etapaId`: editor do texto consolidado com os pareceres individuais ao lado como referência, pré-visualização de como o participante verá o texto e confirmação antes de publicar. Com o estado da inscrição já fechado na etapa, o editor abre somente para leitura, com o texto consolidado preservado e a indicação do bloqueio.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação de salvar desabilitada com indicador enquanto grava |
| Erro de validação | Destaca o texto quando abaixo de 100 caracteres |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e apresenta a consolidação como publicada |
| Bloqueado | Estado fechado na etapa: campos e ação de salvar desabilitados, com "O estado já foi fechado; o feedback consolidado não pode mais ser alterado." |
| Empty state | Consolidação indisponível enquanto houver avaliadores pendentes |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um texto de 100 caracteres ou mais é registrado como feedback consolidado, com data e autor, quando todos os avaliadores finalizaram | cenário "Consolidar o feedback da etapa" |
| SC-02 | A consolidação permanece indisponível enquanto houver avaliação pendente | cenário "Avaliadores ainda não finalizaram" |
| SC-03 | Uma nova consolidação substitui o texto anterior e atualiza data e autor enquanto o estado está aberto | cenário "Re-consolidar substituindo o texto" |
| SC-04 | A alteração do feedback consolidado é recusada nas inscrições de um estado já fechado na etapa | cenário "Alterar a consolidação com o estado já fechado" |
| SC-05 | Consolidada a última inscrição pendente, o estado passa a atender ao pré-requisito de consolidação para o seu fechamento | cenário "Consolidar a última inscrição pendente do estado" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consolidar Avaliação | EE | 1 | 3 | Simples | 3 | 2026-02-28 |
| Pré-visualizar Consolidação | CE | 1 | 2 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consolidar Avaliação** — ALR (1): Avaliação de Inscrição. DER (3): Texto consolidação · Ação · Mensagem.

```json
{"pe": "Consolidar Avaliação",
 "alr": ["Avaliação de Inscrição"],
 "der": ["Texto consolidação", "Ação", "Mensagem"]}
```
- **Pré-visualizar Consolidação** — ALR (1): Avaliação de Inscrição. DER (2): Texto · Ação.

```json
{"pe": "Pré-visualizar Consolidação",
 "alr": ["Avaliação de Inscrição"],
 "der": ["Texto", "Ação"]}
```

**Total: 6 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/painel-administrativo/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Trava de consolidação com o estado fechado e consolidação completa do estado como pré-requisito do fechamento |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado das HU-027 e HU-031 |

---

*Feature Set: Painel Administrativo de Avaliações · Major Feature Set: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
