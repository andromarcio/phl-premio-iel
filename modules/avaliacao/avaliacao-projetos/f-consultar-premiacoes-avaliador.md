<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-AVA-07
feature_set: AVL-AVA
dominio: AVL
entidade: Alocação de Avaliadores
data_model_ref: data-models/avaliacao.md#alocacao-de-avaliadores
endpoints: []
error_codes: []
depende_de: [ACS-ACE-01]
origem:
  tipo: issue
  chave: HU-029_Termo_Confidencialidade_Avaliador
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

# Consultar Premiações do Avaliador
> **Nível 3** - Feature Set: Avaliação de Projetos — Major Feature Set: Avaliação - `AVL-AVA-07`

## Descrição
Apresenta ao avaliador, logo ao entrar, as premiações em que ele tem projetos para avaliar, com quanto já avançou em cada uma e o aviso de qual delas ainda exige o aceite do termo de confidencialidade.

Ao entrar na área do avaliador, ele vê um cartão por premiação, com a situação do termo e os contadores, e aciona "Ler e aceitar termo", quando o termo está pendente, ou "Avaliar", para seguir à lista de projetos daquela premiação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-029_Termo_Confidencialidade_Avaliador`](../../../hus/HU-029_Termo_Confidencialidade_Avaliador.docx) | Criação | — funcionalidade *Selecionar Premiação para Avaliar* da HU: um cartão por premiação alocada, com a situação do termo e os contadores de avaliações, levando ao aceite ou às avaliações |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao` (porta de entrada do perfil Avaliador)

**Fidelidade ao protótipo**: n/a *(o protótipo de Avaliação de Projetos declara a Seleção de Premiação como não representada)*

---

</div>

## Regras de negócio

1. A consulta abrange apenas as premiações em que o avaliador tem projetos designados.
2. A premiação cujo termo de confidencialidade ainda não foi aceito é marcada como pendente de aceite.
3. A premiação com termo pendente não revela os projetos designados nem os seus contadores. → ver `AVL-AVA-02` (Aceitar Termo de Confidencialidade)
4. A premiação sem termo de confidencialidade cadastrado dá acesso direto aos projetos.
5. Os contadores de cada premiação refletem apenas os projetos designados ao próprio avaliador.

---

## Cenários

```gherkin
Feature: Consultar Premiações do Avaliador

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Entrar e escolher em qual premiação avaliar
    Given que tenho projetos designados em duas premiações
    When entro na área do avaliador
    Then vejo um cartão por premiação, com quantos projetos tenho a iniciar, em andamento e finalizados
    And ao escolher uma premiação sou levado à minha lista de projetos daquela premiação

  Scenario: Premiação com termo pendente
    Given que tenho projetos numa premiação cujo termo de confidencialidade ainda não aceitei
    When entro na área do avaliador
    Then o cartão dessa premiação aparece como pendente de aceite, sem os contadores
    And ao escolhê-la sou levado à leitura e ao aceite do termo

  Scenario: Premiação sem termo cadastrado
    Given que a premiação não tem termo de confidencialidade cadastrado
    When escolho essa premiação
    Then sou levado direto à minha lista de projetos

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Avaliador sem projetos designados
    Given que não tenho nenhum projeto designado
    When entro na área do avaliador
    Then o sistema informa que ainda não há projetos para avaliar

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Participante tenta acessar a área do avaliador
    Given que estou autenticado como Participante
    When tento abrir a área do avaliador
    Then o sistema nega o acesso
```

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Premiação | Premiação | padrão ↑ |
| Situação do termo de confidencialidade | derivado (aceito, pendente ou não exigido) | — |
| A iniciar | derivado (projetos designados ainda não iniciados) | — |
| Em andamento | derivado (projetos iniciados e não finalizados) | — |
| Finalizados | derivado (projetos concluídos) | — |

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Premiação escolhida | Premiação | entrada do usuário | somente leitura | seleção → Premiação | não | escolhida pelo cartão da premiação; apenas premiações em que o avaliador tem projetos designados |

*A consulta não tem preenchimento: a lista é montada a partir do avaliador autenticado.*

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação do termo de confidencialidade | aceito, pendente de aceite ou não exigido | Ao montar a consulta |
| Data do aceite | data em que o avaliador aceitou o termo daquela premiação | Ao montar a consulta, quando o termo já foi aceito |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Alocação de Avaliadores | lê | Delimita as premiações em que o avaliador tem projetos designados (regra 1) |
| Avaliação de Inscrição | lê | Dá os contadores A iniciar, Em andamento e Finalizados de cada premiação, só com os projetos do próprio avaliador (regra 5) |
| Termo de Confidencialidade | lê | Diz se a premiação tem termo ativo; sem termo, o acesso aos projetos é direto (regras 2 e 4) |
| Aceite do Termo de Confidencialidade | lê | Diz se o avaliador já aceitou o termo e em que data (regra 2 e campo automático *Data do aceite*) |

---

## Comportamento de tela

### Onde fica
Página própria em `/avaliacao`, primeira tela do perfil Avaliador. Traz uma saudação personalizada, o aviso de quantas premiações estão com termo pendente e, abaixo, um cartão por premiação com o nome, a situação do termo e os contadores. O cartão leva ao aceite do termo, quando pendente, ou à lista de projetos daquela premiação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe cartões de carregamento no lugar da lista |
| Erro de validação | Não se aplica (não há preenchimento) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Apresenta os cartões, com a chamada "Ler e aceitar termo" ou "Avaliar" conforme a situação |
| Empty state | Sem projetos designados, informa que ainda não há projetos para avaliar |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O avaliador identifica, ao entrar, em quais premiações tem trabalho e quanto falta em cada uma | cenário "Entrar e escolher em qual premiação avaliar" |
| SC-02 | Premiação com termo pendente não expõe os projetos nem os contadores | cenário "Premiação com termo pendente" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem processo elementar correspondente. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); HU de origem corrigida na `## Origem` — sai a HU-033, que descreve o painel de inscrições e não a seleção de premiação, e entra a HU-029, cuja funcionalidade *Selecionar Premiação para Avaliar* é esta feature — e critérios em prosa, porque a HU não numera critérios; coluna Entidade em `## Campos`, com o Preenchimento normalizado; `## Dados lidos e gravados`; coluna Papel na tabela de `## Métricas de tamanho`, ainda sem processo elementar contado. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (seleção de premiação, porta de entrada do avaliador) — tela citada no N2 e até então sem feature própria |

---

*Feature Set: Avaliação de Projetos · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
