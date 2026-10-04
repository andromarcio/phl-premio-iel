<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-10
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

# Editar Submodalidade
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-10`

## Descrição
Permite ao administrador alterar os parâmetros de uma submodalidade já cadastrada — permissão de equipe, limites de membros, slug e ordem — mantendo a oferta atualizada. ⚠️ *(escopo editável da submodalidade a confirmar)*

Na aba "Geral" do nó do tipo de participante, na árvore de configuração do prêmio, o administrador abre a submodalidade, altera os parâmetros da oferta, como permissão de equipe, limites de membros e slug da URL, e aciona "Salvar".

> ⚠️ **Colisão de terminologia confirmada no código** (2026-08-28). O que esta feature descreve — o vínculo tipo de participante × modalidade × categoria, com parâmetros de equipe e slug — é a **Oferta** (`TB_TIPO_PART_MOD_CAT`), configurada na aba **Geral** do editor de Tipo de Participante. Na interface implementada, o rótulo **“Sub Modalidades”** designa outra coisa: o **Enquadramento** (`TB_ENQUADRAMENTO`, features `CFG-TIP-10`/`CFG-TIP-11`). Renomear esta feature depende de decisão do PO — ver `global/CONFORMIDADE-CODIGO.md` § 3.2.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | — RN5 da HU: os parâmetros de equipe, slug e ordem são próprios de cada oferta e podem ser alterados |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Geral**)* (Submodalidades da Oferta, edição da submodalidade)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O cruzamento que define a oferta — tipo de participante, modalidade e categoria — é imutável na edição; a alteração muda apenas os parâmetros da submodalidade.
2. Quando a submodalidade permite equipe, o máximo de membros é maior ou igual ao mínimo.
3. O slug da URL da submodalidade é único entre as ofertas da edição.

---

## Cenários

```gherkin
Feature: Editar Submodalidade

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Alterar os parâmetros de uma submodalidade
    Given que selecionei uma submodalidade existente
    When altero a permissão de equipe e os limites de membros e clico em "Salvar"
    Then o sistema grava as alterações e exibe "Registro salvo com sucesso."

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Máximo de membros menor que o mínimo
    Given que a submodalidade permite equipe
    When informo um máximo de membros menor que o mínimo e clico em "Salvar"
    Then o sistema não grava e aponta a inconsistência entre mínimo e máximo

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Slug já usado por outra oferta da edição
    Given que outra oferta da edição já usa o slug informado
    When tento salvar a submodalidade com esse slug
    Then o sistema não grava e mantém o slug anterior
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Tipo de participante | Tipo de Participante | exibido do cadastro | imutável | seleção | — | define a oferta; não muda após a criação |
| Modalidade e categoria | Modalidade × Categoria | exibido do cadastro | imutável | seleção | — | define a oferta; não muda após a criação |
| Permite equipe | Oferta | entrada do usuário | editável | sim/não | não | quando desmarcado, dispensa os limites de membros |
| Mínimo de membros da equipe | Oferta | entrada do usuário | editável | número | condicional | exigido quando permite equipe |
| Máximo de membros da equipe | Oferta | entrada do usuário | editável | número | condicional | maior ou igual ao mínimo |
| Slug da URL | Oferta | entrada do usuário | editável | texto | não | único entre as ofertas da edição → ver FIELD-DICTIONARY: URL |
| Ordem | Oferta | entrada do usuário | editável | número | não | posição da oferta na modalidade-categoria |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Premiação | lê | O formulário de edição abre no contexto da edição (ALR da consulta implícita) |
| Categoria | lê | O formulário mostra a categoria do caminho da oferta (regra 1; ALR da consulta implícita) |
| Modalidade | lê | O formulário mostra a modalidade do caminho da oferta (regra 1; ALR da consulta implícita) |

---

## Comportamento de tela

### Onde fica
Página própria em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Geral**)* (Submodalidades da Oferta): edição dos parâmetros da submodalidade selecionada, com o cruzamento tipo × modalidade × categoria apresentado em modo leitura.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca os campos de equipe quando o máximo é menor que o mínimo |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de parâmetros de uma submodalidade são persistidas | cenário "Alterar os parâmetros de uma submodalidade" |
| SC-02 | O cruzamento tipo × modalidade × categoria não é alterado na edição | regra de negócio 1 |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Submodalidade (implícita) | acessório | CE | 4 | 3 | Médio | 4 | 2026-02-28 |
| Editar Submodalidade | principal | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

**Consultar Submodalidade (implícita)** — CE · ALR 4 · DER 3 · Médio · 4 PF

```json
{"pe": "Consultar Submodalidade (implícita)",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Nome", "Descrição", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — o formulário abre no contexto da edição
2. `Categoria` — traz a categoria do caminho da oferta
3. `Modalidade` — traz a modalidade do caminho da oferta
4. `Tipo Participante` — traz os dados da submodalidade (subgrupo do arquivo lógico Tipo de Participante)

⚠️ A consulta implícita traz os mesmos DER que a lista (*Listar Submodalidades*, em `CFG-VIN-09` — Cadastrar Submodalidade). Pela *Regra da consulta implícita* do `global/SIZING.md`, ela só conta quando o formulário traz dado que a lista não mostrava; ficou como o baseline contou, a confirmar com a equipe de métricas.

**Editar Submodalidade** — EE · ALR 1 · DER 4 · Simples · 3 PF

```json
{"pe": "Editar Submodalidade",
 "alr": ["Tipo Participante"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — grava os parâmetros alterados da submodalidade (subgrupo do arquivo lógico Tipo de Participante)

⚠️ No documento legado (`hus/LEGADO_PIEL_Configurar_Premio.docx`), os processos de mesmo nome — *Listar*, *Incluir*, *Editar* e *Ativar/Desativar Submodalidade* — tratam do enquadramento, que a tela rotula "Sub Modalidades"; os DER que a planilha nomeia (*Nome*, *Descrição*) são os dele, e não os parâmetros da oferta que este N3 descreve (ver a nota da Descrição e `global/CONFORMIDADE-CODIGO.md` § 3.2). Ficaram os números e os nomes da planilha; cabe à equipe de métricas dizer se os processos pertencem ao enquadramento, cujas features `CFG-TIP-10` — Cadastrar Enquadramento e `CFG-TIP-11` — Ativar/Inativar Enquadramento estão sem processo elementar.

**Total: 7 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), com a nota de colisão de terminologia movida para depois dele; critérios da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 |

---

*Feature Set: Vínculos e Ofertas · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
