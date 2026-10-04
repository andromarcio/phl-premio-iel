<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-06
feature_set: CFG-TIP
dominio: CFG
entidade: Formulário Dinâmico
data_model_ref: data-models/configuracao.md#formulário-dinâmico
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

# Configurar Formulário de Inscrição
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-06`

## Descrição
Permite ao administrador configurar o formulário de inscrição de um tipo de participante, escolhendo o modo de preenchimento em página única ou em etapas e organizando os campos e seções.

Na árvore de configuração do prêmio, no nó do tipo de participante, o administrador abre a aba "Formulário de Inscrição", escolhe o modo — página única ou em etapas —, monta e reordena os campos, confere a pré-visualização e o checklist de pendências e aciona "Salvar".

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-007_Configurar_Formulario_Tipo_Participante`](../../../hus/HU-007_Configurar_Formulario_Tipo_Participante.docx) | Criação | `CA-2, CA-3, CA-4, CA-5, CA-8` — reordenação dos campos por arrastar; checklist que bloqueia a gravação enquanto houver pendência crítica; gravação da configuração do formulário seguida da dos campos; pré-visualização fiel ao que o candidato verá; nova versão do formulário a cada gravação |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)* (Construtor de Formulário)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Cada tipo de participante mantém uma única configuração de inscrição vigente.
2. O modo de preenchimento é definido antes de a configuração ser concluída: página única ou em etapas.
3. No modo em etapas, há ao menos uma etapa configurada.
4. A configuração de inscrição é versionada: cada gravação bem-sucedida registra uma nova versão.
5. Um campo já respondido por inscrições existentes não é removido em definitivo; sua retirada é apenas lógica.

---

## Cenários

```gherkin
Feature: Configurar Formulário de Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Configurar formulário em página única
    Given que estou no construtor de formulário de um tipo de participante com campos adicionados
    When escolho o modo página única e salvo
    Then o sistema grava a configuração do formulário e registra uma nova versão

  Scenario: Configurar formulário em etapas
    Given que estou no construtor de formulário e escolho o modo em etapas
    When crio etapas nomeadas e associo campos a cada etapa e salvo
    Then o sistema grava o formulário com as etapas definidas e registra uma nova versão

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Salvar sem definir o modo de preenchimento
    Given que ainda não escolhi o modo de preenchimento do formulário
    When tento salvar
    Then o sistema não conclui a gravação enquanto o modo de preenchimento não for definido

  Scenario: Modo em etapas sem nenhuma etapa
    Given que escolhi o modo em etapas mas não criei nenhuma etapa
    When tento salvar
    Then o sistema não conclui a gravação enquanto não houver ao menos uma etapa

  Scenario: Campo sem rótulo ao salvar
    Given que existe um campo sem rótulo preenchido no formulário
    When tento salvar
    Then o sistema não conclui a gravação enquanto houver campo sem rótulo
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Modo de preenchimento | dado de código | entrada do usuário | editável | lista (Página única, Em etapas) | sim | definido antes da conclusão da configuração |
| Título do formulário | Formulário Dinâmico | entrada do usuário | editável | texto | não | máximo de 300 caracteres |
| Descrição do formulário | Formulário Dinâmico | entrada do usuário | editável | texto longo | não | texto livre |
| Etapas | Formulário Dinâmico | entrada do usuário | editável | lista de etapas nomeadas | condicional | ao menos uma no modo em etapas |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Versão | Incrementada a cada gravação bem-sucedida | Ao salvar a configuração do formulário |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Campo do Formulário | lê e grava | A gravação leva os campos montados e reordenados no construtor; o campo já respondido só sai de forma lógica (regra 5) |
| Seção do Formulário | lê e grava | O construtor organiza os campos em seções |
| Premiação | lê | A abertura do construtor traz a premiação do nó configurado (ALR da consulta implícita) |
| Categoria | lê | A abertura do construtor traz a categoria do nó configurado (ALR da consulta implícita) |
| Modalidade | lê | A abertura do construtor traz a modalidade do nó configurado (ALR da consulta implícita) |

---

## Comportamento de tela

### Onde fica
Construtor de Formulário em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)*: catálogo de tipos de campo à esquerda, área central para montagem e reordenação dos campos, painel de propriedades à direita, alternância entre página única e etapas no topo, além de pré-visualização e checklist de validação antes de salvar.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | O checklist relaciona as pendências (modo não definido, etapa ausente, campo sem rótulo) e mantém o salvamento indisponível |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e reflete a nova versão do formulário |
| Empty state | Formulário sem campos: convite para arrastar um tipo de campo do catálogo |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O formulário só é gravado com o modo de preenchimento definido e, no modo em etapas, com ao menos uma etapa | Regras de negócio 2 e 3 (HU-007) |
| SC-02 | Cada gravação bem-sucedida registra uma nova versão do formulário | Critério de aceite 8 (HU-007) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Configurar Formulário de Inscrição | principal | EE | 1 | 10 | Simples | 3 | 2026-02-28 |
| Consultar Estrutura do Formulário de Inscrição (implícita) | acessório | CE | 4 | 9 | Complexo | 6 | 2026-02-28 |

> No baseline, o processo elementar principal se chama *Configurar Estrutura do Formulário de Inscrição*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Configurar Formulário de Inscrição** — EE · ALR 1 · DER 10 · Simples · 3 PF

```json
{"pe": "Configurar Formulário de Inscrição",
 "alr": ["Tipo Participante"],
 "der": ["Cor primária", "Fundo", "Rótulos", "Imagem Banner", "Título", "Subtítulo", "Descrição Rica", "Layout", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — a transação grava a configuração do formulário do tipo; formulário, seções e campos são subgrupos do mesmo arquivo lógico

⚠️ A planilha enumera a aparência do formulário (cor primária, fundo, rótulos, banner, título, subtítulo, descrição rica e layout) e não conta o modo de preenchimento nem as etapas, que o N3 documenta em `## Campos`. A divergência entre a tela documentada e a medida vai à equipe de métricas.

**Consultar Estrutura do Formulário de Inscrição (implícita)** — CE · ALR 4 · DER 9 · Complexo · 6 PF

```json
{"pe": "Consultar Estrutura do Formulário de Inscrição (implícita)",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Cor primária", "Fundo", "Rótulos", "Imagem Banner", "Título", "Subtítulo", "Descrição Rica", "Layout", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — a abertura do construtor traz a premiação do nó configurado
2. `Categoria` — a abertura traz a categoria do nó
3. `Modalidade` — a abertura traz a modalidade do nó
4. `Tipo Participante` — o construtor abre com a configuração atual do formulário do tipo

**Total: 9 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-007 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
