<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ALO-02
feature_set: AVL-ALO
dominio: AVL
entidade: Alocação de Avaliadores
data_model_ref: data-models/avaliacao.md#alocação-de-avaliadores
endpoints: []
error_codes: []
depende_de: ["AVL-ALO-01"]
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

# Alocar Avaliador ao Grupo
> **Nível 3** - Feature Set: Alocação de Avaliadores — Major Feature Set: Avaliação - `AVL-ALO-02`

## Descrição
Permite ao administrador compor e salvar o pool de avaliadores aptos a avaliar um grupo de categoria, modalidade, tipo de participante e submodalidade em uma etapa, servindo de base para a alocação por inscrição.

Na tela Alocação por Grupo, o administrador abre o seletor de avaliadores na linha do grupo, inclui ou retira avaliadores do pool — buscando por nome ou e-mail — e aciona "Salvar pool".

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-025_Alocar_Avaliadores`](../../../hus/HU-025_Alocar_Avaliadores.docx) | Criação | — funcionalidade "Alocar Pool de Avaliadores por Grupo" da HU, que não numera critérios: incluir e retirar avaliadores do pool do grupo na etapa e salvar o pool, com o bloqueio da retirada de quem já tem avaliação em andamento ou finalizada |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: a tela Alocação por Grupo (`/avaliacao-admin/alocacao-matriz`), pelo seletor de avaliadores de cada grupo.

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/alocacao/flow.html`

---

</div>

## Regras de negócio

1. O pool de um grupo autoriza quem pode avaliar aquele grupo (categoria × modalidade × tipo de participante × submodalidade) na etapa; a alocação por inscrição só designa avaliadores presentes nesse pool. → ver `AVL-ALO-04` (Alocar Avaliador à Inscrição), regra 7. *(a submodalidade foi acrescentada ao grupo em 2026-09-01: antes esta feature a omitia, e a definição divergia da usada na alocação por inscrição)*
2. Somente usuários com perfil Avaliador podem compor o pool de um grupo.
3. Cada etapa tem o pool de cada grupo configurado de forma independente; o pool de uma etapa não vale para outra.
4. O nome e o login do avaliador são preservados no momento da alocação e permanecem inalterados no histórico, ainda que o cadastro corporativo mude depois.
5. Um avaliador não pode ser retirado do pool de um grupo enquanto tiver avaliações em andamento ou finalizadas naquele grupo e etapa.
6. O administrador regional compõe o pool apenas dos grupos cujas UFs estão vinculadas ao seu perfil.

---

## Cenários

```gherkin
Feature: Alocar Avaliador ao Grupo

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Adicionar avaliador ao pool e salvar
    Given que consulto os grupos de uma etapa
    When incluo um avaliador do cadastro corporativo no pool de um grupo e salvo
    Then o sistema registra o pool e exibe "Registro salvo com sucesso."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Salvar grupo sem avaliadores
    Given que um grupo está sem avaliadores no pool
    When salvo o pool sem incluir avaliadores
    Then o sistema mantém o grupo com o pool vazio

  Scenario: Remover avaliador sem avaliações
    Given que um avaliador do pool não possui avaliações no grupo e etapa
    When removo o avaliador do pool e salvo
    Then o sistema registra o pool sem o avaliador

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Remover avaliador com avaliação ativa
    Given que um avaliador do pool possui avaliação em andamento no grupo
    When tento removê-lo do pool
    Then o sistema mantém o avaliador no pool e exibe "Não é possível remover o avaliador: há avaliações em andamento ou finalizadas."
    # ← MESSAGE-DICTIONARY: AVL_REMOCAO_AVALIADOR_BLOQUEADA
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Avaliadores do pool | externo: Portal corporativo | entrada do usuário | editável | seleção múltipla (usuários com perfil Avaliador) | não | apenas usuários com perfil Avaliador do cadastro corporativo; busca por nome e e-mail |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Nome do avaliador | Nome vigente no cadastro corporativo | No momento em que o avaliador é incluído no pool |
| Login do avaliador | Login vigente no cadastro corporativo | No momento em que o avaliador é incluído no pool |
| Situação | Ativa | Ao registrar a alocação do avaliador no grupo |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Alocação de Avaliadores | lê e grava | Recebe o pool do grupo na etapa, com o nome, o login e a situação de cada avaliador (regras 1, 3 e 4 e campos automáticos) |
| Avaliação de Inscrição | lê | As avaliações em andamento ou finalizadas do avaliador no grupo e etapa impedem a retirada dele do pool (regra 5) |
| Usuário | lê | As UFs vinculadas ao perfil limitam os grupos cujo pool o administrador regional compõe (regra 6) |

---

## Comportamento de tela

### Onde fica
Na tela Alocação por Grupo (`/avaliacao-admin/alocacao-matriz`), o seletor de avaliadores de cada linha de grupo permite incluir e retirar avaliadores; a gravação é confirmada por grupo e etapa.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar pool" desabilitado com indicador enquanto grava |
| Erro de validação | Não se aplica (composição opcional do pool) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e atualiza a contagem do pool |
| Empty state | Grupo sem avaliadores: etiqueta "Sem avaliadores" |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O pool de um grupo é composto apenas por usuários com perfil Avaliador e persistido por grupo e etapa | Regra de negócio (HU-025) |
| SC-02 | A remoção de avaliador com avaliação em andamento ou finalizada é impedida | cenário "Remover avaliador com avaliação ativa" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Alocar Avaliador ao Grupo | principal | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Salvar Pool*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Alocar Avaliador ao Grupo** — EE · ALR 1 · DER 4 · Simples · 3 PF

```json
{"pe": "Alocar Avaliador ao Grupo",
 "alr": ["Alocação Avaliadores"],
 "der": ["ID Avaliador", "ID Pool", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Alocação Avaliadores` — a transação grava a composição do pool do grupo na etapa

⚠️ A retirada consulta as avaliações do avaliador no grupo (`Avaliação de Inscrição`, regra 5) e o escopo de UFs do administrador regional (`Usuário`, regra 6), arquivos declarados em `## Dados lidos e gravados` que a planilha não enumera. Ficou o número da planilha; a divergência vai à equipe de métricas junto com o questionamento do baseline.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); `## Origem` com o que a feature realiza da HU, que não numera critérios; coluna Entidade em `## Campos`, com a lista de avaliadores vinda do portal corporativo; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A tela de Alocação por Grupo, que o fluxo já desenhava como contexto, passa a ser atribuída a esta feature — é nela que a alocação ao pool acontece. Fidelidade **referência** |
| 2026-09-01 | Decisões de produto (docqui) | Grupo corrigido | A **submodalidade** passa a compor o grupo, convergindo com `AVL-ALO-04` Alocar Avaliador à Inscrição, cuja definição foi conferida contra o código. Antes as duas leituras conviviam e mostravam grupos diferentes para a mesma premiação |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-025 |

---

*Feature Set: Alocação de Avaliadores · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
