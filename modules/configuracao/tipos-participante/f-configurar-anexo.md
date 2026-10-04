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

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-009_Anexo_Tipo_Participante`](../../../hus/HU-009_Anexo_Tipo_Participante.docx) | Criação | — |

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome do documento | entrada do usuário | editável | texto | sim | máximo de 300 caracteres |
| Descrição | entrada do usuário | editável | texto longo | não | instruções de apoio ao candidato |
| Obrigatório | entrada do usuário | editável | booleano | não | padrão: não |
| Extensões permitidas | entrada do usuário | editável | lista de extensões | sim | ao menos uma; sugestões: .pdf, .jpg, .png, .docx, .xlsx, .pptx |
| Tamanho máximo (MB) | entrada do usuário | editável | número | sim | entre 1 e 100; padrão 10 |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativo | Na criação do documento exigido |
| Obrigatório | Não | Quando não definido pelo administrador |
| Tamanho máximo (MB) | 10 | Quando não informado |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Listar Configuração de Anexos | CE | 4 | 6 | Complexo | 6 | 2026-02-28 |
| Incluir Configuração de Anexo | EE | 1 | 7 | Simples | 3 | 2026-02-28 |
| Consultar Configuração de Anexo | CE | 4 | 6 | Complexo | 6 | 2026-02-28 |
| Editar Configuração de Anexo | EE | 1 | 7 | Simples | 3 | 2026-02-28 |
| Desativar Configuração de Anexo | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Listar Configuração de Anexos** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (6): Nome do Anexo · Obrigatório · Extensões · Tamanho Max · Ação · Mensagem.

```json
{"pe": "Listar Configuração de Anexos",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Nome do Anexo", "Obrigatório", "Extensões", "Tamanho Max", "Ação", "Mensagem"]}
```
- **Incluir Configuração de Anexo** — ALR (1): Tipo Participante. DER (7): Nome do Anexo · Obrigatório · Descrição · Extensões · Tamanho Max · Ação · Mensagem.

```json
{"pe": "Incluir Configuração de Anexo",
 "alr": ["Tipo Participante"],
 "der": ["Nome do Anexo", "Obrigatório", "Descrição", "Extensões", "Tamanho Max", "Ação", "Mensagem"]}
```
- **Consultar Configuração de Anexo** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (6): Nome do Anexo · Obrigatório · Descrição · Extensões · Tamanho Max · Ação.

```json
{"pe": "Consultar Configuração de Anexo",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Nome do Anexo", "Obrigatório", "Descrição", "Extensões", "Tamanho Max", "Ação"]}
```
- **Editar Configuração de Anexo** — ALR (1): Tipo Participante. DER (7): Nome do Anexo · Obrigatório · Descrição · Extensões · Tamanho Max · Ação · Mensagem.

```json
{"pe": "Editar Configuração de Anexo",
 "alr": ["Tipo Participante"],
 "der": ["Nome do Anexo", "Obrigatório", "Descrição", "Extensões", "Tamanho Max", "Ação", "Mensagem"]}
```
- **Desativar Configuração de Anexo** — ALR (1): Tipo Participante. DER (3): ID · Ação · Mensagem.

```json
{"pe": "Desativar Configuração de Anexo",
 "alr": ["Tipo Participante"],
 "der": ["ID", "Ação", "Mensagem"]}
```

**Total: 21 PF** (5 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (5 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-009 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
