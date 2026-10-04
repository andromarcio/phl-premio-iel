<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-03
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

# Editar Tipo de Participante
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-03`

## Descrição
Permite ao administrador alterar os dados gerais e as opções de inscrição em equipe de um tipo de participante já cadastrado, mantendo a estrutura da premiação atualizada.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-006_Cadastrar_Tipo_Participantes`](../../../hus/HU-006_Cadastrar_Tipo_Participantes.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/tipos-participante/:id/visualizar` (Formulário do Tipo, aba Geral)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Não há restrição de unicidade global do nome: o mesmo nome de tipo de participante é permitido em contextos diferentes.
2. Quando o tipo não permite inscrição em equipe, os tamanhos mínimo e máximo da equipe não se aplicam.
3. Quando o tipo permite inscrição em equipe, o tamanho máximo da equipe é maior ou igual ao mínimo.
4. A modalidade de origem do tipo de participante é imutável: a edição não transfere o tipo para outra modalidade. ⚠️ *(vínculo à modalidade tratado no Feature Set Vínculos e Ofertas — confirmar escopo)*

---

## Cenários

```gherkin
Feature: Editar Tipo de Participante

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Editar nome e descrição
    Given que selecionei um tipo de participante existente
    When altero o nome e a descrição e clico em "Salvar"
    Then o sistema grava as alterações e exibe "Registro salvo com sucesso."

  Scenario: Ativar inscrição em equipe em um tipo existente
    Given que edito um tipo de participante sem inscrição em equipe
    When ativo a inscrição em equipe e informo tamanho mínimo 2 e tamanho máximo 4
    Then o sistema grava o tipo com a inscrição em equipe habilitada

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome apagado na edição
    Given que estou editando um tipo de participante
    When apago o campo Nome e clico em "Salvar"
    Then o sistema não grava e exibe "Campo obrigatório."

  Scenario: Tamanho máximo da equipe menor que o mínimo
    Given que edito um tipo com inscrição em equipe e informo tamanho mínimo 6 e tamanho máximo 3
    When clico em "Salvar"
    Then o sistema não grava as alterações, pois o tamanho máximo da equipe deve ser maior ou igual ao mínimo
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | sim | máximo de 200 caracteres; sem unicidade global |
| Descrição | entrada do usuário | editável | texto longo | não | texto livre |
| Abrangência | entrada do usuário | editável | lista | não | valores a confirmar ⚠️ |
| Permite equipe | entrada do usuário | editável | booleano (sim/não) | não | quando sim, exige os tamanhos de equipe |
| Tamanho mínimo da equipe | entrada do usuário | editável | número | condicional | obrigatório quando permite equipe |
| Tamanho máximo da equipe | entrada do usuário | editável | número | condicional | obrigatório quando permite equipe; maior ou igual ao mínimo |
| Modalidade de origem | — | imutável | seleção → Modalidade | — | não pode ser alterada após a criação ⚠️ |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Formulário do tipo em `/tipos-participante/:id/visualizar`, aba "Geral" (nome, descrição, abrangência e opções de inscrição em equipe); os campos de tamanho da equipe aparecem quando a inscrição em equipe está ativada.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome com "Campo obrigatório." e sinaliza tamanho de equipe inconsistente |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de nome, descrição e opções de equipe de um tipo de participante são persistidas | cenário "Editar nome e descrição" |
| SC-02 | Com inscrição em equipe ativada, a edição só é gravada quando o tamanho máximo é maior ou igual ao mínimo | Critério de aceite 3 (HU-006) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consutar Tipo de Participante (implícita) | SE | 4 | 15 | Complexo | 7 | 2026-02-28 |
| Editar Tipo de Participante | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consutar Tipo de Participante (implícita)** — ALR (4): Tipo Participante · Premiação · Modalidade · Categoria. DER (15): Nome · Descrição · Premiação · Categoria · Modalidade · ID do Vinculo · Situação · Seção · Campo · Sub Modalidades · Equipe · Anexos · Questionário · Qtd questões · Ações.

```json
{"pe": "Consutar Tipo de Participante (implícita)",
 "alr": ["Tipo Participante", "Premiação", "Modalidade", "Categoria"],
 "der": ["Nome", "Descrição", "Premiação", "Categoria", "Modalidade", "ID do Vinculo", "Situação", "Seção", "Campo", "Sub Modalidades", "Equipe", "Anexos", "Questionário", "Qtd questões", "Ação"]}
```
- **Editar Tipo de Participante** — ALR (1): Tipo Participante. DER (4): Nome · Descrição · Ação · Mensagem.

```json
{"pe": "Editar Tipo de Participante",
 "alr": ["Tipo Participante"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"]}
```

**Total: 10 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-006 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
