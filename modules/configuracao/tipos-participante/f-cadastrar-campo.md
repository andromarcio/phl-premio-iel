<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-07
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

# Cadastrar Campo
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-07`

## Descrição
Permite ao administrador adicionar um campo tipado ao formulário de inscrição, definindo seu rótulo, tipo e regras de preenchimento.

No Construtor de Formulário, o administrador arrasta um tipo de campo do catálogo à esquerda para a área de montagem e, no painel de propriedades que se abre, informa o rótulo e as regras do campo, como obrigatoriedade, máscara e opções.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-007_Configurar_Formulario_Tipo_Participante`](../../../hus/HU-007_Configurar_Formulario_Tipo_Participante.docx) | Criação | `CA-1, CA-2` — catálogo de tipos de campo carregado no construtor; adição do campo arrastando-o do catálogo para o formulário |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Construtor de Formulário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)*); o campo é adicionado ao formulário a partir do catálogo lateral de tipos de campo, abrindo o painel de propriedades.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Todo campo, exceto o cabeçalho de seção, precisa de um rótulo preenchido.
2. Um campo de seleção precisa de ao menos uma opção, informada manualmente ou proveniente de uma lista do sistema.
3. Um campo de cabeçalho de seção serve para separar as seções e não coleta resposta do candidato.
4. A ordem de preenchimento de um campo corresponde à sua posição na sequência definida.

---

## Cenários

```gherkin
Feature: Cadastrar Campo

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Adicionar um campo de texto curto
    Given que estou no construtor de formulário com o catálogo de tipos de campo disponível
    When arrasto um campo de texto curto para o formulário e informo o rótulo "Nome completo"
    Then o sistema adiciona o campo ao formulário com a ordem definida pela posição

  Scenario: Configurar um campo de texto curto com máscara de CPF
    Given que adicionei um campo de texto curto e informei o rótulo
    When defino a máscara "CPF" para o campo
    Then o sistema registra o campo com a máscara de CPF aplicada ao preenchimento

  Scenario: Configurar um campo de seleção com lista do sistema
    Given que adicionei um campo de seleção ao formulário
    When indico que as opções vêm da lista do sistema "UF do Brasil"
    Then o sistema registra o campo de seleção com as opções da lista escolhida

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Campo sem rótulo
    Given que adicionei um campo diferente de cabeçalho de seção
    When deixo o rótulo em branco e tento salvar o formulário
    Then o sistema não conclui a gravação e exibe "Campo obrigatório."

  Scenario: Campo de seleção sem opções
    Given que adicionei um campo de seleção sem opções e sem lista do sistema
    When tento salvar o formulário
    Then o sistema não conclui a gravação enquanto o campo de seleção não tiver ao menos uma opção
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Tipo de campo | Tipo de Campo | entrada do usuário | editável | lista (Texto curto, Texto longo, Numérico, Data, E-mail, Seleção, Upload de arquivo, Cabeçalho de seção, Aceite de termo) | sim | escolhido no catálogo de tipos de campo |
| Rótulo | Campo do Formulário | entrada do usuário | editável | texto | sim (exceto cabeçalho de seção) | máximo de 300 caracteres |
| Descrição do campo | Campo do Formulário | entrada do usuário | editável | texto | não | texto de ajuda exibido ao candidato |
| Obrigatório | Campo do Formulário | entrada do usuário | editável | booleano (sim/não) | não | padrão: não |
| Máscara | dado de código | entrada do usuário | editável | lista (ex.: CPF, CNPJ, Telefone) | não | aplicável a campos de texto → ver FIELD-DICTIONARY: CPF |
| Opções | Campo do Formulário | entrada do usuário | editável | lista de opções | condicional | obrigatório para campo de seleção; manual ou de uma lista do sistema |
| Lista do sistema | Lista do Sistema | entrada do usuário | editável | seleção → Lista do Sistema | não | fornece as opções de um campo de seleção |
| Largura em grade | Campo do Formulário | entrada do usuário | editável | número (1 a 12) | não | padrão: 12 colunas |
| Tamanho máximo | Campo do Formulário | entrada do usuário | editável | número | não | tamanho máximo aceito no preenchimento |
| Etapa | Formulário Dinâmico | entrada do usuário | editável | seleção → Formulário Dinâmico (etapas) | condicional | obrigatório quando o formulário está no modo em etapas; as etapas são as definidas no formulário |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Ordem | Definida pela posição do campo no formulário | Ao adicionar ou reposicionar o campo |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Item da Lista do Sistema | lê | As opções do campo de seleção ligado a uma lista do sistema são os itens dessa lista (regra 2) |

---

## Comportamento de tela

### Onde fica
Ação no Construtor de Formulário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)*): o tipo de campo é arrastado do catálogo à esquerda para a área de montagem, e o painel de propriedades à direita abre para configurar rótulo, obrigatoriedade, máscara, opções e aparência.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Painel de propriedades desabilitado enquanto o catálogo de tipos de campo carrega |
| Erro de validação | Sinaliza no checklist o campo sem rótulo ou o campo de seleção sem opções |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | O campo passa a compor o formulário e aparece na pré-visualização |
| Empty state | Formulário sem campos: convite para arrastar um tipo de campo do catálogo |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um campo tipado é adicionado ao formulário com rótulo e ordem definidos pela posição | cenário "Adicionar um campo de texto curto" |
| SC-02 | Um campo de seleção só é aceito com ao menos uma opção, manual ou de uma lista do sistema | Regra de negócio 2 (HU-007) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Cadastrar Campo | principal | EE | 1 | 24 | Médio | 4 | 2026-02-28 |

> No baseline, o processo elementar se chama *Adicionar Campo*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Cadastrar Campo** — EE · ALR 1 · DER 24 · Médio · 4 PF

```json
{"pe": "Cadastrar Campo",
 "alr": ["Tipo Participante"],
 "der": ["Rotulo", "Descrição", "Obrigatório", "Tamanho (geral)", "Máscara predefinida", "Min caracteres", "Max caracteres", "Ícone", "Tooltip", "Placeholder", "Tamanho (aparência)", "Espaçamento", "Classe CSS", "Opções", "Valor", "Texto exibido", "Extensões permitidas", "Tamanho máximo", "Texto do cabeçalho", "Texto do link", "Título do Modal", "Conteúdo", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — a transação grava o campo novo no formulário do tipo; campo e formulário são subgrupos do mesmo arquivo lógico

A planilha agrupa os DER por tipo de campo: as propriedades gerais, de validação e de aparência; as opções do campo de seleção (*Opções*, anotada "usar lista do sistema", *Valor* e *Texto exibido*); o upload de arquivo (*Extensões permitidas* e *Tamanho máximo*); o cabeçalho de seção (*Texto do cabeçalho*); e o aceite de termo (*Texto do link*, *Título do Modal* e *Conteúdo*).

⚠️ A planilha registra *Tamanho* duas vezes, nas propriedades gerais e nas de aparência do campo; aqui desambiguados como *Tamanho (geral)* e *Tamanho (aparência)*. Se forem o mesmo dado, pelo CPM contam uma vez; ficou como o baseline contou, a confirmar com a equipe de métricas.

⚠️ O catálogo de tipos de campo e a escolha da lista do sistema são listas lidas de arquivo lógico (Tipo de Participante e Listas do Sistema) que a planilha não conta como processo elementar nem no ALR desta transação — a confirmar com a equipe de métricas (`global/SIZING.md` → *Regra da lista consultada*).

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos` (o Tipo da Etapa passa a nomear o Formulário Dinâmico, onde as etapas são definidas), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature e o DER *Tamanho* desambiguado. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-007 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
