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

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | — |

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Modalidade da estrutura | seleção → Modalidade vinculada | somente leitura | seleção | sim | modalidade já vinculada que recebe o tipo de participante |
| Tipo de participante | seleção → Tipo de Participante | editável | seleção (catálogo) | sim | tipo ainda não vinculado à modalidade |
| Nome (novo tipo) | entrada do usuário | editável | texto | condicional | obrigatório ao criar e vincular; máximo de 200 caracteres |
| Permite equipe | entrada do usuário | editável | sim/não | não | padrão: não |
| Mínimo de membros da equipe | entrada do usuário | editável | número | condicional | exigido quando permite equipe |
| Máximo de membros da equipe | entrada do usuário | editável | número | condicional | maior ou igual ao mínimo, quando permite equipe |
| Slug da URL | entrada do usuário | editável | texto | não | compõe o link público da oferta → ver FIELD-DICTIONARY: URL |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Ordem | Próxima posição na modalidade | Ao formar a oferta |
| Situação da oferta | Ativo | Ao vincular o tipo de participante à modalidade |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Copiar Tipo de Participante | EE | 4 | 3 | Médio | 4 | 2026-02-28 |

### Memória de cálculo

- **Copiar Tipo de Participante** — ALR (4): Premiação · Tipo de Participante · Categoria · Modalidade. DER (3): ID · Ação · Mensagem.

```json
{"pe": "Copiar Tipo de Participante",
 "alr": ["Premiação", "Tipo de Participante", "Categoria", "Modalidade"],
 "der": ["ID", "Ação", "Mensagem"]}
```

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 |

---

*Feature Set: Vínculos e Ofertas · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
