<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-09
feature_set: CFG-VIN
dominio: CFG
entidade: Oferta
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

# Cadastrar Submodalidade
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-09`

## Descrição
Permite ao administrador cadastrar uma submodalidade da edição — a oferta que cruza tipo de participante, modalidade e categoria — como opção de inscrição. ⚠️ *(submodalidade tratada como sinônimo de oferta; equivalência a confirmar)*

Na aba "Geral" do nó do tipo de participante, na árvore de configuração do prêmio, o administrador escolhe o tipo de participante e o contexto de modalidade e categoria, preenche os parâmetros da oferta, como permissão de equipe, limites de membros e slug da URL, e aciona "Salvar".

> ⚠️ **Colisão de terminologia confirmada no código** (2026-08-28). O que esta feature descreve — o vínculo tipo de participante × modalidade × categoria, com parâmetros de equipe e slug — é a **Oferta** (`TB_TIPO_PART_MOD_CAT`), configurada na aba **Geral** do editor de Tipo de Participante. Na interface implementada, o rótulo **“Sub Modalidades”** designa outra coisa: o **Enquadramento** (`TB_ENQUADRAMENTO`, features `CFG-TIP-10`/`CFG-TIP-11`). Renomear esta feature depende de decisão do PO — ver `global/CONFORMIDADE-CODIGO.md` § 3.2.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | `CA-6` — a combinação tipo de participante e modalidade-categoria é única na edição; os parâmetros da oferta (equipe, limites de membros, slug e ordem) vêm da RN5 da HU |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Geral**)* (Submodalidades da Oferta)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A submodalidade corresponde a uma oferta: o cruzamento de um tipo de participante com uma modalidade e uma categoria dentro da edição. ⚠️ *(equivalência submodalidade ↔ oferta a confirmar)*
2. A oferta é única para cada combinação de tipo de participante e modalidade-categoria na edição.
3. A oferta guarda seus próprios parâmetros de inscrição: se permite equipe, mínimo e máximo de membros, slug da URL e ordem.

---

## Cenários

```gherkin
Feature: Cadastrar Submodalidade

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Cadastrar uma submodalidade da edição
    Given que a estrutura da edição tem modalidade e categoria vinculadas
    When informo o tipo de participante e o contexto de modalidade e categoria e salvo
    Then o sistema registra a submodalidade e exibe "Registro salvo com sucesso."

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Máximo de membros menor que o mínimo
    Given que marquei que a submodalidade permite equipe
    When informo um máximo de membros menor que o mínimo e salvo
    Then o sistema não registra a submodalidade e aponta a inconsistência entre mínimo e máximo

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Submodalidade já existente para a mesma combinação
    Given que já existe uma submodalidade para o tipo de participante naquela modalidade e categoria
    When tento cadastrar a mesma combinação
    Then o sistema não registra a submodalidade e mantém apenas a existente

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para cadastrar
    Given que meu perfil não tem permissão para cadastrar submodalidades
    When tento cadastrar uma submodalidade
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Tipo de participante | Tipo de Participante | entrada do usuário | editável | seleção → Tipo de Participante | sim | tipo que compõe a oferta |
| Modalidade e categoria | Modalidade × Categoria | entrada do usuário | editável | seleção → Modalidade × Categoria | sim | contexto modalidade-categoria da oferta |
| Permite equipe | Oferta | entrada do usuário | editável | sim/não | não | padrão: não |
| Mínimo de membros da equipe | Oferta | entrada do usuário | editável | número | condicional | exigido quando permite equipe |
| Máximo de membros da equipe | Oferta | entrada do usuário | editável | número | condicional | maior ou igual ao mínimo |
| Slug da URL | Oferta | entrada do usuário | editável | texto | não | compõe o link público da oferta → ver FIELD-DICTIONARY: URL |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Ordem | Próxima posição na modalidade-categoria | Na criação da submodalidade |
| Situação | Ativo | Na criação da submodalidade |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Premiação | lê | A lista de submodalidades da tela é a da edição (ALR do acessório *Listar Submodalidades*) |
| Categoria | lê | A lista mostra a categoria do caminho de cada oferta (regra 1; ALR do acessório *Listar Submodalidades*) |
| Modalidade | lê | A lista mostra a modalidade do caminho de cada oferta (regra 1; ALR do acessório *Listar Submodalidades*) |

---

## Comportamento de tela

### Onde fica
Página própria em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Geral**)* (Submodalidades da Oferta): formulário para escolher o tipo de participante e o contexto de modalidade e categoria e definir os parâmetros de equipe e o slug.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca os campos de equipe quando o máximo é menor que o mínimo |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e retorna à lista de submodalidades |
| Empty state | Edição sem modalidade e categoria vinculadas: orienta montar a estrutura antes |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma submodalidade válida é registrada e passa a compor as ofertas da edição | cenário "Cadastrar uma submodalidade da edição" |
| SC-02 | A combinação tipo de participante + modalidade-categoria é única na edição | regra de negócio 2 |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Listar Submodalidades | acessório | CE | 4 | 3 | Médio | 4 | 2026-02-28 |
| Cadastrar Submodalidade | principal | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar principal se chama *Incluir Submodalidades*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Listar Submodalidades** — CE · ALR 4 · DER 3 · Médio · 4 PF

```json
{"pe": "Listar Submodalidades",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Nome", "Descrição", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — a lista é a das submodalidades da edição
2. `Categoria` — a lista mostra a categoria do caminho de cada oferta
3. `Modalidade` — a lista mostra a modalidade do caminho de cada oferta
4. `Tipo Participante` — lê as submodalidades (subgrupo do arquivo lógico Tipo de Participante)

⚠️ A listagem das submodalidades não é principal de nenhuma feature do Feature Set (não há *Listar Submodalidades* no catálogo); fica como acessório da tela, onde o baseline a pôs.

**Cadastrar Submodalidade** — EE · ALR 1 · DER 4 · Simples · 3 PF

```json
{"pe": "Cadastrar Submodalidade",
 "alr": ["Tipo Participante"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — grava a submodalidade nova (subgrupo do arquivo lógico Tipo de Participante)

⚠️ No documento legado (`hus/LEGADO_PIEL_Configurar_Premio.docx`), os processos de mesmo nome — *Listar*, *Incluir*, *Editar* e *Ativar/Desativar Submodalidade* — tratam do enquadramento, que a tela rotula "Sub Modalidades"; os DER que a planilha nomeia (*Nome*, *Descrição*) são os dele, e não os parâmetros da oferta que este N3 descreve (ver a nota da Descrição e `global/CONFORMIDADE-CODIGO.md` § 3.2). Ficaram os números e os nomes da planilha; cabe à equipe de métricas dizer se os processos pertencem ao enquadramento, cujas features `CFG-TIP-10` — Cadastrar Enquadramento e `CFG-TIP-11` — Ativar/Inativar Enquadramento estão sem processo elementar.

**Total: 7 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), com a nota de colisão de terminologia movida para depois dele; critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 |

---

*Feature Set: Vínculos e Ofertas · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
