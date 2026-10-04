<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-AVA-02
feature_set: AVL-AVA
dominio: AVL
entidade: Aceite do Termo de Confidencialidade
data_model_ref: data-models/avaliacao.md#aceite-do-termo-de-confidencialidade
endpoints: []
error_codes: []
depende_de: []
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

# Aceitar Termo de Confidencialidade
> **Nível 3** - Feature Set: Avaliação de Projetos — Major Feature Set: Avaliação - `AVL-AVA-02`

## Descrição
Permite ao avaliador ler e aceitar o termo de confidencialidade de uma premiação, liberando o acesso aos dados dos participantes; o aceite é registrado uma única vez por avaliador e premiação.

Na seleção de premiação, o avaliador aciona "Ler e aceitar termo" no cartão da premiação com termo pendente, lê o termo na tela — ou baixa o anexo —, marca "Li e aceito" e aciona "Aceitar e continuar".

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-029_Termo_Confidencialidade_Avaliador`](../../../hus/HU-029_Termo_Confidencialidade_Avaliador.docx) | Criação | — funcionalidade *Aceitar Termo de Confidencialidade* da HU: leitura do termo em texto ou anexo, confirmação "Li e aceito" e aceite registrado uma única vez por avaliador e premiação, com data e IP de origem |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao/premiacao/:premiacaoId/termo` (Aceite do Termo): leitura do termo (texto ou anexo) e confirmação do aceite.

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/avaliacao-projetos/flow.html`

---

</div>

## Regras de negócio

1. Há no máximo um termo de confidencialidade ativo por premiação, do tipo Texto ou Anexo.
2. O aceite é único por avaliador e premiação, registrado uma única vez, e guarda a data do aceite e o IP de origem.
3. Enquanto o termo ativo da premiação não for aceito, o avaliador não tem acesso aos dados dos participantes daquela premiação.
4. Editar o termo não invalida os aceites já registrados: quem já aceitou não precisa aceitar de novo.
5. Premiação sem termo ativo, ou com termo desativado, não exige aceite e libera o acesso às avaliações.
6. O aceite só é registrado depois que o avaliador confirma a leitura do termo.

---

## Cenários

```gherkin
Feature: Aceitar Termo de Confidencialidade

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Aceitar o termo da premiação
    Given que a premiação tem termo ativo e confirmo a leitura
    When aceito o termo
    Then o sistema registra o aceite com a data e o IP de origem e libera as avaliações da premiação

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Aceitar sem confirmar a leitura
    Given que abro o termo mas não marco a confirmação de leitura
    When tento aceitar
    Then o sistema não registra o aceite e exibe "Confirme a leitura do termo para continuar."
    # ← MESSAGE-DICTIONARY: AVL_ACEITE_CONFIRMACAO_OBRIGATORIA

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Premiação sem termo configurado
    Given que a premiação não tem termo ativo
    When acesso as avaliações da premiação
    Then o sistema libera o acesso sem exigir aceite

  Scenario: Termo já aceito anteriormente
    Given que já aceitei o termo desta premiação
    When acesso novamente a premiação
    Then o sistema mantém o acesso às avaliações liberado sem solicitar novo aceite
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Li e aceito o termo | Aceite do Termo de Confidencialidade | entrada do usuário | editável | confirmação | sim | habilita o registro do aceite |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Data do aceite | Data e hora da confirmação | No momento em que o avaliador aceita o termo |
| IP de origem | Endereço de origem do avaliador | No momento do aceite |
| Nome do avaliador | Nome vigente no cadastro corporativo | No momento do aceite |
| Login do avaliador | Login vigente no cadastro corporativo | No momento do aceite |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Termo de Confidencialidade | lê | Exibe o título e o conteúdo do termo ativo da premiação, em texto ou anexo, e diz se há termo a aceitar (regras 1 e 5) |
| Premiação | lê | O termo e o aceite são escopados pela premiação (regra 2); é o arquivo lógico que a planilha do baseline nomeia nas três transações |

---

## Comportamento de tela

### Onde fica
Página própria em `/avaliacao/premiacao/:premiacaoId/termo` (Aceite do Termo): o título e o conteúdo do termo (texto exibido para leitura ou anexo para download), a confirmação de leitura e o comando de aceite.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Comando de aceite desabilitado com indicador enquanto grava |
| Erro de validação | Aceite indisponível até a confirmação de leitura ser marcada |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Registra o aceite e conduz às avaliações da premiação |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O aceite é registrado uma única vez por avaliador e premiação, com data e IP de origem | Regra de negócio (HU-029) |
| SC-02 | Enquanto o termo ativo não é aceito, o acesso aos dados dos participantes fica bloqueado | cenário "Aceitar sem confirmar a leitura" e Regra 3 |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Termos de Aceite por Prêmios | acessório | CE | 1 | 3 | Simples | 3 | 2026-02-28 |
| Visualizar Termo de Aceite | acessório | CE | 1 | 2 | Simples | 3 | 2026-02-28 |
| Aceitar Termo de Confidencialidade | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar principal se chama *Aceitar Termo de Aceite*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Consultar Termos de Aceite por Prêmios** — CE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Consultar Termos de Aceite por Prêmios",
 "alr": ["Premiação"],
 "der": ["Prêmio", "Status Termo", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — as premiações do avaliador, cada uma com a situação do termo de confidencialidade

⚠️ Esta lista — as premiações do avaliador com a situação do termo — é a tela Seleção de Premiação, que a feature `AVL-AVA-07` (Consultar Premiações do Avaliador) especifica e que segue sem contagem. Se o processo elementar realiza aquela feature, ele deveria contar lá; mover a linha é decisão da equipe de métricas.

**Visualizar Termo de Aceite** — CE · ALR 1 · DER 2 · Simples · 3 PF

```json
{"pe": "Visualizar Termo de Aceite",
 "alr": ["Premiação"],
 "der": ["Termo de Confidencialidade", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — o termo de confidencialidade ativo da premiação, exibido em texto ou como anexo para leitura

**Aceitar Termo de Confidencialidade** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Aceitar Termo de Confidencialidade",
 "alr": ["Premiação"],
 "der": ["ID Termo", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — a transação grava o aceite do avaliador no termo da premiação, com data e IP de origem

⚠️ A planilha nomeia o arquivo lógico *Premiação* nas três transações, mas o `global/data-models/avaliacao.md` registra o Termo de Confidencialidade e o Aceite como subgrupos do ALI *Avaliação de Inscrição*. Ficou o nome da planilha — o número não muda, ALR 1 nos dois casos —, e a divergência vai à equipe de métricas.

**Total: 9 PF** (3 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); critérios em prosa na `## Origem`, porque a HU não numera critérios; coluna Entidade em `## Campos`; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (3 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/avaliacao-projetos/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-029 |

---

*Feature Set: Avaliação de Projetos · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
