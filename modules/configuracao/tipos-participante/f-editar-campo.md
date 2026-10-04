<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-08
feature_set: CFG-TIP
dominio: CFG
entidade: Campo do Formulário
data_model_ref: data-models/configuracao.md#campo-do-formulário
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-007_Configurar_Formulario_Tipo_Participante
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

# Editar Campo
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-08`

## Descrição
Permite ao administrador alterar o rótulo, a obrigatoriedade e as demais propriedades de um campo já existente no formulário de inscrição.

No Construtor de Formulário, o administrador seleciona um campo na área de montagem, ajusta no painel de propriedades o que quiser — como rótulo, obrigatoriedade ou opções — e salva o formulário.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-007_Configurar_Formulario_Tipo_Participante`](../../../hus/HU-007_Configurar_Formulario_Tipo_Participante.docx) | Criação | — painel de propriedades do campo selecionado (cenário 03 da HU), mantendo na edição o rótulo obrigatório e ao menos uma opção no campo de seleção (RN4 e RN8 da HU) |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Construtor de Formulário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)*); o campo selecionado é ajustado no painel de propriedades.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Todo campo, exceto o cabeçalho de seção, mantém um rótulo preenchido.
2. Um campo de seleção mantém ao menos uma opção disponível, manual ou proveniente de uma lista do sistema.
3. As alterações em um campo preservam as respostas já registradas por inscrições existentes. ⚠️ *(comportamento inferido da HU-007 para campos com inscrições — confirmar)*

---

## Cenários

```gherkin
Feature: Editar Campo

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Alterar o rótulo de um campo
    Given que selecionei um campo existente no formulário
    When altero o rótulo e salvo o formulário
    Then o sistema grava o novo rótulo do campo

  Scenario: Tornar um campo obrigatório
    Given que selecionei um campo opcional no formulário
    When marco o campo como obrigatório e salvo
    Then o sistema grava o campo como obrigatório

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Rótulo apagado na edição
    Given que estou editando um campo diferente de cabeçalho de seção
    When apago o rótulo e tento salvar o formulário
    Then o sistema não conclui a gravação e exibe "Campo obrigatório."

  Scenario: Remover todas as opções de um campo de seleção
    Given que edito um campo de seleção
    When removo todas as opções e não indico uma lista do sistema e tento salvar
    Then o sistema não conclui a gravação enquanto o campo de seleção não tiver ao menos uma opção
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Tipo de campo | Tipo de Campo | entrada do usuário | editável | lista (Texto curto, Texto longo, Numérico, Data, E-mail, Seleção, Upload de arquivo, Cabeçalho de seção, Aceite de termo) | sim | alteração com ressalvas quando há inscrições ⚠️ |
| Rótulo | Campo do Formulário | entrada do usuário | editável | texto | sim (exceto cabeçalho de seção) | máximo de 300 caracteres |
| Descrição do campo | Campo do Formulário | entrada do usuário | editável | texto | não | texto de ajuda exibido ao candidato |
| Obrigatório | Campo do Formulário | entrada do usuário | editável | booleano (sim/não) | não | padrão: não |
| Máscara | dado de código | entrada do usuário | editável | lista (ex.: CPF, CNPJ, Telefone) | não | aplicável a campos de texto → ver FIELD-DICTIONARY: CPF |
| Opções | Campo do Formulário | entrada do usuário | editável | lista de opções | condicional | obrigatório para campo de seleção; manual ou de uma lista do sistema |
| Largura em grade | Campo do Formulário | entrada do usuário | editável | número (1 a 12) | não | padrão: 12 colunas |
| Ordem | Campo do Formulário | entrada do usuário | editável | número | — | definida pela posição do campo no formulário |
| Etapa | Formulário Dinâmico | entrada do usuário | editável | seleção → Formulário Dinâmico (etapas) | condicional | obrigatório quando o formulário está no modo em etapas; as etapas são as definidas no formulário |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Lista do Sistema | lê | As opções do campo de seleção podem vir de uma lista do sistema (regra 2) |
| Item da Lista do Sistema | lê | As opções do campo de seleção ligado a uma lista do sistema são os itens dessa lista (regra 2) |
| Premiação | lê | A abertura do campo para edição traz a premiação do nó configurado (ALR da consulta implícita) |
| Categoria | lê | A abertura do campo para edição traz a categoria do nó configurado (ALR da consulta implícita) |
| Modalidade | lê | A abertura do campo para edição traz a modalidade do nó configurado (ALR da consulta implícita) |

---

## Comportamento de tela

### Onde fica
Ação no Construtor de Formulário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)*): o campo selecionado na área de montagem é ajustado no painel de propriedades à direita (seções Geral, Validação, Aparência e Visibilidade), com reflexo imediato na pré-visualização.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Sinaliza no checklist o campo sem rótulo ou o campo de seleção sem opções |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e reflete a alteração na pré-visualização |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de rótulo, obrigatoriedade e demais propriedades de um campo são persistidas | cenário "Alterar o rótulo de um campo" |
| SC-02 | A edição rejeita campo sem rótulo e campo de seleção sem opções | Regras de negócio 1 e 2 (HU-007) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Campo (implícito) | acessório | CE | 4 | 23 | Complexo | 6 | 2026-02-28 |
| Editar Campo | principal | EE | 1 | 24 | Médio | 4 | 2026-02-28 |

### Memória de cálculo

**Consultar Campo (implícito)** — CE · ALR 4 · DER 23 · Complexo · 6 PF

```json
{"pe": "Consultar Campo (implícito)",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Rotulo", "Descrição", "Obrigatório", "Tamanho (geral)", "Máscara predefinida", "Min caracteres", "Max caracteres", "Ícone", "Tooltip", "Placeholder", "Tamanho (aparência)", "Espaçamento", "Classe CSS", "Opções", "Valor", "Texto exibido", "Extensões permitidas", "Tamanho máximo", "Texto do cabeçalho", "Texto do link", "Título do Modal", "Conteúdo", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — a abertura do campo para edição traz a premiação do nó configurado
2. `Categoria` — a abertura traz a categoria do nó
3. `Modalidade` — a abertura traz a modalidade do nó
4. `Tipo Participante` — o painel de propriedades abre preenchido com os dados do campo

O nome *(implícito)*, no masculino, é o da planilha: o acessório mantém o nome do baseline.

**Editar Campo** — EE · ALR 1 · DER 24 · Médio · 4 PF

```json
{"pe": "Editar Campo",
 "alr": ["Tipo Participante"],
 "der": ["Rotulo", "Descrição", "Obrigatório", "Tamanho (geral)", "Máscara predefinida", "Min caracteres", "Max caracteres", "Ícone", "Tooltip", "Placeholder", "Tamanho (aparência)", "Espaçamento", "Classe CSS", "Opções", "Valor", "Texto exibido", "Extensões permitidas", "Tamanho máximo", "Texto do cabeçalho", "Texto do link", "Título do Modal", "Conteúdo", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — a transação grava as propriedades alteradas do campo; campo e formulário são subgrupos do mesmo arquivo lógico

Nos dois processos a planilha agrupa os DER por tipo de campo: as propriedades gerais, de validação e de aparência; as opções do campo de seleção (*Opções*, anotada "usar lista do sistema", *Valor* e *Texto exibido*); o upload de arquivo (*Extensões permitidas* e *Tamanho máximo*); o cabeçalho de seção (*Texto do cabeçalho*); e o aceite de termo (*Texto do link*, *Título do Modal* e *Conteúdo*).

⚠️ Nos dois processos a planilha registra *Tamanho* duas vezes, nas propriedades gerais e nas de aparência do campo; aqui desambiguados como *Tamanho (geral)* e *Tamanho (aparência)*. Se forem o mesmo dado, pelo CPM contam uma vez; ficou como o baseline contou, a confirmar com a equipe de métricas.

⚠️ As opções vindas de uma lista do sistema leem o arquivo lógico Listas do Sistema, que a planilha não conta no ALR — a confirmar com a equipe de métricas.

**Total: 10 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), prosa da HU na `## Origem` (nenhum critério numerado cabe só à edição do campo), coluna Entidade em `## Campos` (o Tipo da Etapa passa a nomear o Formulário Dinâmico, onde as etapas são definidas), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON (o processo elementar principal já levava o nome da feature), com o DER *Tamanho* desambiguado. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-007 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
