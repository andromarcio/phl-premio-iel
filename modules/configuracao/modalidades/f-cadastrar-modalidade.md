<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-MOD-02
feature_set: CFG-MOD
dominio: CFG
entidade: Modalidade
data_model_ref: data-models/configuracao.md#modalidade
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-005_Cadastrar_Modalidades
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

# Cadastrar Modalidade
> **Nível 3** - Feature Set: Modalidades — Major Feature Set: Configuração da Premiação - `CFG-MOD-02`

## Descrição
Permite ao administrador registrar uma nova modalidade sob uma categoria, com descrição, link de regulamento e período de inscrição próprio, deixando-a disponível como forma de participação.

No Catálogo de Modalidades, o administrador abre o formulário de nova modalidade, informa o nome e, se quiser, dados como a descrição, o link do regulamento e o período de inscrição, e salva; na árvore de configuração de um prêmio, o botão "+" do nó de uma categoria cria a modalidade com o nome "Nova Modalidade" e abre o editor para renomeá-la.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-005_Cadastrar_Modalidades`](../../../hus/HU-005_Cadastrar_Modalidades.docx) | Criação | `CA-1, CA-2, CA-7` — nome obrigatório e único na categoria; período de inscrição opcional, com o fim posterior ao início; datas de inscrição informadas com horário |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/modalidades/novo` (Formulário de Modalidade). Também pode ser criada por criação rápida a partir da árvore de configuração do prêmio (ação em tela).

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O nome da modalidade é único dentro da mesma categoria; o mesmo nome é permitido em categorias diferentes.
2. A modalidade nasce subordinada a uma categoria, e essa categoria não muda depois de criada.
3. O período de inscrição é opcional; quando informado, a data de início é anterior à data de fim.
4. O link de regulamento e o período de inscrição pertencem ao vínculo da modalidade com a categoria e podem variar conforme a categoria vinculada. ⚠️ *(no catálogo administrativo sem categoria vinculada, regulamento e período só se aplicam ao vincular — confirmar o escopo)*
5. O período de inscrição da modalidade tem precedência sobre as datas globais do prêmio para o acesso ao fluxo público de inscrição.
6. Na criação rápida pela árvore, a modalidade é criada com o nome padrão "Nova Modalidade" e fica pronta para renomeação.

---

## Cenários

```gherkin
Feature: Cadastrar Modalidade

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Cadastrar modalidade com período de inscrição
    Given que acesso o formulário de nova modalidade em uma categoria
    When informo o nome "Individual", o período de início e o período de fim e salvo
    Then o sistema registra a modalidade e exibe "Registro salvo com sucesso."
    And a modalidade fica disponível como forma de participação da categoria

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome em branco
    Given que estou no formulário de modalidade
    When deixo o campo Nome em branco e clico em "Salvar"
    Then o sistema não registra e exibe "Campo obrigatório."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Criação rápida pela árvore
    Given que estou na configuração de um prêmio, no nó de uma categoria
    When aciono a criação rápida de modalidade
    Then o sistema cria a modalidade com o nome 'Nova Modalidade' e abre o editor para renomeação

  # ── Conflitos com dados existentes ─────────────────────────────

  # ← MESSAGE-DICTIONARY: CFG_MODALIDADE_PERIODO_INVALIDO
  Scenario: Período de inscrição com fim anterior ao início
    Given que informo o início das inscrições em 01/07/2026 e o fim em 30/06/2026
    When clico em "Salvar"
    Then o sistema não registra e exibe "A data de fim das inscrições deve ser posterior à data de início."

  # ← MESSAGE-DICTIONARY: CFG_MODALIDADE_NOME_DUPLICADO
  Scenario: Nome duplicado na mesma categoria
    Given que já existe a modalidade "Individual" na categoria
    When tento criar outra modalidade com o mesmo nome nesta categoria
    Then o sistema não registra e exibe "Já existe uma modalidade com este nome nesta categoria."

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de escrita
    Given que meu perfil não tem permissão para cadastrar modalidades
    When tento acessar o cadastro de modalidade
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome | Modalidade | entrada do usuário | editável | texto | sim | único dentro da mesma categoria; máximo de 200 caracteres |
| Descrição | Modalidade | entrada do usuário | editável | texto longo | não | texto livre |
| Link do regulamento | Modalidade × Categoria | entrada do usuário | editável | texto (URL) | não | → ver FIELD-DICTIONARY: URL |
| Início das inscrições | Modalidade × Categoria | entrada do usuário | editável | data e hora | não | quando informado, anterior ao fim das inscrições |
| Fim das inscrições | Modalidade × Categoria | entrada do usuário | editável | data e hora | não | quando informado, posterior ao início das inscrições |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativo | Na criação da modalidade |
| Nome (criação rápida) | "Nova Modalidade" | Quando criada pela árvore de configuração, antes da renomeação |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Categoria | lê | A modalidade nasce subordinada à categoria do prêmio em que é criada — na criação rápida, a do nó selecionado na árvore (regras 2 e 6) |

---

## Comportamento de tela

### Onde fica
Formulário próprio em `/modalidades/novo` (nome, descrição, regulamento e período de inscrição) e, alternativamente, no editor contextual aberto pela criação rápida na árvore de configuração do prêmio.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo com "Campo obrigatório." ou o período com a mensagem de período inválido |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e retorna ao catálogo |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma modalidade com nome válido é registrada e passa a constar no catálogo | cenário "Cadastrar modalidade com período de inscrição" |
| SC-02 | O período de inscrição com fim anterior ao início é rejeitado | Critério de aceite 2 (HU-005) |
| SC-03 | A criação rápida gera a modalidade com o nome "Nova Modalidade" e abre o editor | cenário "Criação rápida pela árvore" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Cadastrar Modalidade | principal | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Incluir Modalidade*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Cadastrar Modalidade** — EE · ALR 1 · DER 4 · Simples · 3 PF

```json
{"pe": "Cadastrar Modalidade",
 "alr": ["Modalidade"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Modalidade` — a transação grava a modalidade nova; o vínculo com a categoria, que guarda regulamento e período de inscrição, é subgrupo do mesmo arquivo lógico

⚠️ O N3 também recebe *Link do regulamento*, *Início das inscrições* e *Fim das inscrições*, que a planilha não enumera, e a criação rápida lê a categoria do prêmio (arquivo lógico `Categoria`), que a planilha não conta como ALR. Ficou o número da planilha; as duas divergências vão à equipe de métricas junto com o questionamento do baseline.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-005 |

---

*Feature Set: Modalidades · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
