---
id: CFG-MOD-02
feature_set: CFG-MOD
dominio: CFG
entidade: Modalidade
prioridade: P1
mvp: true
data_model_ref: data-models/configuracao.md#modalidade
endpoints: []
error_codes: []
depende_de: []
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Cadastrar Modalidade
> **Nível 3** - Feature Set: Modalidades — Domínio: Configuração da Premiação - `CFG-MOD-02`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador registrar uma nova modalidade sob uma categoria, com descrição, link de regulamento e período de inscrição próprio, deixando-a disponível como forma de participação.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/modalidades/novo` (Formulário de Modalidade). Também pode ser criada por criação rápida a partir da árvore de configuração do prêmio (ação em tela).

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O nome da modalidade é único dentro da mesma categoria; o mesmo nome é permitido em categorias diferentes.
2. A modalidade nasce subordinada a uma categoria, e essa categoria não muda depois de criada.
3. O período de inscrição é opcional; quando informado, a data de início é anterior à data de fim.
4. O link de regulamento e o período de inscrição pertencem ao vínculo da modalidade com a categoria e podem variar conforme a categoria vinculada. ⚠️ *(no catálogo administrativo sem categoria vinculada, regulamento e período só se aplicam ao vincular — confirmar o escopo)*
5. O período de inscrição da modalidade tem precedência sobre as datas globais do prêmio para o acesso ao fluxo público de inscrição.
6. Na criação rápida pela árvore, a modalidade é criada com o nome padrão "Nova Modalidade" e fica pronta para renomeação.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Cadastrar modalidade com período de inscrição
  Given que acesso o formulário de nova modalidade em uma categoria
  When informo o nome "Individual", o período de início e o período de fim e salvo
  Then o sistema registra a modalidade e exibe "Registro salvo com sucesso."
  And a modalidade fica disponível como forma de participação da categoria

# ── Erros de validação ─────────────────────────────────────────

Scenario: Nome em branco
  Given que estou no formulário de modalidade
  When deixo o campo Nome em branco e clico em "Salvar"
  Then o sistema não registra e exibe "Campo obrigatório."

# ── Estados especiais ──────────────────────────────────────────

Scenario: Criação rápida pela árvore
  Given que estou na configuração de um prêmio, no nó de uma categoria
  When aciono a criação rápida de modalidade
  Then o sistema cria a modalidade com o nome 'Nova Modalidade' e abre o editor para renomeação

# ── Conflitos com dados existentes ─────────────────────────────

# ← MESSAGE-DICTIONARY: CFG_MODALIDADE_PERIODO_INVALIDO
Scenario: Período de inscrição com fim anterior ao início
  Given que informo o início das inscrições em 01/07/2026 e o fim em 30/06/2026
  When clico em "Salvar"
  Then o sistema não registra e exibe "A data de fim das inscrições deve ser posterior à data de início."

# ← MESSAGE-DICTIONARY: CFG_MODALIDADE_NOME_DUPLICADO
Scenario: Nome duplicado na mesma categoria
  Given que já existe a modalidade "Individual" na categoria
  When tento criar outra modalidade com o mesmo nome nesta categoria
  Then o sistema não registra e exibe "Já existe uma modalidade com este nome nesta categoria."

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Usuário sem permissão de escrita
  Given que meu perfil não tem permissão para cadastrar modalidades
  When tento acessar o cadastro de modalidade
  Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | sim | único dentro da mesma categoria; máximo de 200 caracteres |
| Descrição | entrada do usuário | editável | texto longo | não | texto livre |
| Link do regulamento | entrada do usuário | editável | texto (URL) | não | → ver FIELD-DICTIONARY: URL |
| Início das inscrições | entrada do usuário | editável | data e hora | não | quando informado, anterior ao fim das inscrições |
| Fim das inscrições | entrada do usuário | editável | data e hora | não | quando informado, posterior ao início das inscrições |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativo | Na criação da modalidade |
| Nome (criação rápida) | "Nova Modalidade" | Quando criada pela árvore de configuração, antes da renomeação |

---

## Comportamento de tela

### Onde fica
Formulário próprio em `/modalidades/novo` (nome, descrição, regulamento e período de inscrição) e, alternativamente, no editor contextual aberto pela criação rápida na árvore de configuração do prêmio.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo com "Campo obrigatório." ou o período com a mensagem de período inválido |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e retorna ao catálogo |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma modalidade com nome válido é registrada e passa a constar no catálogo | cenário "Cadastrar modalidade com período de inscrição" |
| SC-02 | O período de inscrição com fim anterior ao início é rejeitado | Critério de aceite 2 (HU-005) |
| SC-03 | A criação rápida gera a modalidade com o nome "Nova Modalidade" e abre o editor | cenário "Criação rápida pela árvore" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Incluir Modalidade | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Incluir Modalidade** — ALR (1): Modalidade. DER (4): Nome · Descrição · Ação · Mensagem.

```json
{"pe": "Incluir Modalidade",
 "alr": ["Modalidade"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-005 |

---

*Feature Set: Modalidades · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
