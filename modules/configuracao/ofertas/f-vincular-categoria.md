<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-02
feature_set: CFG-VIN
dominio: CFG
entidade: Categoria
data_model_ref: data-models/configuracao.md#premiacao--categoria-vinculo
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-011_Vincular_Categoria_Modalidade_TipoParticipante
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

# Vincular Categoria
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-02`

## Descrição
Permite ao administrador associar uma categoria do catálogo à edição do prêmio, ou registrar uma nova categoria e vinculá-la num único passo, montando o primeiro nível abaixo da premiação.

No nó da premiação, na árvore de configuração do prêmio, o administrador aciona "Vincular" e escolhe uma categoria do catálogo no diálogo, ou aciona "Criar Nova", informa nome e descrição e confirma em "Criar e Vincular".

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | `CA-1, CA-2, CA-4, CA-6` — o diálogo lista o catálogo sem as categorias já vinculadas à edição; criar e vincular numa única operação; a árvore recarrega após vincular; o vínculo duplicado é impedido |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*), ação de vincular no nó da premiação, que abre o Diálogo de Vínculo com o catálogo e a opção de criar uma nova categoria.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Uma categoria só pode estar vinculada uma vez à mesma edição; a mesma categoria pode ser vinculada a edições diferentes.
2. Ao criar e vincular, a categoria passa a existir no catálogo e fica vinculada à edição na mesma operação.
3. O vínculo entre a edição e a categoria guarda a ordem de exibição da categoria naquela edição.
4. A categoria vinculada continua sendo um item de catálogo reutilizável, independente da edição.

---

## Cenários

```gherkin
Feature: Vincular Categoria

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Vincular categoria existente do catálogo à edição
    Given que estou na estrutura de um prêmio e escolho vincular uma categoria ao nó da premiação
    When seleciono uma categoria disponível no catálogo e confirmo
    Then o sistema cria o vínculo e a categoria passa a integrar a estrutura da edição

  Scenario: Criar e vincular uma nova categoria num único passo
    Given que estou vinculando uma categoria à edição
    When informo o nome de uma nova categoria e confirmo criar e vincular
    Then o sistema registra a categoria no catálogo e a vincula à edição na mesma operação

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Categoria já vinculada à edição
    Given que a categoria "Categoria Estudantil" já está vinculada à edição
    When tento vinculá-la novamente à mesma edição
    Then o sistema não cria um novo vínculo e mantém apenas o existente

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Cancelar a vinculação
    Given que iniciei a vinculação de uma categoria
    When cancelo a operação
    Then o sistema não cria nenhum vínculo e a estrutura permanece como estava

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para vincular
    Given que meu perfil não tem permissão para vincular categorias
    When tento vincular uma categoria à edição
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Categoria | Categoria | entrada do usuário | editável | seleção → Categoria | sim | escolhida do catálogo; ainda não vinculada à edição |
| Nome (nova categoria) | Categoria | entrada do usuário | editável | texto | condicional | obrigatório ao criar e vincular; máximo de 200 caracteres |
| Descrição (nova categoria) | Categoria | entrada do usuário | editável | texto longo | não | texto livre, ao criar e vincular |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Ordem de exibição | Próxima posição na edição | Ao criar o vínculo |
| Situação do vínculo | Ativo | Ao vincular a categoria à edição |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Premiação × Categoria | grava | Recebe o vínculo da categoria com a edição, com a ordem de exibição e a situação (regras 1 e 3; campos automáticos) |
| Premiação | lê | A edição que recebe a categoria é o nó de origem da ação (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Ação disparada do nó da premiação na Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*): abre o Diálogo de Vínculo com o catálogo de categorias disponíveis e a opção de criar e vincular uma nova.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão de confirmação desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome com "Campo obrigatório." ao criar e vincular sem nome |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Fecha o diálogo, recarrega a árvore e mostra o novo nó da categoria |
| Empty state | Catálogo sem categorias disponíveis: oferece criar e vincular uma nova |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma categoria selecionada é vinculada à edição e passa a integrar a estrutura | cenário "Vincular categoria existente do catálogo à edição" |
| SC-02 | Criar e vincular registra a categoria e cria o vínculo numa única operação | Critério de aceite 2 (HU-011) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Vincular Categoria (do catálogo) | principal | EE | 2 | 3 | Simples | 3 | 2026-02-28 |
| Vincular Categoria (criar e vincular) | principal | EE | 2 | 4 | Simples | 3 | 2026-02-28 |

> No baseline, os processos elementares se chamam *Copiar Categoria* e *Criar e Vincular Categoria*; aqui levam o nome da feature, com a variante entre parênteses, como pede o `global/SIZING.md` para o `principal`. Os números são os do baseline.

### Memória de cálculo

**Vincular Categoria (do catálogo)** — EE · ALR 2 · DER 3 · Simples · 3 PF

```json
{"pe": "Vincular Categoria (do catálogo)",
 "alr": ["Categoria", "Premiação"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Categoria` — grava o vínculo da categoria escolhida com a edição (o vínculo é subgrupo do arquivo lógico Categoria)
2. `Premiação` — lê a edição que recebe a categoria

No legado, associar uma categoria existente do catálogo chamava-se *Copiar*; o DER `ID` é a categoria escolhida no diálogo.

**Vincular Categoria (criar e vincular)** — EE · ALR 2 · DER 4 · Simples · 3 PF

```json
{"pe": "Vincular Categoria (criar e vincular)",
 "alr": ["Categoria", "Premiação"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Categoria` — grava a categoria nova no catálogo e, na mesma operação, o vínculo dela com a edição
2. `Premiação` — lê a edição que recebe a categoria

**Total: 6 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com os dois processos elementares principais levando o nome da feature e a variante (do catálogo, criar e vincular). Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 |

---

*Feature Set: Vínculos e Ofertas · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
