<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-06
feature_set: CFG-VIN
dominio: CFG
entidade: Tipo de Participante
data_model_ref: data-models/configuracao.md#oferta-tipo--modalidade--categoria
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

# Vincular Tipo de Participante
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-06`

## Descrição
Permite ao administrador associar um tipo de participante a uma modalidade da estrutura, formando a oferta que o inscrito escolhe, ou criar o tipo e vinculá-lo no mesmo passo.

No nó de uma modalidade, na árvore de configuração do prêmio, o administrador aciona "Vincular" e escolhe um tipo de participante do catálogo no diálogo, ou aciona "Criar Nova", informa os dados do novo tipo e confirma em "Criar e Vincular". No mesmo diálogo informa os parâmetros da oferta, como permissão de equipe, limites de membros e slug da URL.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | `CA-1, CA-2, CA-4, CA-6` — o diálogo lista o catálogo sem os tipos já vinculados à modalidade; criar e vincular numa única operação; a árvore recarrega após vincular; o vínculo duplicado é impedido |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*), ação de vincular no nó de uma modalidade, que abre o Diálogo de Vínculo com o catálogo de tipos de participante e a opção de criar um novo.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Um tipo de participante só pode estar vinculado uma vez à mesma modalidade da estrutura; o mesmo tipo pode compor ofertas em modalidades diferentes.
2. Vincular um tipo de participante exige uma modalidade já vinculada como nó de origem.
3. A oferta formada pelo vínculo do tipo com a modalidade e a categoria guarda parâmetros próprios: se permite equipe, mínimo e máximo de membros, slug da URL e ordem.
4. Ao criar e vincular, o tipo de participante passa a existir no catálogo e forma a oferta na mesma operação.

---

## Cenários

```gherkin
Feature: Vincular Tipo de Participante

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Vincular tipo de participante existente a uma modalidade
    Given que uma modalidade já está vinculada na estrutura
    When seleciono um tipo de participante disponível no catálogo e confirmo
    Then o sistema forma a oferta e o tipo passa a integrar a modalidade na edição

  Scenario: Criar e vincular um novo tipo de participante num único passo
    Given que estou vinculando um tipo de participante à modalidade
    When informo o nome de um novo tipo e confirmo criar e vincular
    Then o sistema registra o tipo no catálogo e forma a oferta na mesma operação

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Tipo de participante já vinculado à modalidade
    Given que o tipo de participante já está vinculado à modalidade
    When tento vinculá-lo novamente à mesma modalidade
    Then o sistema não cria um novo vínculo e mantém apenas o existente

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para vincular
    Given que meu perfil não tem permissão para vincular tipos de participante
    When tento vincular um tipo de participante à modalidade
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Modalidade da estrutura | Modalidade | exibido do cadastro | somente leitura | seleção → Modalidade | sim | modalidade já vinculada na estrutura que recebe o tipo de participante |
| Tipo de participante | Tipo de Participante | entrada do usuário | editável | seleção → Tipo de Participante | sim | escolhido do catálogo; ainda não vinculado à modalidade |
| Nome (novo tipo) | Tipo de Participante | entrada do usuário | editável | texto | condicional | obrigatório ao criar e vincular; máximo de 200 caracteres |
| Permite equipe | Oferta | entrada do usuário | editável | sim/não | não | padrão: não |
| Mínimo de membros da equipe | Oferta | entrada do usuário | editável | número | condicional | exigido quando permite equipe |
| Máximo de membros da equipe | Oferta | entrada do usuário | editável | número | condicional | maior ou igual ao mínimo, quando permite equipe |
| Slug da URL | Oferta | entrada do usuário | editável | texto | não | compõe o link público da oferta → ver FIELD-DICTIONARY: URL |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Ordem | Próxima posição na modalidade | Ao formar a oferta |
| Situação da oferta | Ativo | Ao vincular o tipo de participante à modalidade |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Modalidade × Categoria | lê | O vínculo da modalidade com a categoria é o nó de origem que recebe o tipo (regra 2) |
| Categoria | lê | A oferta cruza o tipo com a modalidade e a categoria da edição (regra 3; ALR do baseline) |
| Premiação | lê | A edição em que a oferta é formada (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Ação disparada do nó de uma modalidade na Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*): abre o Diálogo de Vínculo com o catálogo de tipos de participante disponíveis e a opção de criar e vincular um novo.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão de confirmação desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome com "Campo obrigatório." ao criar e vincular sem nome |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Fecha o diálogo, recarrega a árvore e mostra a nova oferta |
| Empty state | Catálogo sem tipos disponíveis: oferece criar e vincular um novo |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um tipo de participante vinculado a uma modalidade forma a oferta na estrutura | cenário "Vincular tipo de participante existente a uma modalidade" |
| SC-02 | Criar e vincular registra o tipo e forma a oferta numa única operação | Critério de aceite 2 (HU-011) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Vincular Tipo de Participante | principal | EE | 4 | 3 | Médio | 4 | 2026-02-28 |

> No baseline, o processo elementar se chama *Copiar Tipo de Participante*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Vincular Tipo de Participante** — EE · ALR 4 · DER 3 · Médio · 4 PF

```json
{"pe": "Vincular Tipo de Participante",
 "alr": ["Premiação", "Tipo de Participante", "Categoria", "Modalidade"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — lê a edição em que a oferta é formada
2. `Tipo de Participante` — grava a oferta, vínculo do tipo escolhido com a modalidade e a categoria (a oferta é subgrupo do arquivo lógico Tipo de Participante)
3. `Categoria` — lê a categoria do ramo em que a oferta é formada
4. `Modalidade` — lê o vínculo da modalidade que recebe o tipo

No legado, associar um tipo existente do catálogo chamava-se *Copiar*; o DER `ID` é o tipo escolhido no diálogo.

⚠️ O baseline conta só a vinculação de um tipo existente do catálogo; a variante criar e vincular, que a feature especifica (regra 4), não tem processo elementar na planilha. A lacuna vai à equipe de métricas junto com o questionamento do baseline.

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 |

---

*Feature Set: Vínculos e Ofertas · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
