<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-02
feature_set: CFG-TIP
dominio: CFG
entidade: Tipo de Participante
data_model_ref: data-models/configuracao.md#tipo-de-participante
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-006_Cadastrar_Tipo_Participantes
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

# Cadastrar Tipo de Participante
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-02`

## Descrição
Permite ao administrador registrar um novo tipo de participante, com nome e descrição e a opção de inscrição em equipe com tamanho mínimo e máximo de membros.

A partir do Catálogo de Tipos de Participante, o administrador abre o formulário de novo tipo, informa o nome — e, se quiser, a descrição, a abrangência e a inscrição em equipe com os tamanhos mínimo e máximo — e salva; na árvore de configuração de um prêmio, a criação rápida num nó gera o tipo com o nome "Novo Tipo", pronto para ser renomeado.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-006_Cadastrar_Tipo_Participantes`](../../../hus/HU-006_Cadastrar_Tipo_Participantes.docx) | Criação | `CA-1, CA-2, CA-3, CA-4` — nome obrigatório com mensagem clara; inscrição em equipe que exibe os tamanhos mínimo e máximo, obrigatórios e com o máximo maior ou igual ao mínimo; abas de configuração da estrutura habilitadas só depois de criado o tipo |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/tipos-participante/novo` (Formulário do Tipo, aba Geral). Também pode ser criado por criação rápida a partir da árvore de configuração do prêmio (ação em tela).

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Não há restrição de unicidade global do nome: o mesmo nome de tipo de participante é permitido em contextos diferentes.
2. Cada tipo de participante comporta, no máximo, uma estrutura de inscrição e um questionário de avaliação próprios.
3. Quando o tipo não permite inscrição em equipe, os tamanhos mínimo e máximo da equipe não se aplicam.
4. Quando o tipo permite inscrição em equipe, o tamanho máximo da equipe é maior ou igual ao mínimo.
5. Todo tipo de participante nasce com um enquadramento "Geral" criado automaticamente.
6. Na criação rápida pela árvore de configuração, o tipo nasce com o nome padrão "Novo Tipo" e sem inscrição em equipe.

---

## Cenários

```gherkin
Feature: Cadastrar Tipo de Participante

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Cadastrar tipo individual (sem equipe)
    Given que acesso o formulário de novo tipo de participante
    When informo o nome "Estudante Bolsista", mantenho a inscrição em equipe desativada e salvo
    Then o sistema registra o tipo de participante e exibe "Registro salvo com sucesso."
    And o tipo fica disponível para configuração da estrutura de inscrição e avaliação

  Scenario: Cadastrar tipo com inscrição em equipe
    Given que estou no formulário de novo tipo e ativo a inscrição em equipe
    When informo tamanho mínimo 2 e tamanho máximo 5 e salvo
    Then o sistema registra o tipo com a inscrição em equipe habilitada

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome em branco
    Given que estou no formulário de tipo de participante
    When deixo o campo Nome em branco e clico em "Salvar"
    Then o sistema não registra e exibe "Campo obrigatório."

  Scenario: Tamanho máximo da equipe menor que o mínimo
    Given que ativo a inscrição em equipe e informo tamanho mínimo 5 e tamanho máximo 2
    When clico em "Salvar"
    Then o sistema não registra o tipo, pois o tamanho máximo da equipe deve ser maior ou igual ao mínimo

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Criação rápida pela árvore
    Given que estou na configuração de um prêmio
    When aciono a criação rápida de tipo de participante em um nó da árvore
    Then o sistema cria o tipo com o nome "Novo Tipo" e sem inscrição em equipe

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de escrita
    Given que meu perfil não tem permissão para cadastrar tipos de participante
    When tento acessar o cadastro de tipo de participante
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome | Tipo de Participante | entrada do usuário | editável | texto | sim | máximo de 200 caracteres; sem unicidade global |
| Descrição | Tipo de Participante | entrada do usuário | editável | texto longo | não | texto livre |
| Abrangência | dado de código | entrada do usuário | editável | lista | não | padrão: Nacional ⚠️ *(não citada na HU-006; coluna do data-model — valores a confirmar)* |
| Permite equipe | Oferta | entrada do usuário | editável | booleano (sim/não) | não | padrão: não; quando sim, exige os tamanhos de equipe |
| Tamanho mínimo da equipe | Oferta | entrada do usuário | editável | número | condicional | obrigatório quando permite equipe ⚠️ *(armazenado na oferta tipo×modalidade×categoria no data-model)* |
| Tamanho máximo da equipe | Oferta | entrada do usuário | editável | número | condicional | obrigatório quando permite equipe; maior ou igual ao mínimo |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativo | Na criação do tipo de participante |
| Nome (criação rápida) | "Novo Tipo" | Quando criado pela árvore de configuração, antes da renomeação |
| Enquadramento inicial | "Geral" | Criado automaticamente junto com o tipo de participante |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Enquadramento | grava | O enquadramento "Geral" nasce junto com o tipo de participante (regra 5 e campo automático *Enquadramento inicial*) |

---

## Comportamento de tela

### Onde fica
Formulário próprio em `/tipos-participante/novo`, aba "Geral" (nome, descrição, abrangência e opção de inscrição em equipe); os campos de tamanho da equipe aparecem quando a inscrição em equipe é ativada. Alternativamente, no editor contextual aberto pela criação rápida na árvore de configuração do prêmio.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome com "Campo obrigatório." e sinaliza tamanho de equipe inconsistente |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e habilita as abas de configuração da estrutura |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um tipo de participante com nome válido é registrado e passa a constar no catálogo | Critério de aceite 1 (HU-006) |
| SC-02 | Com inscrição em equipe ativada, o tipo só é registrado quando o tamanho máximo é maior ou igual ao mínimo | Critério de aceite 3 (HU-006) |
| SC-03 | A criação rápida gera o tipo com o nome "Novo Tipo" e sem inscrição em equipe | cenário "Criação rápida pela árvore" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Cadastrar Tipo de Participante | principal | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Incluir Tipo de Participante*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Cadastrar Tipo de Participante** — EE · ALR 1 · DER 4 · Simples · 3 PF

```json
{"pe": "Cadastrar Tipo de Participante",
 "alr": ["Tipo Participante"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — a transação grava o tipo novo; a oferta que guarda a inscrição em equipe e o enquadramento "Geral" criado junto são subgrupos do mesmo arquivo lógico

⚠️ A planilha conta só *Nome* e *Descrição*; a abrangência e os campos de inscrição em equipe, que o N3 documenta em `## Campos`, não entram no DER. A divergência vai à equipe de métricas.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-006 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
