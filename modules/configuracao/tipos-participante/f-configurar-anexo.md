<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-12
feature_set: CFG-TIP
dominio: CFG
entidade: Configuração de Anexo
data_model_ref: data-models/configuracao.md#configuração-de-anexo
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-009_Anexo_Tipo_Participante
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

# Configurar Anexos Exigidos
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-12`

## Descrição
Permite ao administrador configurar os documentos que o candidato deve enviar na inscrição de um tipo de participante, definindo nome, obrigatoriedade, extensões aceitas e tamanho máximo de cada anexo.

Na aba "Anexos" do tipo de participante, na árvore de configuração do prêmio, o administrador abre o diálogo de um documento — novo ou já configurado —, informa os dados, como nome, extensões aceitas e tamanho máximo, e salva; o painel de preview mostra o checklist como o candidato o verá, e a linha de cada documento oferece a remoção.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-009_Anexo_Tipo_Participante`](../../../hus/HU-009_Anexo_Tipo_Participante.docx) | Criação | `CA-1, CA-2, CA-4, CA-5, CA-6, CA-7` — ao menos uma extensão, com mensagem clara quando falta; tamanho máximo entre 1 e 100 MB, com padrão de 10; preview que reflete as configurações ativas; remoção só lógica, com o documento fora da inscrição pública; obrigatoriedade desligada por padrão; lista recarregada após criar, editar ou desativar |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Anexos**)* (Anexos Exigidos), com lista dos documentos, diálogo de configuração e painel de preview.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Cada documento exigido aceita ao menos uma extensão de arquivo.
2. O tamanho máximo de cada documento fica entre 1 MB e 100 MB → ver RULES-DICTIONARY: RC-08 — Arquivo com tamanho máximo (parâmetro: 1 a 100 MB por anexo).
3. Um documento é opcional por padrão e só passa a obrigatório quando o administrador o define assim.
4. A configuração de anexo pertence a um único tipo de participante e não é compartilhada entre tipos.
5. Um documento exigido removido deixa de ser solicitado ao candidato, mas seu registro é preservado (exclusão lógica).

---

## Cenários

```gherkin
Feature: Configurar Anexos Exigidos

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Configurar anexo obrigatório
    Given que acesso a configuração de anexos de um tipo de participante
    When informo o nome, marco como obrigatório, informo as extensões ".pdf" e ".docx" e o tamanho máximo de 5 MB e salvo
    Then o sistema registra o documento exigido e exibe "Registro salvo com sucesso."

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome do documento em branco
    Given que estou na configuração de um anexo
    When deixo o campo Nome em branco e clico em "Salvar"
    Then o sistema não registra e exibe "Campo obrigatório."

  Scenario: Salvar sem nenhuma extensão
    Given que preenchi o nome mas não informei nenhuma extensão
    When clico em "Salvar"
    Then o sistema não registra e exibe "Informe ao menos uma extensão de arquivo."
    # ← MESSAGE-DICTIONARY: CFG_ANEXO_SEM_EXTENSAO

  Scenario: Tamanho máximo fora do intervalo
    Given que informo um tamanho máximo menor que 1 MB ou maior que 100 MB
    When clico em "Salvar"
    Then o sistema não registra e exibe "O tamanho máximo deve ser entre 1 MB e 100 MB."
    # ← MESSAGE-DICTIONARY: CFG_ANEXO_TAMANHO_INTERVALO

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Remover documento exigido
    Given que existe um documento exigido configurado
    When removo o documento
    Then o sistema deixa de solicitá-lo ao candidato e preserva o registro

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para configurar anexos
    Given que meu perfil não tem permissão para configurar anexos
    When tento acessar a configuração de anexos
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome do documento | Configuração de Anexo | entrada do usuário | editável | texto | sim | máximo de 300 caracteres |
| Descrição | Configuração de Anexo | entrada do usuário | editável | texto longo | não | instruções de apoio ao candidato |
| Obrigatório | Configuração de Anexo | entrada do usuário | editável | booleano | não | padrão: não |
| Extensões permitidas | Configuração de Anexo | entrada do usuário | editável | lista de extensões | sim | ao menos uma; sugestões: .pdf, .jpg, .png, .docx, .xlsx, .pptx |
| Tamanho máximo (MB) | Configuração de Anexo | entrada do usuário | editável | número | sim | entre 1 e 100; padrão 10 |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativo | Na criação do documento exigido |
| Obrigatório | Não | Quando não definido pelo administrador |
| Tamanho máximo (MB) | 10 | Quando não informado |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Tipo de Participante | lê | Cada configuração de anexo pertence a um único tipo de participante (regra 4) |
| Premiação | lê | A lista e o diálogo abrem no nó do tipo de participante, dentro da premiação (ALR das consultas) |
| Categoria | lê | A lista e o diálogo abrem no nó do tipo de participante, sob a categoria (ALR das consultas) |
| Modalidade | lê | A lista e o diálogo abrem no nó do tipo de participante, sob a modalidade (ALR das consultas) |

---

## Comportamento de tela

### Onde fica
Tela de Anexos Exigidos do tipo de participante (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Anexos**)*): a lista dos documentos configurados, o diálogo de criação/edição de cada anexo e um painel de preview que mostra o checklist como o candidato o verá.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo pendente com a mensagem correspondente |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e atualiza a lista e o preview |
| Empty state | Sem documentos configurados: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um documento com ao menos uma extensão e tamanho entre 1 e 100 MB é registrado | cenário "Configurar anexo obrigatório" |
| SC-02 | A tentativa de salvar um anexo sem nenhuma extensão é rejeitada | Critério de aceite 1 (HU-009) |
| SC-03 | Um documento nasce opcional e só se torna obrigatório por definição explícita | Critério de aceite 6 (HU-009) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Listar Configuração de Anexos | acessório | CE | 4 | 6 | Complexo | 6 | 2026-02-28 |
| Configurar Anexos Exigidos (inclusão) | principal | EE | 1 | 7 | Simples | 3 | 2026-02-28 |
| Consultar Configuração de Anexo | acessório | CE | 4 | 6 | Complexo | 6 | 2026-02-28 |
| Configurar Anexos Exigidos (edição) | principal | EE | 1 | 7 | Simples | 3 | 2026-02-28 |
| Configurar Anexos Exigidos (desativação) | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

> No baseline, os processos elementares principais se chamam *Incluir Configuração de Anexo*, *Editar Configuração de Anexo* e *Desativar Configuração de Anexo*; aqui levam o nome da feature com a variante entre parênteses, como pede o `global/SIZING.md` quando há mais de um `principal`. Os números são os do baseline.

### Memória de cálculo

**Listar Configuração de Anexos** — CE · ALR 4 · DER 6 · Complexo · 6 PF

```json
{"pe": "Listar Configuração de Anexos",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Nome do Anexo", "Obrigatório", "Extensões", "Tamanho Max", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — a lista abre no nó do tipo de participante, dentro da premiação
2. `Categoria` — a lista abre sob a categoria do nó
3. `Modalidade` — a lista abre sob a modalidade do nó
4. `Tipo Participante` — a lista traz os documentos configurados para o tipo

**Configurar Anexos Exigidos (inclusão)** — EE · ALR 1 · DER 7 · Simples · 3 PF

```json
{"pe": "Configurar Anexos Exigidos (inclusão)",
 "alr": ["Tipo Participante"],
 "der": ["Nome do Anexo", "Obrigatório", "Descrição", "Extensões", "Tamanho Max", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — a transação grava a nova configuração de anexo, subgrupo do arquivo lógico do tipo de participante

**Consultar Configuração de Anexo** — CE · ALR 4 · DER 6 · Complexo · 6 PF

```json
{"pe": "Consultar Configuração de Anexo",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Nome do Anexo", "Obrigatório", "Descrição", "Extensões", "Tamanho Max", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — o diálogo de edição abre no nó do tipo de participante, dentro da premiação
2. `Categoria` — o diálogo abre sob a categoria do nó
3. `Modalidade` — o diálogo abre sob a modalidade do nó
4. `Tipo Participante` — o diálogo abre preenchido com a configuração do anexo, inclusive a descrição, que a lista não mostra

**Configurar Anexos Exigidos (edição)** — EE · ALR 1 · DER 7 · Simples · 3 PF

```json
{"pe": "Configurar Anexos Exigidos (edição)",
 "alr": ["Tipo Participante"],
 "der": ["Nome do Anexo", "Obrigatório", "Descrição", "Extensões", "Tamanho Max", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — a transação grava as alterações da configuração de anexo

**Configurar Anexos Exigidos (desativação)** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Configurar Anexos Exigidos (desativação)",
 "alr": ["Tipo Participante"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — a transação grava a situação inativa da configuração de anexo (regra 5)

**Total: 21 PF** (5 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com os três processos elementares principais (inclusão, edição e desativação) levando o nome da feature e a variante entre parênteses. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (5 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-009 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
