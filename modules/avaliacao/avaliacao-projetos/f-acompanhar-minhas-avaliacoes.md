<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-AVA-01
feature_set: AVL-AVA
dominio: AVL
entidade: Avaliação de Inscrição
data_model_ref: data-models/avaliacao.md#avaliação-de-inscrição
endpoints: []
error_codes: []
depende_de: ["AVL-ALO-04"]
origem:
  tipo: issue
  chave: HU-033_Painel_Avaliacao_Avaliador
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

# Acompanhar Minhas Avaliações
> **Nível 3** - Feature Set: Avaliação de Projetos — Major Feature Set: Avaliação - `AVL-AVA-01`

## Descrição
Permite ao avaliador acompanhar, em uma tela própria, todas as inscrições que lhe foram alocadas, com indicadores de andamento, prazos e seleção por premiação, etapa e status.

No menu Minhas Avaliações, o avaliador abre o Painel do Avaliador, restringe a visão por premiação, etapa e status e aciona "Iniciar", "Continuar" ou "Ver" no cartão da inscrição para abrir a avaliação dela.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-033_Painel_Avaliacao_Avaliador`](../../../hus/HU-033_Painel_Avaliacao_Avaliador.docx) | Criação | — funcionalidades *Consultar Minhas Avaliações* e *Filtrar Avaliações por Premiação, Etapa e Status* da HU: cartões das inscrições alocadas, indicadores agregados e filtros combinados |
| [`PDTIC25093-61`](../../../analise-impacto/AIM-PDTIC25093-61.md) | Alteração | — o painel passa a ser a fonte da fila de pendentes, com a sequência e o recorte consumidos pelo salto "Próxima pendente" |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao/premiacao/:premiacaoId` (Painel do Avaliador): indicadores agregados, seletores e o grid de cartões das inscrições alocadas.

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/avaliacao-projetos/flow.html`

---

</div>

## Regras de negócio

1. O avaliador acompanha exclusivamente as inscrições alocadas ao próprio usuário autenticado.
2. O status de cada avaliação deriva do registro de notas: A iniciar quando não há nota, Em andamento quando há ao menos uma nota e a avaliação não foi finalizada, e Finalizada quando todas as questões foram pontuadas e a finalização foi confirmada.
3. Os indicadores agregados de A iniciar, Em andamento e Finalizadas consideram todas as alocações do avaliador, independentemente da seleção momentânea de premiação, etapa ou status.
4. O avaliador não tem acesso às notas atribuídas por outros avaliadores à mesma inscrição.
5. Em inscrição confidencial, a identificação do participante fica oculta e o protocolo a identifica no lugar do nome.
6. O prazo de cada avaliação é a data final da etapa; a pontuação continua possível após o prazo, pois o encerramento é feito pelo administrador ao fechar a etapa.
7. A fila de avaliações pendentes de um avaliador é composta pelas avaliações alocadas a ele que ainda não foram finalizadas, na sequência crescente de protocolo com que este acompanhamento as apresenta.
8. O recorte de premiação, etapa e status vigente neste acompanhamento delimita a fila de pendentes consumida pelo salto para a próxima avaliação pendente em Finalizar Avaliação (`AVL-AVA-04`). *(confirmado em 2026-09-01: a fila do salto é a do painel — mesmo recorte e mesma ordem de protocolo que este acompanhamento apresenta)*

---

## Cenários

```gherkin
Feature: Acompanhar Minhas Avaliações

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Acompanhar as inscrições alocadas
    Given que tenho inscrições alocadas em uma premiação
    When acesso o painel do avaliador
    Then o sistema apresenta os cartões das inscrições alocadas com o status de cada avaliação

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Restringir por premiação e status
    Given que possuo avaliações em mais de uma premiação
    When seleciono uma premiação e o status "Em andamento"
    Then o sistema apresenta apenas as avaliações correspondentes à seleção

  Scenario: Inscrição confidencial no cartão
    Given que uma inscrição alocada é confidencial
    When acompanho minhas avaliações
    Then o cartão oculta o nome do participante e identifica a inscrição pelo protocolo

  Scenario: Fila de avaliações pendentes conforme o recorte vigente
    Given que restrinjo o acompanhamento a uma premiação e a uma etapa
    When acompanho minhas avaliações
    Then o sistema mantém como pendentes apenas as avaliações não finalizadas desse recorte, em sequência crescente de protocolo — a mesma fila que indica qual é a próxima avaliação pendente

  Scenario: Seleção sem correspondência
    Given que nenhuma avaliação corresponde à premiação, etapa e status selecionados
    When aplico a seleção
    Then o sistema informa que nenhuma avaliação corresponde à seleção
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Premiação | Premiação | entrada do usuário | editável | seleção (Todas as premiações; premiações com alocação) | não | padrão: Todas as premiações |
| Etapa | Etapa | entrada do usuário | editável | seleção (Todas as etapas; etapas da premiação) | não | limpa ao trocar de premiação |
| Status | dado de código | entrada do usuário | editável | seleção (Todas, A iniciar, Em andamento, Finalizadas) | não | padrão: Todas |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Protocolo | Inscrição | padrão ↑ |
| Status da avaliação | derivado | — |
| Nome do projeto | Inscrição | — |
| Identificação do participante | Inscrição (oculta se confidencial) | — |
| Etapa | Etapa | — |
| Tipo de participante / Modalidade / Categoria | Oferta | — |
| Progresso da pontuação | derivado | — |
| Prazo da etapa | Etapa | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Status da avaliação | A iniciar, Em andamento ou Finalizada | Derivado do registro de notas, a cada consulta |
| Progresso da pontuação | Percentual de questões pontuadas | Derivado a cada consulta |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Alocação de Avaliadores | lê | Os grupos de avaliação a que o avaliador está alocado em cada etapa (ALR do baseline) |
| Avaliação de Inscrição | lê | Traz as inscrições alocadas ao próprio avaliador e o status de cada avaliação, que compõem os cartões, os indicadores e a fila de pendentes (regras 1, 2, 3 e 7) |
| Nota de Avaliação | lê | O status e o progresso da pontuação derivam das notas registradas (regra 2 e campos automáticos) |
| Inscrição | lê | Protocolo, nome do projeto e identificação do participante de cada cartão, oculta em inscrição confidencial (regras 5 e 7) |
| Tipo de Participante | lê | Tipo de participante do enquadramento exibido no cartão (ALR do baseline) |
| Modalidade | lê | Modalidade do enquadramento exibida no cartão (ALR do baseline) |
| Categoria | lê | Categoria do enquadramento exibida no cartão (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Página própria em `/avaliacao/premiacao/:premiacaoId` (Painel do Avaliador): cabeçalho de saudação e resumo de pendências, os indicadores agregados, os seletores de premiação, etapa e status e o grid de cartões das inscrições alocadas. A seleção vigente e a ordem dos cartões definem a fila de pendentes que a tela Avaliação da Inscrição consome no comando "Próxima pendente" (`AVL-AVA-04`) — o avaliador continua na mesma fila que montou aqui, sem voltar a este painel a cada avaliação concluída.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto as alocações são recuperadas |
| Erro de validação | Não se aplica (seleção opcional) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe os cartões das inscrições alocadas e os indicadores agregados |
| Empty state | Sem alocações: "Nenhuma avaliação atribuída"; sem correspondência à seleção: "Nenhuma avaliação corresponde aos filtros selecionados" |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O avaliador vê apenas as inscrições alocadas a si, com status derivado do registro de notas | Regra de negócio (HU-033) |
| SC-02 | Os indicadores agregados refletem todas as alocações, independentemente da seleção aplicada | cenário "Restringir por premiação e status" |
| SC-03 | A fila de pendentes entregue ao salto para a próxima avaliação contém apenas avaliações não finalizadas do recorte vigente, na sequência do acompanhamento | cenário "Fila de avaliações pendentes conforme o recorte vigente" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Acompanhar Minhas Avaliações | principal | SE | 7 | 18 | Complexo | 7 | 2026-02-28 |

> No baseline, o processo elementar se chama *Consultar Painel Minhas Avaliações*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Acompanhar Minhas Avaliações** — SE · ALR 7 · DER 18 · Complexo · 7 PF

```json
{"pe": "Acompanhar Minhas Avaliações",
 "alr": ["Alocação Avaliadores", "Avaliação de Inscrição", "Premiação", "Inscrição", "Modalidade", "Categoria", "Tipo de Participante"],
 "der": ["Nome avaliador", "Quantidade de avaliações pendentes", "Prazo máximo para avaliação pendentes", "Qtd avaliações a iniciar", "Qtd avaliações em andamento", "Qtd avaliações finalizadas", "Premiação", "Etapa", "Status", "Número projeto", "Status avaliação da Inscrição", "Modalidade", "Categoria", "Tipo Participante", "Percentual de conclusão", "Prazo inscrição", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Alocação Avaliadores` — os grupos de avaliação a que o avaliador está alocado em cada etapa
2. `Avaliação de Inscrição` — as inscrições designadas ao avaliador, com o status de cada avaliação e as notas que dão o progresso da pontuação
3. `Premiação` — o nome da premiação e as etapas dela, com o prazo de cada uma
4. `Inscrição` — o protocolo, o nome do projeto e a identificação do participante de cada cartão
5. `Modalidade` — a modalidade do enquadramento exibida no cartão
6. `Categoria` — a categoria do enquadramento exibida no cartão
7. `Tipo de Participante` — o tipo de participante do enquadramento exibido no cartão

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); HU de origem corrigida na `## Origem` — sai a HU-028, que só cita o painel, e fica a HU-033, de onde a feature deriva — e critérios em prosa, porque as HUs não numeram critérios; coluna Entidade em `## Campos`; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/avaliacao-projetos/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Decisões de produto (docqui) | Fila confirmada | O produto confirmou que a fila do salto "Próxima pendente" é **a do painel** — mesmo recorte e mesma ordem de protocolo que o acompanhamento apresenta. A regra deixa de ser suposição |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Acompanhamento passa a definir a fila de avaliações pendentes — sequência e recorte — consumida pelo salto "Próxima pendente" |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-033 |

---

*Feature Set: Avaliação de Projetos · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
